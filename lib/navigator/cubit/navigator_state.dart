part of 'navigator_cubit.dart';

enum CurrentPage { libraryPage, playerPage, playlistPage }

final class NavigatorState extends Equatable {
  const NavigatorState({
    required this.currentPage,
    this.isQueueVisible = false,
    this.isAddToPlaylistVisible = false,
    this.selectedPlaylistId
  });

  final CurrentPage currentPage;
  final bool isQueueVisible;
  final bool isAddToPlaylistVisible;
  final String? selectedPlaylistId;

  @override
  List<Object?> get props => [
    currentPage,
    isQueueVisible,
    isAddToPlaylistVisible,
    selectedPlaylistId
  ];

  NavigatorState copyWith({
    CurrentPage? currentPage,
    bool? isQueueVisible,
    bool? isAddToPlaylistVisible,
    String? selectedPlaylistId,
  }) {
    return NavigatorState(
      currentPage: currentPage ?? this.currentPage,
      isQueueVisible: isQueueVisible ?? this.isQueueVisible,
      isAddToPlaylistVisible:
          isAddToPlaylistVisible ?? this.isAddToPlaylistVisible,
      selectedPlaylistId: selectedPlaylistId ?? this.selectedPlaylistId
    );
  }
}
