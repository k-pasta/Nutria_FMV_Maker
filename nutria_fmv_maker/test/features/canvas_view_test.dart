import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/features/canvas/providers/canvas_view_provider.dart';
import 'package:nutria_fmv_maker/features/canvas/widgets/canvas_view.dart';
import 'package:nutria_fmv_maker/features/nodes/node_bounds.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';

import 'app_tester.dart';

/// The canvas viewport starts below the menu bar.
Offset viewportPoint(WidgetTester tester, Offset global) =>
    global - tester.getTopLeft(find.byType(CanvasView));

void main() {
  testWidgets('the view starts on the origin node, centered at 100%',
      (tester) async {
    final container = await pumpApp(tester, startView: true);
    final view = container.read(canvasViewProvider);
    final origin = container.read(projectDocumentProvider).origin;
    final rect = container.read(nodeBoundsProvider).rectOf(origin);
    expect(view.scale, 1);
    expect(view.center.dx, moreOrLessEquals(rect.center.dx, epsilon: 1e-6));
    expect(view.center.dy, moreOrLessEquals(rect.center.dy, epsilon: 1e-6));
  });

  testWidgets('the mouse wheel zooms around the pointer', (tester) async {
    final container = await pumpApp(tester);
    final view = container.read(canvasViewProvider);
    final underPointer =
        view.toCanvasPosition(viewportPoint(tester, kCanvasPoint));

    await scrollAt(tester, kCanvasPoint, up: true);
    expect(view.scale, greaterThan(1));
    final after = view.toCanvasPosition(viewportPoint(tester, kCanvasPoint));
    expect(after.dx, moreOrLessEquals(underPointer.dx, epsilon: 1e-6));
    expect(after.dy, moreOrLessEquals(underPointer.dy, epsilon: 1e-6));

    await scrollAt(tester, kCanvasPoint, up: false);
    await scrollAt(tester, kCanvasPoint, up: false);
    expect(view.scale, lessThan(1));
  });

  testWidgets('keyboard zoom and arrow-key panning', (tester) async {
    final container = await pumpApp(tester);
    final view = container.read(canvasViewProvider);
    await tester.sendKeyEvent(LogicalKeyboardKey.equal);
    expect(view.scale, greaterThan(1));

    final before = view.toCanvasPosition(Offset.zero);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    expect(view.toCanvasPosition(Offset.zero).dx, greaterThan(before.dx));
  });

  testWidgets('right-clicking the canvas adds a node where clicked',
      (tester) async {
    final container = await pumpApp(tester);
    final before = container.read(projectDocumentProvider).nodes.length;

    await rightClickAt(tester, kCanvasPoint);
    await tester.tap(find.text('Branching Video'));
    await tester.pumpAndSettle();

    final nodes = container.read(projectDocumentProvider).nodes.values;
    expect(nodes.length, before + 1);
    final added = nodes.whereType<BranchedVideoNode>().single;
    final clicked = container
        .read(canvasViewProvider)
        .toCanvasPosition(viewportPoint(tester, kCanvasPoint));
    // The visible corner (inside the node's padding) is at the click.
    expect(added.position.x + 30, moreOrLessEquals(clicked.dx, epsilon: 1e-6));
    expect(added.position.y + 30, moreOrLessEquals(clicked.dy, epsilon: 1e-6));
  });
}
