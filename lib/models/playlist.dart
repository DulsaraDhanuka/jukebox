import 'package:flutter/foundation.dart';
import 'package:jukebox/models/playable.dart';

abstract class Playlist extends ChangeNotifier {
  final List<Playable> _playables = [];

  Playable getPlayable(int index) {
    return _playables[index];
  }

  void addPlayable(Playable playable) {
    playable.addListener(notifyListeners);
    _playables.add(playable);
    notifyListeners();
  }

  void removePlayable(int index) {
    _playables[index].removeListener(notifyListeners);
    _playables.removeAt(index);
    notifyListeners();
  }

  @override
  bool operator ==(Object other) {
    return other is Playlist &&
        listEquals(other._playables, _playables);
  }

  @override
  int get hashCode => _playables.hashCode;
}