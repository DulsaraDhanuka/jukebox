import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jukebox/desktop_scaffold.dart';
import 'package:jukebox/player/bloc/player_bloc.dart';
import 'package:jukebox/playlists/bloc/playlists_bloc.dart';
import 'package:library_repository/library_repository.dart';
import 'package:player_service/player_service.dart';
import 'package:playlists_repository/playlists_repository.dart';

class App extends StatelessWidget {
  const App({
    required this.createLibraryRepository,
    required this.createPlaylistsRepository,
    super.key,
  });

  final LibraryRepository Function() createLibraryRepository;

  final PlaylistsRepository Function() createPlaylistsRepository;

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
        RepositoryProvider(
          create: (context) => createPlaylistsRepository(),
          dispose: (repository) => repository.dispose(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                PlayerBloc(playerService: context.read<PlayerService>())
                  ..add(const PlayerSubscribe()),
          ),
          BlocProvider(
            create: (context) => PlaylistsBloc(
              playlistsRepository: context.read<PlaylistsRepository>(),
            )..add(const PlaylistsSubscribe()),
          ),
        ],
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
