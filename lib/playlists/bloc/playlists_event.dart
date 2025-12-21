part of 'playlists_bloc.dart';

sealed class PlaylistsEvent extends Equatable {
  const PlaylistsEvent();

  @override
  List<Object> get props => [];
}

final class PlaylistsSubscribe extends PlaylistsEvent {
  const PlaylistsSubscribe();
}

final class PlaylistsNewPlaylist extends PlaylistsEvent {
  const PlaylistsNewPlaylist(this.title);

  final String title;

  @override
  List<Object> get props => [...super.props, this.title];
}

final class PlaylistsAddLibraryFileToPlaylist extends PlaylistsEvent {
  const PlaylistsAddLibraryFileToPlaylist(this.playlistId, this.libraryFileId);

  final String playlistId;
  final String libraryFileId;

  @override
  List<Object> get props => [...super.props, this.playlistId, this.libraryFileId];
}