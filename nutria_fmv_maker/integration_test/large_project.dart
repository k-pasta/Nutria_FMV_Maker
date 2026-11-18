// A generated project with many connected nodes, for performance tests.
import 'package:nutria_fmv_maker/core/document/edge.dart';
import 'package:nutria_fmv_maker/core/document/media.dart';
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/core/document/position.dart';
import 'package:nutria_fmv_maker/core/document/project_document.dart';
import 'package:nutria_fmv_maker/core/graph/ports.dart';

/// [columns] x [rows] video nodes on a grid around the canvas middle, every
/// third one branched with three choices, each connected to the next nodes.
/// Every node has its own video, so each draws a thumbnail.
ProjectDocument buildLargeDocument({int columns = 20, int rows = 15}) {
  final empty = ProjectDocument.empty();
  final nodes = <String, Node>{...empty.nodes};
  final videos = <MediaAsset>[];
  final edges = <Edge>[];
  final count = columns * rows;
  String idOf(int i) => 'n$i';
  for (var i = 0; i < count; i++) {
    final position = Position(
      (i % columns - columns / 2) * 300,
      (i ~/ columns - rows / 2) * 460,
    );
    final videoId = 'v$i';
    videos.add(MediaAsset(id: videoId, path: 'C:/videos/clip_$i.mp4'));
    final swatch = i % 5;
    nodes[idOf(i)] = i % 3 == 0
        ? Node.branchedVideo(
            id: idOf(i),
            position: position,
            swatch: swatch,
            videoId: videoId,
            choices: [
              for (var c = 0; c < 3; c++)
                Choice(id: 'c${i}_$c', text: 'Choice ${c + 1}'),
            ],
          )
        : Node.simpleVideo(
            id: idOf(i),
            position: position,
            swatch: swatch,
            videoId: videoId,
          );
  }
  for (var i = 0; i < count; i++) {
    final node = nodes[idOf(i)]!;
    final ports = outputPortsOf(node);
    for (var p = 0; p < ports.length; p++) {
      final target = i + 1 + p;
      if (target >= count) break;
      edges.add(Edge(
        from: PortRef(nodeId: node.id, port: ports[p]),
        to: PortRef.input(idOf(target)),
      ));
    }
  }
  return empty.copyWith(nodes: nodes, media: videos, edges: edges);
}
