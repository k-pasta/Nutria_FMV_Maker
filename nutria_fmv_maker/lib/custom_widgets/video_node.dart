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
                  //Swatch Strip on top
                  Container(
                    height: 10, //TODO de-hardcode
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(theme.dPanelBorderRadius),
                          topRight: Radius.circular(theme.dPanelBorderRadius)),
                      color: theme.cSwatches[0], //TODO implement into nodedata
                    ),
                  ),
                  //Main node background
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(theme.dPanelBorderRadius),
                        bottomRight: Radius.circular(theme.dPanelBorderRadius),
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
                        //thumbnail
                        Container(
                          height: _currentWidth *
                              9 /
                              16, //TODO allow for vertical aspect ratio
                          color: theme.cPanelTransparent,
                          child: Placeholder(
                            strokeWidth: 2,
                          ),
                        ),
                        //under thumbnail
                        Container(
                          padding: EdgeInsets.all(theme.dPanelPadding),
                          child: Column(
                            children: [
                              //video file name
                              Text(
                                widget.nodeData.videoDataPath,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: theme.cText),
                              ),
                              //sizedbox for spacing
                              SizedBox(
                                height: theme.dPanelPadding,
                              ),
                              //textfields
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
                          ),
                        ),
                      ],
                    ),
                  ),
                  //distance between main node and expansion
                  SizedBox(
                    height: theme.dPanelPadding / 4,
                  ),
                  //expansion
                  Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(theme.dPanelBorderRadius),
                      border: Border.all(color: theme.cOutlines, width: 1),
                      color: theme.cPanelTransparent,
                    ),
                    padding: EdgeInsets.all(theme.dPanelPadding),
                    child: Column(
                      children: [
                        //swatches picker
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final spacing =
                                theme.dPanelPadding; // Spacing between items
                            final totalSpacing =
                                spacing * (theme.cSwatches.length - 1);
                            final itemWidth =
                                (constraints.maxWidth - totalSpacing) /
                                    theme.cSwatches.length;
                            return Wrap(
                              spacing: theme.dPanelPadding,
                              children:
                                  theme.cSwatches.asMap().entries.map((entry) {
                                final index = entry.key;
                                final color = entry.value;
                                return MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: () {
                                      print(index);
                                    },
                                    child: Container(
                                      height: itemWidth,
                                      width: itemWidth,
                                      margin: EdgeInsets.zero,
                                      decoration: BoxDecoration(
                                        color: color,
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          },
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
