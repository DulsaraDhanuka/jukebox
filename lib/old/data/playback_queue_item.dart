import 'package:jukebox/old/data/library_file.dart';

class PlaybackQueueItem {
  final String id;
  final LibraryFile file;

  PlaybackQueueItem({required this.id, required this.file});


  @override
  bool operator ==(Object other) {
    return other is PlaybackQueueItem &&
        other.id == id &&
        other.file == file;
  }

  @override
  int get hashCode =>
      id.hashCode ^ file.hashCode;
}