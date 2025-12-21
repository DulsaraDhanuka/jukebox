import 'package:flutter/material.dart' hide NavigatorState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jukebox/navigator/cubit/navigator_cubit.dart';
import 'package:jukebox/navigator/widgets/menu_tile.dart';
import 'package:jukebox/playlists/widgets/playlists_overview.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigatorCubit, NavigatorState>(
      builder: (context, state) {
        return Container(
          width: 260.0,
          height: double.infinity,
          decoration: BoxDecoration(
            color: state.currentPage == CurrentPage.libraryPage
                ? const Color(0xFF111111)
                : null,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            children: [
              MenuTile(
                title: "My Library",
                iconOutlined: Icons.my_library_music_outlined,
                iconFilled: Icons.my_library_music_rounded,
                selected: state.currentPage == CurrentPage.libraryPage,
                onTap: () => context.read<NavigatorCubit>().openLibraryPage(),
              ),
              Column(children: [PlaylistsOverview()]),
            ],
          ),
        );
      },
    );
  }
}
