import 'package:library_api/library_api.dart';
import 'package:playlists_api/playlists_api.dart';

/// {@template playlists_repository}
/// A repository that handles playlists related requests
/// {@endtemplate}
class PlaylistsRepository {
  /// {@macro playlists_repository}
  const PlaylistsRepository({required PlaylistsApi playlistsApi})
    : _playlistsApi = playlistsApi;

  final PlaylistsApi _playlistsApi;

  Stream<List<Playlist>> getPlaylists() => _playlistsApi.getPlaylists();
  Future<List<LibraryFile>> getPlaylistLibraryFiles(String playlistId) =>
      _playlistsApi.getPlaylistLibraryFiles(playlistId);
  Future<void> addPlaylist(String title) => _playlistsApi.addPlaylist(title);
  Future<void> addLibraryFileToPlaylist(
    String playlistId,
    String libraryFileId,
  ) => _playlistsApi.addLibraryFileToPlaylist(playlistId, libraryFileId);
  Future<void> editPlaylistTitle(String playlistId, String title) =>
      _playlistsApi.editPlaylistTitle(playlistId, title);
  Future<void> deletePlaylist(String id) => _playlistsApi.deletePlaylist(id);
  Future<void> dispose() => _playlistsApi.dispose();
}
