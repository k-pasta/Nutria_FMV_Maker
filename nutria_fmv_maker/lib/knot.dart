import 'dart:math';
import 'package:flutter/material.dart';
import 'static_data/ui_static_properties.dart';
import 'package:nutria_fmv_maker/models/app_theme.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class Knot extends StatefulWidget {
  final double _sizeLarge = UiStaticProperties.knotSizeLarge;
  final double _sizeSmall = UiStaticProperties.knotSizeSmall;
  final Offset offset;

  const Knot({super.key, required this.offset});

  // final void Function(DragStartDetails)? onPanStart;
  // final void Function(DragUpdateDetails)? onPanUpdate;
  // final void Function(DragEndDetails)? onPanEnd;

  @override
  State<Knot> createState() => _KnotState();
}

class _KnotState extends State<Knot> {
  bool hovered = false;
  bool dragging = false;

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;
    final double boxSize = widget._sizeLarge * sqrt2;

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
            dragging = true;
            print('start triggered');
          },
          // onPanUpdate: widget.onPanUpdate,
          onPanEnd: (details) {
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
                width: hovered
                    ? widget._sizeLarge
                    : widget._sizeSmall, // Scale up on hover
                height: hovered ? widget._sizeLarge : widget._sizeSmall,
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
