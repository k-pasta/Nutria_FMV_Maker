// The node canvas: dot grid, pan/zoom, and the surface nodes are placed on.
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/core/document/position.dart';
import 'package:nutria_fmv_maker/features/canvas/providers/canvas_view_provider.dart';
import 'package:nutria_fmv_maker/features/canvas/widgets/canvas_space.dart';
import 'package:nutria_fmv_maker/features/nodes/node_layout.dart';
import 'package:nutria_fmv_maker/features/nodes/providers/node_gesture_provider.dart';
import 'package:nutria_fmv_maker/features/preferences/providers/preferences_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/graph_editor.dart';
import 'package:nutria_fmv_maker/features/selection/providers/selection_provider.dart';
import 'package:nutria_fmv_maker/features/shell/providers/overlay_provider.dart';
import 'package:nutria_fmv_maker/l10n/generated/app_localizations.dart';
import 'package:nutria_fmv_maker/ui/painters/dot_grid_painter.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_context_menu.dart';

/// The whole editing surface. Scrolling zooms around the mouse; dragging
/// empty space pans. Children of [CanvasSpace] are laid out in canvas
/// coordinates, where (0, 0) is the middle of the canvas.
class CanvasView extends ConsumerWidget {
  const CanvasView({super.key, this.layers = const []});

  /// Drawn above the background, in canvas coordinates (offset by
  /// [kCanvasCenter]): noodles, then nodes.
  final List<Widget> layers;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(canvasViewProvider);
    final theme = context.appTheme;
    final gridSize = ref
        .watch(preferencesProvider.select((p) => p.gridSize))
        .toDouble();
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        if (size != controller.viewportSize) {
          // After layout: moving the view rebuilds the InteractiveViewer.
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => controller.setViewportSize(size),
          );
        }
        return Listener(
          onPointerSignal: (event) {
            if (event is PointerScrollEvent && event.scrollDelta.dy != 0) {
              controller.zoomAt(
                event.localPosition,
                zoomIn: event.scrollDelta.dy < 0,
              );
            }
          },
          child: Stack(
            children: [
              Positioned.fill(
                child: IgnorePointer(
                  // Repaints only when the view moves, not with the nodes.
                  child: RepaintBoundary(
                    child: ColoredBox(
                      color: theme.cBackground,
                      child: CustomPaint(
                        painter: DotGridPainter(
                          transform: controller,
                          origin: kCanvasCenter,
                          spacing: gridSize,
                          color: theme.cBackgroundDots,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: InteractiveViewer(
                  transformationController: controller,
                  // Zoom is handled above, one step per scroll notch.
                  scaleEnabled: false,
                  // Pans stop when the mouse is released.
                  interactionEndFrictionCoefficient: double.minPositive,
                  boundaryMargin: const EdgeInsets.all(double.infinity),
                  clipBehavior: Clip.none,
                  constrained: false,
                  child: SizedBox.square(
                    dimension: kCanvasSize,
                    child: CanvasSpace(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const Positioned.fill(child: _EmptyCanvasArea()),
                          ...layers,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// The canvas behind the nodes: a click clears the selection, a right-click
/// offers new nodes, and library videos can be dropped on it.
class _EmptyCanvasArea extends ConsumerWidget {
  const _EmptyCanvasArea();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editor = ref.read(graphEditorProvider);

    // A dropped library video becomes a node with its thumbnail under the
    // pointer.
    void dropVideo(DragTargetDetails<String> details) {
      final point = CanvasSpace.maybeOf(context)?.fromGlobal(details.offset);
      if (point == null) return;
      final metrics = NodeMetrics.of(context);
      editor.addVideoNode(
        Position(
          point.dx - kNodePadding - kDefaultNodeWidth / 2,
          point.dy - kNodePadding - metrics.thumbnailHeight / 2,
        ),
        videoId: details.data,
      );
    }

    return DragTarget<String>(
      onAcceptWithDetails: dropVideo,
      builder: (context, _, _) => _contextMenu(context, ref),
    );
  }

  Widget _contextMenu(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final editor = ref.read(graphEditorProvider);

    // A new node's visible corner goes where the user clicked.
    Position nodePositionAt(Offset canvasPoint) {
      final p = canvasPoint - kCanvasCenter;
      return Position(p.dx - kNodePadding, p.dy - kNodePadding);
    }

    return NutriaContextMenuArea(
      onTap: ref.read(selectionProvider.notifier).clear,
      onOpenChanged: ref.read(overlayProvider.notifier).setContextMenuOpen,
      itemsAt: (local) => [
        NutriaContextMenuItem(
          icon: Icons.videocam,
          label: t.contextSimpleVideoNode,
          onSelected: () => editor.addVideoNode(
            nodePositionAt(local),
            type: DefaultNodeType.simpleVideo,
          ),
        ),
        NutriaContextMenuItem(
          icon: Icons.video_call,
          label: t.contextBranchingVideoNode,
          onSelected: () => editor.addVideoNode(
            nodePositionAt(local),
            type: DefaultNodeType.branchedVideo,
          ),
        ),
      ],
      // Empty space paints nothing, so it has to catch clicks explicitly.
      behavior: HitTestBehavior.opaque,
      child: const SizedBox.expand(),
    );
  }
}
