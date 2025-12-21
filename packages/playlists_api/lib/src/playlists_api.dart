import 'package:library_api/library_api.dart';
import 'package:playlists_api/src/models/models.dart';

/// {@template playlists_api}
/// The interface and models for playlist implementations
/// {@endtemplate}
abstract class PlaylistsApi {
  /// {@macro playlists_api}
  const PlaylistsApi(this.libraryApis);

  final List<LibraryApi> libraryApis;

  Future<void> initialize();
  Stream<List<Playlist>> getPlaylists();
  Future<List<LibraryFile>> getPlaylistLibraryFiles(String playlistId);
  Future<void> addPlaylist(String title);
  Future<void> editPlaylistTitle(String playlistId, String title);
  Future<void> addLibraryFileToPlaylist(String playlistId, String libraryFileId);
  Future<void> deletePlaylist(String id);
  Future<void> dispose();
}
