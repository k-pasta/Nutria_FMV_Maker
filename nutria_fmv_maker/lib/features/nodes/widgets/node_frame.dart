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
import 'package:nutria_fmv_maker/ui/widgets/nutria_context_menu.dart';

/// A node card. [lit] (hovered or selected) shows the lighter card color.
/// Themes with elevation give it a constant soft shadow; it never changes
/// with selection, so nothing animates or jumps.
///
/// Selection is shown by an outline in the node's color, drawn inside the
/// card over its content: it lines up with the color strip, never changes
/// the layout and never sticks out of the node at any zoom.
BoxDecoration _card(AppTheme theme, {required bool lit}) => BoxDecoration(
      color: lit ? theme.cCardHovered : theme.cCard,
      borderRadius: BorderRadius.circular(theme.dNodeBorderRadius),
      boxShadow: theme.dElevation > 0 ? theme.cardShadow() : null,
    );

/// Never `null`, even when not [selected]: a `Container` only inserts its
/// foreground layer when it has one, and that change of tree shape would
/// recreate the node's content (dropping text-field focus) on selection.
BoxDecoration _selectionOutline(AppTheme theme, Node node,
        {required bool selected}) =>
    BoxDecoration(
      borderRadius: BorderRadius.circular(theme.dNodeBorderRadius),
      border: selected
          ? Border.all(
              color: theme.swatch(node.swatch),
              width: theme.dSelectionWidth,
              strokeAlign: BorderSide.strokeAlignInside,
            )
          : null,
    );

/// Ctrl or Shift: add to / remove from the selection.
bool get _additive =>
    HardwareKeyboard.instance.isControlPressed ||
    HardwareKeyboard.instance.isShiftPressed;

/// The padded box of one node: [body] under the color strip, [expansion]
/// below it while the node is expanded, and the knots on its edges. The
/// padding leaves room for the knots, which stick out of the node.
class NodeFrame extends ConsumerStatefulWidget {
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
  ConsumerState<NodeFrame> createState() => _NodeFrameState();
}

class _NodeFrameState extends ConsumerState<NodeFrame> {
  /// Over any part of the node, body or expansion: the whole node lights.
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final node = widget.node;
    final body = widget.body;
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
    final expansion = widget.expansion;
    final lit = _hovered || selected;
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
              child: MouseRegion(
                onEnter: (_) => setState(() => _hovered = true),
                onExit: (_) {
                  if (mounted) setState(() => _hovered = false);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _NodeBody(
                      node: node,
                      selected: selected,
                      lit: lit,
                      child: body,
                    ),
                    if (expansion != null && node.isExpanded) ...[
                      SizedBox(height: theme.dPanelPadding),
                      _Expansion(
                        node: node,
                        selected: selected,
                        lit: lit,
                        child: expansion,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          for (final knot in layout.knots)
            Positioned(
              left: knot.offset.dx - kKnotHitSize / 2,
              top: knot.offset.dy - kKnotHitSize / 2,
              child: Knot(port: knot.port, color: theme.swatch(node.swatch)),
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
    required this.lit,
    required this.child,
  });

  final Node node;
  final bool selected;
  final bool lit;
  final Widget child;

  @override
  ConsumerState<_NodeBody> createState() => _NodeBodyState();
}

class _NodeBodyState extends ConsumerState<_NodeBody> {
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
      // Tells noodle drags which node they're over (lazy connections).
      child: MouseRegion(
        onEnter: (_) => _drag.hover(HoverTarget.node(node.id)),
        onExit: (_) => _drag.hover(const HoverTarget.none()),
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
              Container(
                decoration: _card(theme, lit: widget.lit || dropping),
                foregroundDecoration:
                    _selectionOutline(theme, node, selected: widget.selected),
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
    final radius = Radius.circular(theme.dNodeBorderRadius);
    return Container(
      height: NodeMetrics.of(context).stripHeight(node),
      padding: EdgeInsets.symmetric(horizontal: theme.dPanelPadding * 2),
      alignment: Alignment.centerLeft,
      // Rounded itself rather than clipped by the card: clipping every node
      // costs more to draw.
      decoration: BoxDecoration(
        color: theme.swatch(node.swatch),
        borderRadius: BorderRadius.only(topLeft: radius, topRight: radius),
      ),
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
    required this.lit,
    required this.child,
  });

  final Node node;
  final bool selected;
  final bool lit;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    return Container(
      decoration: _card(theme, lit: lit),
      foregroundDecoration: _selectionOutline(theme, node, selected: selected),
      padding: EdgeInsets.all(theme.dPanelPadding),
      child: child,
    );
  }
}
