import 'package:flutter/material.dart';
import 'package:nutria_fmv_maker/custom_widgets/node_elements/knot.dart';
import 'package:nutria_fmv_maker/custom_widgets/node_elements/node_video_expansion.dart';
import 'package:nutria_fmv_maker/models/action_models.dart';
import 'package:nutria_fmv_maker/models/snap_settings.dart';
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

class BaseNode extends StatelessWidget {
  final String nodeId;
  final List<Widget> body;
  final Widget expansion;
  final BaseNodeData baseNodeData;

  const BaseNode(
      {super.key,
      required this.nodeId,
      required this.body,
      required this.expansion,
      required this.baseNodeData});

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
        final BaseNodeData nodeData = nodesProvider.getNodeById(nodeId);

        void loadVideo() {
          if (nodeData is VideoNodeData) {
            final VideoData videoData =
                nodesProvider.getVideoDataById(nodeData.videoDataId);
            videoPlayerProvider.loadVideo(
                videoData: videoData, nodeId: nodeData.id);
          }
        }

        return Positioned(
          top: nodeData.position.dy + (UiStaticProperties.topLeftToMiddle.dy),
          left: nodeData.position.dx + (UiStaticProperties.topLeftToMiddle.dx),
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
                    nodesProvider.offsetSelectedNodes(details.delta,
                        snapSettings: keyboardProvider.isShiftPressed
                            ? appSettingsProvider.snapSettings
                                .copyWith(gridSnapping: true)
                            : appSettingsProvider.snapSettings);
                  },
                  onPanStart: (details) {
                    if (nodeData.isSelected || keyboardProvider.isCtrlPressed) {
                      nodesProvider
                          .selectNodes([nodeData.id], multiSelection: true);
                    } else {
                      nodesProvider.selectNodes([nodeData.id]);
                    }
                    nodesProvider.setActiveNode(nodeData.id);
                  },
                  onPanEnd: (_) {
                    nodesProvider.resetNodeIntendedValues(nodeData.id);
                  },
                  onPanCancel: () {
                    nodesProvider.resetNodeIntendedValues(nodeData.id);
                  },
                  onTap: () {
                    if (!keyboardProvider.isCtrlPressed) {
                      nodesProvider.setActiveNode(nodeData.id);
                      nodesProvider.selectNodes([nodeData.id]);
                      loadVideo();
                    } else {
                      if (!nodeData.isSelected) {
                        nodesProvider.setActiveNode(nodeData.id);
                        nodesProvider
                            .selectNodes([nodeData.id], multiSelection: true);
                        loadVideo();
                      } else {
                        nodesProvider.deselectNodes([nodeData.id]);
                      }
                    }
                  },
                  child: MouseRegion(
                    onEnter: (_) {
                      nodesProvider.setCurrentUnderCursor(
                          LogicalPosition.node(nodeData.id));
                    },
                    onExit: (_) {
                      nodesProvider
                          .setCurrentUnderCursor(LogicalPosition.empty());
                    },
                    hitTestBehavior: HitTestBehavior.deferToChild,
                    child: SizedBox(
                      width: nodeData.nodeWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          //Swatch Strip on top
                          NodeSwatchStrip(
                            nodeData: nodeData,
                          ),
                          //Main node background
                          NodeMainContainer(
                            nodeData: nodeData,
                            children: body,
                          ),
                          //expansion
                          if (nodeData.isExpanded)
                            //distance between main node and expansion
                            SizedBox(
                              height: theme.dPanelPadding,
                            ),
                          if (nodeData.isExpanded)
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
                                child: expansion),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),

            //left resize handle
            NodeResizeHandle(
              nodeData: nodeData,
              isLeftSide: true,
              draggableAreaHeight: nodeData.nodeHeight(theme),
            ),
            //right resize handle
            NodeResizeHandle(
              nodeData: nodeData,
              isLeftSide: false,
              draggableAreaHeight: nodeData.nodeHeight(theme),
            ),

            //input knot
            Knot.input(
              nodeData: nodeData,
              offset: nodeData.inputPosition(theme),
            ),
            //output knot(s)
            ...nodeData.outputs.asMap().entries.map((entry) {
              int index = entry.key;
              var output = entry.value;
              bool isLast = index == nodeData.outputs.length - 1;
              if (!isLast ||
                  (nodeData is VideoNodeData &&
                      isLast &&
                      nodeData.hasMaxedOutOutputs)) {
                // if (!isLast) {
                return Knot.output(
                  nodeData: nodeData,
                  index: index,
                  offset: nodeData.outputPosition(theme, index),
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

class VideoNode extends StatelessWidget {
  final String nodeId;

  const VideoNode({super.key, required this.nodeId});

  @override
  Widget build(BuildContext context) {
    final NodesProvider nodesProvider = context.read<NodesProvider>();

    // final VideoNodeData nodeData = nodesProvider.getNodeById(nodeId);
    // final VideoData videoData =
    //     nodesProvider.getVideoDataById(nodeData.videoDataId);

    return Selector<NodesProvider, NodeData>(
        selector: (context, provider) =>
            provider.getNodeById(nodeId), // Only listen to this node
        builder: (context, node, child) {
          nodesProvider.initializeOutputs(nodeId);
          final VideoNodeData nodeData = nodesProvider.getNodeById(nodeId);

          return BaseNode(
            baseNodeData: nodeData,
            nodeId: nodeId,
            body: [
              //thumbnail
              NodeVideoThumbnail(
                videoDataId: nodeData.videoDataId,
                videoNodeData: nodeData,
              ),
              //video file name
              NodeVideoFileNameText(videoNodeData: nodeData),
              //outputs and expand button
              NodeVideoOutputsList(
                videoNodeData: nodeData,
              ),
            ],
            expansion: NodeVideoExpansion(videoNodeData: nodeData),
          );
        });
  }
}
