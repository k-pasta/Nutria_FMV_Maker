import 'package:flutter/material.dart';
import 'package:nutria_fmv_maker/models/noodle_data.dart';
import 'package:nutria_fmv_maker/static_data/ui_static_properties.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import 'models/app_theme.dart';

class NoodlePainter extends CustomPainter {
  final TransformationController transformationController;
  final BuildContext context;
  final List<NoodleData> noodles;

  const NoodlePainter({
    required this.transformationController,
    required this.context,
    required this.noodles,
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
      ..strokeWidth = UiStaticProperties.noodleWidth;

    final Matrix4 matrix = transformationController.value;
    final double scale = matrix.getMaxScaleOnAxis();
    final translation = matrix.getTranslation();
    final double translationX = translation.x;
    final double translationY = translation.y;

    for (var noodle in noodles) {
      Offset start = noodle.startPosition + UiStaticProperties.topLeftToMiddle;
      Offset end = noodle.endPosition + UiStaticProperties.topLeftToMiddle;

      // If start is locked, draw the initial horizontal segment and move the start position
      if (noodle.startLocked) {
        Offset firstSegmentEnd =
            start + const Offset(UiStaticProperties.noodleConnectedSpacing, 0);
        canvas.drawLine(start, firstSegmentEnd, paint);
        start = firstSegmentEnd;
      }

      // If end is locked, draw the final horizontal segment and move the end position
      if (noodle.endLocked) {
        Offset secondSegmentStart =
            end - const Offset(UiStaticProperties.noodleConnectedSpacing, 0);
        canvas.drawLine(secondSegmentStart, end, paint);
        end = secondSegmentStart;
      }

      // Draw the main connecting segment
      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
