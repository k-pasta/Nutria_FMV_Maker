import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../models/node_data/node_data.dart';
import '../../models/app_theme.dart';
import '../../providers/theme_provider.dart';
import '../../providers/nodes_provider.dart';
import '../../static_data/ui_static_properties.dart';

class NodeMainContainer extends StatelessWidget {
  const NodeMainContainer({
    super.key,
    required this.nodeData,
    required this.children,
  });

  final NodeData nodeData; //unnecessary?
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;
    final NodesProvider nodesProvider = context.read<NodesProvider>();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(theme.dPanelBorderRadius),
          bottomRight: Radius.circular(theme.dPanelBorderRadius),
        ),
        border: Border(
          left: BorderSide(color: theme.cOutlines, width: theme.dOutlinesWidth),
          right:
              BorderSide(color: theme.cOutlines, width: theme.dOutlinesWidth),
          bottom:
              BorderSide(color: theme.cOutlines, width: theme.dOutlinesWidth),
        ),
        color: nodeData.isBeingHovered || nodeData.isSelected ? theme.cButton :theme.cPanelTransparent,
      ),
      child: Column(children: children),
    );
  }
}
