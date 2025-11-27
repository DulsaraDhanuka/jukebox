import 'package:jukebox/data/library_file.dart';
import 'package:media_kit/media_kit.dart';

class PlaybackHandler {
  static final PlaybackHandler _instance = PlaybackHandler._internal();

  factory PlaybackHandler() {
    return _instance;
  }

  PlaybackHandler._internal();
  
  bool isInitialized = false;
  late final Player player;
  LibraryFile? currentFile;

  void initialize() {
    player = Player();
    player.setVolume(100.0);
    isInitialized = true;
  }

  Future<void> addToQueue(LibraryFile file) async {
    if (player.state.playing) {
      await player.stop();
    }

    await player.open(Media(file.path));
    currentFile = file;
  }

  Future<void> play() async {
    await player.play();
  }

  Future<void> pause() async {
    player.pause();
  }

  Future<void> seek(Duration position) async {
    player.seek(position);
  }

  bool isPlaying() {
    return player.state.playing;
  }

  void onPlayerStarted(void Function(LibraryFile, Duration) callback) {
    player.stream.duration.listen((Duration duration) {
      if (currentFile != null && duration.inMicroseconds > 0) {
        callback(currentFile!, duration);
      }
    });
  }

  void onPlayerPositionChange(void Function(bool, Duration) callback) {
    player.stream.position.listen((Duration position) {
      callback(player.state.playing, position);
    });
  }

  void onPlayerComplete(void Function() callback) {
    player.stream.completed.listen((_) {
      callback();
    });
  }

  void onPlayerError(void Function(String) callback) {
    player.stream.error.listen((error) {
      callback(error.toString());
    });
  }
}