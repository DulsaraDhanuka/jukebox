
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'playable.g.dart';

@immutable
@JsonSerializable()
final class Playable extends Equatable {
  const Playable({
    required this.title,
    required this.filePath
  });

  final String title;
  final String filePath; 

  @override
  List<String> get props => [title, filePath];

  /// Deserializes the given [JsonMap] into a [Todo].
  static Playable fromJson(Map<String, dynamic> json) => _$PlayableFromJson(json);

  /// Converts this [Todo] into a [JsonMap].
  Map<String, dynamic> toJson() => _$PlayableToJson(this);

}