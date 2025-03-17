import 'dart:math';

import 'package:flutter/material.dart';

class DiagonalStripedPatternPainter extends CustomPainter {
  final double stripeWidth;
  final double stripeSpacing;
  final Color stripesColor;

  DiagonalStripedPatternPainter({
    required this.stripeWidth,
    required this.stripeSpacing,
    this.stripesColor = Colors.black,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = stripesColor
      ..style = PaintingStyle.fill;

    double diagonalStep = stripeWidth + stripeSpacing;
    double diagonalLength = sqrt(size.width * size.width + size.height * size.height);
    
    // Start drawing from the top-left corner, extending past the bottom-right corner
    for (double i = -diagonalLength; i < size.width + diagonalLength; i += diagonalStep) {
      Path path = Path();
      path.moveTo(i, 0);
      path.lineTo(i + stripeWidth, 0);
      path.lineTo(i + stripeWidth - size.height, size.height);
      path.lineTo(i - size.height, size.height);
      path.close();
      
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
