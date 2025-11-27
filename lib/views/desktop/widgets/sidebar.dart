import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:jukebox/data/notifiers.dart';
import 'package:jukebox/views/desktop/pages/my_library_page.dart';
import 'package:jukebox/views/desktop/widgets/menu_tile.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: currentPageNotifier,
      builder: (context, currentPage, child) {
        return Container(
          width: 260.0,
          height: double.infinity,
          decoration: BoxDecoration(
            color: (currentPage is MyLibraryPage) ? const Color(0xFF111111) : null,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            children: [
              MenuTile(
                title: "My Library",
                iconOutlined: Icons.my_library_music_outlined,
                iconFilled: Icons.my_library_music_rounded,
                selected: currentPage is MyLibraryPage,
                onTap: () {
                  if (currentPage is! MyLibraryPage) {
                    currentPageNotifier.value = const MyLibraryPage();
                  }
              
                  setState(() {});
                },
              ),
              Column(
                children: [
                  MenuTile(
                    title: "Playlists",
                    iconOutlined: Icons.queue_music_outlined,
                    iconFilled: Icons.queue_music_rounded,
                    selected: false,
                    onTap: () async {
                      
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      }
    );
  }
}
