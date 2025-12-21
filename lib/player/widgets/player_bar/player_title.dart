import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jukebox/navigator/cubit/navigator_cubit.dart';
import 'package:jukebox/player/bloc/player_bloc.dart';

class PlayerTitle extends StatelessWidget {
  const PlayerTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerBloc, PlayerState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () => context.read<NavigatorCubit>().openPlayerPage(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              spacing: 8.0,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFF555555),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                Expanded(
                  child: Text(
                    state.queue.isEmpty
                        ? ""
                        : state.queue[state.currentQueueIndex].title,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      buildWhen: (previous, current) =>
          previous.currentQueueIndex != current.currentQueueIndex ||
          previous.status != current.status,
    );
  }
}
