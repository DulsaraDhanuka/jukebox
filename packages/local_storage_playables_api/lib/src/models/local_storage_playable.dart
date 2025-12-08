import 'package:meta/meta.dart';
import 'package:playables_api/playables_api.dart';

@immutable
class LocalStoragePlayable extends Playable {
  const LocalStoragePlayable({
    required super.id,
    required super.title,
    required this.fileName,
    required super.filePath,
    required super.srtPath,
  });

  final String fileName;

  static LocalStoragePlayable fromJson(
    Map<String, Object?> json,
    Lazy<String?> filePath,
    Lazy<String?> srtPath,
  ) {
    return LocalStoragePlayable(
      id: json['id']!.toString(),
      title: json['title']!.toString(),
      fileName: json['fileName']!.toString(),
      filePath: filePath,
      srtPath: srtPath,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'fileName': fileName};
  }
}
