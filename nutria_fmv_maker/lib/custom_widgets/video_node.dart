import 'package:flutter/material.dart';
import 'package:nutria_fmv_maker/custom_widgets/nutria_button.dart';
import 'package:nutria_fmv_maker/custom_widgets/nutria_textfield.dart';
import 'package:nutria_fmv_maker/knot.dart';
import 'package:provider/provider.dart';

import '../models/node_data.dart';
import '../models/app_theme.dart';
import '../providers/theme_provider.dart';
import '../providers/nodes_provider.dart';
import '../static_data/ui_static_properties.dart';
import 'node_elements/node_debug_info.dart';
import 'node_elements/node_main_container.dart';
import 'node_elements/node_resize_handle.dart';
import 'node_elements/node_swatches_picker.dart';
import 'node_elements/node_video_filename_text.dart';
import 'node_elements/node_video_thumbnail.dart';

class VideoNode extends StatefulWidget {
  final VideoNodeData nodeData;
  const VideoNode({super.key, required this.nodeData});

  @override
  State<VideoNode> createState() => _VideoNodeState();
}

class _VideoNodeState extends State<VideoNode> {
  final GlobalKey _parentKey = GlobalKey(); // Key for the Positioned parent
  final List<GlobalKey> _childKeys = []; // Key for the Child
  final TextEditingController _nameTextEditingController =
      TextEditingController();

  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   setState(() {});
    // });
    super.initState();

    context.read<NodesProvider>().initializeOutputs(widget.nodeData.id);
    // widget.nodeData.initializeOutputs();
    // int currentOutputs =
    //     context.read<NodesProvider>().getEffectiveOutputs(widget.nodeData.id);
    for (int i = 0; i < 10; i++) { //de-hardcode
      _childKeys.add(GlobalKey());
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;

    {
      return Selector<NodesProvider, NodeData>(
          selector: (context, provider) => provider
              .getNodeById(widget.nodeData.id), // Only listen to this node
          builder: (context, node, child) {
            print(
                'rebuilding ${widget.nodeData.id}'); //DEBUG to check when nodes rebuild
            // Important! these need to be within the selector to work properly
            final NodesProvider nodesProvider = context.read<NodesProvider>();
            final VideoNodeData videoNodeData =
                nodesProvider.getNodeById(widget.nodeData.id) as VideoNodeData;
            return Positioned(
              key: _parentKey,
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
                    child: Container(color: Colors.black26),
                  ),
                ),
                Positioned(
                  top: UiStaticProperties.nodePadding,
                  left: UiStaticProperties.nodePadding,
                  child: GestureDetector(
                    // behavior: HitTestBehavior.translucent,
                    onPanUpdate: (details) {
                      nodesProvider.offsetNodePosition(
                          videoNodeData.id, details.delta);
                    },
                    onPanStart: (details) {
                      nodesProvider.setActiveNode(videoNodeData.id);
                    },
                    onTap: () {
                      nodesProvider.setActiveNode(videoNodeData.id);
                    },
                    child: Container(
                      width: videoNodeData.nodeWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          //Swatch Strip on top
                          NodeSwatchStrip(
                              nodeData: videoNodeData,
                              nameTextEditingController:
                                  _nameTextEditingController),
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
                                  childKeys: _childKeys),
                            ],
                          ),
                          //distance between main node and expansion
                          SizedBox(
                            height: theme.dPanelPadding,
                          ),
                          //expansion
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
                NodeResizeHandle(
                  nodeData: videoNodeData,
                  isLeftSide: false,
                  draggableAreaHeight: 200,
                ),
                NodeResizeHandle(
                  nodeData: videoNodeData,
                  isLeftSide: true,
                  draggableAreaHeight: 200,
                ),
                //left resizer

                Knot(offset: videoNodeData.inputOffsetFromTopLeft),

                ...videoNodeData.outputs.asMap().entries.map((entry) {
                  int index = entry.key;
                  var output = entry.value;
                  bool isLast = index == videoNodeData.outputs.length - 1;
                  // nodesProvider.updateOutputPosition(videoNodeData.id, index,
                  //     _getContainerPositionRelativeToParent(_childKeys[index]));
                  if (!isLast) {
                    return Knot(
                      offset: Offset(
                          videoNodeData.nodeWidth +
                              UiStaticProperties.nodePadding,
                          (_getContainerPositionRelativeToParent(
                                  _childKeys[index]))
                              .dy),
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

  Offset _getContainerPositionRelativeToParent(GlobalKey key) {
    final RenderBox? containerRenderBox =
        key.currentContext?.findRenderObject() as RenderBox?;
    final RenderBox? parentRenderBox =
        _parentKey.currentContext?.findRenderObject() as RenderBox?;

    if (containerRenderBox != null && parentRenderBox != null) {
      final containerGlobalPosition =
          containerRenderBox.globalToLocal(Offset.zero);
      final parentGlobalPosition = parentRenderBox.globalToLocal(Offset.zero);

      return parentGlobalPosition - containerGlobalPosition;
    }
    return Offset.zero;
  }
}

class NodeVideoOutputsList extends StatelessWidget {
  const NodeVideoOutputsList({
    super.key,
    required this.videoNodeData,
    required this.childKeys,
  });

  final List<GlobalKey> childKeys;
  final VideoNodeData videoNodeData;

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;
    final NodesProvider nodesProvider = context.read<NodesProvider>();

    return FocusScope(
      //this makes it so the tab key only cycles through the current node's inputs
      child: Container(
        padding: EdgeInsets.all(theme.dPanelPadding),
        child: Column(
          children: [
            //sizedbox for spacing
            ...videoNodeData.outputs.asMap().entries.map((entry) {
              int index = entry.key;
              var output = entry.value;
              bool isLast = index == videoNodeData.outputs.length - 1;
              return Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: NutriaTextfield(
                          onChanged: () {
                            //
                          },
                          index: index + 1,
                          text: (entry.value as VideoOutput).outputText,
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
                            key: childKeys[index],
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
            }).toList(),
          ],
        ),
      ),
    );
  }
}

class NodeSwatchStrip extends StatelessWidget {
  const NodeSwatchStrip({
    super.key,
    required this.nodeData,
    required this.nameTextEditingController,
  });

  final BaseNodeData nodeData;
  final TextEditingController nameTextEditingController;

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;

    return Container(
      padding: EdgeInsets.symmetric(
          vertical: theme.dSwatchHeight / 2,
          horizontal: theme.dPanelPadding + 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(theme.dPanelBorderRadius),
            topRight: Radius.circular(theme.dPanelBorderRadius)),
        color: theme.cSwatches[nodeData.swatch],
      ),
      child: IgnorePointer(
        child: Container(
          alignment: Alignment.centerLeft,
          child: nodeData.nodeName != null
              ? TextField(
                  controller: nameTextEditingController
                    ..text = nodeData.nodeName!,
                  style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: theme.cText,
                    fontVariations: [FontVariation('wght', 700)],
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                  ),
                  onSubmitted: (newValue) {
                    // nodesProvider.updateNodeName(videoNodeData.id, newValue);
                  },
                )
              : Container(),
        ),
      ),
    );
  }
}
