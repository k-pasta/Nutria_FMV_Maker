// Dragging noodles between knots, including "lazy" connections onto node bodies.
import 'package:flutter/painting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nutria_fmv_maker/core/document/edge.dart';
import 'package:nutria_fmv_maker/core/graph/connection_rules.dart';
import 'package:nutria_fmv_maker/core/graph/graph_ops.dart';
import 'package:nutria_fmv_maker/features/nodes/providers/alt_drag_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connection_drag_provider.freezed.dart';
part 'connection_drag_provider.g.dart';

/// What the pointer is over, plus the noodle being dragged (if any).
@freezed
abstract class CanvasInteraction with _$CanvasInteraction {
  const factory CanvasInteraction({
    @Default(HoverTarget.none()) HoverTarget hover,

    /// The fixed end of the dragged noodle. `null` when not dragging.
    DragAnchor? anchor,

    /// The free end of the dragged noodle, in canvas coordinates.
    @Default(Offset.zero) Offset pointer,
  }) = _CanvasInteraction;
}

/// Knots and nodes report hovering here; knots start and end drags.
///
/// The whole drag is one undo transaction named "Connect": picking up a
/// connected output disconnects it, and dropping it on nothing leaves it
/// disconnected (which is how users delete a connection).
@Riverpod(keepAlive: true)
class ConnectionDragNotifier extends _$ConnectionDragNotifier {
  @override
  CanvasInteraction build() => const CanvasInteraction();

  DocumentNotifier get _document => ref.read(documentProvider.notifier);

  /// The pointer entered (or left, with [HoverTarget.none]) a node or knot.
  void hover(HoverTarget target) {
    if (state.hover != target) state = state.copyWith(hover: target);
  }

  /// Starts dragging from output [port] with the pointer at [pointer].
  /// A connected output is picked up from its target: the noodle stays
  /// attached to the target's input and the output is disconnected.
  void beginFromOutput(PortRef port, Offset pointer) {
    _document.beginTransaction('Connect');
    final existing = ref.read(documentProvider).document.edgeFrom(port);
    if (existing == null) {
      state = state.copyWith(anchor: DragAnchor.output(port), pointer: pointer);
      return;
    }
    _document.apply('Connect', (d) => d.disconnect(port));
    state = state.copyWith(
      anchor: DragAnchor.input(existing.to.nodeId),
      pointer: pointer,
    );
  }

  /// Starts dragging from node [nodeId]'s input.
  void beginFromInput(String nodeId, Offset pointer) {
    _document.beginTransaction('Connect');
    state = state.copyWith(anchor: DragAnchor.input(nodeId), pointer: pointer);
  }

  /// Moves the free end of the noodle by [delta] (canvas units).
  void updatePointer(Offset delta) {
    if (state.anchor == null) return;
    state = state.copyWith(pointer: state.pointer + delta);
  }

  /// Drops the noodle: connects to whatever [potentialConnectionProvider]
  /// shows, or leaves things disconnected.
  void end() {
    final anchor = state.anchor;
    if (anchor == null) return;
    final target = resolveConnection(
      ref.read(documentProvider).document,
      anchor,
      state.hover,
    );
    if (target != null) {
      _document.apply('Connect', (d) => d.connect(target.from, target.to));
    }
    _document.commit();
    state = state.copyWith(anchor: null);
  }
}

/// The connection that would be made if the noodle were dropped now, so
/// knots can highlight it.
@riverpod
PotentialConnection? potentialConnection(Ref ref) {
  final interaction = ref.watch(connectionDragProvider);
  final anchor = interaction.anchor;
  if (anchor == null) return null;
  return resolveConnection(
    ref.watch(projectDocumentProvider),
    anchor,
    interaction.hover,
  );
}

/// Whether [port] is the anchor or the target of the drag in progress, so its
/// knot is drawn enlarged. Inputs use [PortRef.input].
@riverpod
bool isKnotActive(Ref ref, PortRef port) {
  final anchor = ref.watch(connectionDragProvider.select((s) => s.anchor));
  final isAnchor = switch (anchor) {
    null => false,
    AnchorOutput(port: final anchored) => anchored == port,
    AnchorInput(:final nodeId) => PortRef.input(nodeId) == port,
  };
  if (isAnchor) return true;
  final target = ref.watch(potentialConnectionProvider);
  if (target != null && (target.from == port || target.to == port)) {
    return true;
  }
  // Alt over a node shows the output an Alt+drag would pull.
  return ref.watch(altPreviewPortProvider) == port;
}
