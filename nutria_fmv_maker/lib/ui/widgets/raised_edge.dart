// The outline of buttons and fields in themes with elevation.
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';

/// In themes with elevation, draws a thin outline around [child] (a rounded
/// box with [radius]), so light controls stand out from light surfaces.
/// Painted as one plain rounded rectangle behind the child, 1px larger on
/// every side: a stroke or a `BoxShadow` takes slower paths, and there are
/// several controls on every node.
class RaisedEdge extends StatelessWidget {
  const RaisedEdge({
    super.key,
    required this.radius,
    required this.child,
    this.enabled = true,
  });

  final double radius;
  final Widget child;

  /// Off for controls that draw no box (e.g. inactive buttons).
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    return CustomPaint(
      painter: enabled && theme.dElevation > 0
          ? _EdgePainter(theme.cControlOutline, radius)
          : null,
      child: child,
    );
  }
}

class _EdgePainter extends CustomPainter {
  const _EdgePainter(this.color, this.radius);

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) => canvas.drawRRect(
    RRect.fromRectAndRadius(
      (Offset.zero & size).inflate(1),
      Radius.circular(radius + 1),
    ),
    Paint()..color = color,
  );

  @override
  bool shouldRepaint(_EdgePainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.radius != radius;
}
