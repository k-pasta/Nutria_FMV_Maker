import 'package:flutter/material.dart';
import 'package:nutria_fmv_maker/static_data/ui_static_properties.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import 'models/app_theme.dart';

class NoodlePainter extends CustomPainter {
  final TransformationController transformationController;
  final BuildContext context;
  final List<Map<Offset, Offset>> startAndEndPoints;

  const NoodlePainter({
    required this.transformationController,
    required this.context,
    required this.startAndEndPoints,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final AppTheme theme =
        Provider.of<ThemeProvider>(context, listen: false).currentAppTheme;

    final Paint paint = Paint()
      ..color = theme.cAccent // Set to red as requested
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      // ..strokeWidth = 5.0 / transformationController.value.getMaxScaleOnAxis();
      ..strokeWidth = 5.0;

    final Matrix4 matrix = transformationController.value;
    final double scale = matrix.getMaxScaleOnAxis();
    final translation = matrix.getTranslation();
    final double translationX = translation.x;
    final double translationY = translation.y;

    for (var pointPair in startAndEndPoints) {
      pointPair.forEach((start, end) {
        final Offset transformedStart = start + Offset(UiStaticProperties.topLeftToMiddle.dx, UiStaticProperties.topLeftToMiddle.dy);
        final Offset transformedEnd = end + Offset(UiStaticProperties.topLeftToMiddle.dx, UiStaticProperties.topLeftToMiddle.dy);
        canvas.drawLine(transformedStart, transformedEnd, paint);
        print('$translationY, $translationX');
      });
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
