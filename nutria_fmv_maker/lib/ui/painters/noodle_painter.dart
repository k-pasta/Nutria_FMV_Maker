// Draws connection lines ("noodles") as curves from outputs to inputs.
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

/// One line from an output knot ([start]) to an input knot ([end]). An end
/// that isn't on a knot (it follows the pointer) is "unlocked".
///
/// The line fades from the color of the node it leaves ([startSwatch]) to
/// the color of the node it enters ([endSwatch]); both are node color
/// indexes, resolved by the painter's theme colors.
@immutable
class Noodle {
  const Noodle(
    this.start,
    this.end, {
    this.startLocked = true,
    this.endLocked = true,
    this.startSwatch = 0,
    this.endSwatch = 0,
  });

  final Offset start;
  final Offset end;
  final bool startLocked;
  final bool endLocked;
  final int startSwatch;
  final int endSwatch;

  @override
  bool operator ==(Object other) =>
      other is Noodle &&
      other.start == start &&
      other.end == end &&
      other.startLocked == startLocked &&
      other.endLocked == endLocked &&
      other.startSwatch == startSwatch &&
      other.endSwatch == endSwatch;

  @override
  int get hashCode => Object.hash(
      start, end, startLocked, endLocked, startSwatch, endSwatch);
}

/// Length of the horizontal piece at a knot, for straight noodles.
const kNoodleStubLength = 25.0;

/// Paints [noodles], shifted by [origin] (where (0, 0) is on the canvas).
/// Each noodle leaves its output to the right and enters its input from the
/// left, like the knots face.
class NoodlePainter extends CustomPainter {
  const NoodlePainter({
    required this.noodles,
    required this.swatches,
    this.curved = false,
    this.origin = Offset.zero,
    this.width = 5,
  });

  final List<Noodle> noodles;

  /// The theme's node colors; noodle swatch indexes wrap around them.
  final List<Color> swatches;

  /// Smooth curves; otherwise straight lines with a short horizontal piece
  /// at each locked end.
  final bool curved;
  final Offset origin;
  final double width;

  /// The line of [noodle], for painting and tests.
  static Path pathOf(Noodle noodle,
      {bool curved = false, Offset origin = Offset.zero}) {
    final start = noodle.start + origin;
    final end = noodle.end + origin;
    if (!curved) {
      const stub = Offset(kNoodleStubLength, 0);
      final path = Path()..moveTo(start.dx, start.dy);
      final from = noodle.startLocked ? start + stub : start;
      final to = noodle.endLocked ? end - stub : end;
      if (noodle.startLocked) path.lineTo(from.dx, from.dy);
      path.lineTo(to.dx, to.dy);
      if (noodle.endLocked) path.lineTo(end.dx, end.dy);
      return path;
    }
    // Longer handles for longer or backwards connections, so they loop
    // around instead of cutting through the nodes.
    final handle = math.max(50.0, (end.dx - start.dx).abs() / 2);
    return Path()
      ..moveTo(start.dx, start.dy)
      ..cubicTo(start.dx + handle, start.dy, end.dx - handle, end.dy, end.dx,
          end.dy);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = width;
    Color colorOf(int swatch) => swatches[swatch % swatches.length];
    for (final noodle in noodles) {
      final from = colorOf(noodle.startSwatch);
      final to = colorOf(noodle.endSwatch);
      if (from == to) {
        paint
          ..shader = null
          ..color = from;
      } else {
        paint.shader = ui.Gradient.linear(
            noodle.start + origin, noodle.end + origin, [from, to]);
      }
      canvas.drawPath(pathOf(noodle, curved: curved, origin: origin), paint);
    }
  }

  @override
  bool shouldRepaint(NoodlePainter oldDelegate) =>
      !_colorsEqual(oldDelegate.swatches, swatches) ||
      oldDelegate.curved != curved ||
      oldDelegate.origin != origin ||
      oldDelegate.width != width ||
      !_listEquals(oldDelegate.noodles, noodles);

  static bool _colorsEqual(List<Color> a, List<Color> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  static bool _listEquals(List<Noodle> a, List<Noodle> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
