import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nutria_fmv_maker/models/node_data/video_node_data.dart';
import 'package:nutria_fmv_maker/providers/grid_canvas_provider.dart';

import 'package:provider/provider.dart';

import '../../models/node_data/branched_video_node_data.dart';
import '../../models/node_data/node_data.dart';
import '../../models/app_theme.dart';
import '../../painters/striped_pattern_painter.dart';
import '../../providers/theme_provider.dart';
import '../../providers/nodes_provider.dart';
import '../../providers/video_player_provider.dart';
import '../../static_data/ui_static_properties.dart';
import '../nutria_text.dart';

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

    VideoData videoData = nodesProvider.getVideoDataById(videoDataId);
    return Stack(children: [
      ClipRRect(
        child: SizedBox(
          width: double.infinity, // Ensures it fills horizontally
          height: UiStaticProperties.nodeDefaultWidth * 9 / 16,

          child: videoData.thumbnailPath == null
              ? Placeholder(
                  child: Container(
                    color: Colors.black12,
                  ),
                ) //todo implement missing
              : videoData.thumbnailPath == 'error'
                  ? SizedBox(
                      width: UiStaticProperties.nodeMaxWidth,
                      height: UiStaticProperties.nodeDefaultWidth * 9 / 16,
                      child: CustomPaint(
                        painter: DiagonalStripedPatternPainter(
                            stripeSpacing: 5, stripeWidth: 2.5),
                        child: const Center(
                          child: NutriaText(text: 'thumbnail error'),
                        ),
                      ),
                    )
                  : FittedBox(
                    fit: BoxFit.cover,
                      child: videoData.thumbnailPath!.startsWith('http')
                          ? Image.network(videoData.thumbnailPath!)
                          : Image.file(File(videoData.thumbnailPath!)),
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
