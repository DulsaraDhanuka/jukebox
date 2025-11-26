import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';

ValueNotifier<String?> musicFileNotifier = ValueNotifier<String?>("");
ValueNotifier<Player?> playerNotifier = ValueNotifier<Player?>(null);