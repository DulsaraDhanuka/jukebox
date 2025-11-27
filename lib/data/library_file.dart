import 'dart:io';
import 'package:path/path.dart' as p;

class LibraryFile {
  final int libraryId;
  final String title;
  final String path;
  final Duration duration;

  LibraryFile({
    required this.libraryId,
    required this.title,
    required this.path,
    required this.duration,
  });

  File? getSrtFile() {
    File mediaFile = File(path);
    File srtFile = File("${mediaFile.path}${p.basenameWithoutExtension(mediaFile.path)}.srt");

    return srtFile;
  }
}