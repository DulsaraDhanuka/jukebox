import 'package:flutter/material.dart';
import 'package:jukebox/views/desktop/widgets/menu_tile.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  bool selected = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260.0,
      height: double.infinity,
      decoration: BoxDecoration(color: selected ?  const Color(0xFF111111) : null, borderRadius: BorderRadius.circular(10.0)),
      child: Column(
        children: [
          MenuTile(title: "My Library", iconOutlined: Icons.my_library_music_outlined,iconFilled: Icons.my_library_music_rounded, selected: selected)
        ],
      ),
    );
  }
}
