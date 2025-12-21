
import 'package:library_api/src/models/models.dart';

abstract class LibraryApi {
  const LibraryApi();

  Future<void> initialize();
  Stream<List<LibraryFile>> getFiles();
  Future<LibraryFile> getFile(String id);
  Future<void> editFile(String id, String name);
  Future<void> addFile(String filePath);
  Future<void> deleteFile(String id);
  Future<void> dispose();
}
