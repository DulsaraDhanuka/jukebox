import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:jukebox/old/data/library_file.dart';
import 'package:jukebox/old/data/library_handler.dart';
import 'package:jukebox/old/data/playback_handler.dart';
import 'package:jukebox/old/data/playback_queue_item.dart';

class MyLibraryPage extends StatefulWidget {
  const MyLibraryPage({super.key});

  @override
  State<MyLibraryPage> createState() => _MyLibraryPageState();
}

class _MyLibraryPageState extends State<MyLibraryPage> {
  PlaybackQueueItem? currentQueueItem;
  List<LibraryFile> files = [];

  void onCurrentQueueItemChanged() {
    setState(() {
      currentQueueItem = PlaybackHandler().queue.currentQueueItem.value;
    });
  }

  @override
  void initState() {
    files = LibraryHandler().getFiles();
    PlaybackHandler().queue.currentQueueItem.addListener(onCurrentQueueItemChanged);
    currentQueueItem = PlaybackHandler().queue.currentQueueItem.value;
    super.initState();
  }

  @override
  void dispose() {
    PlaybackHandler().queue.currentQueueItem.removeListener(onCurrentQueueItemChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<DataRow> dataRows = files.map((file) {
      return DataRow(
        selected: currentQueueItem?.file == file,
        onSelectChanged: (value) {
          if (value == true) {
            PlaybackHandler().queue.add(file);
          }
        },
        cells: [
          DataCell(Text(file.title)),
          DataCell(Text(file.duration.toString().split('.').first)),
          DataCell(
            IconButton(icon: Icon(Icons.playlist_add), onPressed: () {}),
          ),
        ],
      );
    }).toList();

    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () async {
                  FilePickerResult? result = await FilePicker.platform
                      .pickFiles(type: FileType.any, allowMultiple: true);

                  if (result != null && result.files.isNotEmpty) {
                    await LibraryHandler().addFiles(
                      result.files.map((e) => e.path!).toList(),
                    );
                    
                    setState(() {
                      files = LibraryHandler().getFiles();
                    });
                  }
                },
                icon: Icon(Icons.add),
              ),
            ],
          ),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: DataTable(
                showCheckboxColumn: false,
                columns: <DataColumn>[
                  DataColumn(label: Expanded(child: Text("Title"))),
                  DataColumn(label: Expanded(child: Text("Duration"))),
                  DataColumn(label: Expanded(child: Container())),
                ],
                rows: dataRows,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
