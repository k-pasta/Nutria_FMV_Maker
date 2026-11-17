// The "raised" look of buttons and fields in themes with elevation.
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';

/// In themes with elevation, draws a crisp 1px darker edge under [child] (a
/// rounded box with [radius]), so it reads as slightly raised. Painted as
/// one plain rounded rectangle: a `BoxShadow`, even unblurred, takes the
/// much slower shadow path, and there are several controls on every node.
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
          ? _EdgePainter(theme.cShadow, radius)
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
    RRect.fromRectAndRadius(const Offset(0, 1) & size, Radius.circular(radius)),
    Paint()..color = color,
  );

  @override
  bool shouldRepaint(_EdgePainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.radius != radius;
}
