import 'package:equatable/equatable.dart';
import 'package:library_api/src/utils.dart';
import 'package:meta/meta.dart';

@immutable
class LibraryFile extends Equatable {
  const LibraryFile({
    required this.id,
    required this.title,
    required this.filePath,
    required this.srtPath
  });
  
  final String id;
  final String title;
  final Lazy<String?> filePath;
  final Lazy<String?> srtPath;

  @override
  List<Object?> get props => [id];
}