import 'dart:io';

import 'package:media_kit/media_kit.dart' hide Playable;
import 'package:player_service/src/models/playable.dart';
import 'package:player_service/src/player_service.dart';
import 'package:test/test.dart';

final String testAudioFile =
    '${Directory.current.path}/test_resources/audio.mp3';
final Playable testAudioPlayable = Playable(
  title: 'Test',
  filePath: testAudioFile,
  libraryId: '0'
);

void main() {
  group('PlayerService', () {
    late PlayerService playerService;

    setUp(() {
      MediaKit.ensureInitialized();
      playerService = PlayerService();
    });

    tearDownAll(() async {
      await playerService.dispose();
    });

    test('Open file', () async {
      expect(
        playerService.getStatus(),
        emitsInOrder([PlayerServiceStatus.stopped, PlayerServiceStatus.paused]),
      );
      await playerService.open(testAudioPlayable);
    });

    test('Openening a file while a file is already opened', () async {
      expect(
        playerService.getStatus(),
        emitsInOrder([
          PlayerServiceStatus.stopped,
          PlayerServiceStatus.paused,
          PlayerServiceStatus.stopped,
          PlayerServiceStatus.paused,
        ]),
      );

      await playerService.open(testAudioPlayable);
      await playerService.open(testAudioPlayable);
    });

    test(
      'Openening a file while a file is already opened and playing',
      () async {
        expect(
          playerService.getStatus(),
          emitsInOrder([
            PlayerServiceStatus.stopped,
            PlayerServiceStatus.paused,
            PlayerServiceStatus.playing,
            PlayerServiceStatus.stopped,
            PlayerServiceStatus.paused,
          ]),
        );

        await playerService.open(testAudioPlayable);
        await playerService.play();
        await playerService.open(testAudioPlayable);
      },
    );

    test('Trying play file when nothing is opened', () async {
      expect(
        playerService.getStatus(),
        emits(PlayerServiceStatus.stopped),
      );
      await playerService.play();
    });

    test('Playing after file has been opened', () async {
      expect(
        playerService.getStatus(),
        emitsInOrder([
          PlayerServiceStatus.stopped,
          PlayerServiceStatus.paused,
          PlayerServiceStatus.playing,
        ]),
      );
      await playerService.open(testAudioPlayable);
      await playerService.play();
    });

    test('Pausing after file has been opened and playing', () async {
      expect(
        playerService.getStatus(),
        emitsInOrder([
          PlayerServiceStatus.stopped,
          PlayerServiceStatus.paused,
          PlayerServiceStatus.playing,
          PlayerServiceStatus.paused,
        ]),
      );
      await playerService.open(testAudioPlayable);
      await playerService.play();
      await playerService.pause();
    });

    test('Trying pause file when nothing is opened', () async {
      expect(
        playerService.getStatus(),
        emits(PlayerServiceStatus.stopped),
      );
      await playerService.pause();
    });

    test('Trying pause after immediately opening', () async {
      expect(
        playerService.getStatus(),
        emitsInOrder([
          PlayerServiceStatus.stopped,
          PlayerServiceStatus.paused,
          PlayerServiceStatus.paused,
        ]),
      );
      await playerService.open(testAudioPlayable);
      await playerService.pause();
    });

    test('Trying pause while already paused', () async {
      expect(
        playerService.getStatus(),
        emitsInOrder([
          PlayerServiceStatus.stopped,
          PlayerServiceStatus.paused,
          PlayerServiceStatus.playing,
          PlayerServiceStatus.paused,
          PlayerServiceStatus.paused,
        ]),
      );
      await playerService.open(testAudioPlayable);
      await playerService.play();
      await playerService.pause();
      await playerService.pause();
    });

    test('Stopping after file has been opened', () async {
      expect(
        playerService.getStatus(),
        emitsInOrder([
          PlayerServiceStatus.stopped,
          PlayerServiceStatus.paused,
          PlayerServiceStatus.stopped,
        ]),
      );
      await playerService.open(testAudioPlayable);
      await playerService.stop();
    });

    test('Stopping after file has been opened and playing', () async {
      expect(
        playerService.getStatus(),
        emitsInOrder([
          PlayerServiceStatus.stopped,
          PlayerServiceStatus.paused,
          PlayerServiceStatus.playing,
          PlayerServiceStatus.stopped,
        ]),
      );
      await playerService.open(testAudioPlayable);
      await playerService.play();
      await playerService.stop();
    });

    test('Stopping after file has been opened and paused', () async {
      expect(
        playerService.getStatus(),
        emitsInOrder([
          PlayerServiceStatus.stopped,
          PlayerServiceStatus.paused,
          PlayerServiceStatus.playing,
          PlayerServiceStatus.paused,
          PlayerServiceStatus.stopped,
        ]),
      );
      await playerService.open(testAudioPlayable);
      await playerService.play();
      await playerService.pause();
      await playerService.stop();
    });

    test('Changing Volume', () async {
      expect(playerService.getVolume(), emits(50.0));
      await playerService.setVolume(50);
    });

    test('Changing Volume to invalid 101.0', () async {
      expect(playerService.getVolume(), emitsInOrder([50.0, 100.0]));
      await playerService.setVolume(50);
      await playerService.setVolume(101);
    });

    test('Changing Volume to invalid -1', () async {
      expect(playerService.getVolume(), emitsInOrder([50.0, 0.0]));
      await playerService.setVolume(50);
      await playerService.setVolume(-1);
    });

    // test('Trying seek without a file opened', () async {
    //   expect(playerService.getPosition(), emits(Duration.zero));
    //   await playerService.seek(const Duration(seconds: 15));
    // });

    test('Seeking after opening a file', () async {
      expect(
        playerService.getStatus(),
        emitsInOrder([
          PlayerServiceStatus.stopped,
          PlayerServiceStatus.paused,
        ]),
      );
      expect(
        playerService.getPosition(),
        emitsInOrder([Duration.zero, const Duration(seconds: 15)]),
      );
      await playerService.open(testAudioPlayable);
      await playerService.seek(const Duration(seconds: 15));
    });

    test('Completion status', () async {
      expect(
        playerService.getStatus(),
        emitsInOrder([
          PlayerServiceStatus.stopped,
          PlayerServiceStatus.paused,
          PlayerServiceStatus.playing,
          PlayerServiceStatus.completed,
        ]),
      );
      expect(
        playerService.getPosition(),
        emitsInOrder([
          Duration.zero,
          const Duration(seconds: 41),
        ]),
      );
      await playerService.open(testAudioPlayable);
      await playerService.seek(const Duration(seconds: 41));
      await playerService.play();
    });

    test('Seeking longer than the duration', () async {
      expect(
        playerService.getStatus(),
        emitsInOrder([
          PlayerServiceStatus.stopped,
          PlayerServiceStatus.paused,
          PlayerServiceStatus.completed,
        ]),
      );
      expect(
        playerService.getPosition(),
        emitsInOrder([
          Duration.zero,
          const Duration(seconds: 42, microseconds: 8000),
        ]),
      );
      await playerService.open(testAudioPlayable);
      await playerService.seek(const Duration(minutes: 1));
    });
  });
}
