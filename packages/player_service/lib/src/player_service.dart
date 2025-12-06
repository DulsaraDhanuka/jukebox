import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:media_kit/media_kit.dart';

enum PlayerServiceStatus { stopped, completed, playing, paused, error }

class PlayerService {
  PlayerService() {
    _statusController.add(PlayerServiceStatus.stopped);
    _player.stream.completed.listen((completed) {
      if (completed) {
        _statusController.add(PlayerServiceStatus.completed);
      }
    });

    _player.stream.error.listen((error) {
      print(error);
      _statusController.add(PlayerServiceStatus.error);
    });
  }

  final Player _player = Player();
  final _statusController = StreamController<PlayerServiceStatus>.broadcast();

  Stream<PlayerServiceStatus> getStatus() => _statusController.stream;

  Stream<Duration> getDuration() => _player.stream.duration;

  Stream<Duration> getPosition() => _player.stream.position;
  Future<void> seek(Duration position) async {
    if (position >= _player.state.duration) {
      _statusController.add(PlayerServiceStatus.completed);
      await _player.seek(_player.state.duration);
    } else {
      await _player.seek(position);
    }
  }

  Stream<double> getVolume() => _player.stream.volume;
  Future<void> setVolume(double volume) =>
      _player.setVolume(max(0, min(100, volume)).toDouble());

  Future<void> play() async {
    if (_player.state.playlist.medias.isNotEmpty) {
      await _player.play();
      _statusController.add(PlayerServiceStatus.playing);
    } else {
      _statusController.add(PlayerServiceStatus.stopped);
    }
  }

  Future<void> open(String filePath) async {
    await stop();
    unawaited(
      _player.open(Media(File(filePath).uri.toString()), play: false),
    );

    await for (final playlist in _player.stream.playlist) {
      if (playlist.medias.isNotEmpty) {
        break;
      }
    }

    await for (final duration in _player.stream.duration) {
      if (duration > Duration.zero) {
        _statusController.add(PlayerServiceStatus.paused);
        break;
      }
    }
  }

  Future<void> stop() async {
    unawaited(_player.stop());
    await for (final playlist in _player.stream.playlist) {
      if (playlist.medias.isEmpty) {
        _statusController.add(PlayerServiceStatus.stopped);
        break;
      }
    }
  }

  Future<void> pause() async {
    if (_player.state.playlist.medias.isNotEmpty) {
      await _player.pause();
      _statusController.add(PlayerServiceStatus.paused);
    } else {
      _statusController.add(PlayerServiceStatus.stopped);
    }
  }

  Player getPlayer() => _player;

  Future<void> dispose() async {
    await _statusController.close();
    await _player.dispose();
  }
}
