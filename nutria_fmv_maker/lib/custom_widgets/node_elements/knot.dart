import 'dart:math';
import 'package:flutter/material.dart';
import 'package:nutria_fmv_maker/models/action_models.dart';
import '../../models/node_data.dart';
import '../../static_data/ui_static_properties.dart';
import '../../models/app_theme.dart';

import '../../providers/nodes_provider.dart';
import 'package:provider/provider.dart';
import '../../../providers/theme_provider.dart';

class Knot extends StatefulWidget {
  final double _sizeLarge = UiStaticProperties.knotSizeLarge;
  final double _sizeSmall = UiStaticProperties.knotSizeSmall;
  final Offset offset;
  final int? index;
  final BaseNodeData nodeData;
  final bool isInput;

  const Knot(
      {super.key,
      required this.offset,
      this.index,
      required this.nodeData,
      this.isInput = false});

  // final void Function(DragStartDetails)? onPanStart;
  // final void Function(DragUpdateDetails)? onPanUpdate;
  // final void Function(DragEndDetails)? onPanEnd;

  @override
  State<Knot> createState() => _KnotState();
}

class _KnotState extends State<Knot> {
  bool hovered = false;
  bool dragging = false;
  bool isBeingTargeted = false;

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;

    final NodesProvider nodesProvider = context.read<NodesProvider>();
    final double boxSize = widget._sizeLarge * sqrt2;

if (widget.index != null){ //if is output
  isBeingTargeted = widget.nodeData.outputs[widget.index!].isBeingTargeted;
}else if (widget.index == null){ //if is input
  isBeingTargeted = widget.nodeData.input.isBeingTargeted;
}

// isBeingTargeted
    return Positioned(
      top: widget.offset.dy - boxSize / 2,
      left: widget.offset.dx - boxSize / 2,
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
            hovered = true;
          });
        },
        onExit: (_) {
          if (dragging) return;
          setState(() {
            hovered = false;
          });
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanStart: (details) {
            nodesProvider.beginDragging(
                NoodleDragIntent.output(widget.nodeData.id, widget.index));
            dragging = true;
            print('start triggered');
          },
          // onPanUpdate: widget.onPanUpdate,
          onPanEnd: (details) {
            nodesProvider.endDragging();
            print('end triggered');
            setState(() {
              hovered = false;
              dragging = false;
            });
          },

          child: SizedBox(
            width: boxSize,
            height: boxSize,
            child: Center(
              child: SizedBox(
                width: hovered ||
                        (widget.nodeData.isBeingHovered && widget.isInput)
                    ? widget._sizeLarge
                    : widget._sizeSmall, // Scale up on hover
                height: hovered ||
                        (widget.nodeData.isBeingHovered && widget.isInput)
                    ? widget._sizeLarge
                    : widget._sizeSmall,
                child: Transform.rotate(
                  angle: 45 * 3.1415927 / 180, // Rotate by 45 degrees
                  child: Container(
                    color: theme.cAccent,
                  ),
                ),
              ),
            ),
          ),
          //   ),
        ),
      ),
    );
  }
}
