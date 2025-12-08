import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jukebox/player/bloc/player_bloc.dart';
import 'package:player_service/player_service.dart';

import 'player/widgets/player_bar/player_bar.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => PlayerService(),
          dispose: (service) => service.dispose(),
        ),
      ],
      child: BlocProvider(
        create: (context) =>
            PlayerBloc(playerService: context.read<PlayerService>())
              ..add(const PlayerSubscribe()),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: DesktopScaffold(),
    );
  }
}

class DesktopScaffold extends StatelessWidget {
  const DesktopScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: const Color(0xFF060606)),
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            FilledButton(
              onPressed: () {
                context.read<PlayerBloc>().add(
                  PlayerAddToQueue(
                    '/mnt/data/songs/2XKO Official Cinematic_ Ties That Bind ft. Courtney LaPlante of Spiritbox.mp3',
                  ),
                );
                context.read<PlayerBloc>().add(
                  PlayerAddToQueue(
                    '/mnt/data/songs/Adoギラギラ.mp3',
                  ),
                );
                context.read<PlayerBloc>().add(
                  PlayerAddToQueue(
                    '/mnt/data/songs/Anytime Anywhere.mp3',
                  ),
                );
                context.read<PlayerBloc>().add(
                  PlayerAddToQueue(
                    '/mnt/data/songs/dreamy night.mp3',
                  ),
                );
              },
              child: Text("Test"),
            ),
            PlayerBar(),
          ],
        ),
      ),
    );
  }
}
