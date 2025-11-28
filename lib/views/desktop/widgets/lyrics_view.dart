import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jukebox/data/library_file.dart';
import 'package:jukebox/data/playback_handler.dart';
import 'package:collection/collection.dart';
import 'package:path/path.dart' as p;

class DurationRange {
  final Duration start;
  final Duration end;

  DurationRange({required this.start, required this.end});
}

class LyricsView extends StatefulWidget {
  const LyricsView({super.key});

  @override
  State<LyricsView> createState() => _LyricsViewState();
}

class _LyricsViewState extends State<LyricsView> {
  List<String> lyrics = [];
  List<DurationRange> timeRanges = [];
  int? currentLyricPart = null;

  static Duration parseTimeString(String timeStr) {
    final parts = timeStr.split(':');
    final secondsAndMillis = parts[2].split(',');

    final hours = int.parse(parts[0]);
    final minutes = int.parse(parts[1]);
    final seconds = int.parse(secondsAndMillis[0]);
    final milliseconds = int.parse(secondsAndMillis[1]);

    return Duration(
      hours: hours,
      minutes: minutes,
      seconds: seconds,
      milliseconds: milliseconds,
    );
  }

  void onNewFileSelected() async {
    LibraryFile? currentFile = PlaybackHandler().currentFile.value;

    if (currentFile != null) {
      File? srtFile = await currentFile.getSrtFile();
      if (srtFile != null) {
        List<String> srtParts = (await srtFile.readAsString()).split("\n\n");

        for (var srtPart in srtParts) {
          List<String> parts = srtPart.split("\n");
          lyrics.add(parts[2]);

          List<String> durations = parts[1].split(" --> ");
          timeRanges.add(
            DurationRange(
              start: parseTimeString(durations[0]),
              end: parseTimeString(durations[1]),
            ),
          );
        }

        setState(() {});
      }
    }
  }

  void onPlayerPositionChange() {
    Duration currentTime = PlaybackHandler().currentPosition.value;
    for (var i = 0; i < timeRanges.length; i++) {
      if (timeRanges[i].start < currentTime &&
          timeRanges[i].end > currentTime) {
        currentLyricPart = i;
        setState(() {});
        return;
      }
    }

    currentLyricPart = null;
    setState(() {});
  }

  @override
  void initState() {
    onNewFileSelected();

    PlaybackHandler().currentFile.addListener(onNewFileSelected);
    PlaybackHandler().currentPosition.addListener(onPlayerPositionChange);
    super.initState();
  }

  @override
  void dispose() {
    PlaybackHandler().currentFile.removeListener(onNewFileSelected);
    PlaybackHandler().currentPosition.removeListener(onPlayerPositionChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4.0,
      children: lyrics.mapIndexed((index, part) => Text(style: TextStyle(color: currentLyricPart == index ? Colors.red : Colors.white), part)).toList(),
    );
  }
}
