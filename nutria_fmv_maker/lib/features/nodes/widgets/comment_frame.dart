// A comment on the canvas: a card of formatted text, edited in place.
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/features/nodes/providers/comment_provider.dart';
import 'package:nutria_fmv_maker/features/nodes/providers/node_gesture_provider.dart';
import 'package:nutria_fmv_maker/features/nodes/widgets/node_frame.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:nutria_fmv_maker/features/project/providers/graph_editor.dart';
import 'package:nutria_fmv_maker/features/selection/providers/selection_provider.dart';
import 'package:nutria_fmv_maker/features/shell/providers/overlay_provider.dart';
import 'package:nutria_fmv_maker/l10n/generated/app_localizations.dart';
import 'package:nutria_fmv_maker/ui/text/markdown_text.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_context_menu.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_text_field.dart';

/// Ctrl or Shift: add to / remove from the selection.
bool get _additive =>
    HardwareKeyboard.instance.isControlPressed ||
    HardwareKeyboard.instance.isShiftPressed;

/// A comment, in the node card's color, with no strip and no knots.
///
/// It shows its text with bold and italic; a double-click (or F2) edits it.
/// Like a node, a click selects it, a drag moves it and its edges resize
/// it. An attached comment (see [CommentNode.attachedTo]) has no padding
/// above or below, takes its node's width, and its edges resize the node.
class CommentFrame extends ConsumerStatefulWidget {
  const CommentFrame({super.key, required this.node});

  final CommentNode node;

  @override
  ConsumerState<CommentFrame> createState() => _CommentFrameState();
}

class _CommentFrameState extends ConsumerState<CommentFrame> {
  bool _hovered = false;

  /// One undo step per editing session.
  Object _editSession = Object();

  late final NodeGestureNotifier _gestures = ref.read(
    nodeGestureProvider.notifier,
  );

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final t = AppLocalizations.of(context);
    final node = widget.node;
    final hostId = node.attachedTo;
    final hostWidth = hostId == null
        ? null
        : ref.watch(nodeProvider(hostId).select((n) => n?.width));
    final selected = ref.watch(isNodeSelectedProvider(node.id));
    final editing = ref.watch(
      editingCommentProvider.select((id) => id == node.id),
    );
    final editor = ref.read(graphEditorProvider);
    final textStyle = TextStyle(
      color: theme.cText,
      fontSize: theme.dTextHeight,
    );
    final radius = BorderRadius.circular(theme.dNodeBorderRadius);
    // Resizing an attached comment resizes its node, which it follows.
    final resized = hostId ?? node.id;

    final content = editing
        ? NutriaTextField(
            text: node.text,
            hint: t.commentHint,
            markdown: true,
            maxLines: null,
            bareStyle: textStyle,
            autofocus: true,
            onChanged: (text) =>
                editor.setCommentText(node.id, text, mergeKey: _editSession),
            onEscape: _stopEditing,
            onFocusChanged: (focused) {
              if (!focused) _stopEditing();
            },
          )
        : Text.rich(
            node.text.isEmpty
                ? TextSpan(
                    text: t.commentHint,
                    style: textStyle.copyWith(color: theme.cTextInactive),
                  )
                : markdownSpan(node.text, textStyle),
          );

    final card = Container(
      padding: EdgeInsets.all(theme.dTextfieldPadding),
      decoration: BoxDecoration(
        color: _hovered || selected ? theme.cCardHovered : theme.cCard,
        borderRadius: radius,
        boxShadow: theme.dElevation > 0 ? theme.cardShadow() : null,
      ),
      // Comments have no color: the outline uses the text color.
      foregroundDecoration: BoxDecoration(
        borderRadius: radius,
        border: selected
            ? Border.all(
                color: theme.cTextInactive,
                width: theme.dSelectionWidth,
                strokeAlign: BorderSide.strokeAlignInside,
              )
            : null,
      ),
      child: content,
    );

    return SizedBox(
      width: (hostWidth ?? node.width) + kNodePadding * 2,
      child: Padding(
        padding: hostId == null
            ? const EdgeInsets.all(kNodePadding)
            : const EdgeInsets.symmetric(horizontal: kNodePadding),
        child: Listener(
          onPointerDown: (event) {
            if (event.buttons & kMiddleMouseButton != 0) return;
            _gestures.pointerDown(node.id, additive: _additive);
          },
          child: MouseRegion(
            onEnter: (_) => setState(() => _hovered = true),
            onExit: (_) {
              if (mounted) setState(() => _hovered = false);
            },
            child: NutriaContextMenuArea(
              onOpenChanged: ref
                  .read(overlayProvider.notifier)
                  .setContextMenuOpen,
              itemsAt: (_) => [
                NutriaContextMenuItem(
                  icon: Icons.edit,
                  label: t.commentEdit,
                  onSelected: _startEditing,
                ),
                if (hostId != null)
                  NutriaContextMenuItem(
                    icon: Icons.call_made,
                    label: t.commentDetach,
                    onSelected: () => editor.detachComment(node.id),
                  ),
                NutriaContextMenuItem(
                  icon: Icons.delete,
                  label: t.editDeleteSelectedNodes,
                  onSelected: () => editor.removeNodeOrSelection(node.id),
                ),
              ],
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _gestures.tap(node.id, additive: _additive),
                onDoubleTap: _startEditing,
                onPanStart: (_) =>
                    _gestures.beginMove(node.id, additive: _additive),
                onPanUpdate: (details) => _gestures.updateMove(
                  details.delta,
                  snap: HardwareKeyboard.instance.isShiftPressed,
                ),
                onPanEnd: (_) => _gestures.end(),
                onPanCancel: _gestures.end,
                child: Stack(
                  children: [
                    card,
                    NodeResizeHandle(nodeId: resized, fromLeft: true),
                    NodeResizeHandle(nodeId: resized, fromLeft: false),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _startEditing() {
    _editSession = Object();
    ref.read(selectionProvider.notifier).selectOnly(widget.node.id);
    ref.read(editingCommentProvider.notifier).start(widget.node.id);
  }

  void _stopEditing() =>
      ref.read(editingCommentProvider.notifier).stop(widget.node.id);
}
