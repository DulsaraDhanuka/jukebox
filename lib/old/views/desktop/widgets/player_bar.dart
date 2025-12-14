import 'package:flutter/material.dart';
import 'package:jukebox/old/data/notifiers.dart';
import 'package:jukebox/old/data/playback_handler.dart';
import 'package:jukebox/old/views/desktop/pages/player_page.dart';

class PlayerBar extends StatefulWidget {
  const PlayerBar({super.key});

  @override
  State<PlayerBar> createState() => _PlayerBarState();
}

class _PlayerBarState extends State<PlayerBar> {
  Duration currentFileDuration = Duration.zero;
  Duration currentPosition = Duration.zero;

  void updateCurrentFileDuration() {
    setState(() {
      currentFileDuration = PlaybackHandler().currentFileDuration.value;
    });
  }

  void updateCurrentPosition() {
    setState(() {
      currentPosition = PlaybackHandler().currentPosition.value;
    });
  }

  void onPlayerStateChanged() async {
    setState(() {});
  }

  @override
  void initState() {
    PlaybackHandler().currentFileDuration.addListener(
      updateCurrentFileDuration,
    );
    PlaybackHandler().currentPosition.addListener(updateCurrentPosition);
    PlaybackHandler().state.addListener(onPlayerStateChanged);

    super.initState();
  }

  @override
  void dispose() {
    PlaybackHandler().currentFileDuration.removeListener(
      updateCurrentFileDuration,
    );
    PlaybackHandler().currentPosition.removeListener(updateCurrentPosition);
    PlaybackHandler().state.removeListener(onPlayerStateChanged);

    super.dispose();
  }

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
          IconButton.filled(
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFF1ED760),
            ),
            icon: Icon(
              PlaybackHandler().state.value == PlaybackHandlerState.playing
                  ? Icons.pause
                  : Icons.play_arrow,
              color: Colors.black,
            ),
            onPressed: () async {
              if (PlaybackHandler().state.value ==
                  PlaybackHandlerState.playing) {
                await PlaybackHandler().pause();
              } else if (PlaybackHandler().state.value ==
                  PlaybackHandlerState.completed) {
                PlaybackHandler().queue.next(
                  PlaybackHandler().loopMode.value ==
                      PlaybackHandlerLoopMode.queue,
                );
                await PlaybackHandler().play();
              } else {
                await PlaybackHandler().play();
              }
            },
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.skip_previous, color: Color(0xFF898989)),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.skip_next, color: Color(0xFF898989)),
          ),
          ValueListenableBuilder(
            valueListenable: PlaybackHandler().loopMode,
            builder: (context, value, child) {
              return IconButton(
                onPressed: () {
                  setState(() {
                    if (PlaybackHandler().loopMode.value ==
                        PlaybackHandlerLoopMode.off) {
                      PlaybackHandler().loopMode.value =
                          PlaybackHandlerLoopMode.queue;
                    } else if (PlaybackHandler().loopMode.value ==
                        PlaybackHandlerLoopMode.queue) {
                      PlaybackHandler().loopMode.value =
                          PlaybackHandlerLoopMode.single;
                    } else {
                      PlaybackHandler().loopMode.value =
                          PlaybackHandlerLoopMode.off;
                    }
                  });
                },
                icon: Icon(
                  PlaybackHandler().loopMode.value ==
                          PlaybackHandlerLoopMode.single
                      ? Icons.repeat_one_rounded
                      : Icons.repeat_rounded,
                  color:
                      PlaybackHandler().loopMode.value ==
                          PlaybackHandlerLoopMode.off
                      ? Color(0xFF898989)
                      : Colors.white,
                ),
              );
            },
          ),
          Expanded(
            child: Row(
              spacing: 5.0,
              children: [
                Text(
                  currentPosition.toString().split('.').first.padLeft(8, '0'),
                ),
                Expanded(
                  child: SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: Colors.white,
                      inactiveTrackColor: Color(0x1B898989),
                      trackHeight: 3.0,
                      thumbColor: Colors.white,
                      thumbShape: RoundSliderThumbShape(
                        enabledThumbRadius: 4.0,
                      ),
                      overlayColor: Colors.white.withAlpha(32),
                      overlayShape: RoundSliderOverlayShape(overlayRadius: 8.0),
                    ),
                    child: Slider(
                      min: 0.0,
                      max: currentFileDuration.inMicroseconds.toDouble(),
                      value: currentPosition.inMicroseconds.toDouble().clamp(
                        0.0,
                        currentFileDuration.inMicroseconds.toDouble(),
                      ),
                      divisions: currentFileDuration.inMicroseconds == 0
                          ? null
                          : currentFileDuration.inMicroseconds,
                      onChanged: (value) async {
                        await PlaybackHandler().seek(
                          Duration(microseconds: value.toInt()),
                        );
                      },
                    ),
                  ),
                ),
                Text(
                  currentFileDuration
                      .toString()
                      .split('.')
                      .first
                      .padLeft(8, '0'),
                ),
              ],
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (currentPageNotifier.value is! PlayerPage) {
                  currentPageNotifier.value = PlayerPage();
                }
                setState(() {});
              },
              child: ValueListenableBuilder(
                valueListenable: PlaybackHandler().queue.currentQueueItem,
                builder: (_, currentQueueItem, _) {
                  return Padding(
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
                              currentQueueItem != null
                                  ? currentQueueItem.file.title
                                  : "",
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                  );
                },
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.playlist_add, color: Color(0xFF898989)),
          ),
          ValueListenableBuilder(
            valueListenable: isQueueVisibleNotifier,
            builder: (context, isQueueVisible, child) {
              return IconButton(
                onPressed: () {
                  isQueueVisibleNotifier.value = !isQueueVisible;
                },
                icon: Icon(
                  Icons.playlist_play,
                  color: isQueueVisible ? Colors.white : Color(0xFF898989),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
