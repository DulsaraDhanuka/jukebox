import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jukebox/navigator/cubit/navigator_cubit.dart';
import 'package:jukebox/playlists/bloc/playlists_bloc.dart';
import 'package:playlists_api/playlists_api.dart';

class PlaylistsOverview extends StatefulWidget {
  const PlaylistsOverview({super.key});

  @override
  State<PlaylistsOverview> createState() => _PlaylistsOverviewState();
}

class _PlaylistsOverviewState extends State<PlaylistsOverview> {
  bool selected = false;
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              selected = !selected;
            });
          },
          child: MouseRegion(
            onEnter: (event) {
              setState(() {
                hovered = true;
              });
            },
            onExit: (event) {
              setState(() {
                hovered = false;
              });
            },
            child: Container(
              height: 54,
              width: 260,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: selected ? const Color(0xFF111111) : null,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 10.0,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.queue_music_rounded,
                      size: 25.0,
                      color: selected || hovered
                          ? const Color(0xFFE0E0E0)
                          : const Color(0xFF898989),
                    ),
                    SizedBox(width: 10.0),
                    Expanded(
                      child: Text(
                        "Playlists",
                        style: TextStyle(
                          color: selected || hovered
                              ? const Color(0xFFE0E0E0)
                              : const Color(0xFF898989),
                          fontWeight: FontWeight.normal,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                    Icon(
                      selected
                          ? Icons.arrow_drop_down_rounded
                          : Icons.arrow_right_rounded,
                      size: 25.0,
                      color: selected || hovered
                          ? const Color(0xFFE0E0E0)
                          : const Color(0xFF898989),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: selected,
          child: BlocBuilder<PlaylistsBloc, PlaylistsState>(
            builder: (context, state) => switch (state) {
              PlaylistsInitial() => SizedBox(),
              PlaylistsFailure() => SizedBox(),
              PlaylistsLoading() => SizedBox(),
              PlaylistsSuccess() => ListView.builder(
                shrinkWrap: true,
                itemCount: state.playlists.length,
                itemBuilder: (_, index) {
                  final playlist = state.playlists.elementAt(index);
                  return PlaylistOverviewTile(
                    id: playlist.id,
                    title: playlist.title,
                    selected: false,
                  );
                },
              ),
            },
          ),
        ),
      ],
    );
  }
}

class PlaylistOverviewTile extends StatefulWidget {
  const PlaylistOverviewTile({
    super.key,
    required this.id,
    required this.title,
    required this.selected,
  });

  final String id;
  final String title;
  final bool selected;

  @override
  State<PlaylistOverviewTile> createState() => _PlaylistOverviewTileState();
}

class _PlaylistOverviewTileState extends State<PlaylistOverviewTile> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<NavigatorCubit>().openPlaylistPage(widget.id);
      },
      child: MouseRegion(
        onEnter: (event) {
          setState(() {
            hovered = true;
          });
        },
        onExit: (event) {
          setState(() {
            hovered = false;
          });
        },
        child: Container(
          height: 40,
          width: 260,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: widget.selected ? const Color(0xFF111111) : null,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 20.0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.queue_music_rounded,
                  size: 25.0,
                  color: widget.selected || hovered
                      ? const Color(0xFFE0E0E0)
                      : const Color(0xFF898989),
                ),
                SizedBox(width: 10.0),
                Text(
                  widget.title,
                  style: TextStyle(
                    color: widget.selected || hovered
                        ? const Color(0xFFE0E0E0)
                        : const Color(0xFF898989),
                    fontWeight: FontWeight.normal,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
