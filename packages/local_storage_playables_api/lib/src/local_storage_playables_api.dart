import 'dart:io';
import 'package:local_storage_playables_api/src/models/local_storage_playable.dart';
import 'package:path/path.dart';
import 'package:playables_api/playables_api.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class LocalStoragePlayablesApi extends PlayablesApi {
  LocalStoragePlayablesApi._({
    required String libraryPath,
  }) : _libraryPath = libraryPath;

  final String _libraryPath;
  late final Database _database;

  late final _playablesStreamController =
      BehaviorSubject<List<LocalStoragePlayable>>.seeded(const []);

  static Future<LocalStoragePlayablesApi> getInstance(
    String libraryPath,
  ) async {
    final api = LocalStoragePlayablesApi._(libraryPath: libraryPath);
    await api._init();
    return api;
  }

  Future<void> _init() async {
    _database = await openDatabase(
      join(_libraryPath, '.jukebox.index'),
      onCreate: (db, version) {
        return db.execute(
          '''
            CREATE TABLE "files" (
              "id"	TEXT NOT NULL UNIQUE,
              "title"	TEXT NOT NULL,
              "file_name"	TEXT NOT NULL,
              PRIMARY KEY("id")
            );''',
        );
      },
      version: 1,
    );

    final playables = (await _database.query('files'))
        .map(
          (map) => LocalStoragePlayable.fromJson(
            map,
            Lazy(() => _getFilePathPlayable(map)),
            Lazy(() => _getSrtPathPlayable(map)),
          ),
        )
        .toList();
    _playablesStreamController.add(playables);
  }

  String? _getFilePathPlayable(
    Map<String, Object?> row,
  ) {
    return join(_libraryPath, row['file_name']!.toString());
  }

  String? _getSrtPathPlayable(
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
    final newId = const Uuid().v4();
    await _database.insert('files', {
      'id': newId,
      'name': basename(newFile.path),
      'filePath': basename(newFile.path),
    });
    final newRow = (await _database.query('file', where: 'id = $newId')).first;
    _playablesStreamController.add([
      ..._playablesStreamController.value,
      LocalStoragePlayable.fromJson(
        newRow,
        Lazy(() => _getFilePathPlayable(newRow)),
        Lazy(() => _getSrtPathPlayable(newRow)),
      ),
    ]);
  }

  @override
  Future<void> close() async {
    await _database.close();
    await _playablesStreamController.close();
  }

  @override
  Future<void> deletePlayable(String id) {
    throw UnimplementedError();
  }

  @override
  Future<void> editPlayable(String id, String name) {
    throw UnimplementedError();
  }

  @override
  Stream<List<LocalStoragePlayable>> getPlayables() =>
      _playablesStreamController.asBroadcastStream();
}
