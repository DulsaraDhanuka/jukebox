import 'package:flutter/material.dart';
import 'package:jukebox/views/desktop/pages/player_page.dart';
import 'package:jukebox/views/desktop/widgets/player.dart';

import 'widgets/menu.dart';
import 'widgets/sidebar.dart';

class DesktopScaffold extends StatelessWidget {
  const DesktopScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: const Color(0xFF060606)),
        padding: EdgeInsets.all(10.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Sidebar(),
            ),
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Menu(),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: BoxBorder.all(
                                color: const Color(0xFF202020),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: PlayerPage(),
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Player(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
