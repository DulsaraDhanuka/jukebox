part of 'playlists_bloc.dart';

sealed class PlaylistsState extends Equatable {
  const PlaylistsState();

  @override
  List<Object> get props => [];
}

final class PlaylistsInitial extends PlaylistsState {}

final class PlaylistsSuccess extends PlaylistsState {
  final List<Playlist> playlists;

  const PlaylistsSuccess({required this.playlists});

  @override
  List<Object> get props => [...super.props, ...playlists];
}

final class PlaylistsFailure extends PlaylistsState {
  final String message;

  const PlaylistsFailure({required this.message});

  @override
  List<Object> get props => [...super.props, message];
}

final class PlaylistsLoading extends PlaylistsState {
  const PlaylistsLoading();
}
