import 'dart:convert';

import 'package:library_api/library_api.dart';
import 'package:local_storage_playlists_api/helper.dart';
import 'package:meta/meta.dart';
import 'package:playlists_api/playlists_api.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// {@template local_storage_playlists_api}
/// Playlists api implemented using local storage
/// {@endtemplate}
class LocalStoragePlaylistsApi extends PlaylistsApi {
  /// {@macro local_storage_playlists_api}
  LocalStoragePlaylistsApi(super.libraryApis);

  late final SharedPreferences _plugin;
  late final _playlistStreamController = BehaviorSubject<List<Playlist>>.seeded(
    const [],
  );

  @visibleForTesting
  static const kPlaylistsCollectionKey = '__playlists_collection_key__';

  String? _getValue(String key) => _plugin.getString(key);
  Future<void> _setValue(String key, String value) =>
      _plugin.setString(key, value);

  @override
  Future<void> initialize() async {
    _plugin = await SharedPreferences.getInstance();

    final playlistsJson = _getValue(kPlaylistsCollectionKey);
    if (playlistsJson != null) {
      final playlists =
          List<Map<dynamic, dynamic>>.from(json.decode(playlistsJson) as List)
              .map(
                (jsonMap) =>
                    Playlist.fromJson(Map<String, dynamic>.from(jsonMap)),
              )
              .toList();
      _playlistStreamController.add(playlists);
    } else {
      _playlistStreamController.add(const []);
    }
  }

  @override
  Stream<List<Playlist>> getPlaylists() =>
      _playlistStreamController.asBroadcastStream();

  @override
  Future<List<LibraryFile>> getPlaylistLibraryFiles(String playlistId) async {
    var files = <LibraryFile>[];
    final libraryFileIds = _playlistStreamController.value
        .firstWhere((t) => t.id == playlistId)
        .libraryFiles;
    for (final libraryApi in libraryApis) {
      for (final libraryFileId in libraryFileIds) {
        final file = await libraryApi.getFile(libraryFileId);
        files.add(file);
      }
    }

    return files;
  }

  @override
  Future<void> addPlaylist(String title) {
    final playlists = [
      ..._playlistStreamController.value,
      Playlist(id: getRandomString(5), title: title, libraryFiles: const []),
    ];

    _playlistStreamController.add(playlists);
    return _setValue(kPlaylistsCollectionKey, json.encode(playlists));
  }

  @override
  Future<void> addLibraryFileToPlaylist(
    String playlistId,
    String libraryFileId,
  ) {
    final playlists = [..._playlistStreamController.value];
    final playlistIndex = playlists.indexWhere((t) => t.id == playlistId);
    if (playlistIndex >= 0) {
      playlists[playlistIndex] = Playlist(
        id: playlists[playlistIndex].id,
        title: playlists[playlistIndex].title,
        libraryFiles: [libraryFileId, ...playlists[playlistIndex].libraryFiles],
      );
    }

    _playlistStreamController.add(playlists);
    return _setValue(kPlaylistsCollectionKey, json.encode(playlists));
  }

  @override
  Future<void> editPlaylistTitle(String playlistId, String title) {
    final playlists = [..._playlistStreamController.value];
    final playlistIndex = playlists.indexWhere((t) => t.id == playlistId);
    if (playlistIndex >= 0) {
      playlists[playlistIndex] = Playlist(
        id: playlists[playlistIndex].id,
        title: title,
        libraryFiles: playlists[playlistIndex].libraryFiles,
      );
    }

    _playlistStreamController.add(playlists);
    return _setValue(kPlaylistsCollectionKey, json.encode(playlists));
  }

  @override
  Future<void> deletePlaylist(String id) {
    final playlists = [..._playlistStreamController.value];
    final playlistIndex = playlists.indexWhere((t) => t.id == id);
    if (playlistIndex >= 0) {
      playlists.removeAt(playlistIndex);
      _playlistStreamController.add(playlists);
      return _setValue(kPlaylistsCollectionKey, json.encode(playlists));
    } else {
      throw Exception();
    }
  }

  @override
  Future<void> dispose() {
    return _playlistStreamController.close();
  }
}
