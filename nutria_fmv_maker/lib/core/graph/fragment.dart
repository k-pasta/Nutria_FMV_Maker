// Copying nodes out of a document and pasting them into one (clipboard,
// duplicate).
import 'dart:convert';

import 'package:nutria_fmv_maker/core/document/edge.dart';
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/core/document/position.dart';
import 'package:nutria_fmv_maker/core/document/project_document.dart';
import 'package:nutria_fmv_maker/core/graph/graph_ops.dart';

/// Copied nodes, the connections among them and the videos they play. Can be
/// pasted into any project, including another one than it was copied from.
class NodeFragment {
  const NodeFragment({
    this.nodes = const [],
    this.edges = const [],
    this.videos = const [],
  });

  final List<Node> nodes;

  /// Only connections whose both ends are in [nodes].
  final List<Edge> edges;
  final List<VideoAsset> videos;

  bool get isEmpty => nodes.isEmpty;

  /// Marks clipboard text as Nutria nodes; the value is the format version.
  static const _marker = 'nutriaFmvNodes';
  static const _version = 1;

  /// Clipboard text.
  String encode() => jsonEncode({
        _marker: _version,
        'nodes': [for (final n in nodes) n.toJson()],
        'edges': [for (final e in edges) e.toJson()],
        'videos': [for (final v in videos) v.toJson()],
      });

  /// Reads clipboard [text], or returns `null` if it isn't copied nodes.
  static NodeFragment? decode(String? text) {
    if (text == null || !text.contains(_marker)) return null;
    try {
      final json = jsonDecode(text);
      if (json is! Map<String, dynamic> || json[_marker] != _version) {
        return null;
      }
      List<Map<String, dynamic>> list(String key) =>
          (json[key] as List).cast<Map<String, dynamic>>();
      return NodeFragment(
        nodes: [for (final n in list('nodes')) Node.fromJson(n)],
        edges: [for (final e in list('edges')) Edge.fromJson(e)],
        videos: [for (final v in list('videos')) VideoAsset.fromJson(v)],
      );
    } on Object {
      return null;
    }
  }

  /// The middle of the nodes' positions (their top-left corners).
  Position get center {
    final xs = nodes.map((n) => n.position.x);
    final ys = nodes.map((n) => n.position.y);
    double mid(Iterable<double> v) =>
        (v.reduce((a, b) => a < b ? a : b) + v.reduce((a, b) => a > b ? a : b)) /
        2;
    return Position(mid(xs), mid(ys));
  }
}

/// Copy and paste on documents.
extension FragmentOps on ProjectDocument {
  /// Nodes [ids] (never the origin) with their connections among each other
  /// and their videos.
  NodeFragment copyFragment(Iterable<String> ids) {
    final picked = {
      for (final id in ids)
        if (nodes[id] case final node? when node is! OriginNode) id: node,
    };
    final videoIds = {
      for (final node in picked.values) ?node.videoIdOrNull,
    };
    return NodeFragment(
      nodes: picked.values.toList(),
      edges: [
        for (final edge in edges)
          if (picked.containsKey(edge.from.nodeId) &&
              picked.containsKey(edge.to.nodeId))
            edge,
      ],
      videos: [
        for (final video in videos)
          if (videoIds.contains(video.id)) video,
      ],
    );
  }

  /// Adds a copy of [fragment], moved by [offset]. Nodes and choices get new
  /// ids from [newId]; videos are imported by path (reusing ones already in
  /// the project). Returns the new document and the new nodes' ids.
  (ProjectDocument, List<String>) pasteFragment(
    NodeFragment fragment, {
    required Position offset,
    required IdGenerator newId,
  }) {
    var doc = this;
    final videoIds = <String, String>{};
    for (final video in fragment.videos) {
      final (next, id) =
          doc.importVideo(VideoAsset(id: newId(), path: video.path));
      doc = next;
      videoIds[video.id] = id;
    }

    final nodeIds = <String, String>{};
    // Old choice id (= output port key) to new, per old node id.
    final portIds = <String, Map<String, String>>{};
    for (final node in fragment.nodes) {
      if (node is OriginNode) continue;
      final id = newId();
      nodeIds[node.id] = id;
      final position = Position(
          node.position.x + offset.x, node.position.y + offset.y);
      final copy = switch (node) {
        SimpleVideoNode() => node.copyWith(
            id: id, position: position, videoId: videoIds[node.videoId]),
        BranchedVideoNode() => node.copyWith(
            id: id,
            position: position,
            videoId: videoIds[node.videoId],
            choices: [
              for (final choice in node.choices)
                choice.copyWith(
                    id: (portIds[node.id] ??= {})[choice.id] = newId()),
            ],
          ),
        OriginNode() => throw StateError('unreachable'),
      };
      doc = doc.putNode(copy);
    }

    for (final edge in fragment.edges) {
      final from = nodeIds[edge.from.nodeId];
      final to = nodeIds[edge.to.nodeId];
      if (from == null || to == null) continue;
      final port = portIds[edge.from.nodeId]?[edge.from.port] ?? edge.from.port;
      doc = doc.connect(PortRef(nodeId: from, port: port), PortRef.input(to));
    }
    return (doc, nodeIds.values.toList());
  }
}
