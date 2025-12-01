import 'package:jukebox/data/library_file.dart';

class PlaylistItem {
  final String id;
  final LibraryFile file;

  PlaylistItem({required this.id, required this.file});


  @override
  bool operator ==(Object other) {
    return other is PlaylistItem &&
        other.id == id &&
        other.file == file;
  }

  @override
  int get hashCode =>
      id.hashCode ^ file.hashCode;
}