import 'package:flutter/material.dart';

enum PlayerState { completed, playing, paused, error }
enum PlayerLoopMode { off, single, queue }

class Player extends ChangeNotifier {
  PlayerState _state = PlayerState.paused;
  Duration _position = Duration.zero;
  bool _error = false;
  String? _errorMessage;
  PlayerLoopMode _loopMode = PlayerLoopMode.off;
  
  PlayerState getState() => _state;
  Duration getPosition() => _position;
  bool hasError() => _error;
  String? getErrorMessage() => _errorMessage;
  PlayerLoopMode getLoopMode() => _loopMode;

  void setState(PlayerState state) {
    _state = state;
    notifyListeners();
  }

  void setPosition(Duration position) {
    _position = position;
    notifyListeners();
  }

  void setError(bool error, String? message) {
    _error = error;
    _errorMessage = message;
    notifyListeners();
  }

  void setLoopMode(PlayerLoopMode mode) {
    _loopMode = mode;
    notifyListeners();
  }
}
