import 'package:flutter/material.dart';
import 'package:jukebox/old/data/playback_handler.dart';

class QueueView extends StatefulWidget {
  const QueueView({super.key});

  @override
  State<QueueView> createState() => _QueueViewState();
}

class _QueueViewState extends State<QueueView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: const Color(0xEE333842),
        border: BoxBorder.all(color: const Color(0xFF333842), width: 1),
        borderRadius: BorderRadius.circular(10.0),
      ),
      width: 500.0,
      child: ValueListenableBuilder(
        valueListenable: PlaybackHandler().queue.notifier,
        builder: (context, queueFiles, child) {
          return ListView.builder(
            itemCount: queueFiles.length,
            itemBuilder: (context, index) {
              return ValueListenableBuilder(
                valueListenable: PlaybackHandler().queue.currentQueueItem,
                builder: (_, _, _) {
                  return ListTile(
                    minTileHeight: 55,
                    onTap: () {
                      PlaybackHandler().queue.setIndex(index);
                    },
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFF555555),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: index == PlaybackHandler().queue.getCurrentIndex()
                          ? Icon(Icons.play_arrow, color: Colors.white)
                          : null,
                    ),
                    title: Text(
                      queueFiles[index].file.title,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: IconButton(
                      style: IconButton.styleFrom(fixedSize: Size(50, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))),
                      // iconSize: 45,
                      onPressed: () {
                        PlaybackHandler().queue.remove(index);
                      },
                      icon: const Icon(Icons.close_rounded),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
