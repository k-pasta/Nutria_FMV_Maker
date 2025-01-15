import 'dart:ffi';

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

class VideoNode extends StatefulWidget {
  final VideoNodeData nodeData;
  const VideoNode({super.key, required this.nodeData});

  @override
  State<VideoNode> createState() => _VideoNodeState();
}

class _VideoNodeState extends State<VideoNode> {
  late Offset _dragPosition;
  double _currentWidth = UiStaticProperties.nodeMinWidth;
  GlobalKey _parentKey = GlobalKey(); // Key for the Positioned parent
  final List<GlobalKey> _childKeys = []; // Key for the Child

  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getContainerPositionRelativeToParent(
          _childKeys, context.read<NodesProvider>(), widget.nodeData.id);
    });
    super.initState();
    widget.nodeData.initializeOutputs();
    int currentOutputs =
        context.read<NodesProvider>().getEffectiveOutputs(widget.nodeData.id);
    _dragPosition = widget.nodeData.position;
    for (int i = 0; i < currentOutputs; i++) {
      _childKeys.add(GlobalKey());
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;
    final NodesProvider nodesProvider = context.read<NodesProvider>();
    final VideoNodeData videoNodeData =
        nodesProvider.getNodeById(widget.nodeData.id);
    {
      return Selector<NodesProvider, NodeData>(
          selector: (context, provider) => nodesProvider
              .getNodeById(widget.nodeData.id), // Only listen to this node
          builder: (context, node, child) {
            print('rebuilding ${widget.nodeData.id}');
            return Positioned(
              key: _parentKey,
              top: _dragPosition.dy + (UiStaticProperties.topLeftToMiddle.dy),
              left: _dragPosition.dx + (UiStaticProperties.topLeftToMiddle.dx),
              // top: _dragPosition.dy,
              // left: _dragPosition.dx,
              child: Stack(clipBehavior: Clip.none, children: [
                IgnorePointer(
                  child: SizedBox(
                    height: 1000,
                    width: 500,
                    // child: Container(color: Colors.black26),
                  ),
                ),
                Positioned(
                  top: UiStaticProperties.nodePadding,
                  left: UiStaticProperties.nodePadding,
                  child: GestureDetector(
                    // behavior: HitTestBehavior.translucent,
                    onPanUpdate: (details) {
                      setState(() {
                        _dragPosition += details.delta;
                      });
                      nodesProvider.updateNodePosition(
                          videoNodeData.id, _dragPosition);
                    },
                    onPanStart: (details) {
                      nodesProvider.setActiveNode(videoNodeData.id);
                    },
                    onTap: () {
                      nodesProvider.setActiveNode(videoNodeData.id);
                    },
                    child: Container(
                      width: _currentWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          //Swatch Strip on top
                          Container(
                            height: theme.dSwatchHeight,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft:
                                      Radius.circular(theme.dPanelBorderRadius),
                                  topRight: Radius.circular(
                                      theme.dPanelBorderRadius)),
                              color: theme.cSwatches[videoNodeData.swatch],
                            ),
                          ),
                          //Main node background
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft:
                                    Radius.circular(theme.dPanelBorderRadius),
                                bottomRight:
                                    Radius.circular(theme.dPanelBorderRadius),
                              ),
                              border: Border(
                                left: BorderSide(
                                    color: theme.cOutlines,
                                    width: theme.dOutlinesWidth),
                                right: BorderSide(
                                    color: theme.cOutlines,
                                    width: theme.dOutlinesWidth),
                                bottom: BorderSide(
                                    color: theme.cOutlines,
                                    width: theme.dOutlinesWidth),
                              ),
                              color: theme.cPanelTransparent,
                            ),
                            child: Column(
                              children: [
                                //thumbnail
                                Container(
                                  height: _currentWidth *
                                      9 /
                                      16, //TODO allow for vertical aspect ratio
                                  child: Placeholder(
                                    strokeWidth: 2,
                                  ),
                                ),
                                //under thumbnail
                                FocusScope(
                                  //this makes it so the tab key only cycles through the current node's inputs
                                  child: Container(
                                    padding:
                                        EdgeInsets.all(theme.dPanelPadding),
                                    child: Column(
                                      children: [
                                        //video file name
                                        Text(
                                          videoNodeData
                                              .getVideoData(
                                                  nodesProvider.videos)!
                                              .fileName, //TODO handle null
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: theme.cText),
                                        ),
                                        //sizedbox for spacing
                                        SizedBox(
                                          height: theme.dPanelPadding,
                                        ),

                                        ...videoNodeData.outputs
                                            .asMap()
                                            .entries
                                            .map((entry) {
                                          int index = entry.key;
                                          var output = entry.value;
                                          bool isLast = index ==
                                              videoNodeData.outputs.length - 1;
                                          return Column(
                                            children: [
                                              Row(
                                                key: _childKeys[index],
                                                children: [
                                                  Expanded(
                                                    child: NutriaTextfield(
                                                      onTap: () {
                                                        _getContainerPositionRelativeToParent(
                                                            _childKeys,
                                                            context.read<
                                                                NodesProvider>(),
                                                            widget.nodeData.id);
                                                      },
                                                      index: index + 1,
                                                      text: (entry.value
                                                              as VideoOutput)
                                                          .outputText,
                                                    ),
                                                  ),
                                                  if (isLast) ...[
                                                    SizedBox(
                                                      width:
                                                          theme.dPanelPadding,
                                                    ),
                                                    NutriaButton.Icon(
                                                      icon: videoNodeData
                                                              .isExpanded
                                                          ? Icons.arrow_drop_up
                                                          : Icons
                                                              .arrow_drop_down,
                                                      onTap: () {
                                                        setState(() {
                                                          nodesProvider
                                                              .expandToggle(
                                                                  videoNodeData
                                                                      .id);
                                                        });
                                                      },
                                                    ),
                                                  ],
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
                                ),
                              ],
                            ),
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
                                  LayoutBuilder(
                                    builder: (context, constraints) {
                                      final spacing = theme
                                          .dPanelPadding; // Spacing between items
                                      final totalSpacing = spacing *
                                          (theme.cSwatches.length - 1);
                                      final itemWidth = (constraints.maxWidth -
                                              totalSpacing) /
                                          theme.cSwatches.length;
                                      return Wrap(
                                        spacing: theme.dPanelPadding,
                                        children: theme.cSwatches
                                            .asMap()
                                            .entries
                                            .map((entry) {
                                          final index = entry.key;
                                          final color = entry.value;
                                          return MouseRegion(
                                            cursor: SystemMouseCursors.click,
                                            child: GestureDetector(
                                              onTap: () {
                                                nodesProvider.setSwatch(
                                                    videoNodeData.id, index);
                                              },
                                              child: Container(
                                                height: itemWidth,
                                                width: itemWidth,
                                                margin: EdgeInsets.zero,
                                                decoration: BoxDecoration(
                                                  color: color,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.0),
                                                  border: Border.all(
                                                      color: theme.cOutlines,
                                                      width: 1),
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      );
                                    },
                                  ),
                                  if (UiStaticProperties.isDebug) ...[
                                    SizedBox(
                                      height: theme.dPanelPadding,
                                    ),
                                    Text(
                                      'Debug Info:',
                                      style: TextStyle(color: theme.cText),
                                    ),
                                    SizedBox(
                                      height: theme.dPanelPadding,
                                    ),
                                    Text(
                                      'Node ID: ${widget.nodeData.id}',
                                      style: TextStyle(color: theme.cText),
                                    ),
                                    SizedBox(
                                      height: theme.dPanelPadding,
                                    ),
                                    Text(
                                      'Position: ${_dragPosition.toString()}',
                                      style: TextStyle(color: theme.cText),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                Knot(offset: videoNodeData.inputOffsetFromTopLeft),
                // Knot(
                //   offset: _getContainerPositionRelativeToParent(_childKeys[0]),
                // ),
                ...videoNodeData.outputs.asMap().entries.map((entry) {
                  int index = entry.key;
                  var output = entry.value;
                  bool isLast = index == videoNodeData.outputs.length - 1;
                  // nodesProvider.updateOutputPosition(videoNodeData.id, index,
                  //     _getContainerPositionRelativeToParent(_childKeys[index]));
                  // _getContainerPositionRelativeToParent(_childKeys[index])
                  if (!isLast) {
                    return Knot(
                      offset: output.outputOffsetFromTopLeft,
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

  void _getContainerPositionRelativeToParent(
      List<GlobalKey> keys, NodesProvider nodesProvider, String id) {
    // Get the RenderBox of the container (target widget)
    keys.forEach((key) {
      final RenderBox containerRenderBox =
          key.currentContext?.findRenderObject() as RenderBox;
      final RenderBox parentRenderBox =
          _parentKey.currentContext?.findRenderObject() as RenderBox;

      if (containerRenderBox != null && parentRenderBox != null) {
        // Get the global position of the container
        final containerGlobalPosition =
            containerRenderBox.localToGlobal(Offset.zero);
        // Get the global position of the parent (Positioned widget)
        final parentGlobalPosition = parentRenderBox.localToGlobal(Offset.zero);

        final relativePosition = containerGlobalPosition -
            parentGlobalPosition +
            Offset(
                (nodesProvider.getNodeById(id) as VideoNodeData).nodeWidth - 8,
                50 / 2);
        // Calculate the position relative to the parent by subtracting

        final index = keys.indexOf(key);
        nodesProvider.updateOutputPosition(id, index, relativePosition);
      }
    });
    // List<Offset>
    // return Offset.zero;
  }
}
