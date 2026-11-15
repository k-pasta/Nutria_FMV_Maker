// Fills an area with diagonal stripes (used for "no video" placeholders).
import 'dart:math';

import 'package:material_ui/material_ui.dart';

class DiagonalStripesPainter extends CustomPainter {
  const DiagonalStripesPainter({
    required this.stripeWidth,
    required this.stripeSpacing,
    required this.color,
  });

  final double stripeWidth;
  final double stripeSpacing;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final step = stripeWidth + stripeSpacing;
    final diagonal = sqrt(size.width * size.width + size.height * size.height);
    for (var x = -diagonal; x < size.width + diagonal; x += step) {
      canvas.drawPath(
        Path()
          ..moveTo(x, 0)
          ..lineTo(x + stripeWidth, 0)
          ..lineTo(x + stripeWidth - size.height, size.height)
          ..lineTo(x - size.height, size.height)
          ..close(),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(DiagonalStripesPainter oldDelegate) =>
      oldDelegate.stripeWidth != stripeWidth ||
      oldDelegate.stripeSpacing != stripeSpacing ||
      oldDelegate.color != color;
}
