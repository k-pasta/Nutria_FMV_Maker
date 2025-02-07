import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../models/node_data.dart';
import '../../models/app_theme.dart';
import '../../providers/theme_provider.dart';
import '../../providers/nodes_provider.dart';
import '../../static_data/ui_static_properties.dart';

class NodeVideoThumbnail extends StatelessWidget {
  const NodeVideoThumbnail({
    super.key,
    required this.videoNodeData,
  });

  final VideoNodeData videoNodeData;

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;

    return const SizedBox(
      height: UiStaticProperties.nodeDefaultWidth *
          9 /
          16, //TODO allow for vertical aspect ratio
      child: Placeholder(
        strokeWidth: 2,
      ),
    );
  }
}