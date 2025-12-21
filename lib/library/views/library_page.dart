import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jukebox/library/bloc/library_bloc.dart';
import 'package:jukebox/player/bloc/player_bloc.dart';
import 'package:library_api/library_api.dart';
import 'package:library_repository/library_repository.dart';
import 'package:player_service/player_service.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          LibraryBloc(libraryRepository: context.read<LibraryRepository>())
            ..add(LibrarySubscribe()),
      child: const LocalLibraryView(),
    );
  }
}

class LocalLibraryView extends StatelessWidget {
  const LocalLibraryView({super.key});

  @override
  Widget build(BuildContext context) {
    final files = context.select((LibraryBloc bloc) {
      switch (bloc.state) {
        case LibraryInitial():
        case LibraryLoading():
        case LibraryFailure():
          return const <LibraryFile>[];
        case LibrarySuccess():
          return (bloc.state as LibrarySuccess).files;
      }
    });
    List<DataRow> dataRows = files.map((file) {
      return DataRow(
        onSelectChanged: (value) {
          context.read<PlayerBloc>().add(
            PlayerAddToQueue(
              Playable(title: file.title, filePath: file.filePath()!, libraryId: file.id),
            ),
          );
        },
        cells: [
          DataCell(Text(file.title)),
          DataCell(
            IconButton(icon: Icon(Icons.playlist_add), onPressed: () {}),
          ),
        ],
      );
    }).toList();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.0),
      child: MultiBlocListener(
        listeners: [
          BlocListener<LibraryBloc, LibraryState>(
            listenWhen: (previous, current) =>
                previous.runtimeType != current.runtimeType,
            listener: (context, state) {
              if (state is LibraryFailure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
          ),
          BlocListener<LibraryBloc, LibraryState>(
            listenWhen: (previous, current) =>
                previous is LibrarySuccess &&
                current is LibrarySuccess &&
                !listEquals(previous.files, current.files),
            listener: (context, state) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text("Library updated.")));
            },
          ),
        ],
        child: BlocBuilder<LibraryBloc, LibraryState>(
          builder: (context, state) {
            if (state is LibrarySuccess) {
              return Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(children: [AddFileButton()]),
                    Expanded(child: LibraryTable(dataRows: dataRows)),
                  ],
                ),
              );
            } else {
              return SizedBox(
                width: double.infinity,
                child: Center(child: Text("Empty...")),
              );
            }
          },
        ),
      ),
    );
  }
}

class AddFileButton extends StatelessWidget {
  const AddFileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.any,
          allowMultiple: true,
        );

        if (result != null && result.files.isNotEmpty && context.mounted) {
          context.read<LibraryBloc>().add(
            LibraryAddNewFile(filePath: result.files.first.path!),
          );
        }
      },
      icon: Icon(Icons.add),
    );
  }
}

class LibraryTable extends StatelessWidget {
  const LibraryTable({required List<DataRow> dataRows, super.key})
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
