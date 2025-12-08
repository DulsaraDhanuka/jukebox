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
  List<Object> get props => [volume];
}

final class PlayerSeek extends PlayerEvent {
  const PlayerSeek(this.position);

  final Duration position;

  @override
  List<Object> get props => [position];
}

final class PlayerAddToQueue extends PlayerEvent {
  const PlayerAddToQueue(this.filePath);

  final String filePath;

  @override
  List<Object> get props => [filePath];
}

final class PlayerNext extends PlayerEvent {
  const PlayerNext();
}

final class PlayerPrevious extends PlayerEvent {
  const PlayerPrevious();
}