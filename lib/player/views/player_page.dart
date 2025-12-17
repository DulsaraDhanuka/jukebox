import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:player_service/player_service.dart';

class PlayerPage extends StatelessWidget {
  const PlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                      child: VideoPlayer(),
                    ),
                  ),
                ),
                Expanded(child: Text("No file playing title")),
              ],
            ),
          ),
          SizedBox(height: 20.0),
          Expanded(child: PlayerPageTabs()),
        ],
      ),
    );
  }
}

class VideoPlayer extends StatelessWidget {
  const VideoPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = VideoController(
      context.read<PlayerService>().getPlayer(),
      configuration: VideoControllerConfiguration(
        enableHardwareAcceleration: true,
      ),
    );
    return Video(
      width: double.infinity,
      height: double.infinity,
      controller: controller,
      subtitleViewConfiguration: SubtitleViewConfiguration(visible: false),
      controls: (state) {
        return const SizedBox.shrink();
      },
    );
  }
}

class PlayerPageTabs extends StatefulWidget {
  const PlayerPageTabs({super.key});

  @override
  State<PlayerPageTabs> createState() => _PlayerPageTabsState();
}

class _PlayerPageTabsState extends State<PlayerPageTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 1, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
            children: [LyricsView()],
          ),
        ),
      ],
    );
  }
}

class LyricsView extends StatelessWidget {
  const LyricsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(child: Center(child: Text("Hello World")));
  }
}
