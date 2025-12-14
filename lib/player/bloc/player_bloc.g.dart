// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerState _$PlayerStateFromJson(Map<String, dynamic> json) => $checkedCreate(
  'PlayerState',
  json,
  ($checkedConvert) {
    final val = PlayerState(
      status: $checkedConvert(
        'status',
        (v) =>
            $enumDecodeNullable(_$PlayerStatusEnumMap, v) ??
            PlayerStatus.stopped,
      ),
      currentQueueIndex: $checkedConvert(
        'current_queue_index',
        (v) => (v as num?)?.toInt() ?? -1,
      ),
      queue: $checkedConvert(
        'queue',
        (v) =>
            (v as List<dynamic>?)
                ?.map((e) => Playable.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
      ),
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
  },
  fieldKeyMap: const {'currentQueueIndex': 'current_queue_index'},
);

Map<String, dynamic> _$PlayerStateToJson(PlayerState instance) =>
    <String, dynamic>{
      'status': _$PlayerStatusEnumMap[instance.status]!,
      'current_queue_index': instance.currentQueueIndex,
      'queue': instance.queue.map((e) => e.toJson()).toList(),
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
