import 'package:flutter/material.dart' hide NavigatorState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jukebox/navigator/cubit/navigator_cubit.dart';
import 'package:jukebox/player/bloc/player_bloc.dart';
import 'package:jukebox/playlist/bloc/playlist_bloc.dart';
import 'package:player_service/player_service.dart';
import 'package:playlists_repository/playlists_repository.dart';

class PlaylistPage extends StatelessWidget {
  const PlaylistPage({super.key, required this.playlistId});

  final String playlistId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PlaylistBloc(
        playlistsRepository: context.read<PlaylistsRepository>(),
        playlistId: playlistId,
      )..add(PlaylistLoadLibraryFiles()),
      child: const PlaylistPageView(),
    );
  }
}

class PlaylistPageView extends StatelessWidget {
  const PlaylistPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.0),
      child: BlocBuilder<PlaylistBloc, PlaylistState>(
        builder: (context, state) {
          if (state is PlaylistSuccess) {
            List<DataRow> dataRows = state.files.map((file) {
              return DataRow(
                onSelectChanged: (value) {
                  context.read<PlayerBloc>().add(
                    PlayerAddToQueue(
                      Playable(
                        title: file.title,
                        filePath: file.filePath()!,
                        libraryId: file.id,
                      ),
                    ),
                  );
                },
                cells: [
                  DataCell(Text(file.title)),
                  DataCell(
                    IconButton(
                      icon: Icon(Icons.playlist_add),
                      onPressed: () {},
                    ),
                  ),
                ],
              );
            }).toList();

            return Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [Expanded(child: PlaylistTable(dataRows: dataRows))],
              ),
            );
          } else {
            return SizedBox(
              width: double.infinity,
              child: Center(child: Text("Something went wrong...")),
            );
          }
        },
      ),
    );
  }
}

class PlaylistTable extends StatelessWidget {
  const PlaylistTable({required List<DataRow> dataRows, super.key})
    : _dataRows = dataRows;

  final List<DataRow> _dataRows;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DataTable(
        showCheckboxColumn: false,
        columns: <DataColumn>[
          DataColumn(label: Expanded(child: Text("Title"))),
          DataColumn(label: Expanded(child: Container())),
        ],
        rows: _dataRows,
      ),
    );
  }
}
