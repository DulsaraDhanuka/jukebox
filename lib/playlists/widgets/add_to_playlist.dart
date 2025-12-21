import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jukebox/navigator/cubit/navigator_cubit.dart';
import 'package:jukebox/player/bloc/player_bloc.dart';
import 'package:jukebox/playlists/bloc/playlists_bloc.dart';

class AddToPlaylistWidget extends StatefulWidget {
  const AddToPlaylistWidget({super.key});

  @override
  State<AddToPlaylistWidget> createState() => _AddToPlaylistWidgetState();
}

class _AddToPlaylistWidgetState extends State<AddToPlaylistWidget> {
  TextEditingController controller = TextEditingController();
  List<String> selectedPlaylists = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 372,
      height: 550,
      decoration: BoxDecoration(
        color: Color.fromARGB(204, 32, 32, 32),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: BoxBorder.fromLTRB(
                bottom: BorderSide(color: Color(0x55898989)),
              ),
            ),
            padding: const EdgeInsets.all(20.0),
            child: Text("Add to a playlist"),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      context.read<PlaylistsBloc>().add(
                        PlaylistsNewPlaylist(controller.text),
                      );
                      controller.clear();
                    }
                  },
                  icon: Icon(Icons.add_rounded),
                ),
                Expanded(child: TextField(controller: controller)),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 20.0,
              ),
              child: BlocBuilder<PlaylistsBloc, PlaylistsState>(
                builder: (context, state) => switch (state) {
                  PlaylistsInitial() => SizedBox(),
                  PlaylistsFailure() => SizedBox(),
                  PlaylistsLoading() => SizedBox(),
                  PlaylistsSuccess() => ListView.builder(
                    itemCount: state.playlists.length,
                    itemBuilder: (context, index) {
                      final playlist = state.playlists.elementAt(index);
                      return CheckboxListTile(
                        title: Text(playlist.title),
                        value: selectedPlaylists.contains(playlist.id),
                        onChanged: (bool? value) {
                          if (value != null &&
                              value &&
                              !selectedPlaylists.contains(playlist.id)) {
                             setState(() {
                               selectedPlaylists.add(playlist.id);
                             });
                          } else {
                            setState(() {
                              selectedPlaylists.remove(playlist.id);
                            });
                          }
                        },
                      );
                    },
                  ),
                },
              ),
            ),
          ),
          Container(
            height: 72,
            width: double.infinity,
            decoration: BoxDecoration(
              border: BoxBorder.fromLTRB(
                top: BorderSide(color: Color(0x55898989)),
              ),
            ),
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                TextButton(onPressed: () {}, child: Text("Cancel")),
                BlocBuilder<PlayerBloc, PlayerState>(
                  buildWhen: (previous, current) => !listEquals(previous.queue, current.queue) || previous.currentQueueIndex != current.currentQueueIndex,
                  builder: (context, state) {
                    return FilledButton(
                      onPressed: () {
                        for (final playlistId in selectedPlaylists) {
                          context.read<PlaylistsBloc>().add(
                            PlaylistsAddLibraryFileToPlaylist(
                              playlistId,
                              state.queue.elementAt(state.currentQueueIndex).libraryId,
                            ),
                          );
                          context.read<NavigatorCubit>().toggleAddToPlaylist();
                        }
                      },
                      child: Text("Done"),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
