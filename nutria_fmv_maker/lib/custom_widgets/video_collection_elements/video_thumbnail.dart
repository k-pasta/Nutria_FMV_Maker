import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nutria_fmv_maker/providers/nodes_provider.dart';
import 'package:provider/provider.dart';

import '../../models/node_data.dart';
import '../../static_data/ui_static_properties.dart';

class VideoThumbnail extends StatelessWidget {
  const VideoThumbnail({
    super.key,
    required this.videoData,
  });

  final VideoData videoData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: UiStaticProperties.videoCollectionEntryWidth * 9 / 16,
      width: UiStaticProperties.videoCollectionEntryWidth,
      child: ClipRect(
        child: Selector<NodesProvider, VideoData>(
          selector: (context, nodesProvider) =>
              nodesProvider.getVideoDataById(videoData.id),
          builder: (context, videoData, child) {
            return FittedBox(
              // color: Colors.black,

              fit: BoxFit.cover,
              child: videoData.thumbnailPath == null
                  ? Placeholder() //todo implement missing, todo handle not exist
                
                  : videoData.thumbnailPath!.startsWith('http')
                      ? Image.network(videoData.thumbnailPath!)
                      : Image.file(File(videoData.thumbnailPath!)),
            );
          },
        ),
      ),
    );
  }
}
