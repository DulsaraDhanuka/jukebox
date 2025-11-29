import 'package:flutter/material.dart';
import 'package:jukebox/data/library_file.dart';
import 'package:media_kit/media_kit.dart';

enum PlaybackHandlerState { playing, paused, completed, error }

enum PlaybackHandlerLoopMode { off, single, queue }

class PlaybackQueueNotifier extends ValueNotifier<List<LibraryFile>> {
  PlaybackQueueNotifier(super.value);

  void notifyAll() {
    super.notifyListeners();
  }
}

class PlaybackQueue {
  @protected
  int _currentIndex = 0;
  @protected
  final List<LibraryFile> _files = [];

  late final PlaybackQueueNotifier notifier = PlaybackQueueNotifier(_files);
  final ValueNotifier<LibraryFile?> currentFile = ValueNotifier(null);

  void add(LibraryFile file) {
    _files.add(file);
    notifier.notifyAll();

    if (_files.length == 1) {
      _currentIndex = 0;
      currentFile.value = _files[_currentIndex];
    }
    print(_files);
  }

  void next(bool loop) {
    if (_currentIndex == _files.length - 1) {
      if (loop) {
        _currentIndex = 0;
        currentFile.value = _files[_currentIndex];
      }
    } else {
      _currentIndex += 1;
      currentFile.value = _files[_currentIndex];
    }
  }
}

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
  PlaybackQueue queue = PlaybackQueue();
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

      if (loopMode.value == PlaybackHandlerLoopMode.single && queue.currentFile.value != null) {
        await player.open(Media(queue.currentFile.value!.path));
        state.value = PlaybackHandlerState.playing;
      } else {
        queue.next(loopMode.value == PlaybackHandlerLoopMode.queue);
      }
    });

    player.stream.error.listen((error) {
      this.error.value = error.toString();
      state.value = PlaybackHandlerState.error;
    });

    queue.currentFile.addListener(() async {
      if (queue.currentFile.value != null) {
        await player.open(Media(queue.currentFile.value!.path));
        state.value = PlaybackHandlerState.playing;
      }
    });
  }

  Future<void> addToQueue(LibraryFile file) async {
    queue.add(file);
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