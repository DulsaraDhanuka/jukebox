import 'dart:io';

import 'package:library_api/library_api.dart';
import 'package:local_storage_library_api/src/helper.dart';
import 'package:local_storage_library_api/src/models/local_storage_library_file.dart';
import 'package:path/path.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class LocalStorageLibraryApi extends LibraryApi {
  LocalStorageLibraryApi({
    required String libraryPath,
  }) : _libraryPath = libraryPath;

  final String _libraryPath;
  late final Database _database;
  final String kFilesTableName = 'files';

  late final _libraryFilesStreamController =
      BehaviorSubject<List<LocalStorageLibraryFile>>.seeded(const []);

  @override
  Future<void> initialize() async {
    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    _database = await openDatabase(
      join(_libraryPath, '.jukebox.index'),
      onCreate: (db, version) {
        return db.execute(
          '''
            CREATE TABLE "$kFilesTableName" (
              "id"	TEXT NOT NULL UNIQUE,
              "title"	TEXT NOT NULL,
              "file_name"	TEXT NOT NULL,
              PRIMARY KEY("id")
            );''',
        );
      },
      version: 1,
    );

    final files = (await _database.query(kFilesTableName))
        .map(
          (map) => LocalStorageLibraryFile.fromJson(
            map,
            Lazy(() => _getFilePath(map)),
            Lazy(() => _getSrtPath(map)),
          ),
        )
        .toList();
    _libraryFilesStreamController.add(files);
  }

  String? _getFilePath(
    Map<String, Object?> row,
  ) {
    return join(_libraryPath, row['file_name']!.toString());
  }

  String? _getSrtPath(
    Map<String, Object?> row,
  ) {
    return null;
  }

  @override
  Future<void> addFile(String filePath) async {
    final originalFile = File(filePath);
    final newFile = await originalFile.copy(
      '$_libraryPath/${basename(filePath)}',
    );
    final newId = getRandomString(10);
    await _database.insert(kFilesTableName, {
      'id': newId,
      'title': basename(newFile.path),
      'file_name': basename(newFile.path),
    });
    final newRow = (await _database.query(
      kFilesTableName,
      where: "id = '$newId'",
      columns: ['id', 'title', 'file_name'],
    )).first;
    _libraryFilesStreamController.add([
      ..._libraryFilesStreamController.value,
      LocalStorageLibraryFile.fromJson(
        newRow,
        Lazy(() => _getFilePath(newRow)),
        Lazy(() => _getSrtPath(newRow)),
      ),
    ]);
  }

  @override
  Future<void> dispose() async {
    await _database.close();
    await _libraryFilesStreamController.close();
  }

  @override
  Future<void> deleteFile(String id) {
    throw UnimplementedError();
  }

  @override
  Future<void> editFile(String id, String name) {
    throw UnimplementedError();
  }

  @override
  Stream<List<LocalStorageLibraryFile>> getFiles() =>
      _libraryFilesStreamController.asBroadcastStream();

  @override
  Future<LibraryFile> getFile(String id) async {
    final row = await _database.query(
      kFilesTableName,
      where: "id = '$id'",
      limit: 1,
    );
    final file = LocalStorageLibraryFile.fromJson(
      row.first,
      Lazy(() => _getFilePath(row.first)),
      Lazy(() => _getSrtPath(row.first)),
    );
    return file;
  }
}
