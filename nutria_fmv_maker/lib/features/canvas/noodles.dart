// Where the noodles (connection lines) go: one per edge, plus the one being
// dragged.
import 'dart:ui';

import 'package:nutria_fmv_maker/core/document/edge.dart';
import 'package:nutria_fmv_maker/core/document/project_document.dart';
import 'package:nutria_fmv_maker/core/graph/connection_rules.dart';
import 'package:nutria_fmv_maker/features/canvas/providers/connection_drag_provider.dart';
import 'package:nutria_fmv_maker/features/nodes/node_layout.dart';
import 'package:nutria_fmv_maker/ui/painters/noodle_painter.dart';

/// Canvas position of [port]'s knot, or `null` if the node or port is gone.
Offset? knotPosition(ProjectDocument doc, NodeMetrics metrics, PortRef port) {
  final node = doc.nodes[port.nodeId];
  if (node == null) return null;
  final layout = NodeLayout(node, metrics);
  final offset = port.port == PortRef.inputPortKey
      ? layout.input
      : layout.output(port.port);
  if (offset == null) return null;
  return Offset(node.position.x, node.position.y) + offset;
}

/// Every noodle to draw, in canvas coordinates.
///
/// While a noodle is dragged, its free end follows the pointer, or jumps to
/// the knot it would connect to ([potential]) so users see the result before
/// they let go.
List<Noodle> noodlesFor(
  ProjectDocument doc,
  NodeMetrics metrics,
  CanvasInteraction interaction,
  PotentialConnection? potential,
) {
  Offset? at(PortRef port) => knotPosition(doc, metrics, port);
  final noodles = <Noodle>[
    for (final edge in doc.edges)
      if ((at(edge.from), at(edge.to)) case (final from?, final to?))
        Noodle(from, to),
  ];

  final anchor = interaction.anchor;
  if (anchor != null) {
    final fixed = switch (anchor) {
      AnchorOutput(:final port) => at(port),
      AnchorInput(:final nodeId) => at(PortRef.input(nodeId)),
    };
    final free = switch ((anchor, potential)) {
      (AnchorOutput(), (:final to, from: _)?) => at(to),
      (AnchorInput(), (:final from, to: _)?) => at(from),
      _ => null,
    };
    if (fixed != null) {
      // Noodles always run from an output to an input.
      noodles.add(switch (anchor) {
        AnchorOutput() =>
          Noodle(fixed, free ?? interaction.pointer, endLocked: free != null),
        AnchorInput() => Noodle(free ?? interaction.pointer, fixed,
            startLocked: free != null),
      });
    }
  }
  return noodles;
}
