// Turns a project into the .fmv that Nutria FMV Player plays. The file format
// itself (and reading it) lives in the shared nutria_fmv_protocol package.
import 'package:nutria_fmv_maker/core/document/edge.dart';
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/core/document/project_document.dart';
import 'package:nutria_fmv_maker/core/document/video_settings.dart';
import 'package:nutria_fmv_maker/core/graph/graph_ops.dart';
import 'package:nutria_fmv_maker/core/graph/ports.dart';
import 'package:nutria_fmv_protocol/nutria_fmv_protocol.dart';

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

/// The exported project plus any issues found along the way.
typedef FmvExport = ({FmvProject project, List<ExportIssue> issues});

/// Exports [document] for the Player (see [FmvProject] for the format).
///
/// Only nodes reachable from the origin are exported. Nodes get short
/// sequential ids in breadth-first order; the origin is `000` and is itself
/// left out, so playback starts at `001`. Only connected choices are kept.
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

  final nodes = <String, FmvNode>{};
  for (final nodeId in order) {
    final node = document.node(nodeId);
    switch (node) {
      case OriginNode():
        continue;
      case SimpleVideoNode():
        nodes[ids[nodeId]!] = FmvNode(
          video: _videoPath(document, node, issues),
          target: targetOf(PortRef(nodeId: nodeId, port: kNextPortKey)),
          overrides: _overrides(node.overrides),
        );
      case BranchedVideoNode():
        final choices = <FmvChoice>[];
        for (final choice in node.choices) {
          final target = targetOf(PortRef(nodeId: nodeId, port: choice.id));
          if (target != null) {
            choices.add(FmvChoice(text: choice.text, target: target));
          } else if (choice.text.isNotEmpty) {
            issues.add(
                (type: ExportIssueType.unconnectedChoice, nodeId: nodeId));
          }
        }
        nodes[ids[nodeId]!] = FmvNode(
          video: _videoPath(document, node, issues),
          choices: choices.isEmpty ? null : choices,
          overrides: _overrides(node.overrides),
        );
    }
  }

  final settings = document.settings;
  return (
    project: FmvProject(
      info: FmvProjectInfo(
        title: document.info.title,
        description: document.info.description,
      ),
      settings: FmvSettings(
        selectionTimeMs: settings.selectionTimeMs,
        pauseOnEnd: settings.pauseOnEnd,
        showTimer: settings.showTimer,
        videoFit: _videoFit(settings.videoFit),
        defaultSelection: _defaultSelection(settings.defaultSelection),
      ),
      nodes: nodes,
    ),
    issues: issues,
  );
}

FmvOverrides _overrides(VideoSettingsOverride o) => FmvOverrides(
      selectionTimeMs: o.selectionTimeMs,
      pauseOnEnd: o.pauseOnEnd,
      showTimer: o.showTimer,
      videoFit: o.videoFit == null ? null : _videoFit(o.videoFit!),
      defaultSelection: o.defaultSelection == null
          ? null
          : _defaultSelection(o.defaultSelection!),
    );

/// The editor's values all exist in the protocol under the same names.
FmvVideoFit _videoFit(VideoFit fit) => FmvVideoFit.values.byName(fit.name);

FmvDefaultSelection _defaultSelection(DefaultSelectionMethod method) =>
    FmvDefaultSelection.values.byName(method.name);

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
