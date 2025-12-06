import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jukebox/player/bloc/player_bloc.dart';

class PlayerControls extends StatelessWidget {
  const PlayerControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        BlocBuilder<PlayerBloc, PlayerState>(
          builder: (context, state) {
            switch (state.status) {
              case PlayerStatus.stopped:
              case PlayerStatus.completed:
              case PlayerStatus.paused:
              case PlayerStatus.error:
                return IconButton.filled(
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFF1ED760),
                  ),
                  icon: Icon(Icons.play_arrow, color: Colors.black),
                  onPressed: () async {
                    context.read<PlayerBloc>().add(PlayerResumeRequested());
                  },
                );
              case PlayerStatus.playing:
                return IconButton.filled(
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFF1ED760),
                  ),
                  icon: Icon(Icons.pause, color: Colors.black),
                  onPressed: () async {
                    context.read<PlayerBloc>().add(PlayerPauseRequested());
                  },
                );
            }
          },
          buildWhen: (previous, current) => previous.status != current.status,
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.skip_previous, color: Color(0xFF898989)),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.skip_next, color: Color(0xFF898989)),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.repeat_one_rounded, color: Color(0xFF898989)),
        ),
      ],
    );
  }
}
