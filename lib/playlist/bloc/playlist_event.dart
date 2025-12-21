part of 'playlist_bloc.dart';

sealed class PlaylistEvent extends Equatable {
  const PlaylistEvent();

  @override
  List<Object> get props => [];
}

final class PlaylistLoadLibraryFiles extends PlaylistEvent {
  const PlaylistLoadLibraryFiles();
}
