// Pointer gestures on nodes: click-selection, moving and resizing.
import 'package:flutter/painting.dart';
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/core/document/position.dart';
import 'package:nutria_fmv_maker/core/graph/graph_ops.dart';
import 'package:nutria_fmv_maker/core/graph/snapping.dart';
import 'package:nutria_fmv_maker/features/nodes/node_bounds.dart';
import 'package:nutria_fmv_maker/features/preferences/providers/preferences_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/graph_editor.dart';
import 'package:nutria_fmv_maker/features/selection/providers/selection_provider.dart';
import 'package:nutria_fmv_maker/features/video_preview/providers/video_preview_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'node_gesture_provider.g.dart';

/// Offset that makes a node's visible corner (inside its padding) land on the
/// canvas grid dots when snapping.
const kNodePadding = 30.0;

/// A drag in progress. Positions are kept unsnapped so snapping never
/// accumulates error; the document gets the snapped result.
sealed class NodeGesture {
  const NodeGesture();
}

class _Move extends NodeGesture {
  _Move(this.start, {this.comment, this.taken = const {}});
  final Map<String, Position> start;
  Offset total = Offset.zero;

  /// The comment being moved, when it is the only thing moving: it can be
  /// dropped onto a node.
  final String? comment;

  /// Nodes that have a comment already.
  final Set<String> taken;

  /// The node the comment would be attached to if dropped now.
  String? attachTo;
}

class _Resize extends NodeGesture {
  _Resize(this.nodeId, this.startWidth, this.startPosition, this.fromLeft);
  final String nodeId;
  final double startWidth;
  final Position startPosition;
  final bool fromLeft;
  double total = 0;
}

/// Handles clicks and drags on nodes. Each widget callback calls exactly one
/// method here. Modifier keys are passed in by the widget.
@Riverpod(keepAlive: true)
class NodeGestureNotifier extends _$NodeGestureNotifier {
  @override
  NodeGesture? build() => null;

  SelectionNotifier get _selection => ref.read(selectionProvider.notifier);
  DocumentNotifier get _document => ref.read(documentProvider.notifier);

  // -------------------------------------------------------------- selection

  /// Click on a node. Plain click selects only it and previews its video;
  /// with [additive] (Ctrl/Shift) it toggles the node in the selection.
  void tap(String id, {required bool additive}) {
    final isSelected = ref.read(selectionProvider).selected.contains(id);
    if (additive && isSelected) {
      _selection.remove(id);
      return;
    }
    if (additive) {
      _selection.add(id);
    } else {
      _selection.selectOnly(id);
    }
    _selection.raise(id);
    ref.read(videoPreviewProvider.notifier).showNode(id);
  }

  /// A mouse button went down anywhere on node [id], including its buttons
  /// and text fields: using a node selects it. Ctrl/Shift clicks ([additive])
  /// are left to [tap], which toggles.
  void pointerDown(String id, {required bool additive}) {
    if (additive || ref.read(selectionProvider).selected.contains(id)) return;
    _selection.selectOnly(id);
    _selection.raise(id);
  }

  /// Drop of a library video onto node [id].
  void dropVideo(String id, String videoId) =>
      ref.read(graphEditorProvider).setVideo(id, videoId);

  // ------------------------------------------------------------------- move

  /// Starts dragging node [id]. Dragging an unselected node without
  /// [additive] selects only it; otherwise the whole selection moves.
  void beginMove(String id, {required bool additive}) {
    final isSelected = ref.read(selectionProvider).selected.contains(id);
    if (isSelected || additive) {
      _selection.add(id);
    } else {
      _selection.selectOnly(id);
    }
    _selection.raise(id);

    final ids = ref.read(selectionProvider).selected;
    _document.beginTransaction('Move nodes');
    // A comment dragged without its node comes off it, where it is now.
    final bounds = ref.read(nodeBoundsProvider);
    final before = ref.read(documentProvider).document;
    for (final id in ids) {
      final node = before.nodes[id];
      final host = before.hostOf(node!);
      if (host == null || ids.contains(host.id)) continue;
      final rect = bounds.rectOf(node, host: host);
      _document.apply(
        'Move nodes',
        (d) => d.detachComment(
          id,
          Position(rect.left - kNodePadding, rect.top - kNodePadding),
          host.width,
        ),
      );
    }
    final doc = ref.read(documentProvider).document;
    final moving = [
      for (final id in ids)
        // Attached comments follow their node by themselves.
        if (doc.nodes[id] case final node? when doc.hostOf(node) == null) node,
    ];
    final single = moving.length == 1 ? moving.single : null;
    state = _Move(
      {for (final node in moving) node.id: node.position},
      comment: single is CommentNode ? single.id : null,
      taken: {
        if (single is CommentNode)
          for (final node in doc.nodes.values)
            if (node is CommentNode) ?node.attachedTo,
      },
    );
  }

