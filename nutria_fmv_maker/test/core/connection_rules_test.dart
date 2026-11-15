import 'package:flutter_test/flutter_test.dart';
import 'package:nutria_fmv_maker/core/document/edge.dart';
import 'package:nutria_fmv_maker/core/document/project_document.dart';
import 'package:nutria_fmv_maker/core/graph/connection_rules.dart';
import 'package:nutria_fmv_maker/core/graph/ports.dart';

import 'fixtures.dart';

void main() {
  final doc = storyFixture();
  const fromC = PortRef(nodeId: 'C', port: kNextPortKey);

  group('dragging from an output', () {
    const anchor = DragAnchor.output(fromC);

    test('hovering a node body targets its input', () {
      expect(resolveConnection(doc, anchor, const HoverTarget.node('D')),
          (from: fromC, to: PortRef.input('D')));
    });

    test('hovering an input targets it', () {
      expect(resolveConnection(doc, anchor, const HoverTarget.input('D')),
          (from: fromC, to: PortRef.input('D')));
    });

    test('nodes without an input, outputs and itself are ignored', () {
      expect(
          resolveConnection(doc, anchor, const HoverTarget.node(kOriginNodeId)),
          isNull);
      expect(
          resolveConnection(doc, anchor,
              const HoverTarget.output(PortRef(nodeId: 'D', port: kNextPortKey))),
          isNull);
      expect(resolveConnection(doc, anchor, const HoverTarget.node('C')), isNull);
      expect(resolveConnection(doc, anchor, const HoverTarget.none()), isNull);
    });
  });

  group('dragging from an input', () {
    const anchor = DragAnchor.input('D');

    test('hovering a node body targets its first free output', () {
      // A's "yes" and "no" are connected, "maybe" is free.
      expect(resolveConnection(doc, anchor, const HoverTarget.node('A')),
          (from: const PortRef(nodeId: 'A', port: 'maybe'), to: PortRef.input('D')));
    });

    test('a node with no free output gives nothing', () {
      expect(resolveConnection(doc, anchor, const HoverTarget.node('B')), isNull);
    });

    test('hovering a specific output targets it even if connected', () {
      const yes = PortRef(nodeId: 'A', port: 'yes');
      expect(resolveConnection(doc, anchor, const HoverTarget.output(yes)),
          (from: yes, to: PortRef.input('D')));
    });

    test('hovering an input gives nothing', () {
      expect(resolveConnection(doc, anchor, const HoverTarget.input('A')), isNull);
    });
  });
}
