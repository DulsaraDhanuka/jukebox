import 'package:flutter/material.dart';
import 'package:jukebox/data/playback_handler.dart';
import 'package:jukebox/views/desktop/widgets/lyrics_view.dart';
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

    controller = VideoController(
      PlaybackHandler().player,
      configuration: VideoControllerConfiguration(
        enableHardwareAcceleration: false,
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 500.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 20.0,
              children: [
                Flexible(
                  flex: 2,
                  fit: FlexFit.loose,
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: controller != null
                          ? Video(
                              controller: controller!,
                              subtitleViewConfiguration: SubtitleViewConfiguration(visible: false),
                              controls: (state) {
                                return const SizedBox.shrink();
                              },
                            )
                          : Container(color: Colors.black),
                    ),
                  ),
                ),
                Expanded(child: ValueListenableBuilder(
                  valueListenable: PlaybackHandler().queue.currentQueueItem,
                  builder: (context, currentQueueItem, child) {
                    return Text(currentQueueItem?.file.title ?? "No file playing");
                  }
                )),
              ],
            ),
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
                SingleChildScrollView(child: LyricsView()),
              ],
            ),
          ),
          // Expanded(child: Row()),
        ],
      ),
    );
  }
}
