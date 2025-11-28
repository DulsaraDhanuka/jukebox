import 'package:flutter/material.dart';
import 'package:jukebox/data/library_file.dart';
import 'package:media_kit/media_kit.dart';

enum PlaybackHandlerState { playing, paused, completed, error }

enum PlaybackHandlerLoopMode { off, single, queue }

class PlaybackHandler {
  static final PlaybackHandler _instance = PlaybackHandler._internal();

  factory PlaybackHandler() {
    return _instance;
  }

  PlaybackHandler._internal();
  
  bool isInitialized = false;
  late final Player player;
  ValueNotifier<PlaybackHandlerState> state = ValueNotifier(PlaybackHandlerState.completed);
  ValueNotifier<String?> error = ValueNotifier(null);
  ValueNotifier<LibraryFile?> currentFile = ValueNotifier(null);
  ValueNotifier<Duration> currentFileDuration = ValueNotifier(Duration.zero);
  ValueNotifier<Duration> currentPosition = ValueNotifier(Duration.zero);
  ValueNotifier<PlaybackHandlerLoopMode> loopMode = ValueNotifier(PlaybackHandlerLoopMode.off);

  void initialize() {
    player = Player();
    player.setVolume(100.0);
    isInitialized = true;

    player.stream.duration.listen((Duration duration) {
      currentFileDuration.value = duration;
    });

    player.stream.position.listen((Duration position) {
      currentPosition.value = position;
    });

    player.stream.completed.listen((_) async {
      state.value = PlaybackHandlerState.completed;

      if (loopMode.value == PlaybackHandlerLoopMode.single && currentFile.value != null) {
        await player.open(Media(currentFile.value!.path));
        state.value = PlaybackHandlerState.playing;
      }
    });

    player.stream.error.listen((error) {
      this.error.value = error.toString();
      state.value = PlaybackHandlerState.error;
    });
  }

  Future<void> addToQueue(LibraryFile file) async {
    if (state.value == PlaybackHandlerState.playing) {
      await player.stop();
      state.value = PlaybackHandlerState.completed;
    }

    await player.open(Media(file.path));
    currentFile.value = file;
    state.value = PlaybackHandlerState.playing;
  }

  Future<void> play() async {
    await player.play();
    state.value = PlaybackHandlerState.playing;
  }

  Future<void> pause() async {
    player.pause();
    state.value = PlaybackHandlerState.paused;
  }

  Future<void> seek(Duration position) async {
    player.seek(position);
  }
}