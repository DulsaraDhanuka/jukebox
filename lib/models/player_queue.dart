import 'package:jukebox/models/playable.dart';
import 'package:jukebox/models/playlist.dart';

class PlayerQueue extends Playlist {
  int _current = 0;

  void setCurrentIndex(int index) {
    _current = index;
    notifyListeners();
  }

  int getCurrentIndex() {
    return _current;
  }

  Playable getCurrentPlayable() {
    return getPlayable(_current);
  }
}