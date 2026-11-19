// What every node has: color strip, selection outline, move/resize gestures,
// context menu, settings expansion and knots.
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/app/app_commands.dart';
import 'package:nutria_fmv_maker/core/document/media.dart';
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/core/graph/connection_rules.dart';
import 'package:nutria_fmv_maker/core/graph/graph_ops.dart';
import 'package:nutria_fmv_maker/core/graph/ports.dart';
import 'package:nutria_fmv_maker/features/canvas/providers/canvas_view_provider.dart';
import 'package:nutria_fmv_maker/features/canvas/providers/connection_drag_provider.dart';
import 'package:nutria_fmv_maker/features/canvas/widgets/canvas_space.dart';
import 'package:nutria_fmv_maker/features/nodes/node_layout.dart';
import 'package:nutria_fmv_maker/features/nodes/providers/comment_provider.dart';
import 'package:nutria_fmv_maker/features/nodes/providers/node_gesture_provider.dart';
import 'package:nutria_fmv_maker/features/nodes/providers/rename_provider.dart';
import 'package:nutria_fmv_maker/features/nodes/widgets/knot.dart';
import 'package:nutria_fmv_maker/features/nodes/widgets/logic_node_views.dart';
import 'package:nutria_fmv_maker/features/project/providers/clipboard_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:nutria_fmv_maker/features/project/providers/graph_editor.dart';
import 'package:nutria_fmv_maker/features/selection/providers/selection_provider.dart';
import 'package:nutria_fmv_maker/features/shell/providers/overlay_provider.dart';
import 'package:nutria_fmv_maker/l10n/generated/app_localizations.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_context_menu.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_text_field.dart';

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
BoxDecoration _selectionOutline(
  AppTheme theme,
  Node node, {
  required bool selected,
}) => BoxDecoration(
  borderRadius: BorderRadius.circular(theme.dNodeBorderRadius),
  border: selected
      ? Border.all(
          color: theme.swatch(node.swatch),
          width: theme.dSelectionWidth,
          strokeAlign: BorderSide.strokeAlignInside,
        )
      : null,
);

