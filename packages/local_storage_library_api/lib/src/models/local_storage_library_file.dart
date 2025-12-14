import 'package:library_api/library_api.dart';
import 'package:meta/meta.dart';

@immutable
class LocalStorageLibraryFile extends LibraryFile {
  const LocalStorageLibraryFile({
    required super.id,
    required super.title,
    required this.fileName,
    required super.filePath,
    required super.srtPath,
  });

  final String fileName;

  static LocalStorageLibraryFile fromJson(
    Map<String, Object?> json,
    Lazy<String?> filePath,
    Lazy<String?> srtPath,
  ) {
    return LocalStorageLibraryFile(
      id: json['id']!.toString(),
      title: json['title']!.toString(),
      fileName: json['file_name']!.toString(),
      filePath: filePath,
      srtPath: srtPath,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'file_name': fileName};
  }
}
