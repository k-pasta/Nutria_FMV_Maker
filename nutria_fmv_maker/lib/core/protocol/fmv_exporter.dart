// Builds the .fmv JSON read by Nutria FMV Player (the "Nutria FMV Protocol").
//
// The output shape is shared with the separate Player app, so any change here
// is a protocol change. This file must stay free of Flutter imports; it is
// meant to move into a package shared with the Player.
import 'package:nutria_fmv_maker/core/document/edge.dart';
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/core/document/project_document.dart';
import 'package:nutria_fmv_maker/core/graph/graph_ops.dart';
import 'package:nutria_fmv_maker/core/graph/ports.dart';

/// A problem found while exporting. Export still succeeds; the editor can
/// show these so the author can fix them.
enum ExportIssueType {
  /// A reachable video node has no video assigned.
  missingVideo,

  /// A choice has text but leads nowhere, so the Player won't offer it.
  unconnectedChoice,
}

/// One [ExportIssueType] on a specific node (by its editor id).
typedef ExportIssue = ({ExportIssueType type, String nodeId});

/// The exported `.fmv` JSON plus any issues found along the way.
typedef FmvExport = ({Map<String, Object?> json, List<ExportIssue> issues});

/// Exports [document] to the `.fmv` structure:
///
/// ```json
/// {
///   "ProjectInfo": {"title": "...", "description": "..."},
///   "ProjectSettings": {"selectionTime": 6000, "pauseOnEnd": false, ...},
///   "Nodes": {
///     "001": {"video": "C:/path.mp4", "choices": [{"option": "...", "target": "002"}],
///             "overrides": {"showTimer": false}},
///     "002": {"video": "C:/other.mp4", "target": "003"}
///   }
/// }
/// ```
///
/// Only nodes reachable from the origin are exported. Nodes get short
/// sequential ids in breadth-first order; the origin is `000` and is itself
/// left out of `Nodes`, so the Player starts at `001`.
FmvExport exportFmv(ProjectDocument document) {
  final order = _reachableInBfsOrder(document);
  final ids = {
    for (final (index, nodeId) in order.indexed)
      nodeId: index.toString().padLeft(3, '0'),
  };
  final issues = <ExportIssue>[];

  String? targetOf(PortRef port) {
    final edge = document.edgeFrom(port);
    return edge == null ? null : ids[edge.to.nodeId];
  }

  final nodesJson = <String, Object?>{};
  for (final nodeId in order) {
    final node = document.node(nodeId);
    switch (node) {
      case OriginNode():
        continue;
      case SimpleVideoNode():
        final target = targetOf(PortRef(nodeId: nodeId, port: kNextPortKey));
        nodesJson[ids[nodeId]!] = {
          'video': _videoPath(document, node, issues),
          'target': ?target,
          if (!node.overrides.isEmpty)
            'overrides': node.overrides.toProtocolJson(),
        };
      case BranchedVideoNode():
        // Only connected choices are offered by the Player.
        final choices = <Map<String, String>>[];
        for (final choice in node.choices) {
          final target = targetOf(PortRef(nodeId: nodeId, port: choice.id));
          if (target != null) {
            choices.add({'option': choice.text, 'target': target});
          } else if (choice.text.isNotEmpty) {
            issues.add(
                (type: ExportIssueType.unconnectedChoice, nodeId: nodeId));
          }
        }
        nodesJson[ids[nodeId]!] = {
          'video': _videoPath(document, node, issues),
          if (choices.isNotEmpty) 'choices': choices,
          if (!node.overrides.isEmpty)
            'overrides': node.overrides.toProtocolJson(),
        };
    }
  }

  return (
    json: {
      'ProjectInfo': {
        'title': ?document.info.title,
        'description': ?document.info.description,
      },
      'ProjectSettings': document.settings.toProtocolJson(),
      'Nodes': nodesJson,
    },
    issues: issues,
  );
}

/// Node ids reachable from the origin, breadth-first, following each node's
/// outputs in port order. Edges into deleted nodes are ignored.
List<String> _reachableInBfsOrder(ProjectDocument document) {
  final start = document.origin.id;
  final visited = <String>{start};
  final order = <String>[];
  final queue = <String>[start];
  while (queue.isNotEmpty) {
    final nodeId = queue.removeAt(0);
    order.add(nodeId);
    for (final port in outputRefsOf(document.node(nodeId))) {
      final next = document.edgeFrom(port)?.to.nodeId;
      if (next != null &&
          document.nodes.containsKey(next) &&
          visited.add(next)) {
        queue.add(next);
      }
    }
  }
  return order;
}

String? _videoPath(
    ProjectDocument document, Node node, List<ExportIssue> issues) {
  final path = document.videoById(node.videoIdOrNull)?.path;
  if (path == null) {
    issues.add((type: ExportIssueType.missingVideo, nodeId: node.id));
  }
  return path;
}
