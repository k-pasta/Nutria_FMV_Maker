// Draws the selection box above the nodes.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/features/canvas/providers/canvas_view_provider.dart';
import 'package:nutria_fmv_maker/features/canvas/providers/marquee_provider.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';

/// The selection box being dragged (see `marqueeProvider`), above the
/// nodes.
class MarqueeLayer extends ConsumerWidget {
  const MarqueeLayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final box = ref.watch(marqueeProvider);
    if (box == null) return const SizedBox.shrink();
    return Positioned.fromRect(
      rect: box.shift(kCanvasCenter),
      child: IgnorePointer(
        child: CustomPaint(painter: _BoxPainter(context.appTheme.cAccent)),
      ),
    );
  }
}

class _BoxPainter extends CustomPainter {
  const _BoxPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas
      ..drawRect(rect, Paint()..color = color.withValues(alpha: 0.12))
      // Width 0: one physical pixel at any zoom.
      ..drawRect(
          rect,
          Paint()
            ..color = color
            ..style = PaintingStyle.stroke
            ..strokeWidth = 0);
  }

  @override
  bool shouldRepaint(_BoxPainter oldDelegate) => oldDelegate.color != color;
}
