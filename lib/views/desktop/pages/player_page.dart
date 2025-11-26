import 'package:flutter/material.dart';
import 'package:jukebox/data/notifiers.dart';
import 'package:media_kit_video/media_kit_video.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  VideoController? controller;

  @override
  void initState() {
    _tabController = TabController(length: 1, vsync: this);
    super.initState();

    playerNotifier.addListener(() {
      final player = playerNotifier.value;
      if (player != null) {
        controller = VideoController(
          player,
          configuration: VideoControllerConfiguration(
            enableHardwareAcceleration: false,
          ),
        );
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0x228A9DBB),
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 20.0,
            children: [
              Expanded(
                flex: 3,
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: controller != null
                        ? Video(
                            controller: controller!,
                            controls: (state) {
                              return const SizedBox.shrink();
                            },
                          )
                        : Container(color: Colors.black),
                  ),
                ),
              ),
              Expanded(child: Text("Music title")),
            ],
          ),
          SizedBox(height: 20.0),
          SizedBox(
            height: 50.0,
            child: TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              controller: _tabController,
              tabs: [Tab(text: "Lyrics")],
            ),
          ),
          SizedBox(height: 20.0),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                SingleChildScrollView(child: Text("Lyrics for the music")),
              ],
            ),
          ),
          // Expanded(child: Row()),
        ],
      ),
    );
  }
}
