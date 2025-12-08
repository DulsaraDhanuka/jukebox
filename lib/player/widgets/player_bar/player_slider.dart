import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jukebox/player/bloc/player_bloc.dart';

extension _Duration on Duration {
  String format() {
    return toString().split('.').first.padLeft(8, '0');
  }
}

class PlayerSlider extends StatelessWidget {
  const PlayerSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 5.0,
      children: [
        BlocBuilder<PlayerBloc, PlayerState>(
          builder: (context, state) => Text(state.position.format()),
          buildWhen: (previous, current) =>
              previous.position != current.position,
        ),
        BlocBuilder<PlayerBloc, PlayerState>(
          builder: (context, state) => SliderTheme(
            data: SliderThemeData(
              activeTrackColor: Colors.white,
              inactiveTrackColor: Color(0x1B898989),
              trackHeight: 3.0,
              thumbColor: Colors.white,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 4.0),
              overlayColor: Colors.white.withAlpha(32),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 8.0),
            ),
            child: Slider(
              min: 0.0,
              max: state.duration.inMicroseconds.toDouble(),
              value: state.position.inMicroseconds.toDouble(),
              divisions: state.duration.inMicroseconds == 0
                  ? null
                  : state.duration.inMicroseconds,
              onChanged: (value) async {
                context.read<PlayerBloc>().add(PlayerSeek(Duration(microseconds: value.toInt())));
              },
            ),
          ),
          buildWhen: (previous, current) =>
              previous.duration != current.duration ||
              previous.position != current.position,
        ),
        BlocBuilder<PlayerBloc, PlayerState>(
          builder: (context, state) => Text(state.duration.format()),
          buildWhen: (previous, current) =>
              previous.duration != current.duration,
        ),
      ],
    );
  }
}
