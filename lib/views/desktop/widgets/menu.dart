import 'package:flutter/material.dart';
import 'package:jukebox/views/desktop/widgets/menu_search.dart';
import 'package:jukebox/views/desktop/widgets/menu_tile.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      decoration: BoxDecoration(color: const Color(0xFF060606)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 10.0,
        children: [
          MenuTile(title: "Home", iconOutlined: Icons.home_outlined, iconFilled: Icons.home_rounded, selected: true),
          Expanded(
            child: MenuSearch(),
          ),
        ],
      ),
    );
  }
}
