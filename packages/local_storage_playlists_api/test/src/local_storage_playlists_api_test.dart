// Not required for test files
// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:local_storage_playlists_api/local_storage_playlists_api.dart';

void main() {
  group('LocalStoragePlaylistsApi', () {
    test('can be instantiated', () {
      expect(LocalStoragePlaylistsApi([]), isNotNull);
    });
  });
}
