import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../models/node_data.dart';
import '../../models/app_theme.dart';
import '../../providers/theme_provider.dart';
import '../../providers/nodes_provider.dart';
import '../../static_data/ui_static_properties.dart';

class NodeDebugInfo extends StatelessWidget {
  const NodeDebugInfo({
    super.key,
    required this.videoNodeData,
  });

  final VideoNodeData videoNodeData;

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;
    final NodesProvider nodesProvider = context.read<NodesProvider>();

    return Column(
      children: [
        SizedBox(
          height: theme.dPanelPadding,
        ),
        Text(
          'Debug Info:',
          style: TextStyle(color: theme.cText),
        ),
        SizedBox(
          height: theme.dPanelPadding,
        ),
        Text(
          'Node ID: ${videoNodeData.id}',
          style: TextStyle(color: theme.cText),
        ),
        SizedBox(
          height: theme.dPanelPadding,
        ),
        Text(
          'Position: ${videoNodeData.position.toString()}',
          style: TextStyle(color: theme.cText),
        ),
        SizedBox(
          height: theme.dPanelPadding,
        ),
        Text(
          'Output Position: ${videoNodeData.outputs[0].outputOffsetFromTopLeft.toString()}',
          style: TextStyle(color: theme.cText),
        ),
        SizedBox(
          height: theme.dPanelPadding,
        ),
        Text(
          'Node Width: ${videoNodeData.nodeWidth.toStringAsFixed(0)}',
          style: TextStyle(color: theme.cText),
        ),
      ],
    );
  }
}