import 'package:flutter/material.dart';
import 'package:jukebox/old/models/library_file.dart';

class Playable extends ChangeNotifier {
  final String _id = DateTime.now().microsecondsSinceEpoch.toString();
  late final LibraryFile _file;

  Playable({required LibraryFile file}) {
    _file = file;
    _file.addListener(() {
      notifyListeners();
    });
  }

  LibraryFile getFile() => _file;

  @override
  bool operator ==(Object other) {
    return other is Playable &&
        other._id == _id &&
        other._file == _file;
  }

  @override
  int get hashCode =>
      _id.hashCode ^ _file.hashCode;
}