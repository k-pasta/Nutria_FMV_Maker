// The canvas background dots, drawn in screen space for the current view.
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

/// Paints a dot grid that follows a pan/zoom [transform].
///
/// Dots sit on multiples of [spacing] around [origin] (both in scene units).
/// When zooming, the spacing is multiplied or divided by 4 so that the dots
/// on screen always stay between [minScreenSpacing] and 4x that apart.
/// Only the visible dots are drawn, and the painter repaints whenever
/// [transform] changes, without rebuilding any widget.
class DotGridPainter extends CustomPainter {
  DotGridPainter({
    required this.transform,
    required this.origin,
    required this.spacing,
    required this.color,
    this.dotSize = 4,
    this.minScreenSpacing = 20,
  }) : super(repaint: transform);

  final ValueListenable<Matrix4> transform;

  /// The scene point that is always on a dot (the canvas center).
  final Offset origin;
  final double spacing;
  final Color color;

  /// Dot diameter in screen pixels, at every zoom level.
  final double dotSize;
  final double minScreenSpacing;

  @override
  void paint(Canvas canvas, Size size) {
    final matrix = transform.value;
    // x scale; the view is never rotated, and z is never scaled.
    final scale = matrix.storage[0];
    if (scale <= 0 || spacing <= 0) return;

    // The grid step in scene units: spacing * 4^k, with the smallest k that
    // keeps the dots at least minScreenSpacing apart on screen.
    final k = (math.log(minScreenSpacing / (spacing * scale)) / math.log(4))
        .ceil();
    final step = spacing * math.pow(4, k);
    final screenStep = step * scale;

    // Screen position of the origin, then of the first dot left/above it.
    final translation = matrix.getTranslation();
    final originOnScreen = Offset(
      origin.dx * scale + translation.x,
      origin.dy * scale + translation.y,
    );
    final startX = originOnScreen.dx % screenStep;
    final startY = originOnScreen.dy % screenStep;

    final points = <Offset>[
      for (var x = startX; x <= size.width; x += screenStep)
        for (var y = startY; y <= size.height; y += screenStep) Offset(x, y),
    ];
    canvas.drawPoints(
      PointMode.points,
      points,
      Paint()
        ..color = color
        ..strokeCap = StrokeCap.round
        ..strokeWidth = dotSize,
    );
  }

  @override
  bool shouldRepaint(DotGridPainter oldDelegate) =>
      oldDelegate.transform != transform ||
      oldDelegate.origin != origin ||
      oldDelegate.spacing != spacing ||
      oldDelegate.color != color ||
      oldDelegate.dotSize != dotSize ||
      oldDelegate.minScreenSpacing != minScreenSpacing;
}
