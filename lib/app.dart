import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jukebox/desktop_scaffold.dart';
import 'package:jukebox/player/bloc/player_bloc.dart';
import 'package:library_repository/library_repository.dart';
import 'package:player_service/player_service.dart';

class App extends StatelessWidget {
  const App({required this.createLibraryRepository, super.key});

  final LibraryRepository Function() createLibraryRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => PlayerService(),
          dispose: (service) => service.dispose(),
        ),
        RepositoryProvider(
          create: (context) => createLibraryRepository(),
          dispose: (repository) => repository.dispose(),
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

