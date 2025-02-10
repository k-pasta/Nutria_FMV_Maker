import 'package:flutter/material.dart';
import 'package:nutria_fmv_maker/custom_widgets/nutria_button.dart';
import 'package:nutria_fmv_maker/custom_widgets/nutria_textfield.dart';
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
import 'node_elements/node_video_thumbnail.dart';

class TestNode2 extends StatelessWidget {
  final VideoNodeData nodeData;
  const TestNode2(
      {super.key,
      required this.nodeData,});


  // Offset _getContainerPositionRelativeToParent(GlobalKey key) {
  //   final RenderBox? containerRenderBox =
  //       key.currentContext?.findRenderObject() as RenderBox?;
  //   final RenderBox? parentRenderBox =
  //       parentKey.currentContext?.findRenderObject() as RenderBox?;

  //   if (containerRenderBox != null && parentRenderBox != null) {
  //     final containerGlobalPosition =
  //         containerRenderBox.globalToLocal(Offset.zero);
  //     final parentGlobalPosition = parentRenderBox.globalToLocal(Offset.zero);

  //     return parentGlobalPosition - containerGlobalPosition;
  //   }
  //   return Offset.zero;
  // }

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;
    //     WidgetsBinding.instance.addPostFrameCallback((_) {
    //   context.read<NodesProvider>().rebuildNode(nodeData.id);
    // });
    //DEBUG to check when nodes rebuild

    final NodesProvider nodesProvider = context.read<NodesProvider>();
    final VideoNodeData videoNodeData =
        nodesProvider.getNodeById(nodeData.id) as VideoNodeData;
    return Stack(clipBehavior: Clip.none, children: [
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
          // behavior: HitTestBehavior.translucent,
          onPanUpdate: (details) {
            nodesProvider.offsetNodePosition(videoNodeData.id, details.delta);
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
                    NodeVideoFileNameText(videoNodeData: videoNodeData),

                    NodeVideoOutputsList(
                        videoNodeData: videoNodeData, childKeys: null),
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
                      borderRadius:
                          BorderRadius.circular(theme.dPanelBorderRadius),
                      border: Border.all(
                          color: theme.cOutlines, width: theme.dOutlinesWidth),
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
                SizedBox(
                  height: 5,
                  // key: bottomKey,
                  // child: Container(
                  //   color: Colors.red,
                  // ),
                )
              ],
            ),
          ),
        ),
      ),
      NodeResizeHandle(
          nodeData: videoNodeData, isLeftSide: false, draggableAreaHeight: 200
          // _getContainerPositionRelativeToParent(bottomKey).dy -
          //     UiStaticProperties.nodePadding,
          ),
      NodeResizeHandle(
        nodeData: videoNodeData,
        isLeftSide: true,
        draggableAreaHeight:
            outputOffset(videoNodeData, theme, videoNodeData.outputs.length - 1)
                    .dy -
                UiStaticProperties.nodePadding +
                theme.dPanelPadding +
                (theme.dButtonHeight / 2),
      ),
      Knot(
          nodeData: videoNodeData,
          isInput: true,
          index: 0,
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
            // offset: Offset(
            //     videoNodeData.nodeWidth +
            //         UiStaticProperties.nodePadding,
            //     (_getContainerPositionRelativeToParent(
            //             _childKeys[index])) //only call when necessary
            //         .dy),
          );
        } else {
          return Container();
        }
      }).toList(),
    ]);
  }
}

// class VideoNode extends StatefulWidget {
//   final VideoNodeData nodeData;
//   const VideoNode({super.key, required this.nodeData});

//   @override
//   State<VideoNode> createState() => _VideoNodeState();
// }

// class _VideoNodeState extends State<VideoNode> {
//   final GlobalKey _parentKey = GlobalKey(); // Key for the Positioned parent
//   final GlobalKey _bottomKey =
//       GlobalKey(); // Key for the location of the bottom of the node
//   final List<GlobalKey> _childKeys = []; // Key for the Child
//   final TextEditingController _nameTextEditingController =
//       TextEditingController();

//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<NodesProvider>().rebuildNode(widget.nodeData.id);
//     });
//     super.initState();

//     context.read<NodesProvider>().initializeOutputs(widget.nodeData.id);
//     // widget.nodeData.initializeOutputs();
//     // int currentOutputs =
//     context.read<NodesProvider>().getEffectiveOutputs(widget.nodeData.id);
//     for (int i = 0; i < 10; i++) {
//       //TODO de-hardcode
//       _childKeys.add(GlobalKey());
//     }
//   }

