import 'package:flutter/material.dart';
import 'package:jukebox/data/library_file.dart';
import 'package:jukebox/data/playback_queue_item.dart';
import 'package:jukebox/utils.dart';
import 'package:media_kit/media_kit.dart';

enum PlaybackHandlerState { playing, paused, completed, error }

enum PlaybackHandlerLoopMode { off, single, queue }

class PlaybackQueueNotifier extends ValueNotifier<List<PlaybackQueueItem>> {
  PlaybackQueueNotifier(super.value);

  void notifyAll() {
    super.notifyListeners();
  }
}

class PlaybackQueue {
  int _currentIndex = 0;
  final List<PlaybackQueueItem> _queueItems = [];

  late final PlaybackQueueNotifier notifier = PlaybackQueueNotifier(_queueItems);
  final ValueNotifier<PlaybackQueueItem?> currentQueueItem = ValueNotifier(null);

  void add(LibraryFile file) {
    _queueItems.add(PlaybackQueueItem(id: getRandomString(10), file: file));
    notifier.notifyAll();

    if (_queueItems.length == 1) {
      _currentIndex = 0;
      currentQueueItem.value = _queueItems[_currentIndex];
    }
  }

  void remove(int index) {
    _queueItems.removeAt(index);
    notifier.notifyAll();

    if (_currentIndex >= _queueItems.length) {
      _currentIndex = _queueItems.length - 1;
    }
    currentQueueItem.value = _queueItems.isNotEmpty ? _queueItems[_currentIndex] : null;
  }

  void next(bool loop) {
    if (_currentIndex == _queueItems.length - 1) {
      if (loop) {
        _currentIndex = 0;
        currentQueueItem.value = _queueItems[_currentIndex];
      } else {
        _currentIndex = -1;
        currentQueueItem.value = null;
      }
    } else {
      _currentIndex += 1;
      currentQueueItem.value = _queueItems[_currentIndex];
    }
  }

  void setIndex(int index) {
    if (index >= 0 && index < _queueItems.length) {
      _currentIndex = index;
      currentQueueItem.value = _queueItems[_currentIndex];
    }
  }

  int getCurrentIndex() {
    return _currentIndex;
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
      if (state.value == PlaybackHandlerState.error || state.value == PlaybackHandlerState.completed) {
        return;
      }

      state.value = PlaybackHandlerState.completed;

      if (loopMode.value == PlaybackHandlerLoopMode.single && queue.currentQueueItem.value != null) {
        await player.open(Media(queue.currentQueueItem.value!.file.path));
        state.value = PlaybackHandlerState.playing;
      } else {
        queue.next(loopMode.value == PlaybackHandlerLoopMode.queue);
        play();
      }
    });

    player.stream.error.listen((error) {
      this.error.value = error.toString();
      state.value = PlaybackHandlerState.error;
    });

    queue.currentQueueItem.addListener(() async {
      if (queue.currentQueueItem.value != null) {
        await player.open(Media(queue.currentQueueItem.value!.file.path));
        state.value = PlaybackHandlerState.playing;
      } else {
        state.value = PlaybackHandlerState.completed;
        await player.stop();
      }
    });
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