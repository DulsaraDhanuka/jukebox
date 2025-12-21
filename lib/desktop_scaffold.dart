import 'package:flutter/material.dart' hide NavigatorState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jukebox/library/views/library_page.dart';
import 'package:jukebox/navigator/cubit/navigator_cubit.dart';
import 'package:jukebox/navigator/widgets/sidebar.dart';
import 'package:jukebox/player/views/player_page.dart';
import 'package:jukebox/player/widgets/queue/queue.dart';
import 'package:jukebox/playlist/views/playlist_page.dart';
import 'package:jukebox/playlists/widgets/add_to_playlist.dart';
import 'player/widgets/player_bar/player_bar.dart';

class DesktopScaffold extends StatelessWidget {
  const DesktopScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavigatorCubit(),
      child: DesktopScaffoldView(),
    );
  }
}

class DesktopScaffoldView extends StatelessWidget {
  const DesktopScaffoldView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: const Color(0xFF060606)),
        padding: EdgeInsets.all(10.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Sidebar(),
            ),
            Expanded(
              child: Column(
                children: [
                  Expanded(child: MainContent()),
                  SizedBox(height: 4.0),
                  PlayerBar(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MainContent extends StatelessWidget {
  const MainContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentGeometry.bottomRight,
      children: [
        Container(
          decoration: BoxDecoration(
            border: BoxBorder.all(color: const Color(0xFF202020), width: 1),
            borderRadius: BorderRadius.circular(10.0),
          ),
          clipBehavior: Clip.hardEdge,
          child: BlocBuilder<NavigatorCubit, NavigatorState>(
            builder: (context, state) => switch (state.currentPage) {
              CurrentPage.libraryPage => LibraryPage(),
              CurrentPage.playerPage => PlayerPage(),
              CurrentPage.playlistPage => PlaylistPage(key: Key(state.selectedPlaylistId!), playlistId: state.selectedPlaylistId!,)
            },
          ),
        ),
        Visibility(visible: context.watch<NavigatorCubit>().state.isAddToPlaylistVisible, child: AddToPlaylistWidget()),
        Visibility(visible: context.watch<NavigatorCubit>().state.isQueueVisible, child: Queue()),
      ],
    );
  }
}
