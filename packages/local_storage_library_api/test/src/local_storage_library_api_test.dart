// Not required for test files

import 'package:flutter/widgets.dart';
import 'package:local_storage_library_api/local_storage_library_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  WidgetsFlutterBinding.ensureInitialized();
  final libraryApi = LocalStorageLibraryApi(libraryPath: '/tmp/test/');
  await libraryApi.initialize();
  // String id = "";
  await for (final files in libraryApi.getFiles()) {
    for (final file in files) {
      print('${file.id} | ${file.filePath()} | ${file.srtPath()}');
      // id = file.id;
    }
  }
  await libraryApi.addFile('/mnt/data/songs/2XKO Official Cinematic_ Ties That Bind ft. Courtney LaPlante of Spiritbox.mp3');

  // group('LocalStorageLibraryApi', () {
    
  // });
}
