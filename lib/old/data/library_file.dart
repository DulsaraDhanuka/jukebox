import 'dart:io';
import 'package:path/path.dart' as p;

class LibraryFile {
  final int id;
  final String title;
  final String path;
  final Duration duration;

  LibraryFile({
    required this.id,
    required this.title,
    required this.path,
    required this.duration,
  });

  Future<File?> getSrtFile() async {
    File mediaFile = File(path);
    File srtFile = File(
      "${mediaFile.parent.path}/${p.basenameWithoutExtension(mediaFile.path)}.srt",
    );

    if (await srtFile.exists()) {
    print("${mediaFile.parent.path}/${p.basenameWithoutExtension(mediaFile.path)}.srt");
      return srtFile;
    } else {
      return null;
    }
  }

  @override
  bool operator ==(Object other) {
    return other is LibraryFile &&
        other.id == id &&
        other.path == path &&
        other.duration == duration &&
        other.title == title;
  }

  @override
  int get hashCode =>
      id.hashCode ^ path.hashCode ^ duration.hashCode ^ title.hashCode;
}
