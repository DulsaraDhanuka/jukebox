import 'package:flutter/material.dart';
import 'package:jukebox/data/notifiers.dart';
import 'package:jukebox/data/playback_handler.dart';
import 'package:jukebox/views/desktop/pages/player_page.dart';

class PlayerBar extends StatefulWidget {
  const PlayerBar({super.key});

  @override
  State<PlayerBar> createState() => _PlayerBarState();
}

class _PlayerBarState extends State<PlayerBar> {
  Duration audioDuration = Duration.zero;
  Duration currentPosition = Duration.zero;
  bool loop = false;

  @override
  void initState() {
    PlaybackHandler().onPlayerStarted((_, duration) {
      setState(() {
        audioDuration = duration;
      });
    });

    PlaybackHandler().onPlayerPositionChange((isPlaying, position) {
      setState(() {
        currentPosition = position;
      });
    });

    PlaybackHandler().onPlayerComplete(() async {
      if (loop) {
        await PlaybackHandler().player.seek(Duration.zero);
        await PlaybackHandler().player.play();
      }
      setState(() {});
    });

    PlaybackHandler().onPlayerError((error) {
      print("Playback Error: $error");
    });

    super.initState();
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
              PlaybackHandler().isPlaying() ? Icons.pause : Icons.play_arrow,
              color: Colors.black,
            ),
            onPressed: () async {
              if (PlaybackHandler().isPlaying()) {
                await PlaybackHandler().pause();
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
          IconButton(
            onPressed: () {
              setState(() {
                loop = !loop;
              });
            },
            icon: Icon(
              Icons.loop,
              color: loop ? Colors.white : Color(0xFF898989),
            ),
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
                      max: audioDuration.inMicroseconds.toDouble(),
                      value: currentPosition.inMicroseconds.toDouble().clamp(
                        0.0,
                        audioDuration.inMicroseconds.toDouble(),
                      ),
                      divisions: audioDuration.inMicroseconds == 0
                          ? null
                          : audioDuration.inMicroseconds,
                      onChanged: (value) async {
                        await PlaybackHandler().seek(Duration(microseconds: value.toInt()));
                      },
                    ),
                  ),
                ),
                Text(audioDuration.toString().split('.').first.padLeft(8, '0')),
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
              child: Container(width: double.infinity, height: double.infinity, color: Colors.blue,),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.playlist_add, color: Color(0xFF898989)),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.playlist_play, color: Color(0xFF898989)),
          ),
        ],
      ),
    );
  }
}
