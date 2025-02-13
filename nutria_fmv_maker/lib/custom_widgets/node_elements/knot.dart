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
  final int index;
  final BaseNodeData nodeData;
  final bool isOutput;

  const Knot.output(
      {super.key,
      required this.offset,
      required this.index,
      required this.nodeData})
      : isOutput = true;

  const Knot.input(
      {super.key,
      required this.offset,
      required this.index,
      required this.nodeData})
      : isOutput = false;

  // final void Function(DragStartDetails)? onPanStart;
  // final void Function(DragUpdateDetails)? onPanUpdate;
  // final void Function(DragEndDetails)? onPanEnd;

  @override
  State<Knot> createState() => _KnotState();
}

class _KnotState extends State<Knot> {
  bool hovered = false;
  // bool dragging = false;
  bool isBeingTargeted = false;
  bool isBeingDragged = false;
  NoodleDragIntent? nextIntent;
  NoodleDragIntent? selfIntent;
  @override
  Widget build(BuildContext context) {
    // print ('Knot build');
    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;

    final NodesProvider nodesProvider = context.read<NodesProvider>();
    final double boxSize = widget._sizeLarge * sqrt2;

    if (widget.isOutput) {
      //if is output
      isBeingTargeted = widget.nodeData.outputs[widget.index].isBeingTargeted;
      isBeingDragged = widget.nodeData.outputs[widget.index].isBeingDragged;

      if (widget.nodeData.outputs[widget.index].targetNodeId != null) {
        nextIntent = NoodleDragIntent.input(
            widget.nodeData.outputs[widget.index].targetNodeId!);
        selfIntent = NoodleDragIntent.output(widget.nodeData.id, widget.index);
      } else {
        nextIntent = NoodleDragIntent.output(widget.nodeData.id, widget.index);
      }
    } else if (!widget.isOutput) {
      //if is input
      isBeingTargeted = widget.nodeData.input.isBeingTargeted;
      isBeingDragged = widget.nodeData.input.isBeingDragged;
      nextIntent = NoodleDragIntent.input(widget.nodeData.id);
    }

// isBeingTargeted
    return Positioned(
      top: widget.offset.dy - boxSize / 2,
      left: widget.offset.dx - boxSize / 2,
      child: MouseRegion(
        onEnter: (_) {
          nodesProvider.setCurrentUnderCursor(widget.isOutput
              ? NoodleDragOutcome.output(widget.nodeData.id, widget.index)
              : NoodleDragOutcome.input(widget.nodeData.id));
          if (nodesProvider.isDraggingNoodle) return;
          setState(() {
            hovered = true;
          });
        },
        onExit: (_) {
          nodesProvider.setCurrentUnderCursor(NoodleDragOutcome.empty());
          // if (dragging) return;
          setState(() {
            hovered = false;
          });
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanStart: (details) {
            nodesProvider.beginDragging(nextIntent!, toClearIfNothing: selfIntent);
            // dragging = true;
            // print('start triggered, nextIntent: $nextIntent');
          },
          // onPanUpdate: widget.onPanUpdate,
          onPanEnd: (details) {
            nodesProvider.endDragging();
            print('end triggered');
          },

          child: SizedBox(
            width: boxSize,
            height: boxSize,
            child: Center(
              child: SizedBox(
                width: isBeingDragged || isBeingTargeted || hovered
                    ? widget._sizeLarge
                    : widget._sizeSmall, // Scale up on hover
                height: isBeingDragged || isBeingTargeted || hovered
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
