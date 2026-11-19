import 'package:flutter_test/flutter_test.dart';
import 'package:nutria_fmv_maker/core/document/edge.dart';
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/core/document/position.dart';
import 'package:nutria_fmv_maker/core/document/project_document.dart';
import 'package:nutria_fmv_maker/core/graph/fragment.dart';
import 'package:nutria_fmv_maker/core/graph/graph_ops.dart';

import 'fixtures.dart';

void main() {
  final story = storyFixture();

  test('copies the nodes, the connections among them and their videos', () {
    final fragment = story.copyFragment(['A', 'B', kOriginNodeId]);
    expect(
      fragment.nodes.map((n) => n.id),
      unorderedEquals(['A', 'B']),
      reason: 'the origin is never copied',
    );
    // A→B is inside; origin→A, A→C and B→C leave the copied nodes.
    expect(fragment.edges, hasLength(1));
    expect(fragment.edges.single.from, const PortRef(nodeId: 'A', port: 'yes'));
    expect(fragment.media.map((v) => v.id), unorderedEquals(['v1', 'v2']));
  });

  test('survives the clipboard', () {
    final fragment = story.copyFragment(['A', 'B']);
    final back = NodeFragment.decode(fragment.encode())!;
    expect(back.nodes, fragment.nodes);
    expect(back.edges, fragment.edges);
    expect(back.media, fragment.media);
    expect(NodeFragment.decode('just some text'), isNull);
    expect(NodeFragment.decode('{"nutriaFmvNodes": 99}'), isNull);
  });

  test('pasting makes new nodes and choices, connected like the originals', () {
    final fragment = story.copyFragment(['A', 'B']);
    final (doc, ids) = story.pasteFragment(
      fragment,
      offset: const Position(10, 20),
      newId: sequentialIds('new'),
    );
    expect(ids, hasLength(2));
    expect(doc.nodes, hasLength(story.nodes.length + 2));

    final a = doc.nodes.values.whereType<BranchedVideoNode>().firstWhere(
      (n) => ids.contains(n.id),
    );
    expect(a.position, const Position(410, 270));
    expect(a.choices.map((c) => c.text), ['Yes', 'No', 'Maybe']);
    expect(
      a.choices.map((c) => c.id),
      isNot(contains('yes')),
      reason: 'choice ids are port keys, so they must be new',
    );

    final edge = doc.edgeFrom(PortRef(nodeId: a.id, port: a.choices[0].id))!;
    expect(ids, contains(edge.to.nodeId));
    expect(
      doc.edgeFrom(PortRef(nodeId: a.id, port: a.choices[1].id)),
      isNull,
      reason: 'A→C left the copied nodes',
    );
    expect(doc.media, story.media, reason: 'same paths reuse the videos');
  });

  test('pasting into another project brings the videos along', () {
    final fragment = story.copyFragment(['B']);
    final (doc, ids) = ProjectDocument.empty().pasteFragment(
      fragment,
      offset: Position.zero,
      newId: sequentialIds('new'),
    );
    final b = doc.nodes[ids.single]! as SimpleVideoNode;
    expect(doc.mediaById(b.videoId)?.path, r'C:\videos\b.mp4');
  });

  test('collapse all closes every node, and is a no-op if none is open', () {
    expect(story.collapseAll(), same(story));
    final open = story.toggleExpanded('A').toggleExpanded('B');
    expect(open.collapseAll().nodes.values.any((n) => n.isExpanded), isFalse);
  });
}
