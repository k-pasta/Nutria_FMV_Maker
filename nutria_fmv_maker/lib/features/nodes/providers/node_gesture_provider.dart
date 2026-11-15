// Pointer gestures on nodes: click-selection, moving and resizing.
import 'package:flutter/painting.dart';
import 'package:nutria_fmv_maker/core/document/position.dart';
import 'package:nutria_fmv_maker/core/graph/graph_ops.dart';
import 'package:nutria_fmv_maker/core/graph/snapping.dart';
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
  _Move(this.start);
  final Map<String, Position> start;
  Offset total = Offset.zero;
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

    final doc = ref.read(documentProvider).document;
    final ids = ref.read(selectionProvider).selected;
    state = _Move({
      for (final id in ids)
        if (doc.nodes[id] != null) id: doc.nodes[id]!.position,
    });
    _document.beginTransaction('Move nodes');
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
    _document.apply('Move nodes', (d) => d.moveNodes({
          for (final MapEntry(:key, :value) in gesture.start.entries)
            key: shouldSnap
                ? snapToGrid(value + offset,
                    gridSize: prefs.gridSize, gridOffset: -kNodePadding)
                : value + offset,
        }));
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

  /// Ends a move or resize as one undo step.
  void end() {
    if (state == null) return;
    state = null;
    _document.commit();
  }
}
