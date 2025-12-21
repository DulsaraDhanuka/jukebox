import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'navigator_state.dart';

class NavigatorCubit extends Cubit<NavigatorState> {
  NavigatorCubit()
    : super(NavigatorState(currentPage: CurrentPage.libraryPage));

  void openLibraryPage() {
    emit(state.copyWith(currentPage: CurrentPage.libraryPage));
  }

  void openPlayerPage() {
    emit(state.copyWith(currentPage: CurrentPage.playerPage));
  }

  void openPlaylistPage(String playlistId) {
    emit(state.copyWith(currentPage: CurrentPage.playlistPage, selectedPlaylistId: playlistId));
  }

  void toggleQueue() {
    emit(
      state.copyWith(
        isQueueVisible: !state.isQueueVisible,
        isAddToPlaylistVisible: state.isQueueVisible
            ? state.isAddToPlaylistVisible
            : false,
      ),
    );
  }

  void toggleAddToPlaylist() {
    emit(
      state.copyWith(
        isAddToPlaylistVisible: !state.isAddToPlaylistVisible,
        isQueueVisible: state.isAddToPlaylistVisible
            ? state.isQueueVisible
            : false,
      ),
    );
  }
}
