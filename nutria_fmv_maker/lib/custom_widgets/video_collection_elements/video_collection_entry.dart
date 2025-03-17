import 'package:flutter/material.dart';
import 'package:nutria_fmv_maker/models/node_data.dart';
import 'package:nutria_fmv_maker/static_data/ui_static_properties.dart';
import '../../models/app_theme.dart';
import '../../models/enums_ui.dart';
import '../../providers/nodes_provider.dart';
import '../../providers/theme_provider.dart';
import 'package:provider/provider.dart';

import '../../providers/video_player_provider.dart';
import 'video_thumbnail.dart';

class VideoCollectionEntry extends StatefulWidget {
  final String videoDataId;
  const VideoCollectionEntry({
    required this.videoDataId,
    super.key,
  });

  @override
  State<VideoCollectionEntry> createState() => _VideoCollectionEntryState();
}

class _VideoCollectionEntryState extends State<VideoCollectionEntry> {
  VideoFileState _videoFileState = VideoFileState.none;
  // Offset _dragPosition = Offset.zero;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;
    final NodesProvider nodesProvider = context.read<NodesProvider>();
    final VideoPlayerProvider videoPlayerProvider =
        context.read<VideoPlayerProvider>();
    VideoData videoData = nodesProvider.getVideoDataById(widget.videoDataId);

    return Draggable<String>(
      data: widget.videoDataId,
      dragAnchorStrategy: (draggable, context, position) {
        return Offset(UiStaticProperties.videoCollectionEntryWidth / 2,
            UiStaticProperties.videoCollectionEntryWidth * 9 / 16);
      },
      feedback: VideoThumbnail(videoData: videoData),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) {
          setState(() {
            _videoFileState = VideoFileState.hovered;
          });
        },
        onExit: (_) {
          setState(() {
            _videoFileState = VideoFileState.none;
          });
        },
        child: GestureDetector(
          onTapDown: (_) {
            setState(() {
              _videoFileState = VideoFileState.active;
            });
            videoPlayerProvider.loadVideo(videoData: videoData);
          },
          onTapUp: (_) {
            setState(() {
              _videoFileState = VideoFileState.hovered;
            });
          },
          child: Container(
            decoration: BoxDecoration(
                color: _videoFileState == VideoFileState.hovered
                    ? theme.cButtonHovered
                    : _videoFileState == VideoFileState.selected
                        ? theme.cButton
                        : _videoFileState == VideoFileState.active
                            ? theme.cButtonPressed
                            : Colors.transparent,
                borderRadius: BorderRadius.circular(theme.dButtonBorderRadius),
                border: Border.all(
                  color: _videoFileState == VideoFileState.none
                      ? Colors.transparent
                      : theme.cOutlines,
                  width: 1,
                )),
            padding: EdgeInsets.all(theme.dPanelPadding),
            child: Column(
              children: [
                VideoThumbnail(videoData: videoData),
                SizedBox(height: theme.dPanelPadding),
                SizedBox(
                  width: UiStaticProperties.videoCollectionEntryWidth,
                  child: Text(
                    videoData.fileName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: theme.cText),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
