import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nutria_fmv_maker/custom_widgets/nutria_text.dart';
import 'package:nutria_fmv_maker/painters/striped_pattern_painter.dart';
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
                  ? SizedBox(
                      width: UiStaticProperties.videoCollectionEntryWidth,
                      height:
                          UiStaticProperties.videoCollectionEntryWidth * 9 / 16,
                      child: CustomPaint(
                        painter: DiagonalStripedPatternPainter(
                            stripeSpacing: 5, stripeWidth: 2.5),
                        child: Center(
                          child: NutriaText(text: 'loading...'),
                        ),
                      ),
                    )
                  : videoData.thumbnailPath == 'error' ?
                  SizedBox(
                      width: UiStaticProperties.videoCollectionEntryWidth,
                      height:
                          UiStaticProperties.videoCollectionEntryWidth * 9 / 16,
                      child: CustomPaint(
                        painter: DiagonalStripedPatternPainter(
                            stripeSpacing: 5, stripeWidth: 2.5),
                        child: Center(
                          child: NutriaText(text: 'thumbnail error'),
                        ),
                      ),
                    )
                  :
                  videoData.thumbnailPath!.startsWith('http')
                      ? Image.network(videoData.thumbnailPath!)
                      : Image.file(File(videoData.thumbnailPath!)),
            );
          },
        ),
      ),
    );
  }
}
