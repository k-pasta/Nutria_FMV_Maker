// Which ports each node type exposes. The single place to extend for new node types.
import 'package:nutria_fmv_maker/core/document/edge.dart';
import 'package:nutria_fmv_maker/core/document/node.dart';

/// Output port key of nodes that have exactly one "next" output.
const String kNextPortKey = 'next';

/// Output port keys of [node], in display (top to bottom) and export order.
///
/// A branched node's output ports are its choice ids, so a connection follows
/// its choice when choices are edited.
List<String> outputPortsOf(Node node) => switch (node) {
  OriginNode() => const [kNextPortKey],
  SimpleVideoNode() => const [kNextPortKey],
  BranchedVideoNode(:final choices) => [for (final c in choices) c.id],
  CommentNode() => const [],
};

/// Whether [node] can be the target of a flow connection.
bool hasInputPort(Node node) => switch (node) {
  OriginNode() || CommentNode() => false,
  SimpleVideoNode() || BranchedVideoNode() => true,
};

/// Whether [port] is an existing output port of [node].
bool isOutputPortOf(Node node, String port) =>
    outputPortsOf(node).contains(port);

/// The output an Alt+drag on [node] starts from: the first one with no
/// connection, or the first one if all are connected (picking up its
/// connection, like dragging its knot); `null` if [node] has no outputs.
PortRef? firstFreeOutput(Node node, bool Function(PortRef port) isConnected) {
  final outputs = outputRefsOf(node);
  for (final port in outputs) {
    if (!isConnected(port)) return port;
  }
  return outputs.isEmpty ? null : outputs.first;
}

/// Convenience: the [PortRef] of every output of [node].
List<PortRef> outputRefsOf(Node node) => [
  for (final port in outputPortsOf(node)) PortRef(nodeId: node.id, port: port),
];
