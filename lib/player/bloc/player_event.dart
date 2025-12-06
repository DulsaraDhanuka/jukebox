part of 'player_bloc.dart';

sealed class PlayerEvent extends Equatable {
  const PlayerEvent();

  @override
  List<Object> get props => [];
}

final class PlayerSubscriptionRequsted extends PlayerEvent {
  const PlayerSubscriptionRequsted();
}

final class _PlayerStatusChanged extends PlayerEvent {
  final PlayerStatus status;
  const _PlayerStatusChanged(this.status);
}

final class _PlayerPositionChanged extends PlayerEvent {
  final Duration position;
  const _PlayerPositionChanged(this.position);
}

final class _PlayerDurationChanged extends PlayerEvent {
  final Duration duration;
  const _PlayerDurationChanged(this.duration);
}

final class _PlayerVolumeChanged extends PlayerEvent {
  final double volume;
  const _PlayerVolumeChanged(this.volume);
}

final class PlayerPauseRequested extends PlayerEvent {
  const PlayerPauseRequested();
}

final class PlayerResumeRequested extends PlayerEvent {
  const PlayerResumeRequested();
}

final class PlayerStopRequested extends PlayerEvent {
  const PlayerStopRequested();
}

final class PlayerVolumeChangeRequested extends PlayerEvent {
  const PlayerVolumeChangeRequested(this.volume);

  final double volume;

  @override
  List<Object> get props => [volume];
}

final class PlayerSeekRequested extends PlayerEvent {
  const PlayerSeekRequested(this.position);

  final Duration position;

  @override
  List<Object> get props => [position];
}

final class PlayerOpenFileRequested extends PlayerEvent {
  const PlayerOpenFileRequested(this.filePath);

  final String filePath;

  @override
  List<Object> get props => [filePath];
}