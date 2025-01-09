import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/node_data.dart';
import '../models/app_theme.dart';
import '../providers/theme_provider.dart';
import '../providers/nodes_provider.dart';
import '../static_data/ui_static_properties.dart';

class VideoNode extends StatefulWidget {
  final VideoNodeData nodeData;
  // final double width = ;
  const VideoNode({super.key, required this.nodeData});

  @override
  State<VideoNode> createState() => _VideoNodeState();
}

class _VideoNodeState extends State<VideoNode> {
  late Offset _dragPosition;

  @override
  void initState() {
    super.initState();
    _dragPosition = widget.nodeData.position;
  }

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;
    return Positioned(
      // top: _dragPosition.dy + (UiStaticProperties.topLeftToMiddle.dy),
      // left: _dragPosition.dx + (UiStaticProperties.topLeftToMiddle.dx),
      top: _dragPosition.dy,
      left: _dragPosition.dx,
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
                  .updateNodePosition(widget.nodeData.id, _dragPosition);
            },
            onPanStart: (details) {
              Provider.of<NodesProvider>(context, listen: false)
                  .setActiveNode(widget.nodeData.id);
            },
            onTap: () {
              Provider.of<NodesProvider>(context, listen: false)
                  .setActiveNode(widget.nodeData.id);
            },
            child: Container(
              width: 200,
              height: 200,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(theme.dPanelBorderRadius),
                  color: theme.cPanelTransparent,
                ),
              ),
            ),
          ),
        ),
         IgnorePointer(
          child: SizedBox(
            height: 250,
            width: 250,
            child: Container(color: Colors.black26),
          ),
        ),
      ]),
    );
  }
}
