// "Lazy connection": where a dragged noodle would connect if released now.
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nutria_fmv_maker/core/document/edge.dart';
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/core/document/project_document.dart';
import 'package:nutria_fmv_maker/core/graph/graph_ops.dart';
import 'package:nutria_fmv_maker/core/graph/ports.dart';

part 'connection_rules.freezed.dart';

/// What the pointer is over while a noodle is being dragged.
@freezed
sealed class HoverTarget with _$HoverTarget {
  /// Nothing connectable (empty canvas).
  const factory HoverTarget.none() = HoverNone;

  /// The body of a node, anywhere outside its knots.
  const factory HoverTarget.node(String nodeId) = HoverNode;

  /// A node's input knot.
  const factory HoverTarget.input(String nodeId) = HoverInput;

  /// One of a node's output knots.
  const factory HoverTarget.output(PortRef port) = HoverOutput;
}

/// The fixed end of a noodle being dragged. The other end follows the pointer.
@freezed
sealed class DragAnchor with _$DragAnchor {
  /// Dragging out of an output: the free end looks for an input.
  const factory DragAnchor.output(PortRef port) = AnchorOutput;

  /// Dragging out of an input: the free end looks for an output.
  const factory DragAnchor.input(String nodeId) = AnchorInput;

  const DragAnchor._();

  /// The node the fixed end belongs to.
  String get nodeId => switch (this) {
        AnchorOutput(:final port) => port.nodeId,
        AnchorInput(:final nodeId) => nodeId,
      };
}

/// A connection that would be made on release, already oriented output → input.
typedef PotentialConnection = ({PortRef from, PortRef to});

/// Decides what connection releasing the noodle over [hover] would create.
///
/// Users don't need to hit a knot exactly ("lazy connection"):
/// - From an output, hovering another node or its input targets that input.
/// - From an input, hovering another node's body targets its first free
///   output (top to bottom).
/// - From an input, hovering a specific output targets that output, even if
///   it's already connected (the old edge gets replaced).
///
/// Returns `null` when releasing would connect nothing.
PotentialConnection? resolveConnection(
  ProjectDocument doc,
  DragAnchor anchor,
  HoverTarget hover,
) {
  final hoveredNodeId = switch (hover) {
    HoverNone() => null,
    HoverNode(:final nodeId) || HoverInput(:final nodeId) => nodeId,
    HoverOutput(:final port) => port.nodeId,
  };
  if (hoveredNodeId == null || hoveredNodeId == anchor.nodeId) return null;
  final target = doc.nodes[hoveredNodeId];
  if (target == null) return null;

  switch (anchor) {
    case AnchorOutput(:final port):
      if (hover is HoverOutput || !hasInputPort(target)) return null;
      return (from: port, to: PortRef.input(target.id));
    case AnchorInput(:final nodeId):
      final output = switch (hover) {
        HoverOutput(:final port) => port,
        HoverNode() => _firstFreeOutput(doc, target),
        HoverInput() || HoverNone() => null,
      };
      if (output == null) return null;
      return (from: output, to: PortRef.input(nodeId));
  }
}

PortRef? _firstFreeOutput(ProjectDocument doc, Node node) {
  for (final port in outputRefsOf(node)) {
    if (doc.edgeFrom(port) == null) return port;
  }
  return null;
}
