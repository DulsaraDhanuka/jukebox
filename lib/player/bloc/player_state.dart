part of 'player_bloc.dart';

enum PlayerStatus { stopped, completed, playing, paused, error }

@JsonSerializable()
final class PlayerState extends Equatable {
  const PlayerState({
    this.status = PlayerStatus.stopped,
    this.currentQueueIndex = -1,
    this.queue = const [],
    this.duration = Duration.zero,
    this.position = Duration.zero,
    this.volume = 100,
  });

  factory PlayerState.fromJson(Map<String, dynamic> json) =>
      _$PlayerStateFromJson(json);

  final PlayerStatus status;
  final int currentQueueIndex;
  final List<String> queue;
  final Duration duration;
  final Duration position;
  final double volume;

  PlayerState copyWith({
    PlayerStatus? status,
    int? currentQueueIndex,
    List<String>? queue,
    Duration? duration,
    Duration? position,
    double? volume,
  }) {
    return PlayerState(
      status: status ?? this.status,
      currentQueueIndex: currentQueueIndex ?? this.currentQueueIndex,
      queue: queue ?? this.queue,
      duration: duration ?? this.duration,
      position: position ?? this.position,
      volume: volume ?? this.volume,
    );
  }

  Map<String, dynamic> toJson() => _$PlayerStateToJson(this);

  @override
  List<Object> get props => [status, currentQueueIndex, queue, duration, position, volume];
}
