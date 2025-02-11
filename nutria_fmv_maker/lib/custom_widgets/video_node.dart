import 'package:flutter/material.dart';
import 'package:nutria_fmv_maker/custom_widgets/node_elements/knot.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';

import '../models/node_data.dart';
import '../models/app_theme.dart';
import '../providers/theme_provider.dart';
import '../providers/nodes_provider.dart';
import '../static_data/ui_static_properties.dart';
import 'node_elements/node_debug_info.dart';
import 'node_elements/node_main_container.dart';
import 'node_elements/node_resize_handle.dart';
import 'node_elements/node_swatch_strip.dart';
import 'node_elements/node_swatches_picker.dart';
import 'node_elements/node_video_filename_text.dart';
import 'node_elements/node_video_outputs_list.dart';
import 'node_elements/node_video_thumbnail.dart';

class TestNode extends StatelessWidget {
  final VideoNodeData nodeData;
  const TestNode({
    super.key,
    required this.nodeData,
  });

  @override
  Widget build(BuildContext context) {
    // print('rebuilding ${nodeData.id}');    //DEBUG to check when nodes rebuild
    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;
    return Selector<NodesProvider, NodeData>(
        selector: (context, provider) =>
            provider.getNodeById(nodeData.id), // Only listen to this node
        builder: (context, node, child) {

          final NodesProvider nodesProvider = context.read<NodesProvider>();
          final VideoNodeData videoNodeData =
              nodesProvider.getNodeById(nodeData.id) as VideoNodeData;
          nodesProvider.initializeOutputs(nodeData.id);

          return Positioned(
            top: videoNodeData.position.dy +
                (UiStaticProperties.topLeftToMiddle.dy),
            left: videoNodeData.position.dx +
                (UiStaticProperties.topLeftToMiddle.dx),
            child: Stack(clipBehavior: Clip.none, children: [
              IgnorePointer(
                child: SizedBox(
                  height:
                      1000, //TODO De-Hardcode when it is possible to calculate max height
                  width: UiStaticProperties.nodeMaxWidth +
                      UiStaticProperties.nodePadding * 2,
                  child: Container(color: Colors.transparent),
                ),
              ),
              Positioned(
                top: UiStaticProperties.nodePadding,
                left: UiStaticProperties.nodePadding,
                child: GestureDetector(
                  //where node starts really
                  onPanUpdate: (details) {
                    nodesProvider.offsetNodePosition(
                        videoNodeData.id, details.delta);
                  },
                  onPanStart: (details) {
                    nodesProvider.setActiveNode(videoNodeData.id);
                  },
                  onPanEnd: (_) {
                    nodesProvider.resetNodeIntendedValues(videoNodeData.id);
                  },
                  onPanCancel: () {
                    nodesProvider.resetNodeIntendedValues(videoNodeData.id);
                  },
                  onTap: () {
                    nodesProvider.setActiveNode(videoNodeData.id);
                  },
                  child: MouseRegion(
                    onEnter: (_) {
                      nodesProvider.setCurrentUnderCursor(targetId: videoNodeData.id);
                      // print('enter ${videoNodeData.id}');
                    },
                    onExit: (_) {
                      nodesProvider.setCurrentUnderCursor();
                      // print('exit ${videoNodeData.id}');
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
                              NodeVideoThumbnail(videoNodeData: videoNodeData),
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
                              child: Column(
                                children: [
                                  //swatches picker
                                  NodeSwatchesPicker(
                                    nodeData: videoNodeData,
                                  ),
                                  NodeDebugInfo(videoNodeData: videoNodeData),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              NodeResizeHandle(
                  nodeData: videoNodeData,
                  isLeftSide: false,
                  draggableAreaHeight: 200
                  // _getContainerPositionRelativeToParent(bottomKey).dy -
                  //     UiStaticProperties.nodePadding,
                  ),
              NodeResizeHandle(
                nodeData: videoNodeData,
                isLeftSide: true,
                draggableAreaHeight: outputOffset(videoNodeData, theme,
                            videoNodeData.outputs.length - 1)
                        .dy -
                    UiStaticProperties.nodePadding +
                    theme.dPanelPadding +
                    (theme.dButtonHeight / 2),
              ),
              Knot(
                  nodeData: videoNodeData,
                  isInput: true,
                  index: -1, // = input know
                  offset: inputOffset(nodeData, theme)),
              ...videoNodeData.outputs.asMap().entries.map((entry) {
                int index = entry.key;
                var output = entry.value;
                bool isLast = index == videoNodeData.outputs.length - 1;
                // nodesProvider.updateOutputPosition(videoNodeData.id, index,
                //     _getContainerPositionRelativeToParent(_childKeys[index]));
                if (!isLast || (isLast && videoNodeData.hasMaxedOutOutputs)) {
                  return Knot(
                    nodeData: videoNodeData,
                    isInput: false,
                    index: index,
                    offset: outputOffset(videoNodeData, theme, index),
                  );
                } else {
                  return Container();
                }
              }).toList(),
            ]),
          );
        });
  }
}

double getTextHeight(String text, TextStyle style) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: TextDirection.ltr,
    // maxLines: 1,
  )..layout();

  return textPainter.height;
}

Offset get paddingOffset {
  return Offset(UiStaticProperties.nodePadding, UiStaticProperties.nodePadding);
}

Offset inputOffset(BaseNodeData nodeData, AppTheme theme) {
  double x = 0;
  double y = theme.dSwatchHeight +
      (nodeData.nodeName != null
          ? getTextHeight(nodeData.nodeName!, theme.swatchTextStyle)
          : 0) +
      (UiStaticProperties.nodeDefaultWidth * 9 / 16);
  return Offset(x, y) + paddingOffset;
}

Offset outputOffset(VideoNodeData nodeData, AppTheme theme, int index) {
  double x = nodeData.nodeWidth;
  double baseY = theme.dSwatchHeight +
      (nodeData.nodeName != null
          ? getTextHeight(nodeData.nodeName!, theme.swatchTextStyle)
          : 0) +
      (UiStaticProperties.nodeDefaultWidth * 9 / 16) +
      getTextHeight(nodeData.videoDataId, theme.filenameTextStyle) +
      (theme.dPanelPadding * 2) +
      (theme.dButtonHeight / 2);
  double extraY = index * (theme.dButtonHeight + theme.dPanelPadding);
  return Offset(x, baseY + extraY) + paddingOffset;
}
