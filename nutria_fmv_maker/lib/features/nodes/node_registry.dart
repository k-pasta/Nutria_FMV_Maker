// Which widgets draw each node type. Adding a node type means adding a case
// here (the switch is exhaustive, so the compiler points at it).
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/features/nodes/widgets/origin_node_body.dart';
import 'package:nutria_fmv_maker/features/nodes/widgets/video_node_views.dart';

/// The main content of [node], under its color strip.
Widget nodeBodyOf(Node node) => switch (node) {
  OriginNode() => const OriginNodeBody(),
  SimpleVideoNode() => SimpleVideoNodeBody(node: node),
  BranchedVideoNode() => BranchedVideoNodeBody(node: node),
};

/// What [node] shows below itself when expanded, or `null` if it can't be
/// expanded.
Widget? nodeExpansionOf(Node node) => switch (node) {
  OriginNode() => null,
  SimpleVideoNode() || BranchedVideoNode() => VideoNodeExpansion(node: node),
};
