import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jukebox/data/notifiers.dart';
import 'package:jukebox/data/playback_handler.dart';
import 'package:jukebox/player/bloc/player_bloc.dart';
import 'package:jukebox/player/widgets/player_bar/player_controls.dart';
import 'package:jukebox/player/widgets/player_bar/player_slider.dart';
import 'package:jukebox/views/desktop/pages/player_page.dart';
import 'package:player_service/player_service.dart';

class PlayerBar extends StatelessWidget {
  const PlayerBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlayerBarView();
  }
}

class PlayerBarView extends StatelessWidget {
  const PlayerBarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.0,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF333842),
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 5.0,
        children: [
          PlayerControls(),
          PlayerSlider()
        ],
      ),
    );
  }
}