double getTextHeight(String text, TextStyle style) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: TextDirection.ltr,
    // maxLines: 1,
  )..layout();

  return textPainter.height;
}

Offset inputOffset(BaseNodeData nodeData, AppTheme theme) {
  TextStyle swatchTextStyle = TextStyle(
      //TODO Move to theme as a getter
      overflow: TextOverflow.ellipsis,
      color: theme.cTextActive,
      fontVariations: const [FontVariation('wght', 500)],
      fontSize: theme.dTextHeight,
      height: 1.0);
  TextStyle filenameTextStyle = TextStyle(
    color: theme.cText,
    fontSize: theme.dTextHeight,
    height: 1.0,
  );

  double x = UiStaticProperties.nodePadding;
  double y = UiStaticProperties.nodePadding +
      theme.dSwatchHeight +
      (nodeData.nodeName != null
          ? getTextHeight(nodeData.nodeName!, swatchTextStyle)
          : 0) +
      (UiStaticProperties.nodeDefaultWidth * 9 / 16);
  return Offset(x, y);
}

Offset outputOffset(VideoNodeData nodeData, AppTheme theme, int index) {
  TextStyle swatchTextStyle = TextStyle(
    //TODO Move to theme as a getter
    overflow: TextOverflow.ellipsis,
    color: theme.cTextActive,
    fontVariations: const [FontVariation('wght', 500)],
    fontSize: theme.dTextHeight,
    height: 1.0,
  );
  TextStyle filenameTextStyle = TextStyle(
    color: theme.cText,
    fontSize: theme.dTextHeight,
    height: 1.0,
  );

  double x = UiStaticProperties.nodePadding + nodeData.nodeWidth;
  print('width is ${nodeData.nodeWidth}');
  double baseY = UiStaticProperties.nodePadding +
      theme.dSwatchHeight +
      (nodeData.nodeName != null
          ? getTextHeight(nodeData.nodeName!, swatchTextStyle)
          : 0) +
      (UiStaticProperties.nodeDefaultWidth * 9 / 16) +
      getTextHeight(nodeData.videoDataId, filenameTextStyle) +
      (theme.dPanelPadding * 2) +
      (theme.dButtonHeight / 2);
  double extraY = index * (theme.dButtonHeight + theme.dPanelPadding);
  return Offset(x, baseY + extraY);
}

class NodeVideoOutputsList extends StatelessWidget {
  const NodeVideoOutputsList({
    super.key,
    required this.videoNodeData,
    this.childKeys,
  });

  final List<GlobalKey>? childKeys;
  final VideoNodeData videoNodeData;

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;
    final NodesProvider nodesProvider = context.read<NodesProvider>();

    return FocusScope(
      autofocus: false,
      onFocusChange: (gotFocus) {
        if (gotFocus) {
          print('node ${videoNodeData.id} got focus');
        } else {
          print('node ${videoNodeData.id} lost focus');
        }
      },
      child: FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        //this makes it so the tab key only cycles through the current node's inputs
        child: Container(
          padding: EdgeInsets.all(theme.dPanelPadding),
          child: Column(
            children: List.generate(videoNodeData.outputs.length, (index) {
              bool isLast = index == videoNodeData.outputs.length - 1;
              return Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: NutriaTextfield(
                          onChanged: (currentText) {
                            nodesProvider.setVideoNodeOutputText(
                                text: currentText,
                                id: videoNodeData.id,
                                outputIndex: index);
                            // WidgetsBinding.instance.addPostFrameCallback((_) {
                            //   nodesProvider.rebuildNode(videoNodeData.id);
                            // });
                            nodesProvider.rebuildNode(videoNodeData.id);
                          },
                          index: index + 1,
                          text: (videoNodeData.outputs[index].outputData ?? '')
                              .toString(),
                        ),
                      ),
                      if (isLast) ...[
                        SizedBox(
                          width: theme.dPanelPadding,
                        ),
                        NutriaButton.Icon(
                          icon: videoNodeData.isExpanded
                              ? Icons.arrow_drop_up
                              : Icons.arrow_drop_down,
                          onTap: () {
                            nodesProvider.expandToggle(videoNodeData.id);
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              nodesProvider.rebuildNode(videoNodeData.id);
                            });
                            // ;
                          },
                        ),
                      ],
                      Column(
                        children: [
                          SizedBox(
                            width: 0,
                            height: theme.dButtonHeight / 2,
                          ),
                          SizedBox(
                            width: 0,
                            key: childKeys != null ? childKeys![index] : null,
                          ),
                        ],
                      )
                    ],
                  ),
                  if (!isLast)
                    SizedBox(
                      height: theme.dPanelPadding,
                    ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
