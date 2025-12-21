import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jukebox/navigator/cubit/navigator_cubit.dart';
import 'package:jukebox/player/bloc/player_bloc.dart';
import 'package:jukebox/player/widgets/player_bar/player_controls.dart';
import 'package:jukebox/player/widgets/player_bar/player_slider.dart';
import 'package:jukebox/player/widgets/player_bar/player_title.dart';

class PlayerBar extends StatelessWidget {
  const PlayerBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlayerBarView();
  }
}

class PlayerBarView extends StatelessWidget {
  const PlayerBarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.0,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF333842),
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 5.0,
        children: [
          PlayerControls(),
          Expanded(flex: 2, child: PlayerSlider()),
          Expanded(flex: 1, child: PlayerTitle()),
          Row(
            children: [
              BlocBuilder<PlayerBloc, PlayerState>(
                builder: (context, state) => IconButton(
                  onPressed: () {
                    if (state.queue.isNotEmpty &&
                        state.currentQueueIndex >= 0 &&
                        state.currentQueueIndex < state.queue.length) {
                      context.read<NavigatorCubit>().toggleAddToPlaylist();
                    }
                  },
                  icon: const Icon(
                    Icons.playlist_add,
                    color: Color(0xFF898989),
                  ),
                ),
                buildWhen: (previous, current) => !listEquals(previous.queue, current.queue) || previous.currentQueueIndex != current.currentQueueIndex,
              ),
              IconButton(
                onPressed: () {
                  context.read<NavigatorCubit>().toggleQueue();
                },
                icon: Icon(Icons.playlist_play, color: Color(0xFF898989)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
