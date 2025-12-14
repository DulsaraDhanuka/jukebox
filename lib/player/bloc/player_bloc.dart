import 'dart:async';
import 'dart:math';

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
    on<PlayerSubscribe>(_onSubscribe);
    on<PlayerPause>(_onPause);
    on<PlayerResume>(_onResume);
    on<PlayerStop>(_onStop);
    on<PlayerChangeVolume>(_onChangeVolume);
    on<PlayerSeek>(_onSeek);

    on<PlayerAddToQueue>(_onAddToQueue);
    on<PlayerRemoveFromQueue>(_onRemoveFromQueue);
    on<PlayerChangeCurrentQueueIndex>(_onChangeCurrentQueueIndex);
    on<PlayerNext>(_onNext);
    on<PlayerPrevious>(_onPrevious);
  }

  final PlayerService _playerService;
  StreamController<int> currentQueueIndexController =
      StreamController<int>.broadcast();

  Future<void> _onSubscribe(
    PlayerSubscribe event,
    Emitter<PlayerState> emit,
  ) async {
    _playerService.getStatus().listen((status) {
      final newStatus = status.toPlayerStatus();
      emit(state.copyWith(status: newStatus));

      if (newStatus == PlayerStatus.completed) {
        add(PlayerNext());
      }
    });
    _playerService.getDuration().listen(
      (duration) => emit(state.copyWith(duration: duration)),
    );
    _playerService.getPosition().listen(
      (position) => emit(state.copyWith(position: position)),
    );
    _playerService.getVolume().listen(
      (volume) => emit(state.copyWith(volume: volume)),
    );
    await emit.forEach<int>(
      currentQueueIndexController.stream,
      onData: (currentQueueIndex) {
        if (currentQueueIndex != -1) {
          final prevStatus = state.status;
          _playerService.play().whenComplete(() async {
            await _playerService.open(state.queue[currentQueueIndex]);
            if (prevStatus == PlayerStatus.playing) {
              await _playerService.play();
            }
          });
        }

        return state.copyWith(currentQueueIndex: currentQueueIndex);
      },
    );
  }

  Future<void> _onPause(PlayerPause event, Emitter<PlayerState> emit) async {
    await _playerService.pause();
  }

  Future<void> _onResume(PlayerResume event, Emitter<PlayerState> emit) async {
    if (state.currentQueueIndex == -1 && state.queue.isNotEmpty) {
      currentQueueIndexController.add(0);
    } else if (state.currentQueueIndex != -1) {
      await _playerService.play();
    }
  }

  Future<void> _onStop(PlayerStop event, Emitter<PlayerState> emit) async {
    await _playerService.stop();
  }

  Future<void> _onChangeVolume(
    PlayerChangeVolume event,
    Emitter<PlayerState> emit,
  ) async {
    await _playerService.setVolume(event.volume);
  }

  Future<void> _onSeek(PlayerSeek event, Emitter<PlayerState> emit) async {
    await _playerService.seek(event.position);
  }

  Future<void> _onAddToQueue(
    PlayerAddToQueue event,
    Emitter<PlayerState> emit,
  ) async {
    emit(state.copyWith(queue: [...state.queue, event.playable]));
  }

  Future<void> _onRemoveFromQueue(
    PlayerRemoveFromQueue event,
    Emitter<PlayerState> emit,
  ) async {
    if (state.queue.length > event.index && event.index >= 0) {
      emit(
        state.copyWith(
          currentQueueIndex: event.index < state.currentQueueIndex ? state.currentQueueIndex - 1 : state.currentQueueIndex,
          queue: List<Playable>.from(state.queue)..removeAt(event.index),
        ),
      );
    }
  }

  Future<void> _onChangeCurrentQueueIndex(
    PlayerChangeCurrentQueueIndex event,
    Emitter<PlayerState> emit,
  ) async {
    currentQueueIndexController.add(min(max(event.index, 0), state.queue.length - 1));
  }

  Future<void> _onNext(PlayerNext event, Emitter<PlayerState> emit) async {
    currentQueueIndexController.add(
      min(state.currentQueueIndex + 1, state.queue.length - 1),
    );
  }

  Future<void> _onPrevious(
    PlayerPrevious event,
    Emitter<PlayerState> emit,
  ) async {
    currentQueueIndexController.add(max(state.currentQueueIndex - 1, 0));
  }

  @override
  PlayerState? fromJson(Map<String, dynamic> json) {
    final prevState = PlayerState.fromJson(json);
    switch (prevState.status) {
      case PlayerStatus.stopped:
        break;
      case PlayerStatus.completed:
        _playerService
            .open(prevState.queue[prevState.currentQueueIndex])
            .whenComplete(() async {
              _playerService.seek(prevState.duration);
            });
      case PlayerStatus.playing:
        _playerService
            .open(prevState.queue[prevState.currentQueueIndex])
            .whenComplete(() async {
              await _playerService.seek(prevState.position);
              await _playerService.play();
            });
      case PlayerStatus.paused:
        _playerService
            .open(prevState.queue[prevState.currentQueueIndex])
            .whenComplete(() async {
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
