import 'package:flutter/material.dart';
import 'package:jukebox/library/views/library_page.dart';
import 'package:jukebox/player/widgets/queue/queue.dart';
import 'player/widgets/player_bar/player_bar.dart';

class DesktopScaffold extends StatelessWidget {
  const DesktopScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: const Color(0xFF060606)),
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(child: MainContent()),
            SizedBox(height: 4.0),
            PlayerBar(),
          ],
        ),
      ),
    );
  }
}

class MainContent extends StatelessWidget {
  const MainContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentGeometry.topRight,
      children: [
        Container(
          decoration: BoxDecoration(
            border: BoxBorder.all(color: const Color(0xFF202020), width: 1),
            borderRadius: BorderRadius.circular(10.0),
          ),
          clipBehavior: Clip.hardEdge,
          child: LibraryPage(),
        ),
        Queue(),
      ],
    );
  }
}
