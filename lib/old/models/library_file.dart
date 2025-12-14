import 'package:flutter/foundation.dart';

class LibraryFile extends ChangeNotifier {
  late final int _id;
  late String _title;
  late final String _sourcePath;
  late final String? _srtPath;
  late final Duration _duration;

  LibraryFile({required int id, required String title, required String sourcePath, required Duration duration, String? srtPath}) {
    _id = id;
    _title = title;
    _sourcePath = sourcePath;
    _duration = duration;
    _srtPath = srtPath;
  }

  int getId() => _id;
  String getTitle() => _title;
  String getSourcePath() => _sourcePath;
  String? getSrtPath() => _srtPath;
  Duration getDuration() => _duration;

  void setTitle(String title) {
    _title = title;
    notifyListeners();
  }

  @override
  bool operator ==(Object other) {
    return other is LibraryFile &&
        other._id == _id &&
        other._sourcePath == _sourcePath &&
        other._duration == _duration &&
        other._title == _title &&
        other._srtPath == _srtPath;
  }

  @override
  int get hashCode =>
      _id.hashCode ^ _sourcePath.hashCode ^ _duration.hashCode ^ _title.hashCode ^ _srtPath.hashCode;
}