import 'dart:io';
import 'package:flutter/material.dart';

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
        child: FittedBox(
          // color: Colors.black,

          fit: BoxFit.cover,
          child: videoData.thumbnailPath == null
              ? Placeholder() //todo implement missing
              : videoData.thumbnailPath!.startsWith('http')
                  ? Image.network(videoData.thumbnailPath!)
                  : Image.file(File(videoData.thumbnailPath!)),
        ),
      ),
    );
  }
}