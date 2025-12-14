import 'package:library_api/library_api.dart';

/// {@template library_repository}
/// A repository that handles library related requests
/// {@endtemplate}
class LibraryRepository {
  /// {@macro library_repository}
  const LibraryRepository({
    required LibraryApi libraryApi
  }) : _libraryApi = libraryApi;

  final LibraryApi _libraryApi;

  Stream<List<LibraryFile>> getFiles() => _libraryApi.getFiles();

  Future<void> addFile(String filePath) => _libraryApi.addFile(filePath);

  Future<void> dispose() => _libraryApi.dispose();
}
