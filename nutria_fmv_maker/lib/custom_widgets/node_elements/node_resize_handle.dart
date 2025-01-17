import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../models/node_data.dart';
import '../../models/app_theme.dart';
import '../../providers/theme_provider.dart';
import '../../providers/nodes_provider.dart';
import '../../static_data/ui_static_properties.dart';

class NodeResizeHandle extends StatelessWidget {
  const NodeResizeHandle({
    super.key,
    required this.nodeData,
    required this.isLeftSide,
    required this.draggableAreaHeight,
  });
  final bool isLeftSide;
  final BaseNodeData nodeData;
  final double draggableAreaHeight;

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;
    final NodesProvider nodesProvider = context.read<NodesProvider>();

    return Positioned(
      top: UiStaticProperties.nodePadding,
      left: isLeftSide
          ? UiStaticProperties.nodePadding
          : nodeData.nodeWidth +
              UiStaticProperties.nodePadding -
              theme.dPanelPadding,
      width: theme.dPanelPadding, //todo add value that makes sense
      height: draggableAreaHeight, //todo add value that makes sense
      child: MouseRegion(
        cursor: SystemMouseCursors.resizeLeftRight,
        child: GestureDetector(
          onPanUpdate: (details) {
            nodesProvider.resizeNode(nodeData.id, details.delta, isLeftSide);
          },
          onPanEnd: (details) {
            //
          },
          child: Container(
            color: Colors.transparent, //needs this in order to detect gestures
          ),
        ),
      ),
    );
  }
}