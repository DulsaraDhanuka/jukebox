import 'package:flutter/material.dart';
import 'package:jukebox/data/notifiers.dart';
import 'package:media_kit/media_kit.dart';

class PlayerBar extends StatefulWidget {
  const PlayerBar({super.key});

  @override
  State<PlayerBar> createState() => _PlayerBarState();
}

class _PlayerBarState extends State<PlayerBar> {
  late final player = Player();

  Duration audioDuration = Duration.zero;
  Duration currentPosition = Duration.zero;
  bool loop = false;

  @override
  void initState() {
    playerNotifier.value = player;
    player.setVolume(100.0);
    player.stream.playing.listen((bool playing) {
      setState(() {});
    });
    player.stream.completed.listen((_) async {
      if (loop) {
        await player.seek(Duration.zero);
        await player.play();
      }
      setState(() {});
    });

    player.stream.error.listen((error) {
      print("Player Error: $error");
    });

    player.stream.duration.listen((Duration duration) {
      setState(() {
        audioDuration = duration;
      });
    });

    player.stream.position.listen((Duration position) {
      setState(() {
        currentPosition = position;
      });
    });

    musicFileNotifier.addListener(() async {
      final filePath = musicFileNotifier.value;
      if (filePath != null && filePath.isNotEmpty) {
        if (player.state.playing) {
          await player.stop();
        }

        await player.open(
          Media(
            filePath,
          ),
        );
        setState(() {});
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
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
              player.state.playing ? Icons.pause : Icons.play_arrow,
              color: Colors.black,
            ),
            onPressed: () async {
              if (player.state.playing) {
                await player.pause();
              } else {
                await player.play();
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
                      max: audioDuration.inSeconds.toDouble(),
                      value: currentPosition.inSeconds.toDouble().clamp(
                        0.0,
                        audioDuration.inSeconds.toDouble(),
                      ),
                      divisions: audioDuration.inSeconds == 0
                          ? null
                          : audioDuration.inSeconds,
                      onChanged: (value) async {
                        await player.seek(Duration(seconds: value.toInt()));
                      },
                    ),
                  ),
                ),
                Text(audioDuration.toString().split('.').first.padLeft(8, '0')),
              ],
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
