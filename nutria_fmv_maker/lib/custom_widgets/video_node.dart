import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/node_data.dart';
import '../models/app_theme.dart';
import '../providers/theme_provider.dart';
import '../providers/nodes_provider.dart';
import '../static_data/grid_canvas_properties.dart';

class VideoNode extends StatefulWidget {
  final VideoNodeData videoNodeData;
  // final double width = ;
  const VideoNode({super.key, required this.videoNodeData});

  @override
  State<VideoNode> createState() => _VideoNodeState();
}

class _VideoNodeState extends State<VideoNode> {
  late Offset _dragPosition;

  @override
  void initState() {
    super.initState();
    _dragPosition = widget.videoNodeData.position;
  }

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;
    return Positioned(
      top: _dragPosition.dy + (GridCanvasProperties.canvasSize / 2),
      left: _dragPosition.dx + (GridCanvasProperties.canvasSize / 2),
      child: Stack(children: [
        Positioned(
          top: 25,
          left: 25,
          child: GestureDetector(
            // behavior: HitTestBehavior.translucent,
            onPanUpdate: (details) {
              setState(() {
                _dragPosition += details.delta;
              });
              Provider.of<NodesProvider>(context, listen: false)
                  .updateNodePosition(widget.videoNodeData.id, _dragPosition);
            },
            onPanStart: (details) {
              Provider.of<NodesProvider>(context, listen: false)
                  .setActiveNode(widget.videoNodeData.id);
            },
            onTap: () {
              Provider.of<NodesProvider>(context, listen: false)
                  .setActiveNode(widget.videoNodeData.id);
            },
            child: Container(
              // width: widget.,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(theme.dPanelBorderRadius),
                color: theme.cPanelTransparent,
              ),
            ),
          ),
        ),
      ]),
    );
  }
}