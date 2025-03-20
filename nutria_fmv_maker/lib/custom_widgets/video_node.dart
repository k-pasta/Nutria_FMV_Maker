import 'package:flutter/material.dart';
import 'package:nutria_fmv_maker/custom_widgets/node_elements/knot.dart';
import 'package:nutria_fmv_maker/custom_widgets/node_elements/node_video_expansion.dart';
import 'package:nutria_fmv_maker/models/action_models.dart';
import 'package:nutria_fmv_maker/providers/app_settings_provider.dart';
import 'package:nutria_fmv_maker/providers/keyboard_provider.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';

import '../models/node_data.dart';
import '../models/app_theme.dart';
import '../providers/theme_provider.dart';
import '../providers/nodes_provider.dart';
import '../providers/video_player_provider.dart';
import '../static_data/ui_static_properties.dart';
import 'node_elements/node_background.dart';
import 'node_elements/node_main_container.dart';
import 'node_elements/node_resize_handle.dart';
import 'node_elements/node_swatch_strip.dart';
import 'node_elements/node_video_filename_text.dart';
import 'node_elements/node_video_outputs_list.dart';
import 'node_elements/node_video_thumbnail.dart';

class VideoNode extends StatelessWidget {
  final String nodeId;
  const VideoNode({
    super.key,
    required this.nodeId,
  });

  @override
  Widget build(BuildContext context) {
    print('rebuilding ${nodeId}'); //DEBUG to check when nodes rebuild

    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;
    final AppSettingsProvider appSettingsProvider =
        context.read<AppSettingsProvider>();
    final VideoPlayerProvider videoPlayerProvider =
        context.read<VideoPlayerProvider>();
    final NodesProvider nodesProvider = context.read<NodesProvider>();
    final KeyboardProvider keyboardProvider = context.read<KeyboardProvider>();

    return Selector<NodesProvider, NodeData>(
      selector: (context, provider) =>
          provider.getNodeById(nodeId), // Only listen to this node
      builder: (context, node, child) {
        nodesProvider.initializeOutputs(nodeId);
        final VideoNodeData videoNodeData =
            nodesProvider.getNodeById(nodeId) as VideoNodeData;
        final VideoData videoData =
            nodesProvider.getVideoDataById(videoNodeData.videoDataId);

        return Positioned(
          top: videoNodeData.position.dy +
              (UiStaticProperties.topLeftToMiddle.dy),
          left: videoNodeData.position.dx +
              (UiStaticProperties.topLeftToMiddle.dx),
          child: Stack(clipBehavior: Clip.none, children: [
            const NodeBackground(),
            Positioned(
              top: UiStaticProperties.nodePadding,
              left: UiStaticProperties.nodePadding,
              child: DragTarget<String>(onAcceptWithDetails: (details) {
                nodesProvider.setVideo(nodeId: nodeId, videoId: details.data);
              },
                  // onWillAcceptWithDetails: (details) {
                  //   nodesProvider.setVideo(
                  //       nodeId: nodeId, videoId: details.data);
                  //   return true;
                  // },
                  // onLeave: (details) {
                  //                       nodesProvider.setVideo(
                  //       nodeId: nodeId, videoId: );
                  // },
                  builder: (context, candidateData, rejectedData) {
                return GestureDetector(
                  //where node starts really
                  onPanUpdate: (details) {
                    nodesProvider.offsetNodePosition(
                        videoNodeData.id, details.delta,
                        snapToGrid:
                            appSettingsProvider.snapSettings.gridSnapping);
                  },
                  onPanStart: (details) {
                    nodesProvider.selectNodes([videoNodeData.id]);
                    nodesProvider.setActiveNode(videoNodeData.id);
                  },
                  onPanEnd: (_) {
                    nodesProvider.resetNodeIntendedValues(videoNodeData.id);
                  },
                  onPanCancel: () {
                    nodesProvider.resetNodeIntendedValues(videoNodeData.id);
                  },
                  onTap: () {
                    if (!keyboardProvider.isCtrlPressed) {
                      nodesProvider.setActiveNode(videoNodeData.id);
                      nodesProvider.selectNodes([videoNodeData.id]);
                      videoPlayerProvider.loadVideo(
                          videoData: videoData, nodeId: videoNodeData.id);
                    } else {
                      if (!videoNodeData.isSelected) {
                        nodesProvider.setActiveNode(videoNodeData.id);
                        nodesProvider.selectNodes([videoNodeData.id],
                            multiSelection: true);
                        videoPlayerProvider.loadVideo(
                            videoData: videoData, nodeId: videoNodeData.id);
                      } else {
                        nodesProvider.deselectNodes([videoNodeData.id]);
                      }
                    }
                  },
                  child: MouseRegion(
                    onEnter: (_) {
                      nodesProvider.setCurrentUnderCursor(
                          LogicalPosition.node(videoNodeData.id));
                    },
                    onExit: (_) {
                      nodesProvider
                          .setCurrentUnderCursor(LogicalPosition.empty());
                    },
                    hitTestBehavior: HitTestBehavior.deferToChild,
                    child: SizedBox(
                      width: videoNodeData.nodeWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          //Swatch Strip on top
                          NodeSwatchStrip(
                            nodeData: videoNodeData,
                          ),
                          //Main node background
                          NodeMainContainer(
                            nodeData: videoNodeData,
                            children: [
                              //thumbnail
                              NodeVideoThumbnail(
                                videoDataId: videoNodeData.videoDataId,
                                videoNodeData: videoNodeData,
                              ),
                              //video file name
                              NodeVideoFileNameText(
                                  videoNodeData: videoNodeData),
                              NodeVideoOutputsList(
                                videoNodeData: videoNodeData,
                              ),
                            ],
                          ),
                          //expansion
                          if (videoNodeData.isExpanded)
                            //distance between main node and expansion
                            SizedBox(
                              height: theme.dPanelPadding,
                            ),
                          if (videoNodeData.isExpanded)
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    theme.dPanelBorderRadius),
                                border: Border.all(
                                    color: theme.cOutlines,
                                    width: theme.dOutlinesWidth),
                                color: theme.cPanelTransparent,
                              ),
                              padding: EdgeInsets.all(theme.dPanelPadding),
                              child: NodeVideoExpansion(
                                  videoNodeData: videoNodeData),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
            NodeResizeHandle(
              nodeData: videoNodeData,
              isLeftSide: false,
              draggableAreaHeight: videoNodeData.nodeHeight(theme),
            ),
            NodeResizeHandle(
              nodeData: videoNodeData,
              isLeftSide: true,
              draggableAreaHeight: videoNodeData.nodeHeight(theme),
            ),
            Knot.input(
                nodeData: videoNodeData,
                index: -1, // = input know
                offset: videoNodeData.inputPosition(theme)),
            ...videoNodeData.outputs.asMap().entries.map((entry) {
              int index = entry.key;
              var output = entry.value;
              bool isLast = index == videoNodeData.outputs.length - 1;

              if (!isLast || (isLast && videoNodeData.hasMaxedOutOutputs)) {
                return Knot.output(
                  nodeData: videoNodeData,
                  index: index,
                  offset: videoNodeData.outputPosition(theme, index),
                );
              } else {
                return Container();
              }
            }).toList(),
          ]),
        );
      },
    );
  }
}