/// The right-click menu of [node], on its body and its settings panel.
List<NutriaContextMenuItem> _nodeMenu(
  WidgetRef ref,
  Node node,
  AppLocalizations t,
) {
  final editor = ref.read(graphEditorProvider);
  final doc = ref.read(projectDocumentProvider);
  final connected = doc.edges.any(
    (e) => e.from.nodeId == node.id || e.to.nodeId == node.id,
  );
  return [
    NutriaContextMenuItem(
      icon: Icons.edit,
      label: t.nodeRename,
      onSelected: () => ref.read(renamingNodeProvider.notifier).start(node.id),
    ),
    if (doc.commentOf(node.id) == null)
      NutriaContextMenuItem(
        icon: Icons.sticky_note_2,
        label: t.nodeAddComment,
        onSelected: () {
          final id = editor.addComment(node.position, attachTo: node.id);
          ref.read(editingCommentProvider.notifier).start(id);
        },
      ),
    if (connected)
      NutriaContextMenuItem(
        icon: Icons.link_off,
        label: t.editDisconnectNodes,
        onSelected: () => editor.disconnectNodeOrSelection(node.id),
      ),
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
    // Right-clicking selected the node, so these act on the selection,
    // which may hold nothing copyable (only the origin).
    if (ref.read(canCopySelectionProvider)) ...[
      NutriaContextMenuItem(
        icon: Icons.content_cut,
        label: t.editCut,
        onSelected: editor.cutSelection,
      ),
      NutriaContextMenuItem(
        icon: Icons.content_copy,
        label: t.editCopy,
        onSelected: editor.copySelection,
      ),
      NutriaContextMenuItem(
        icon: Icons.copy_all,
        label: t.editDuplicate,
        onSelected: editor.duplicateSelection,
      ),
    ],
    if (ref.read(clipboardHasNodesProvider))
      NutriaContextMenuItem(
        icon: Icons.content_paste,
        label: t.editPaste,
        onSelected: () {
          final view = ref.read(canvasViewProvider);
          editor.paste(view.pointer ?? view.center);
        },
      ),
    if (node is! OriginNode)
      NutriaContextMenuItem(
        icon: Icons.delete,
        label: t.editDeleteSelectedNodes,
        onSelected: () => editor.removeNodeOrSelection(node.id),
      ),
  ];
}

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
        : ref.watch(mediaAssetProvider(videoId).select((v) => v?.fileName));
    final layout = NodeLayout(
      node,
      NodeMetrics.of(context),
      fileName: fileName,
      showsQuestion:
          node is BranchedVideoNode &&
          ref.watch(
            effectiveSettingsProvider(node.id).select((s) => s.showQuestion),
          ),
    );
    final expansion = widget.expansion;
    // Also when a dragged comment would be attached to it.
    final lit =
        _hovered ||
        selected ||
        ref.watch(commentDropTargetProvider.select((id) => id == node.id));
    return SizedBox(
      width: node.width + kNodePadding * 2,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.all(kNodePadding),
            // Sees every press on the node, even ones its buttons and text
            // fields handle, so using any part of a node selects it.
            // The middle button pans the canvas; it doesn't select.
            child: Listener(
              onPointerDown: (event) {
                if (event.buttons & kMiddleMouseButton != 0) return;
                ref
                    .read(nodeGestureProvider.notifier)
                    .pointerDown(node.id, additive: _additive);
              },
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

  @override
  Widget build(BuildContext context) {
    final node = widget.node;
    // Library videos dropped on a video node replace its video.
    // Subtitle files dropped on one are linked to its video.
    return DragTarget<MediaAsset>(
      // Audio becomes menu music on the origin and a video's music; on a
      // branched node a menu asks whether it's pause music instead.
      onWillAcceptWithDetails: (details) => switch (details.data.kind) {
        MediaKind.video => node.isVideoNode,
        MediaKind.subtitle => node.videoIdOrNull != null,
        MediaKind.audio => node is OriginNode || node.isVideoNode,
        _ => false,
      },
      onAcceptWithDetails: (details) => _drop(node, details),
      builder: (context, candidates, _) =>
          _body(context, candidates.isNotEmpty),
    );
  }

  void _drop(Node node, DragTargetDetails<MediaAsset> details) {
    final asset = details.data;
    final editor = ref.read(graphEditorProvider);
    switch (asset.kind) {
      case MediaKind.video:
        _gestures.dropVideo(node.id, asset.id);
      case MediaKind.subtitle:
        AppCommands(
          context,
          ref,
        ).linkSubtitle(node.videoIdOrNull!, asset.id, at: details.offset);
      case MediaKind.audio when node is OriginNode:
        editor.setMenuMusic(asset.id);
      case MediaKind.audio when node is BranchedVideoNode:
        final t = AppLocalizations.of(context);
        showNutriaMenu(
          context,
          details.offset,
          [
            NutriaContextMenuItem(
              icon: Icons.music_note,
              label: t.musicDropAsMusic,
              onSelected: () => editor.setMusic(node.id, asset.id),
            ),
            NutriaContextMenuItem(
              icon: Icons.hourglass_bottom,
              label: t.musicDropAsPause,
              onSelected: () => editor.setPauseMusic(node.id, asset.id),
            ),
          ],
          onOpenChanged: ref.read(overlayProvider.notifier).setContextMenuOpen,
        );
      case MediaKind.audio:
        editor.setMusic(node.id, asset.id);
      case MediaKind.image || MediaKind.font:
        break;
    }
  }

  Widget _body(BuildContext context, bool dropping) {
    final theme = context.appTheme;
    final node = widget.node;
    return NutriaContextMenuArea(
      itemsAt: (_) => _nodeMenu(ref, widget.node, AppLocalizations.of(context)),
      onOpenChanged: ref.read(overlayProvider.notifier).setContextMenuOpen,
      // Tells noodle drags which node they're over (lazy connections).
      child: MouseRegion(
        onEnter: (_) => _drag.hover(HoverTarget.node(node.id)),
        onExit: (_) => _drag.hover(const HoverTarget.none()),
        child: _MoveArea(
          node: node,
          child: Stack(
            children: [
              // One rounded card: color strip on top, content below.
              Container(
                decoration: _card(theme, lit: widget.lit || dropping),
                foregroundDecoration: _selectionOutline(
                  theme,
                  node,
                  selected: widget.selected,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _SwatchStrip(node: node),
                    widget.child,
                  ],
                ),
              ),
              NodeResizeHandle(nodeId: node.id, fromLeft: true),
              NodeResizeHandle(nodeId: node.id, fromLeft: false),
            ],
          ),
        ),
      ),
    );
  }
}

/// The colored top of the node, with its name if it has one.
class _SwatchStrip extends ConsumerWidget {
  const _SwatchStrip({required this.node});

