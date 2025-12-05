import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jukebox/models/player.dart';

final playerModelProvider = Provider<Player>((ref) {
  return Player();
});