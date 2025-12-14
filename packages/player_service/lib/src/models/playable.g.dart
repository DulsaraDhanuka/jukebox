// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playable.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Playable _$PlayableFromJson(Map<String, dynamic> json) =>
    $checkedCreate('Playable', json, ($checkedConvert) {
      final val = Playable(
        title: $checkedConvert('title', (v) => v as String),
        filePath: $checkedConvert('file_path', (v) => v as String),
      );
      return val;
    }, fieldKeyMap: const {'filePath': 'file_path'});

Map<String, dynamic> _$PlayableToJson(Playable instance) => <String, dynamic>{
  'title': instance.title,
  'file_path': instance.filePath,
};
