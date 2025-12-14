import 'package:jukebox/old/models/playlist.dart';

class NamedPlaylist extends Playlist {
  late final int _id;
  late String _name;

  NamedPlaylist({required int id, required String name}) {
    _id = id;
    _name = name;
  }

  int getId() => _id;
  String getName() => _name;

  void setName(String newName) {
    _name = newName;
    notifyListeners();
  }
}