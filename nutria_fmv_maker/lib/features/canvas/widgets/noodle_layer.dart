// The connection lines under the nodes.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/features/canvas/noodles.dart';
import 'package:nutria_fmv_maker/features/canvas/providers/canvas_view_provider.dart';
import 'package:nutria_fmv_maker/features/canvas/providers/connection_drag_provider.dart';
import 'package:nutria_fmv_maker/features/nodes/node_layout.dart';
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
    final noodles = noodlesFor(
      ref.watch(projectDocumentProvider),
      NodeMetrics.of(theme),
      ref.watch(connectionDragProvider),
      ref.watch(potentialConnectionProvider),
    );
    return Positioned.fill(
      child: IgnorePointer(
        child: CustomPaint(
          painter: NoodlePainter(
              noodles: noodles, color: theme.cAccent, origin: kCanvasCenter),
        ),
      ),
    );
  }
}
