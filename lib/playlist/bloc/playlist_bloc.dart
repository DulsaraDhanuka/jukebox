import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:library_api/library_api.dart';
import 'package:playlists_repository/playlists_repository.dart';

part 'playlist_event.dart';
part 'playlist_state.dart';

class PlaylistBloc extends Bloc<PlaylistEvent, PlaylistState> {
  PlaylistBloc({
    required PlaylistsRepository playlistsRepository,
    required String playlistId,
  }) : _playlistsRepository = playlistsRepository,
       _playlistId = playlistId,
       super(PlaylistInitial()) {
    on<PlaylistLoadLibraryFiles>(_onLoadLibraryFiles);
  }

  final PlaylistsRepository _playlistsRepository;
  final String _playlistId;

  Future<void> _onLoadLibraryFiles(
    PlaylistLoadLibraryFiles event,
    Emitter<PlaylistState> emit,
  ) async {
    emit(PlaylistLoading());
    final files = await _playlistsRepository.getPlaylistLibraryFiles(
      _playlistId,
    );
    emit(PlaylistSuccess(files));
  }
}
