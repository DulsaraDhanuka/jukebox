import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jukebox/player/bloc/player_bloc.dart';

class Queue extends StatelessWidget {
  const Queue({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 450,
      decoration: BoxDecoration(
        color: Color.fromARGB(204, 32, 32, 32),
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: EdgeInsets.all(20.0),
      child: QueueView(),
    );
  }
}

class QueueView extends StatelessWidget {
  const QueueView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<PlayerBloc, PlayerState>(
          listenWhen: (previous, current) =>
              previous.currentQueueIndex != current.currentQueueIndex ||
              listEquals(previous.queue, current.queue),
          listener: (context, state) {},
        ),
      ],
      child: BlocBuilder<PlayerBloc, PlayerState>(
        builder: (context, state) {
          return ListView.builder(
            itemCount: state.queue.length,
            itemBuilder: (_, index) {
              final playable = state.queue.elementAt(index);
              // return Dismissible(
              //   key: Key(playable.filePath),
              //   onDismissed: (direction) {
              //     context.read<PlayerBloc>().add(PlayerRemoveFromQueue(index));
              //   },
              //   child: ,
              // );
              return ListTile(
                onTap: () {
                  context.read<PlayerBloc>().add(
                    PlayerChangeCurrentQueueIndex(index),
                  );
                },
                title: Text(playable.title),
                selected: index == state.currentQueueIndex,
                trailing: IconButton(
                  onPressed: () => context.read<PlayerBloc>().add(
                    PlayerRemoveFromQueue(index),
                  ),
                  icon: Icon(Icons.close),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
