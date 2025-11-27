import 'dart:io';
import 'package:path/path.dart' as p; 

import 'package:jukebox/data/library_file.dart';
import 'package:media_kit/media_kit.dart';
import 'package:mime/mime.dart';
import 'package:sqlite3/sqlite3.dart';

class LibraryHandler {
  static final LibraryHandler _instance = LibraryHandler._internal();

  factory LibraryHandler() {
    return _instance;
  }

  LibraryHandler._internal();

  bool isInitialized = false;
  String libraryPath = "";
  late Database database;

  void initialize(String libraryPath) {
    this.libraryPath = libraryPath;
    database = sqlite3.open('$libraryPath/.library.db');

    database.execute('''
      CREATE TABLE IF NOT EXISTS files (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        duration INTEGER,
        path TEXT UNIQUE
      );
    ''');

    database.execute('''
      CREATE TABLE IF NOT EXISTS playlists (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT
      );
    ''');

    database.execute('''
      CREATE TABLE IF NOT EXISTS playlist_items (
        playlist_id INTEGER,
        file_id INTEGER,
        PRIMARY KEY (playlist_id, file_id),
        FOREIGN KEY (playlist_id) REFERENCES playlists(id),
        FOREIGN KEY (file_id) REFERENCES files(id)
      );
    ''');
    isInitialized = true;
  }

  Future<void> addFiles(List<String> filePaths) async {
    for (final filePath in filePaths) {
      final String mimeType = lookupMimeType(filePath) ?? '';
      print(mimeType);

      if (mimeType.startsWith('audio/') || 
          mimeType.startsWith('video/')) {
        await addFile(filePath);
      } else if (mimeType == 'application/x-subrip') {
        await copyFileToLibrary(File(filePath));
      }
    }
  }

  Future<void> addFile(String filePath) async {
    File file = File(filePath);
    copyFileToLibrary(file);
    final stmt = database.prepare(
      'INSERT INTO files (title, duration, path) VALUES (?, ?, ?);',
    );
    final title = p.basenameWithoutExtension(file.path);
    Player tempPlayer = Player();
    await tempPlayer.setVolume(0.0);
    await tempPlayer.open(Media(filePath));
    final duration = (await tempPlayer.stream.duration.first).inMicroseconds;
    await tempPlayer.dispose();

    stmt.execute([title, duration, filePath]);
    stmt.close();
  }

  Future<void> copyFileToLibrary(File sourceFile) async {
    final fileName = sourceFile.path.split('/').last;
    final destinationPath = '$libraryPath/$fileName';
    final destinationFile = File(destinationPath);

    if (!await destinationFile.exists()) {
      await sourceFile.copy(destinationPath);
    }
  }

  List<LibraryFile> getFiles() {
    List<LibraryFile> files = [];
    final ResultSet resultSet = database.select('SELECT * FROM files;');
    for (final Row row in resultSet) {
      files.add(
        LibraryFile(
          libraryId: row['id'],
          title: row['title'],
          path: row['path'],
          duration: Duration(microseconds: row['duration']),
        ),
      );
    }

    return files;
  }
}