  /// Moves the dragged nodes by [delta] (canvas units). Snaps to the grid if
  /// [snap] (Shift) or grid snapping is on.
  void updateMove(Offset delta, {required bool snap}) {
    final gesture = state;
    if (gesture is! _Move) return;
    gesture.total += delta;
    final prefs = ref.read(preferencesProvider);
    final shouldSnap = snap || prefs.gridSnapping;
    final offset = Position(gesture.total.dx, gesture.total.dy);
    _document.apply(
      'Move nodes',
      (d) => d.moveNodes({
        for (final MapEntry(:key, :value) in gesture.start.entries)
          key: shouldSnap
              ? snapToGrid(
                  value + offset,
                  gridSize: prefs.gridSize,
                  gridOffset: -kNodePadding,
                )
              : value + offset,
      }),
    );
    final comment = gesture.comment;
    if (comment != null) _findCommentTarget(gesture, comment);
  }

  /// The node whose card is under the middle of the moved comment, if it
  /// can take a comment.
  void _findCommentTarget(_Move gesture, String commentId) {
    final doc = ref.read(documentProvider).document;
    final bounds = ref.read(nodeBoundsProvider);
    final center = bounds.rectOf(doc.node(commentId)).center;
    String? target;
    for (final node in doc.nodes.values) {
      if (node is CommentNode || gesture.taken.contains(node.id)) continue;
      if (bounds.rectOf(node).contains(center)) target = node.id;
    }
    gesture.attachTo = target;
    ref.read(commentDropTargetProvider.notifier).set(target);
  }

  // ----------------------------------------------------------------- resize

  /// Starts resizing node [id] from its left or right edge.
  void beginResize(String id, {required bool fromLeft}) {
    final node = ref.read(documentProvider).document.nodes[id];
    if (node == null) return;
    state = _Resize(id, node.width, node.position, fromLeft);
    _document.beginTransaction('Resize node');
  }

  /// Applies a horizontal drag of [dx] to the edge being resized. The width
  /// snaps to the default near it; dragging the left edge keeps the right
  /// edge in place.
  void updateResize(double dx) {
    final gesture = state;
    if (gesture is! _Resize) return;
    gesture.total += dx;
    final intended = gesture.fromLeft
        ? gesture.startWidth - gesture.total
        : gesture.startWidth + gesture.total;
    final width = snapNodeWidth(intended);
    final start = gesture.startPosition;
    _document.apply('Resize node', (d) {
      final resized = d.setNodeWidth(gesture.nodeId, width);
      if (!gesture.fromLeft) return resized;
      final x = start.x + gesture.startWidth - width;
      return resized.moveNodes({gesture.nodeId: Position(x, start.y)});
    });
  }

  // -------------------------------------------------------------------- end

  /// Ends a move or resize as one undo step. A comment dropped onto a node
  /// is attached to it.
  void end() {
    final gesture = state;
    if (gesture == null) return;
    state = null;
    if (gesture is _Move) {
      final comment = gesture.comment;
      final host = gesture.attachTo;
      if (comment != null && host != null) {
        _document.apply('Move nodes', (d) => d.attachComment(comment, host));
      }
      ref.read(commentDropTargetProvider.notifier).set(null);
    }
    _document.commit();
  }
}

/// The node a dragged comment would be attached to if dropped now, so it
/// can light up.
@Riverpod(keepAlive: true)
class CommentDropTarget extends _$CommentDropTarget {
  @override
  String? build() => null;

  void set(String? id) => state = id;
}
