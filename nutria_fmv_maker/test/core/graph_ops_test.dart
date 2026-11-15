import 'package:flutter_test/flutter_test.dart';
import 'package:nutria_fmv_maker/core/document/edge.dart';
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/core/document/position.dart';
import 'package:nutria_fmv_maker/core/document/project_document.dart';
import 'package:nutria_fmv_maker/core/graph/graph_ops.dart';
import 'package:nutria_fmv_maker/core/graph/ports.dart';

import 'fixtures.dart';

void main() {
  group('removeNodes', () {
    test('removes the node and every edge touching it', () {
      final doc = storyFixture().removeNodes(['B']);
      expect(doc.nodes.containsKey('B'), isFalse);
      expect(
        doc.edges.where((e) => e.from.nodeId == 'B' || e.to.nodeId == 'B'),
        isEmpty,
      );
      // Unrelated edges survive.
      expect(doc.edgeFrom(const PortRef(nodeId: 'A', port: 'no')), isNotNull);
    });

    test('never removes the origin', () {
      final doc = storyFixture().removeNodes([kOriginNodeId]);
      expect(doc.nodes.containsKey(kOriginNodeId), isTrue);
    });
  });

  group('connect', () {
    const fromC = PortRef(nodeId: 'C', port: kNextPortKey);

    test('adds an edge', () {
      final doc = storyFixture().connect(fromC, PortRef.input('D'));
      expect(doc.edgeFrom(fromC)?.to, PortRef.input('D'));
    });

    test('replaces the existing edge of the same output', () {
      const fromB = PortRef(nodeId: 'B', port: kNextPortKey);
      final doc = storyFixture().connect(fromB, PortRef.input('D'));
      expect(doc.edges.where((e) => e.from == fromB), hasLength(1));
      expect(doc.edgeFrom(fromB)?.to, PortRef.input('D'));
    });

    test('rejects self-connections, unknown ports and the origin as target',
        () {
      final doc = storyFixture();
      expect(doc.connect(fromC, PortRef.input('C')), same(doc));
      expect(
        doc.connect(const PortRef(nodeId: 'C', port: 'nope'), PortRef.input('D')),
        same(doc),
      );
      expect(doc.connect(fromC, PortRef.input(kOriginNodeId)), same(doc));
    });
  });

  group('setChoiceText', () {
    late ProjectDocument doc;
    final newId = sequentialIds('c');

    setUp(() {
      doc = ProjectDocument.empty().putNode(newBranchedVideoNode(
        id: 'N',
        position: Position.zero,
        newId: sequentialIds('start'),
      ));
    });

    List<String> texts(ProjectDocument d) =>
        (d.node('N') as BranchedVideoNode).choices.map((c) => c.text).toList();

    test('a new branched node starts with the minimum empty choices', () {
      expect(texts(doc), List.filled(kMinChoices, ''));
    });

    test('typing in the slot after the last choice adds a choice', () {
      doc = doc
          .setChoiceText('N', 0, 'a', newId: newId)
          .setChoiceText('N', 1, 'b', newId: newId)
          .setChoiceText('N', 2, 'c', newId: newId);
      expect(texts(doc), ['a', 'b', 'c']);
    });

    test('clearing trailing choices trims back to the minimum', () {
      doc = doc
          .setChoiceText('N', 0, 'a', newId: newId)
          .setChoiceText('N', 1, 'b', newId: newId)
          .setChoiceText('N', 2, 'c', newId: newId)
          .setChoiceText('N', 3, 'd', newId: newId)
          .setChoiceText('N', 3, '', newId: newId)
          .setChoiceText('N', 2, '', newId: newId);
      expect(texts(doc), ['a', 'b']);
    });

    test('empty choices that are still connected are kept', () {
      doc = doc.setChoiceText('N', 2, 'c', newId: newId);
      final third = (doc.node('N') as BranchedVideoNode).choices[2];
      doc = doc
          .putNode(const SimpleVideoNode(id: 'T', position: Position.zero))
          .connect(PortRef(nodeId: 'N', port: third.id), PortRef.input('T'))
          .setChoiceText('N', 2, '', newId: newId);
      expect(texts(doc), ['', '', '']);
    });

    test('stops at the maximum number of choices', () {
      for (var i = 0; i < kMaxChoices + 3; i++) {
        doc = doc.setChoiceText('N', i, 'x$i', newId: newId);
      }
      expect(texts(doc), hasLength(kMaxChoices));
    });
  });

  group('convertVideoNode', () {
    test('simple → branched moves the connection to the first choice', () {
      final doc = storyFixture().convertVideoNode('B', newId: sequentialIds());
      final node = doc.node('B') as BranchedVideoNode;
      expect(node.videoId, 'v2');
      expect(
        doc.edgeFrom(PortRef(nodeId: 'B', port: node.choices.first.id))?.to,
        PortRef.input('C'),
      );
    });

    test('branched → simple keeps only the first choice connection', () {
      final doc = storyFixture().convertVideoNode('A', newId: sequentialIds());
      expect(doc.node('A'), isA<SimpleVideoNode>());
      expect(doc.edges.where((e) => e.from.nodeId == 'A'), [
        Edge(
          from: const PortRef(nodeId: 'A', port: kNextPortKey),
          to: PortRef.input('B'),
        ),
      ]);
      // Incoming edges are untouched.
      expect(doc.edgesInto('A'), hasLength(1));
    });
  });

  test('importVideo reuses an asset with the same path', () {
    final (doc, id) = storyFixture()
        .importVideo(const VideoAsset(id: 'new', path: r'C:\videos\a.mp4'));
    expect(id, 'v1');
    expect(doc.videos, hasLength(3));
  });

  test('setNodeWidth clamps to the allowed range', () {
    final doc = storyFixture().setNodeWidth('B', 10000);
    expect(doc.node('B').width, kMaxNodeWidth);
  });
}
