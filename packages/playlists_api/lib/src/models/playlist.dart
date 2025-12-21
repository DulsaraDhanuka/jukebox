import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'playlist.g.dart';

@immutable
@JsonSerializable()
class Playlist extends Equatable {
  const Playlist({
    required this.id,
    required this.title,
    required this.libraryFiles,
  });

  final String id;
  final String title;
  final List<String> libraryFiles;

  @override
  List<Object> get props => [id];

  /// Deserializes the given [Map<String, dynamic>] into a [Playlist].
  static Playlist fromJson(Map<String, dynamic> json) =>
      _$PlaylistFromJson(json);

  /// Converts this [Playlist] into a [Map<String, dynamic>].
  Map<String, dynamic> toJson() => _$PlaylistToJson(this);
}
