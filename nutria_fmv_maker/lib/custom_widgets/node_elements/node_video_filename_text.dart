import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../nutria_text.dart';
import '../../models/enums_ui.dart';
import '../../models/node_data/video_node_data.dart';
import '../../models/node_data/node_data.dart';
import '../../models/app_theme.dart';
import '../../providers/theme_provider.dart';
import '../../providers/nodes_provider.dart';

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
    final VideoData videoData =
        nodesProvider.getVideoDataById(videoNodeData.videoDataId);

    String originalText = videoData.fileName;
    String modifiedText = originalText.split('').join('\u200B');

    return Padding(
        padding: EdgeInsets.only(
          top: theme.dPanelPadding * 2,
          left: theme.dPanelPadding,
          right: theme.dPanelPadding,
          bottom: theme.dPanelPadding,
        ),
        child: NutriaText(
          text: modifiedText,
          textAlign: TextAlign.center,
          textStyle: NutriaTextStyle.italic,
        ));
  }
}
