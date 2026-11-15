// Connections between node ports.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'edge.freezed.dart';
part 'edge.g.dart';

/// What travels along an edge.
///
/// `flow` edges decide which node plays next. `value` edges are reserved for
/// future variable/math/compare nodes that pass bool/int/float values.
enum EdgeKind { flow, value }

/// Identifies one port on one node.
///
/// Output port keys are defined per node type (see `core/graph/ports.dart`);
/// every node with an input uses [PortRef.inputPortKey].
@freezed
abstract class PortRef with _$PortRef {
  const factory PortRef({required String nodeId, required String port}) =
      _PortRef;

  /// The input port of [nodeId].
  factory PortRef.input(String nodeId) =>
      PortRef(nodeId: nodeId, port: inputPortKey);

  factory PortRef.fromJson(Map<String, dynamic> json) =>
      _$PortRefFromJson(json);

  /// Key of the single input port every playable node has.
  static const String inputPortKey = 'in';
}

/// A directed connection from an output port to an input port.
///
/// A flow output connects to at most one input; an input accepts any number of
/// incoming edges.
@freezed
abstract class Edge with _$Edge {
  const factory Edge({
    required PortRef from,
    required PortRef to,
    @Default(EdgeKind.flow) EdgeKind kind,
  }) = _Edge;

  factory Edge.fromJson(Map<String, dynamic> json) => _$EdgeFromJson(json);
}
