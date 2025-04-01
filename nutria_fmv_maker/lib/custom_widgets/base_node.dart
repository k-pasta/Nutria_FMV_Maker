import 'package:flutter/material.dart';
import 'package:nutria_fmv_maker/custom_widgets/node_elements/knot.dart';
import 'package:nutria_fmv_maker/custom_widgets/node_elements/node_video_expansion.dart';
import 'package:nutria_fmv_maker/models/action_models.dart';
import 'package:nutria_fmv_maker/models/node_data/branched_video_node_data.dart';
import 'package:nutria_fmv_maker/models/node_data/video_node_data.dart';
import 'package:nutria_fmv_maker/models/snap_settings.dart';
import 'package:nutria_fmv_maker/providers/app_settings_provider.dart';
import 'package:nutria_fmv_maker/providers/keyboard_provider.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';

import '../models/node_data/node_data.dart';
import '../models/app_theme.dart';
import '../models/node_data/video_data.dart';
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
    // print('rebuilding ${nodeId}'); //DEBUG to check when nodes rebuild

    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;
    final AppSettingsProvider appSettingsProvider =
        context.read<AppSettingsProvider>();
    final VideoPlayerProvider videoPlayerProvider =
        context.read<VideoPlayerProvider>();
    final NodesProvider nodesProvider = context.read<NodesProvider>();
    final KeyboardProvider keyboardProvider = context.read<KeyboardProvider>();

    void loadVideo() {
      if (baseNodeData is VideoNodeData &&
          (baseNodeData as VideoNodeData).videoDataId != null) {
        final VideoData videoData = nodesProvider
            .getVideoDataById((baseNodeData as VideoNodeData).videoDataId!);
        videoPlayerProvider.loadVideo(
            videoData: videoData, nodeId: baseNodeData.id);
      }
    }

    return Positioned(
      top: baseNodeData.position.dy + (UiStaticProperties.topLeftToMiddle.dy),
      left: baseNodeData.position.dx + (UiStaticProperties.topLeftToMiddle.dx),
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
                if (baseNodeData.isSelected || keyboardProvider.isCtrlPressed || keyboardProvider.isShiftPressed) {
                  nodesProvider
                      .selectNodes([baseNodeData.id], multiSelection: true);
                } else {
                  nodesProvider.selectNodes([baseNodeData.id]);
                }
                nodesProvider.setActiveNode(baseNodeData.id);
              },
              onPanEnd: (_) {
                nodesProvider.resetNodesIntendedValues();
              },
              onPanCancel: () {
                nodesProvider.resetNodesIntendedValues();
              },
              onTap: () {
                if (!keyboardProvider.isCtrlPressed && !keyboardProvider.isShiftPressed) {
                  nodesProvider.setActiveNode(baseNodeData.id);
                  nodesProvider.selectNodes([baseNodeData.id]);
                  loadVideo();
                } else {
                  if (!baseNodeData.isSelected) {
                    nodesProvider.setActiveNode(baseNodeData.id);
                    nodesProvider
                        .selectNodes([baseNodeData.id], multiSelection: true);
                    loadVideo();
                  } else {
                    nodesProvider.deselectNodes([baseNodeData.id]);
                  }
                }
              },
              child: MouseRegion(
                onEnter: (_) {
                  nodesProvider.setCurrentUnderCursor(
                      LogicalPosition.node(baseNodeData.id));
                },
                onExit: (_) {
                  nodesProvider.setCurrentUnderCursor(LogicalPosition.empty());
                },
                hitTestBehavior: HitTestBehavior.deferToChild,
                child: SizedBox(
                  width: baseNodeData.nodeWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      //Swatch Strip on top
                      NodeSwatchStrip(
                        nodeData: baseNodeData,
                      ),
                      //Main node background
                      NodeMainContainer(
                        nodeData: baseNodeData,
                        children: body,
                      ),
                      //expansion
                      if (baseNodeData.isExpanded)
                        //distance between main node and expansion
                        SizedBox(
                          height: theme.dPanelPadding,
                        ),
                      if (baseNodeData.isExpanded)
                        Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  theme.dPanelBorderRadius),
                              border: Border.all(
                                  color: theme.cOutlines,
                                  width: theme.dOutlinesWidth),
                              color: baseNodeData.isBeingHovered || baseNodeData.isSelected ? theme.cButton :theme.cPanelTransparent,
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
          nodeData: baseNodeData,
          isLeftSide: true,
          draggableAreaHeight: baseNodeData.nodeHeight(theme),
        ),
        //right resize handle
        NodeResizeHandle(
          nodeData: baseNodeData,
          isLeftSide: false,
          draggableAreaHeight: baseNodeData.nodeHeight(theme),
        ),

        //input knot
        if (baseNodeData.input != null)
          Knot.input(
            nodeData: baseNodeData,
            offset: baseNodeData.inputPosition(theme),
          ),

        //output knot(s)
        ...baseNodeData.outputs.asMap().entries.map((entry) {
          final index = entry.key;
          final isLast = index == baseNodeData.outputs.length - 1;

          // If it's a BranchedVideoNodeData and we're at the last output without maxing out,
          // return an empty container.
          if (baseNodeData is BranchedVideoNodeData &&
              isLast &&
              !(baseNodeData as BranchedVideoNodeData).hasMaxedOutOutputs) {
            return Container();
          }

          // Otherwise, return the Knot output.
          return Knot.output(
            nodeData: baseNodeData,
            index: index,
            offset: baseNodeData.outputPosition(theme, index),
          );
// });
          // if (!isLast ||
          //     (baseNodeData is BranchedVideoNodeData &&
          //         isLast &&
          //         (baseNodeData as BranchedVideoNodeData).hasMaxedOutOutputs)) {
          //   // if (!isLast) {
          //   return Knot.output(
          //     nodeData: baseNodeData,
          //     index: index,
          //     offset: baseNodeData.outputPosition(theme, index),
          //   );
          // } else {
          //   return Container();
          // }
        }).toList(),
      ]),
      // );
      // },
    );
  }
}
