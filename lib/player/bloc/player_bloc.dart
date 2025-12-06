import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:player_service/player_service.dart';

part 'player_bloc.g.dart';
part 'player_event.dart';
part 'player_state.dart';

class PlayerBloc extends HydratedBloc<PlayerEvent, PlayerState> {
  PlayerBloc({required PlayerService playerService})
    : _playerService = playerService,
      super(const PlayerState()) {
        on<PlayerSubscriptionRequsted>(_onSubscriptionRequested);
        on<_PlayerStatusChanged>(_onStatusChanged);
        on<_PlayerDurationChanged>(_onDurationChanged);
        on<_PlayerPositionChanged>(_onPositionChanged);
        on<_PlayerVolumeChanged>(_onVolumeChanged);
        on<PlayerPauseRequested>(_onPauseRequested);
        on<PlayerResumeRequested>(_onResumeRequested);
        on<PlayerStopRequested>(_onStopRequested);
        on<PlayerVolumeChangeRequested>(_onVolumeChangeRequested);
        on<PlayerSeekRequested>(_onSeekRequested);
        on<PlayerOpenFileRequested>(_onOpenFileRequested);
      }

  final PlayerService _playerService;

  Future<void> _onSubscriptionRequested(PlayerSubscriptionRequsted event, Emitter<PlayerState> emit) async {
    _playerService.getStatus().listen((status) => add(_PlayerStatusChanged(status.toPlayerStatus())));
    _playerService.getDuration().listen((duration) => add(_PlayerDurationChanged(duration)));
    _playerService.getPosition().listen((position) => add(_PlayerPositionChanged(position)));
    _playerService.getVolume().listen((volume) => add(_PlayerVolumeChanged(volume)));
  }

  Future<void> _onStatusChanged(_PlayerStatusChanged event, Emitter<PlayerState> emit) async {
    emit(state.copyWith(status: event.status ));
  }

  Future<void> _onDurationChanged(_PlayerDurationChanged event, Emitter<PlayerState> emit) async {
    emit(state.copyWith(duration: event.duration ));
  }

  Future<void> _onPositionChanged(_PlayerPositionChanged event, Emitter<PlayerState> emit) async {
    emit(state.copyWith(position: event.position ));
  }

  Future<void> _onVolumeChanged(_PlayerVolumeChanged event, Emitter<PlayerState> emit) async {
    emit(state.copyWith(volume: event.volume ));
  }

  Future<void> _onPauseRequested(PlayerPauseRequested event, Emitter<PlayerState> emit) async {
    await _playerService.pause();
  }

  Future<void> _onResumeRequested(PlayerResumeRequested event, Emitter<PlayerState> emit) async {
    await _playerService.play();
  }

  Future<void> _onStopRequested(PlayerStopRequested event, Emitter<PlayerState> emit) async {
    await _playerService.stop();
  }

  Future<void> _onVolumeChangeRequested(PlayerVolumeChangeRequested event, Emitter<PlayerState> emit) async {
    await _playerService.setVolume(event.volume);
  }

  Future<void> _onSeekRequested(PlayerSeekRequested event, Emitter<PlayerState> emit) async {
    await _playerService.seek(event.position);
  }
  
  Future<void> _onOpenFileRequested(PlayerOpenFileRequested event, Emitter<PlayerState> emit) async {
    await _playerService.open(event.filePath);
    emit(state.copyWith(filePath: event.filePath));
  }

  @override
  PlayerState? fromJson(Map<String, dynamic> json) {
    final prevState = PlayerState.fromJson(json);
    switch(prevState.status) {
      case PlayerStatus.stopped:
        break;
      case PlayerStatus.completed:
        _playerService.open(prevState.filePath).whenComplete(() async {
          _playerService.seek(prevState.duration);
        });
      case PlayerStatus.playing:
        _playerService.open(prevState.filePath).whenComplete(() async {
          await _playerService.seek(prevState.position);
          await _playerService.play();
        });
      case PlayerStatus.paused:
        _playerService.open(prevState.filePath).whenComplete(() async {
          _playerService.seek(prevState.position);
        });
      case PlayerStatus.error:
        break;
    }

    return prevState;
  }

  @override
  Map<String, dynamic>? toJson(PlayerState state) => state.toJson();
}

extension _PlayerServiceStatus on PlayerServiceStatus {
  PlayerStatus toPlayerStatus() {
    switch (this) {
      case PlayerServiceStatus.stopped:
        return PlayerStatus.stopped;
      case PlayerServiceStatus.completed:
        return PlayerStatus.completed;
      case PlayerServiceStatus.playing:
        return PlayerStatus.playing;
      case PlayerServiceStatus.paused:
        return PlayerStatus.paused;
      case PlayerServiceStatus.error:
        return PlayerStatus.error;
    }
  }
}