import 'package:flutter/material.dart';
import 'package:nutria_fmv_maker/custom_widgets/nutria_button.dart';
import 'package:nutria_fmv_maker/custom_widgets/nutria_textfield.dart';
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

  @override
  void initState() {
    super.initState();
    _dragPosition = widget.nodeData.position;
  }

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;
    return Positioned(
      // top: _dragPosition.dy + (UiStaticProperties.topLeftToMiddle.dy),
      // left: _dragPosition.dx + (UiStaticProperties.topLeftToMiddle.dx),
      top: _dragPosition.dy,
      left: _dragPosition.dx,
      child: Stack(clipBehavior: Clip.none, children: [
        IgnorePointer(
          child: SizedBox(
            height: 1000,
            width: 500,
            child: Container(color: Colors.black26),
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
                  .updateNodePosition(widget.nodeData.id, _dragPosition);
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
                  Container(
                    height: 10, //TODO de-hardcode
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(theme.dPanelBorderRadius),
                          topRight: Radius.circular(theme.dPanelBorderRadius)),
                      color: theme.cSwatches[0], //TODO implement into nodedata
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(theme.dButtonBorderRadius),
                        bottomRight: Radius.circular(theme.dButtonBorderRadius),
                      ),
                      border: Border(
                        left: BorderSide(color: theme.cOutlines, width: 1),
                        right: BorderSide(color: theme.cOutlines, width: 1),
                        bottom: BorderSide(color: theme.cOutlines, width: 1),
                      ),
                      color: theme.cPanelTransparent,
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: _currentWidth *
                              9 /
                              16, //TODO allow for vertical aspect ratio
                          color: theme.cPanelTransparent,
                        ),
                        Container(
                          padding: EdgeInsets.all(theme.dPanelPadding),
                          color: theme.cPanelTransparent,
                          child: Center(
                            child: Text(
                              widget.nodeData.videoDataPath,
                              style: TextStyle(color: theme.cText),
                            ),
                          ),
                        ),
                        Container(
                            padding: EdgeInsets.all(theme.dPanelPadding),
                            child: Column(
                              children: [
                                NutriaTextfield(),
                                SizedBox(
                                  height: theme.dPanelPadding,
                                ),
                                NutriaTextfield(
                                  index: 2,
                                ),
                                SizedBox(
                                  height: theme.dPanelPadding,
                                ),
                                Row(
                                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                        child: NutriaTextfield(
                                      index: 3,
                                    )),
                                    SizedBox(
                                      width: theme.dPanelPadding,
                                    ),
                                    NutriaButton(
                                      onTap: () {},
                                      child: Icon(Icons.arrow_drop_down),
                                    ),
                                  ],
                                )
                              ],
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
