// What every node has: color strip, selection outline, move/resize gestures,
// context menu, settings expansion and knots.
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/core/graph/connection_rules.dart';
import 'package:nutria_fmv_maker/features/canvas/providers/connection_drag_provider.dart';
import 'package:nutria_fmv_maker/features/nodes/node_layout.dart';
import 'package:nutria_fmv_maker/features/nodes/providers/node_gesture_provider.dart';
import 'package:nutria_fmv_maker/features/nodes/widgets/knot.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:nutria_fmv_maker/features/project/providers/graph_editor.dart';
import 'package:nutria_fmv_maker/features/selection/providers/selection_provider.dart';
import 'package:nutria_fmv_maker/features/shell/providers/overlay_provider.dart';
import 'package:nutria_fmv_maker/l10n/generated/app_localizations.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';
import 'package:nutria_fmv_maker/ui/theme/ui_constants.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_context_menu.dart';

/// The node card's color. A selected node is tinted with its own color
/// (the accent for near-black swatches, where a tint wouldn't show) and gets
/// a deeper shadow, instead of an outline.
Color _cardColor(
  AppTheme theme,
  Node node, {
  required bool selected,
  required bool hovered,
}) {
  if (selected) {
    final swatch = theme.cSwatches[node.swatch % theme.cSwatches.length];
    final tint = swatch.computeLuminance() < 0.02 ? theme.cAccent : swatch;
    return Color.alphaBlend(tint.withValues(alpha: 0.14), theme.cCard);
  }
  return hovered ? theme.cCardHovered : theme.cCard;
}

/// Ctrl or Shift: add to / remove from the selection.
bool get _additive =>
    HardwareKeyboard.instance.isControlPressed ||
    HardwareKeyboard.instance.isShiftPressed;

/// The padded box of one node: [body] under the color strip, [expansion]
/// below it while the node is expanded, and the knots on its edges. The
/// padding leaves room for the knots, which stick out of the node.
class NodeFrame extends ConsumerWidget {
  const NodeFrame({
    super.key,
    required this.node,
    required this.body,
    this.expansion,
  });

  final Node node;
  final Widget body;
  final Widget? expansion;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.appTheme;
    final selected = ref.watch(isNodeSelectedProvider(node.id));
    final videoId = node.videoIdOrNull;
    final fileName = videoId == null
        ? null
        : ref.watch(videoAssetProvider(videoId).select((v) => v?.fileName));
    final layout = NodeLayout(
      node,
      NodeMetrics.of(context),
      fileName: fileName,
    );
    final expansion = this.expansion;
    return SizedBox(
      width: node.width + kNodePadding * 2,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.all(kNodePadding),
            // Sees every press on the node, even ones its buttons and text
            // fields handle, so using any part of a node selects it.
            child: Listener(
              onPointerDown: (_) => ref
                  .read(nodeGestureProvider.notifier)
                  .pointerDown(node.id, additive: _additive),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _NodeBody(node: node, selected: selected, child: body),
                  if (expansion != null && node.isExpanded) ...[
                    SizedBox(height: theme.dPanelPadding),
                    _Expansion(
                      node: node,
                      selected: selected,
                      child: expansion,
                    ),
                  ],
                ],
              ),
            ),
          ),
          for (final knot in layout.knots)
            Positioned(
              left: knot.offset.dx - kKnotHitSize / 2,
              top: knot.offset.dy - kKnotHitSize / 2,
              child: Knot(port: knot.port),
            ),
        ],
      ),
    );
  }
}

/// The strip and the main panel. Clicking selects, dragging moves the
/// selection, the edges resize, and right-click opens the node menu.
class _NodeBody extends ConsumerStatefulWidget {
  const _NodeBody({
    required this.node,
    required this.selected,
    required this.child,
  });

  final Node node;
  final bool selected;
  final Widget child;

  @override
  ConsumerState<_NodeBody> createState() => _NodeBodyState();
}

class _NodeBodyState extends ConsumerState<_NodeBody> {
  bool _hovered = false;

  // Read once: the mouse-exit callback can fire while the node is being
  // removed, when `ref` may no longer be used.
  late final NodeGestureNotifier _gestures = ref.read(
    nodeGestureProvider.notifier,
  );
  late final ConnectionDragNotifier _drag = ref.read(
    connectionDragProvider.notifier,
  );

