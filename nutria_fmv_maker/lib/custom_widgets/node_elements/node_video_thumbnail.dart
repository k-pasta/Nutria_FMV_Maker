import 'dart:io';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../models/node_data.dart';
import '../../models/app_theme.dart';
import '../../providers/theme_provider.dart';
import '../../providers/nodes_provider.dart';
import '../../providers/video_player_provider.dart';
import '../../static_data/ui_static_properties.dart';

class NodeVideoThumbnail extends StatelessWidget {
  const NodeVideoThumbnail({
    super.key,
    required this.videoDataId,
    required this.videoNodeData,
  });

  final String videoDataId;
  final VideoNodeData videoNodeData;

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;
    final NodesProvider nodesProvider = context.read<NodesProvider>();
    final VideoPlayerProvider videoPlayerProvider =
        context.read<VideoPlayerProvider>();

    VideoData videoData = nodesProvider.getVideoDataById(videoDataId);
    return Stack(children: [
      GestureDetector(
        onTapDown: (_) {
          videoPlayerProvider.loadVideo(
              path: videoData.videoDataPath, NodeId: videoNodeData.id);
          print('tappped downnn');
        },
        child: ClipRRect(
          child: SizedBox(
            width: double.infinity, // Ensures it fills horizontally
            height: UiStaticProperties.nodeDefaultWidth * 9 / 16,
            child: FittedBox(
              fit: BoxFit.cover, // Ensures larger side fills the container
              child: videoData.thumbnailPath == null
                  ? Placeholder(
                      child: Container(
                        color: Colors.black12,
                      ),
                    ) //todo implement missing
                  : videoData.thumbnailPath!.startsWith('http')
                      ? Image.network(videoData.thumbnailPath!)
                      : Image.file(File(videoData.thumbnailPath!)),
            ),
          ),
        ),
      ),
      Positioned(
        left: UiStaticProperties.nodePlayIndicatorPadding,
        top: UiStaticProperties.nodePlayIndicatorPadding,
        child: Selector<VideoPlayerProvider, bool>(
          selector: (_, provider) => provider.isVideoPlaying,
          builder: (_, isVideoPlaying, __) {
            return isVideoPlaying
                ? BlinkingIcon(
                    icon: Icons.play_arrow,
                    color: theme.cAccent,
                    size: UiStaticProperties.nodePlayIndicatorSize,
                  )
                : Container(); // Return an empty container if the video is playing
          },
        ),
      ),
    ]);
  }
}

class BlinkingIcon extends StatefulWidget {
  const BlinkingIcon({
    Key? key,
    required this.icon,
    required this.color,
    required this.size,
  }) : super(key: key);

  final IconData icon;
  final Color color;
  final double size;

  @override
  _BlinkingIconState createState() => _BlinkingIconState();
}

class _BlinkingIconState extends State<BlinkingIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Icon(
        widget.icon,
        color: widget.color,
        size: widget.size,
      ),
    );
  }
}
