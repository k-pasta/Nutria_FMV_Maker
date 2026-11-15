import 'package:flutter_test/flutter_test.dart';
import 'package:nutria_fmv_maker/core/document/edge.dart';
import 'package:nutria_fmv_maker/core/graph/connection_rules.dart';
import 'package:nutria_fmv_maker/core/graph/graph_ops.dart';
import 'package:nutria_fmv_maker/core/graph/ports.dart';
import 'package:nutria_fmv_maker/features/canvas/providers/connection_drag_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';

import 'harness.dart';

void main() {
  late Harness h;
  ConnectionDragNotifier drag() =>
      h.container.read(connectionDragProvider.notifier);
  const fromC = PortRef(nodeId: 'C', port: kNextPortKey);
  const fromB = PortRef(nodeId: 'B', port: kNextPortKey);

  setUp(() async => h = await Harness.create());

  test('drop a free output on a node body to connect it', () {
    drag().beginFromOutput(fromC, Offset.zero);
    drag().updatePointer(const Offset(50, 50));
    drag().hover(const HoverTarget.node('D'));
    expect(h.container.read(isKnotActiveProvider(PortRef.input('D'))), isTrue);
    drag().end();

    expect(h.document.edgeFrom(fromC)?.to, PortRef.input('D'));
    expect(h.container.read(connectionDragProvider).anchor, isNull);
    expect(h.container.read(historyStatusProvider).undoLabel, 'Connect');
  });

  test('picking up a connected output and dropping it on nothing disconnects',
      () {
    drag().beginFromOutput(fromB, Offset.zero);
    expect(h.container.read(connectionDragProvider).anchor,
        const DragAnchor.input('C'),
        reason: 'the noodle stays attached to its old target');
    drag().end();
    expect(h.document.edgeFrom(fromB), isNull);

    h.container.read(documentProvider.notifier).undo();
    expect(h.document.edgeFrom(fromB)?.to, PortRef.input('C'));
  });

  test('a picked-up noodle can be attached to another output', () {
    // B → C is picked up; the noodle stays on C's input and is dropped on D's
    // output, so the connection becomes D → C.
    const fromD = PortRef(nodeId: 'D', port: kNextPortKey);
    drag().beginFromOutput(fromB, Offset.zero);
    drag().hover(const HoverTarget.output(fromD));
    drag().end();
    expect(h.document.edgeFrom(fromB), isNull);
    expect(h.document.edgeFrom(fromD)?.to, PortRef.input('C'));
  });

  test('dragging from an input onto a node uses its first free output', () {
    drag().beginFromInput('D', Offset.zero);
    drag().hover(const HoverTarget.node('A'));
    drag().end();
    expect(h.document.edgeFrom(const PortRef(nodeId: 'A', port: 'maybe'))?.to,
        PortRef.input('D'));
  });
}
