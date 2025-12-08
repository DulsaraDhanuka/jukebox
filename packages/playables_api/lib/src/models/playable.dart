import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:playables_api/src/helper.dart';

@immutable
class Playable extends Equatable {
  const Playable({
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