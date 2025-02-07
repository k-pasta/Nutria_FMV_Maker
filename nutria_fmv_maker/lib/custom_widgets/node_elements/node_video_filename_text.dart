import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../models/node_data.dart';
import '../../models/app_theme.dart';
import '../../providers/theme_provider.dart';
import '../../providers/nodes_provider.dart';
import '../../static_data/ui_static_properties.dart';

class NodeVideoFileNameText extends StatelessWidget {
  const NodeVideoFileNameText({
    super.key,
    required this.videoNodeData,
  });

  final VideoNodeData videoNodeData;

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;
    final NodesProvider nodesProvider = context.read<NodesProvider>();

    return Padding(
      padding: EdgeInsets.only(
        top: theme.dPanelPadding,
        left: theme.dPanelPadding,
        right: theme.dPanelPadding,
      ),
      child: Text(
        videoNodeData.videoDataId, //TODO handle null
        textAlign: TextAlign.center,
        style: TextStyle(
          color: theme.cText,
          fontSize: theme.dTextHeight,
          height: 1.0,
        ),
      ),
    );
  }
}
