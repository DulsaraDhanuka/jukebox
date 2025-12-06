// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerState _$PlayerStateFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('PlayerState', json, ($checkedConvert) {
  final val = PlayerState(
    status: $checkedConvert(
      'status',
      (v) =>
          $enumDecodeNullable(_$PlayerStatusEnumMap, v) ?? PlayerStatus.stopped,
    ),
    filePath: $checkedConvert('file_path', (v) => v as String? ?? ''),
    duration: $checkedConvert(
      'duration',
      (v) => v == null
          ? Duration.zero
          : Duration(microseconds: (v as num).toInt()),
    ),
    position: $checkedConvert(
      'position',
      (v) => v == null
          ? Duration.zero
          : Duration(microseconds: (v as num).toInt()),
    ),
    volume: $checkedConvert('volume', (v) => (v as num?)?.toDouble() ?? 100),
  );
  return val;
}, fieldKeyMap: const {'filePath': 'file_path'});

Map<String, dynamic> _$PlayerStateToJson(PlayerState instance) =>
    <String, dynamic>{
      'status': _$PlayerStatusEnumMap[instance.status]!,
      'file_path': instance.filePath,
      'duration': instance.duration.inMicroseconds,
      'position': instance.position.inMicroseconds,
      'volume': instance.volume,
    };

const _$PlayerStatusEnumMap = {
  PlayerStatus.stopped: 'stopped',
  PlayerStatus.completed: 'completed',
  PlayerStatus.playing: 'playing',
  PlayerStatus.paused: 'paused',
  PlayerStatus.error: 'error',
};
