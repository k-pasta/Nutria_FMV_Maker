// The connection lines under the nodes.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/features/canvas/noodles.dart';
import 'package:nutria_fmv_maker/features/canvas/providers/canvas_view_provider.dart';
import 'package:nutria_fmv_maker/features/canvas/providers/connection_drag_provider.dart';
import 'package:nutria_fmv_maker/features/nodes/node_layout.dart';
import 'package:nutria_fmv_maker/features/preferences/providers/preferences_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:nutria_fmv_maker/ui/painters/noodle_painter.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';

/// Repaints when the document or the dragged noodle changes. Never hit:
/// clicks go to the canvas and nodes.
class NoodleLayer extends ConsumerWidget {
  const NoodleLayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.appTheme;
    final style = ref.watch(preferencesProvider.select((p) => p.noodleStyle));
    // Only the dragged noodle matters here, not what the pointer hovers:
    // hovering changes nothing that is drawn.
    final drag = ref.watch(connectionDragProvider.select(
        (s) => s.anchor == null ? null : (s.anchor!, s.pointer)));
    final noodles = noodlesFor(
      ref.watch(projectDocumentProvider),
      NodeMetrics.of(context),
      drag == null
          ? const CanvasInteraction()
          : CanvasInteraction(anchor: drag.$1, pointer: drag.$2),
      ref.watch(potentialConnectionProvider),
    );
    return Positioned.fill(
      child: IgnorePointer(
        // Repaints on its own, without the nodes above it.
        child: RepaintBoundary(child: CustomPaint(
          painter: NoodlePainter(
            noodles: noodles,
            swatches: theme.cSwatches,
            curved: style == NoodleStyle.curved,
            origin: kCanvasCenter,
          ),
        )),
      ),
    );
  }
}
