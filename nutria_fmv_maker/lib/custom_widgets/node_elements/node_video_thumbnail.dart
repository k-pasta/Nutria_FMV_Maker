import 'dart:io';

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
    required this.videoDataId,
  });

  final String videoDataId;

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;
    final NodesProvider nodesProvider = context.read<NodesProvider>();
    
    VideoData videoData = nodesProvider.getVideoDataById(videoDataId);
    return ClipRRect(
      child: SizedBox(
        width: double.infinity, // Ensures it fills horizontally
        height: UiStaticProperties.nodeDefaultWidth * 9 / 16,
        child: FittedBox(
          fit: BoxFit.cover, // Ensures larger side fills the container
          child: videoData.thumbnailPath!.startsWith('http')
              ? Image.network(videoData.thumbnailPath!)
              : Image.file(File(videoData.thumbnailPath!)),
        ),
      ),
    );
  }
}
