import 'package:flutter/material.dart';

class NoodlePainter extends CustomPainter {
  final Offset start;
  final Offset end;

  NoodlePainter({required this.start, required this.end});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 4;

    canvas.drawLine(start, end, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Always repaint when the noodle is being dragged
  }
}