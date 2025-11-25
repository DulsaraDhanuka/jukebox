import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:jukebox/data/notifiers.dart';

class Player extends StatefulWidget {
  const Player({super.key});

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  final player = AudioPlayer();
  Duration audioDuration = Duration.zero;
  Duration currentPosition = Duration.zero;
  bool loop = false;

  @override
  void initState() {
    player.setReleaseMode(ReleaseMode.loop);

    player.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        if (loop && state == PlayerState.completed) {
          player.seek(Duration.zero);
          player.resume();
        } else if (!loop && state == PlayerState.completed) {
          player.stop();
        }
      });
    });
    player.onDurationChanged.listen((Duration duration) {
      setState(() {
        audioDuration = duration;
      });
    });
    player.onPositionChanged.listen((Duration position) {
      setState(() {
        currentPosition = position;
      });
    });
    // player.play(DeviceFileSource("/mnt/data/songs/Anytime Anywhere.mp3"));
    musicFileNotifier.addListener(() {
      final filePath = musicFileNotifier.value;
      if (filePath != null && filePath.isNotEmpty) {
        player.stop();
        player.release();
        player.play(DeviceFileSource(filePath));
      }
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
              player.state == PlayerState.playing
                  ? Icons.pause
                  : Icons.play_arrow,
              color: Colors.black,
            ),
            onPressed: () {
              if (player.state == PlayerState.playing) {
                player.pause();
              } else {
                player.resume();
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
                      onChanged: (value) {
                        player.seek(Duration(seconds: value.toInt()));
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