  final Node node;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.appTheme;
    final renaming = ref.watch(
      renamingNodeProvider.select((id) => id == node.id),
    );
    final rename = ref.read(renamingNodeProvider.notifier);
    // The origin always shows a name: its own, or "Origin Node".
    final t = AppLocalizations.of(context);
    final name =
        node.name ??
        (node is OriginNode
            ? t.nodeOriginDefaultName
            : node.isLogicNode
            ? logicNodeTitle(node, t)
            : null);
    final radius = Radius.circular(theme.dNodeBorderRadius);
    final Widget? label = renaming
        ? NutriaTextField(
            text: node.name ?? '',
            hint: node is OriginNode
                ? AppLocalizations.of(context).nodeOriginDefaultName
                : AppLocalizations.of(context).nodeRenameHint,
            bareStyle: theme.swatchTextStyle,
            autofocus: true,
            onChanged: rename.update,
            onSubmitted: (_) => rename.commit(),
            onEscape: rename.cancel,
            onFocusChanged: (focused) {
              if (!focused) rename.commit();
            },
          )
        : name == null
        ? null
        : Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.swatchTextStyle,
          );
    // Double-clicking the strip renames the node.
    return GestureDetector(
      onDoubleTap: () => rename.start(node.id),
      child: Container(
        height: NodeMetrics.of(context).stripHeight(node),
        padding: EdgeInsets.symmetric(horizontal: theme.dPanelPadding * 2),
        alignment: Alignment.centerLeft,
        // Rounded itself rather than clipped by the card: clipping every node
        // costs more to draw.
        decoration: BoxDecoration(
          color: theme.swatch(node.swatch),
          borderRadius: BorderRadius.only(topLeft: radius, topRight: radius),
        ),
        child: node.isLogicNode
            ? Row(
                children: [
                  Expanded(child: label ?? const SizedBox.shrink()),
                  LogicIssueMark(node: node),
                ],
              )
            : label,
      ),
    );
  }
}

/// A grab area on the left or right edge of a node (or comment) that
/// resizes the node.
class NodeResizeHandle extends ConsumerWidget {
  const NodeResizeHandle({
    super.key,
    required this.nodeId,
    required this.fromLeft,
  });

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
class _Expansion extends ConsumerWidget {
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

  /// Like the body: right-click for the node menu, edges to resize. Rows
  /// with their own right-click menu (setting values) take precedence.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.appTheme;
    return NutriaContextMenuArea(
      itemsAt: (_) => _nodeMenu(ref, node, AppLocalizations.of(context)),
      onOpenChanged: ref.read(overlayProvider.notifier).setContextMenuOpen,
      child: _MoveArea(
        node: node,
        child: Stack(
          children: [
            Container(
              decoration: _card(theme, lit: lit),
              foregroundDecoration: _selectionOutline(
                theme,
                node,
                selected: selected,
              ),
              padding: EdgeInsets.all(theme.dPanelPadding),
              child: child,
            ),
            NodeResizeHandle(nodeId: node.id, fromLeft: true),
            NodeResizeHandle(nodeId: node.id, fromLeft: false),
          ],
        ),
      ),
    );
  }
}

/// The part of a node (body or expansion) that a click selects and a drag
/// moves; Alt+drag pulls a noodle instead. Controls inside that handle
/// their own drags (number fields) win over it.
class _MoveArea extends ConsumerStatefulWidget {
  const _MoveArea({required this.node, required this.child});

  final Node node;
  final Widget child;

  @override
  ConsumerState<_MoveArea> createState() => _MoveAreaState();
}

class _MoveAreaState extends ConsumerState<_MoveArea> {
  late final NodeGestureNotifier _gestures = ref.read(
    nodeGestureProvider.notifier,
  );
  late final ConnectionDragNotifier _drag = ref.read(
    connectionDragProvider.notifier,
  );

  /// Whether this drag pulls a noodle (Alt) rather than moving the node.
  bool _pullingNoodle = false;

  /// Alt+drag starts dragging the node's first free output (see
  /// [firstFreeOutput]); a plain drag moves the node.
  void _beginDrag(Node node, DragStartDetails details) {
    if (HardwareKeyboard.instance.isAltPressed) {
      final doc = ref.read(projectDocumentProvider);
      final port = firstFreeOutput(node, (p) => doc.edgeFrom(p) != null);
      if (port != null) {
        _pullingNoodle = true;
        final pointer =
            CanvasSpace.maybeOf(context)?.fromGlobal(details.globalPosition) ??
            Offset.zero;
        _drag.beginFromOutput(port, pointer);
        return;
      }
    }
    _pullingNoodle = false;
    _gestures.beginMove(node.id, additive: _additive);
  }

  void _endDrag() {
    if (_pullingNoodle) {
      _pullingNoodle = false;
      _drag.end();
    } else {
      _gestures.end();
    }
  }

  @override
  Widget build(BuildContext context) {
    final node = widget.node;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _gestures.tap(node.id, additive: _additive),
      onPanStart: (details) => _beginDrag(node, details),
      // Local deltas are in canvas units: the node is inside the canvas.
      onPanUpdate: (details) => _pullingNoodle
          ? _drag.updatePointer(details.delta)
          : _gestures.updateMove(
              details.delta,
              snap: HardwareKeyboard.instance.isShiftPressed,
            ),
      onPanEnd: (_) => _endDrag(),
      onPanCancel: _endDrag,
      child: widget.child,
    );
  }
}
