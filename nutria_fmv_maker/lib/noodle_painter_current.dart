import 'package:flutter/material.dart';
import 'package:nutria_fmv_maker/static_data/ui_static_properties.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import 'models/app_theme.dart';

class NoodlePainterCurrent extends CustomPainter {
  final Offset? mousePosition;
  final Offset startPoint;
  final BuildContext context;

  NoodlePainterCurrent(
      {required this.startPoint,
      required this.mousePosition,
      required this.context});

  @override
  void paint(Canvas canvas, Size size) {
    final AppTheme theme =
        Provider.of<ThemeProvider>(context, listen: false).currentAppTheme;

    if (mousePosition == null) return;

    final Paint paint = Paint()
      ..color = theme.cAccent
      ..strokeWidth = UiStaticProperties.noodleWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(startPoint, mousePosition!, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
