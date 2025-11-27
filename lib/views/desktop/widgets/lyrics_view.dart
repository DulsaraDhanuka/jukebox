import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jukebox/data/playback_handler.dart';
import 'package:path/path.dart' as p;

class LyricsView extends StatefulWidget {
  const LyricsView({super.key});

  @override
  State<LyricsView> createState() => _LyricsViewState();
}

class _LyricsViewState extends State<LyricsView> {
  String srtString = "";

  @override
  void initState() {
    PlaybackHandler().onPlayerStarted((file, _) {
      print("New started");
      setState(() async {
        File? srtFile = file.getSrtFile();
        if (srtFile != null) {
          srtString = await srtFile.readAsString();
        }
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text(srtString);
  }
}