part of 'playlist_bloc.dart';

sealed class PlaylistState extends Equatable {
  const PlaylistState();
  
  @override
  List<Object> get props => [];
}

final class PlaylistInitial extends PlaylistState {}

final class PlaylistFailure extends PlaylistState {
  const PlaylistFailure(this.message);
  final String message;
  @override
  List<Object> get props => [...super.props, message];
}

final class PlaylistLoading extends PlaylistState {
  const PlaylistLoading();
}

final class PlaylistSuccess extends PlaylistState {
  const PlaylistSuccess(this.files);
  final List<LibraryFile> files;
  @override
  List<Object> get props => [...super.props, ...files];
}
