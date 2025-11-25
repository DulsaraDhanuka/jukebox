import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:jukebox/data/notifiers.dart';
import 'package:jukebox/views/desktop/widgets/menu_tile.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260.0,
      height: double.infinity,
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF111111) : null,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          MenuTile(
            title: "My Library",
            iconOutlined: Icons.my_library_music_outlined,
            iconFilled: Icons.my_library_music_rounded,
            selected: selected,
          ),
          Column(
            spacing: 10.0,
            children: [
              MenuTile(
                title: "Open",
                iconOutlined: Icons.file_open_outlined,
                iconFilled: Icons.file_open,
                selected: false,
                onTap: () async {
                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['mp3', 'wav', 'm4a', 'flac'],
                  );

                  if (result != null && result.files.isNotEmpty) {
                    musicFileNotifier.value = result.files.single.path;
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