  List<NutriaContextMenuItem> _menu(AppLocalizations t) {
    final node = widget.node;
    final editor = ref.read(graphEditorProvider);
    return [
      if (node is SimpleVideoNode)
        NutriaContextMenuItem(
          icon: Icons.call_split,
          label: t.nodeConvertToBranching,
          onSelected: () => editor.convertNode(node.id),
        ),
      if (node is BranchedVideoNode)
        NutriaContextMenuItem(
          icon: Icons.arrow_forward,
          label: t.nodeConvertToSimple,
          onSelected: () => editor.convertNode(node.id),
        ),
      if (node is! OriginNode)
        NutriaContextMenuItem(
          icon: Icons.delete,
          label: t.editDeleteSelectedNodes,
          onSelected: () => editor.removeNodeOrSelection(node.id),
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final node = widget.node;
    // Library videos dropped on a video node replace its video.
    return DragTarget<String>(
      onWillAcceptWithDetails: (_) => node.isVideoNode,
      onAcceptWithDetails: (details) =>
          _gestures.dropVideo(node.id, details.data),
      builder: (context, candidates, _) =>
          _body(context, candidates.isNotEmpty),
    );
  }

  Widget _body(BuildContext context, bool dropping) {
    final theme = context.appTheme;
    final node = widget.node;
    return NutriaContextMenuArea(
      itemsAt: (_) => _menu(AppLocalizations.of(context)),
      onOpenChanged: ref.read(overlayProvider.notifier).setContextMenuOpen,
      child: MouseRegion(
        onEnter: (_) {
          setState(() => _hovered = true);
          _drag.hover(HoverTarget.node(node.id));
        },
        onExit: (_) {
          if (mounted) setState(() => _hovered = false);
          _drag.hover(const HoverTarget.none());
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _gestures.tap(node.id, additive: _additive),
          onPanStart: (_) => _gestures.beginMove(node.id, additive: _additive),
          // Local deltas are in canvas units: the node is inside the canvas.
          onPanUpdate: (details) => _gestures.updateMove(
            details.delta,
            snap: HardwareKeyboard.instance.isShiftPressed,
          ),
          onPanEnd: (_) => _gestures.end(),
          onPanCancel: _gestures.end,
          child: Stack(
            children: [
              // One rounded card: color strip on top, content below.
              AnimatedContainer(
                duration: kShortAnimation,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(theme.dPanelBorderRadius),
                  color: _cardColor(
                    theme,
                    node,
                    selected: widget.selected,
                    hovered: _hovered || dropping,
                  ),
                  boxShadow: theme.cardShadow(lifted: widget.selected),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _SwatchStrip(node: node),
                    widget.child,
                  ],
                ),
              ),
              _ResizeHandle(nodeId: node.id, fromLeft: true),
              _ResizeHandle(nodeId: node.id, fromLeft: false),
            ],
          ),
        ),
      ),
    );
  }
}

/// The colored top of the node, with its name if it has one.
class _SwatchStrip extends StatelessWidget {
  const _SwatchStrip({required this.node});

  final Node node;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final name = node.name;
    return Container(
      height: NodeMetrics.of(context).stripHeight(node),
      padding: EdgeInsets.symmetric(horizontal: theme.dPanelPadding * 2),
      alignment: Alignment.centerLeft,
      color: theme.cSwatches[node.swatch % theme.cSwatches.length],
      child: name == null
          ? null
          : Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.swatchTextStyle,
            ),
    );
  }
}

/// A grab area on the left or right edge of the node body.
class _ResizeHandle extends ConsumerWidget {
  const _ResizeHandle({required this.nodeId, required this.fromLeft});

  final String nodeId;
  final bool fromLeft;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gestures = ref.read(nodeGestureProvider.notifier);
    return Positioned(
      top: 0,
      bottom: 0,
      left: fromLeft ? 0 : null,
      right: fromLeft ? null : 0,
      width: context.appTheme.dPanelPadding,
      child: MouseRegion(
        cursor: SystemMouseCursors.resizeLeftRight,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragStart: (_) =>
              gestures.beginResize(nodeId, fromLeft: fromLeft),
          onHorizontalDragUpdate: (details) =>
              gestures.updateResize(details.delta.dx),
          onHorizontalDragEnd: (_) => gestures.end(),
          onHorizontalDragCancel: gestures.end,
        ),
      ),
    );
  }
}

/// The settings panel under an expanded node.
class _Expansion extends StatelessWidget {
  const _Expansion({
    required this.node,
    required this.selected,
    required this.child,
  });

  final Node node;
  final bool selected;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    return AnimatedContainer(
      duration: kShortAnimation,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(theme.dPanelBorderRadius),
        color: _cardColor(theme, node, selected: selected, hovered: false),
        boxShadow: theme.cardShadow(lifted: selected),
      ),
      padding: EdgeInsets.all(theme.dPanelPadding),
      child: child,
    );
  }
}
