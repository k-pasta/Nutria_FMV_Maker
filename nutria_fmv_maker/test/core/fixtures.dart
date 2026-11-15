// Shared test documents for core tests.
import 'package:nutria_fmv_maker/core/document/edge.dart';
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/core/document/position.dart';
import 'package:nutria_fmv_maker/core/document/project_document.dart';
import 'package:nutria_fmv_maker/core/document/video_settings.dart';
import 'package:nutria_fmv_maker/core/graph/graph_ops.dart';
import 'package:nutria_fmv_maker/core/graph/ports.dart';

/// Deterministic id generator: id1, id2, ...
IdGenerator sequentialIds([String prefix = 'id']) {
  var next = 0;
  return () => '$prefix${++next}';
}

/// A small story:
///
/// origin → A (branched: "Yes"→B, "No"→C, "Maybe"→nothing; showTimer overridden)
///          B (simple) → C
///          C (simple, end)
///          D (simple, unreachable)
ProjectDocument storyFixture() {
  const videos = [
    VideoAsset(id: 'v1', path: r'C:\videos\a.mp4'),
    VideoAsset(id: 'v2', path: r'C:\videos\b.mp4'),
    VideoAsset(id: 'v3', path: r'C:\videos\c.mp4'),
  ];
  final empty = ProjectDocument.empty();
  return empty.copyWith(
    info: const ProjectInfo(
      title: 'Τα 88 Ντολμαδάκια',
      description: 'Ένα διαδραστικό παραμύθι',
    ),
    videos: videos,
    nodes: {
      ...empty.nodes,
      'A': const BranchedVideoNode(
        id: 'A',
        position: Position(400, 250),
        videoId: 'v1',
        overrides: VideoSettingsOverride(showTimer: false),
        choices: [
          Choice(id: 'yes', text: 'Yes'),
          Choice(id: 'no', text: 'No'),
          Choice(id: 'maybe', text: 'Maybe'),
        ],
      ),
      'B': const SimpleVideoNode(id: 'B', position: Position(700, 100), videoId: 'v2'),
      'C': const SimpleVideoNode(id: 'C', position: Position(700, 400), videoId: 'v3'),
      'D': const SimpleVideoNode(id: 'D', position: Position(900, 900), videoId: 'v3'),
    },
    edges: const [
      Edge(
        from: PortRef(nodeId: kOriginNodeId, port: kNextPortKey),
        to: PortRef(nodeId: 'A', port: PortRef.inputPortKey),
      ),
      Edge(
        from: PortRef(nodeId: 'A', port: 'yes'),
        to: PortRef(nodeId: 'B', port: PortRef.inputPortKey),
      ),
      Edge(
        from: PortRef(nodeId: 'A', port: 'no'),
        to: PortRef(nodeId: 'C', port: PortRef.inputPortKey),
      ),
      Edge(
        from: PortRef(nodeId: 'B', port: kNextPortKey),
        to: PortRef(nodeId: 'C', port: PortRef.inputPortKey),
      ),
    ],
  );
}
