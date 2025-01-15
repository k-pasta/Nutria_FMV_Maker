import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  // final double width = ;
  const VideoNode({super.key, required this.nodeData});

  @override
  State<VideoNode> createState() => _VideoNodeState();
}

class _VideoNodeState extends State<VideoNode> {
  late Offset _dragPosition;
  double _currentWidth = UiStaticProperties.nodeMinWidth;
  GlobalKey _parentKey = GlobalKey(); // Key for the Positioned parent
  final List<GlobalKey> _childKeys = []; // Key for the Positioned parent

  @override
  void initState() {
    super.initState();
    _dragPosition = widget.nodeData.position;
    for (int i = 0; i < 20; i++) {
      //TODO de-hardcode
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
                      Provider.of<NodesProvider>(context, listen: false)
                          .updateNodePosition(
                              widget.nodeData.id, _dragPosition);
                    },
                    onPanStart: (details) {
                      Provider.of<NodesProvider>(context, listen: false)
                          .setActiveNode(widget.nodeData.id);
                    },
                    onTap: () {
                      Provider.of<NodesProvider>(context, listen: false)
                          .setActiveNode(widget.nodeData.id);
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
                              color: theme.cSwatches[widget.nodeData.swatch],
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
                                          widget.nodeData
                                              .getVideoData(context
                                                  .read<NodesProvider>()
                                                  .videos)!
                                              .fileName, //TODO handle null
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: theme.cText),
                                        ),
                                        //sizedbox for spacing
                                        SizedBox(
                                          height: theme.dPanelPadding,
                                        ),
                                        //textfields
                                        NutriaTextfield(
                                            key: _childKeys[0], index: 1),

                                        SizedBox(
                                          height: theme.dPanelPadding,
                                        ),
                                        NutriaTextfield(
                                          key: _childKeys[1],
                                          index: 2,
                                        ),
                                        SizedBox(
                                          height: theme.dPanelPadding,
                                        ),
                                        Row(
                                          key: _childKeys[2],
                                          // crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            Expanded(
                                                child: NutriaTextfield(
                                              index: 3,
                                            )),
                                            SizedBox(
                                              width: theme.dPanelPadding,
                                            ),
                                            NutriaButton.Icon(
                                              icon: widget.nodeData.isExpanded
                                                  ? Icons.arrow_drop_up
                                                  : Icons.arrow_drop_down,
                                              onTap: () {
                                                _getContainerPositionRelativeToParent(_childKeys[0]);
                                                _getContainerPositionRelativeToParent(_childKeys[1]);
                                                _getContainerPositionRelativeToParent(_childKeys[2]);
                                                // _getContainerPositionRelativeToParent(_childKeys[3]);
                                                Provider.of<NodesProvider>(
                                                        context,
                                                        listen: false)
                                                    .expandToggle(
                                                        widget.nodeData.id);
                                              },
                                            ),
                                          ],
                                        )
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
                          if (widget.nodeData.isExpanded)
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
                                                Provider.of<NodesProvider>(
                                                        context,
                                                        listen: false)
                                                    .setSwatch(
                                                        widget.nodeData.id,
                                                        index);
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
                Knot(offset: widget.nodeData.inputOffsetFromTopLeft)
              ]),
            );
          });
    }
  }

  void _getContainerPositionRelativeToParent(GlobalKey key) {
    // Get the RenderBox of the container (target widget)
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

      // Calculate the position relative to the parent by subtracting
      final relativePosition = containerGlobalPosition - parentGlobalPosition;

      print('Container Position Relative to Parent: $relativePosition');
    }
  }
}
