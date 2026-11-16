import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutria_fmv_maker/core/document/edge.dart';
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/core/document/position.dart';
import 'package:nutria_fmv_maker/core/document/project_document.dart';
import 'package:nutria_fmv_maker/core/graph/connection_rules.dart';
import 'package:nutria_fmv_maker/core/graph/graph_ops.dart';
import 'package:nutria_fmv_maker/core/graph/ports.dart';
import 'package:nutria_fmv_maker/features/canvas/noodles.dart';
import 'package:nutria_fmv_maker/features/canvas/providers/connection_drag_provider.dart';
import 'package:nutria_fmv_maker/features/nodes/node_layout.dart';
import 'package:nutria_fmv_maker/features/nodes/widgets/knot.dart';
import 'package:nutria_fmv_maker/features/preferences/providers/preferences_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:nutria_fmv_maker/features/project/providers/graph_editor.dart';
import 'package:nutria_fmv_maker/ui/painters/noodle_painter.dart';

import 'app_tester.dart';

const metrics = NodeMetrics(
    swatchHeight: 10, textHeight: 14, panelPadding: 5, rowHeight: 25);

const originOut = PortRef(nodeId: kOriginNodeId, port: kNextPortKey);

void main() {
  group('noodlesFor', () {
    final doc = ProjectDocument.empty()
        .putNode(const SimpleVideoNode(id: 'a', position: Position(400, 100)));

    test('one noodle per edge, from output knot to input knot', () {
      final connected = doc.connect(originOut, PortRef.input('a'));
      final noodles =
          noodlesFor(connected, metrics, const CanvasInteraction(), null);
      expect(noodles, [
        Noodle(knotPosition(connected, metrics, originOut)!,
            knotPosition(connected, metrics, PortRef.input('a'))!),
      ]);
      expect(noodles.single.end,
          const Offset(400, 100) + NodeLayout(connected.nodes['a']!, metrics).input!);
    });

    test('a dragged noodle follows the pointer', () {
      final noodles = noodlesFor(
        doc,
        metrics,
        const CanvasInteraction(
            anchor: DragAnchor.output(originOut), pointer: Offset(7, 8)),
        null,
      );
      expect(noodles.single.end, const Offset(7, 8));
      expect(noodles.single.endLocked, isFalse);
    });

    test('a dragged noodle jumps to the knot it would connect to', () {
      final noodles = noodlesFor(
        doc,
        metrics,
        const CanvasInteraction(
            anchor: DragAnchor.output(originOut), pointer: Offset(7, 8)),
        (from: originOut, to: PortRef.input('a')),
      );
      expect(noodles.single.end, knotPosition(doc, metrics, PortRef.input('a')));
      // The straight piece on that side only appears once connected.
      expect(noodles.single.endLocked, isFalse);
      expect(noodles.single.startLocked, isTrue);
    });

    test('dragging from an input draws from the pointer to that input', () {
      final noodles = noodlesFor(
        doc,
        metrics,
        const CanvasInteraction(
            anchor: DragAnchor.input('a'), pointer: Offset(-5, -5)),
        null,
      );
      expect(noodles.single.start, const Offset(-5, -5));
      expect(noodles.single.end, knotPosition(doc, metrics, PortRef.input('a')));
    });
  });

  group('straight noodles', () {
    test('locked ends get a horizontal piece, unlocked ends none', () {
      const connected = Noodle(Offset(0, 0), Offset(200, 100));
      final metrics = NoodlePainter.pathOf(connected).computeMetrics().toList();
      // Two 25 px pieces plus the diagonal between (150, 100).
      final length = metrics.fold(0.0, (sum, m) => sum + m.length);
      expect(length, moreOrLessEquals(25 + 25 + const Offset(150, 100).distance,
          epsilon: 0.01));

      const dragging =
          Noodle(Offset(0, 0), Offset(200, 100), endLocked: false);
      final dragLength = NoodlePainter.pathOf(dragging)
          .computeMetrics()
          .fold(0.0, (sum, m) => sum + m.length);
      expect(dragLength,
          moreOrLessEquals(25 + const Offset(175, 100).distance, epsilon: 0.01));
    });

    test('straight is the default style', () {
      expect(const Preferences().noodleStyle, NoodleStyle.straight);
    });
  });

  testWidgets(
      'dragging from the origin knot onto a node body connects them, '
      'and undo removes the connection', (tester) async {
    final container = await pumpApp(tester);
    // Both nodes in view: the origin on the left, the new node on the right.
    container.read(documentProvider.notifier).apply('Move',
        (d) => d.moveNodes({kOriginNodeId: const Position(-450, -250)}));
    final id = container.read(graphEditorProvider).addVideoNode(
        const Position(0, -250),
        type: DefaultNodeType.simpleVideo);
    await tester.pumpAndSettle();

    final knot = find.byWidgetPredicate((w) => w is Knot && w.port == originOut);
    final gesture = await tester.startGesture(tester.getCenter(knot),
        kind: PointerDeviceKind.mouse);
    final target = tester.getCenter(find.text(kNoVideo));
    final start = tester.getCenter(knot);
    for (var i = 1; i <= 10; i++) {
      await gesture.moveTo(Offset.lerp(start, target, i / 10)!);
      await tester.pump();
    }
    expect(container.read(potentialConnectionProvider),
        (from: originOut, to: PortRef.input(id)));
    await gesture.up();
    await tester.pumpAndSettle();

    expect(container.read(projectDocumentProvider).edgeFrom(originOut)?.to,
        PortRef.input(id));

    container.read(documentProvider.notifier).undo();
    await tester.pumpAndSettle();
    expect(container.read(projectDocumentProvider).edgeFrom(originOut), isNull);
  });
}
