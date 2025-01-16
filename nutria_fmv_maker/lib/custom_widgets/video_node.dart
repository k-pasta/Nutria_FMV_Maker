import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:nutria_fmv_maker/custom_widgets/nutria_button.dart';
import 'package:nutria_fmv_maker/custom_widgets/nutria_textfield.dart';
import 'package:nutria_fmv_maker/knot.dart';
// import 'package:path/path.dart';
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
  double _currentWidth = UiStaticProperties.nodeDefaultWidth;
  double _intendedWidth = UiStaticProperties.nodeDefaultWidth;
  GlobalKey _parentKey = GlobalKey(); // Key for the Positioned parent
  final List<GlobalKey> _childKeys = []; // Key for the Child

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
    super.initState();

    context.read<NodesProvider>().initializeOutputs(widget.nodeData.id);
    _intendedWidth = widget.nodeData.nodeWidth;
    // widget.nodeData.initializeOutputs();
    // int currentOutputs =
    //     context.read<NodesProvider>().getEffectiveOutputs(widget.nodeData.id);
    _dragPosition = widget.nodeData.position;
    for (int i = 0; i < 10; i++) {
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
            print('rebuilding ${widget.nodeData.id}');
            // Important! these need to be within the selector to work properly
            final NodesProvider nodesProvider = context.read<NodesProvider>();
            final VideoNodeData videoNodeData =
                nodesProvider.getNodeById(widget.nodeData.id) as VideoNodeData;
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
                      // setState(() {
                      _dragPosition += details.delta;
                      // });
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
                            padding: EdgeInsets.symmetric(
                                vertical: theme.dSwatchHeight / 2,
                                horizontal: theme.dPanelPadding + 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft:
                                      Radius.circular(theme.dPanelBorderRadius),
                                  topRight: Radius.circular(
                                      theme.dPanelBorderRadius)),
                              color: theme.cSwatches[videoNodeData.swatch],
                            ),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: videoNodeData.nodeName != null
                                  ? Text(
                                      videoNodeData.nodeName!,
                                      style:
                                          TextStyle(color: theme.cBackground),
                                    )
                                  : Container(),
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
                                  height: UiStaticProperties.nodeDefaultWidth *
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
                                                        // setState(() {});
                                                        WidgetsBinding.instance
                                                            .addPostFrameCallback(
                                                                (_) {
                                                          setState(() {});
                                                        });
                                                        // nodesProvider.setActiveNode(videoNodeData.id);
                                                        // print('tapped textfield');
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
                                                        nodesProvider
                                                            .expandToggle(
                                                                videoNodeData
                                                                    .id);
                                                        // ;
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
                                                height: itemWidth <
                                                        theme.dButtonHeight
                                                    ? itemWidth
                                                    : theme.dButtonHeight,
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
                                      'Node ID: ${videoNodeData.id}',
                                      style: TextStyle(color: theme.cText),
                                    ),
                                    SizedBox(
                                      height: theme.dPanelPadding,
                                    ),
                                    Text(
                                      'Position: ${videoNodeData.position.toString()}',
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
                Positioned(
                  top: UiStaticProperties.nodePadding,
                  left: videoNodeData.nodeWidth +
                      UiStaticProperties.nodePadding -
                      theme.dPanelPadding,
                  width: theme.dPanelPadding, //todo add value that makes sense
                  height: 200, //todo add value that makes sense
                  child: MouseRegion(
                    cursor: SystemMouseCursors.resizeLeftRight,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        _currentWidth = _getWidthFromDrag(details.delta);

                        nodesProvider.updateNodeWidth(
                            videoNodeData.id, _currentWidth);
                      },
                      onPanEnd: (details) {
                        _intendedWidth = _currentWidth;
                      },
                      child: Container(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
                //left resizer
                Positioned(
                  top: UiStaticProperties.nodePadding,
                  left: UiStaticProperties.nodePadding,
                  width: theme.dPanelPadding, //todo add value that makes sense
                  height: 200, //todo add value that makes sense
                  child: MouseRegion(
                    cursor: SystemMouseCursors.resizeLeftRight,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        double previousWidth = _currentWidth;

                        // Update the width
                        _currentWidth = _getWidthFromDrag(-details.delta);

                        // Update the position to keep the box aligned correctly
                        double widthDelta = _currentWidth - previousWidth;
                        _dragPosition -= Offset(widthDelta, 0);
                        nodesProvider.updateNodeWidth(
                            videoNodeData.id, _currentWidth);
                        nodesProvider.updateNodePosition(
                            videoNodeData.id, _dragPosition);
                      },
                      onPanEnd: (details) {
                        _intendedWidth = _currentWidth;
                      },
                      child: Container(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),

                Knot(offset: videoNodeData.inputOffsetFromTopLeft),
                // Knot(
                //   offset: _getContainerPwidgetositionRelativeToParent(_childKeys[0]),
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
                      offset: _getContainerPositionRelativeToParent(
                          _childKeys[index]),
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

  double _getWidthFromDrag(Offset delta) {
    _intendedWidth += delta.dx;

    if (_intendedWidth < UiStaticProperties.nodeMinWidth) {
      return UiStaticProperties.nodeMinWidth;
    }

    if (_intendedWidth > UiStaticProperties.nodeMaxWidth) {
      return UiStaticProperties.nodeMaxWidth;
    }

    if ((_intendedWidth - UiStaticProperties.nodeDefaultWidth).abs() <= 20) {
      //TODO de-hardcode
      return UiStaticProperties.nodeDefaultWidth;
    }

    return _intendedWidth;
  }

  Offset _getPositionOffsetFromDrag(Offset delta) {
    _intendedWidth += delta.dx;

    if (_intendedWidth < UiStaticProperties.nodeMinWidth) {
      return Offset.zero;
    }

    if (_intendedWidth > UiStaticProperties.nodeMaxWidth) {
      return Offset.zero;
    }

    // if ((_intendedWidth - UiStaticProperties.nodeDefaultWidth).abs() <= 20) { //TODO de-hardcode
    //   return Offset.zero;
    // }

    return Offset(delta.dx, 0);
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

      return -(containerGlobalPosition - parentGlobalPosition);
    }
    return Offset.zero;
  }
}
