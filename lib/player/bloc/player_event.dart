part of 'player_bloc.dart';

sealed class PlayerEvent extends Equatable {
  const PlayerEvent();

  @override
  List<Object> get props => [];
}

final class PlayerSubscribe extends PlayerEvent {
  const PlayerSubscribe();
}

final class PlayerPause extends PlayerEvent {
  const PlayerPause();
}

final class PlayerResume extends PlayerEvent {
  const PlayerResume();
}

final class PlayerStop extends PlayerEvent {
  const PlayerStop();
}

final class PlayerChangeVolume extends PlayerEvent {
  const PlayerChangeVolume(this.volume);

  final double volume;

  @override
  List<Object> get props => [...super.props, volume];
}

final class PlayerSeek extends PlayerEvent {
  const PlayerSeek(this.position);

  final Duration position;

  @override
  List<Object> get props => [...super.props, position];
}

final class PlayerAddToQueue extends PlayerEvent {
  const PlayerAddToQueue(this.playable);

  final Playable playable;

  @override
  List<Object> get props => [...super.props, playable];
}

final class PlayerRemoveFromQueue extends PlayerEvent {
  const PlayerRemoveFromQueue(this.index);

  final int index;

  @override
  List<Object> get props => [...super.props, index];
}

final class PlayerChangeCurrentQueueIndex extends PlayerEvent {
  const PlayerChangeCurrentQueueIndex(this.index);

  final int index;

  @override
  List<Object> get props => [...super.props, index];
}

final class PlayerNext extends PlayerEvent {
  const PlayerNext();
}

final class PlayerPrevious extends PlayerEvent {
  const PlayerPrevious();
}