import 'package:jukebox/data/library_file.dart';
import 'package:jukebox/data/playlist_item.dart';

class Playlist {
  int id = 0;
  String name = "";
  final List<PlaylistItem> _items = [];
  
  Playlist({ required this.id, required this.name });
  
  addItem(LibraryFile file) {
    
  }
}