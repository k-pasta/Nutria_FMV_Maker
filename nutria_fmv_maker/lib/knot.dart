import 'dart:math';
import 'package:flutter/material.dart';
import 'package:nutria_fmv_maker/models/knot_data.dart';

class Knot extends StatefulWidget {
  final double sizeLarge = 30;
  final double sizeSmall = 15;

  final KnotData knotData;
  const Knot({super.key, required this.knotData});

  // final void Function(DragStartDetails)? onPanStart;
  // final void Function(DragUpdateDetails)? onPanUpdate;
  // final void Function(DragEndDetails)? onPanEnd;

  @override
  State<Knot> createState() => _KnotState();
}

class _KnotState extends State<Knot> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    KnotData knotData = widget.knotData;
    final double boxSize = widget.sizeLarge * sqrt2;

    if (knotData.positionFromTop.dx != 0) {
      print('knot ${knotData.knotID} has weird input offset');
    }

    return
        // Positioned(
        //   top: knotData.positionFromTop.dy,
        //   left: knotData.isInput
        //       ? knotData.positionFromTop.dx - boxSize / 2
        //       : knotData.positionFromTop.dx + boxSize / 2,
        //   child:
        MouseRegion(
      onEnter: (_) {
        setState(() {
          hovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          hovered = false;
        });
      },
      child: GestureDetector(
        onPanStart: (details) {
          print('start triggered');
        },
        // onPanUpdate: widget.onPanUpdate,
        onPanEnd: (details) {
          print('end triggered');
        },

        child: SizedBox(
          width: boxSize,
          height: boxSize,
          child: Center(
            child: Container(
              width: hovered
                  ? widget.sizeLarge
                  : widget.sizeSmall, // Scale up on hover
              height: hovered ? widget.sizeLarge : widget.sizeSmall,
              child: Transform.rotate(
                angle: 45 * 3.1415927 / 180, // Rotate by 45 degrees
                child: Container(
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ),
        //   ),
      ),
    );
  }
}
