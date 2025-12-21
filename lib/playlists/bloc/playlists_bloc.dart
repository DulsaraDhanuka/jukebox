import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:playlists_api/playlists_api.dart';
import 'package:playlists_repository/playlists_repository.dart';

part 'playlists_event.dart';
part 'playlists_state.dart';

class PlaylistsBloc extends Bloc<PlaylistsEvent, PlaylistsState> {
  PlaylistsBloc({required PlaylistsRepository playlistsRepository})
    : _playlistsRepository = playlistsRepository,
      super(PlaylistsInitial()) {
    on<PlaylistsSubscribe>(_onSubscriptionRequested);
    on<PlaylistsNewPlaylist>(_onNewPlaylist);
    on<PlaylistsAddLibraryFileToPlaylist>(_onAddLibraryFileToPlaylist);
  }

  final PlaylistsRepository _playlistsRepository;

  Future<void> _onSubscriptionRequested(
    PlaylistsSubscribe event,
    Emitter<PlaylistsState> emit,
  ) async {
    emit(PlaylistsLoading());

    await emit.forEach<List<Playlist>>(
      _playlistsRepository.getPlaylists(),
      onData: (data) => PlaylistsSuccess(playlists: data),
      onError: (error, trace) => PlaylistsFailure(message: '$error, $trace'),
    );
  }

  Future<void> _onNewPlaylist(
    PlaylistsNewPlaylist event,
    Emitter<PlaylistsState> emit,
  ) async {
    await _playlistsRepository.addPlaylist(event.title);
  }

  Future<void> _onAddLibraryFileToPlaylist(
    PlaylistsAddLibraryFileToPlaylist event,
    Emitter<PlaylistsState> emit,
  ) async {
    await _playlistsRepository.addLibraryFileToPlaylist(
      event.playlistId,
      event.libraryFileId,
    );
  }
}
