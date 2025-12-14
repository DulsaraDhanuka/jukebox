import 'package:jukebox/old/data/library_file.dart';
import 'package:jukebox/old/data/playlist_item.dart';

class Playlist {
  int id = 0;
  String name = "";
  final List<PlaylistItem> _items = [];
  
  Playlist({ required this.id, required this.name });
  
  addItem(LibraryFile file) {
    
  }
}