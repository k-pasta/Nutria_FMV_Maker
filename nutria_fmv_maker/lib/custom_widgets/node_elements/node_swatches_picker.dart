import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../models/node_data.dart';
import '../../models/app_theme.dart';
import '../../providers/theme_provider.dart';
import '../../providers/nodes_provider.dart';
import '../../static_data/ui_static_properties.dart';

class NodeSwatchesPicker extends StatelessWidget {
  const NodeSwatchesPicker({
    super.key,
    required this.nodeData,
  });

  final NodeData nodeData;

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;
    final NodesProvider nodesProvider = context.read<NodesProvider>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final spacing = theme.dPanelPadding; // Spacing between items
        final totalSpacing = spacing * (theme.cSwatches.length - 1);
        final itemWidth =
            (constraints.maxWidth - totalSpacing) / theme.cSwatches.length;
        return Wrap(
          spacing: theme.dPanelPadding,
          children: theme.cSwatches.asMap().entries.map((entry) {
            final index = entry.key;
            final color = entry.value;
            return MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  nodesProvider.setSwatch(nodeData.id, index);
                },
                child: Container(
                  height: itemWidth < theme.dButtonHeight * 2 / 3
                      ? itemWidth
                      : theme.dButtonHeight * 2 / 3,
                  width: itemWidth,
                  margin: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4.0),
                    border: Border.all(color: theme.cOutlines, width: 1),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}