import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart' show TextField;
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/core/document/position.dart';
import 'package:nutria_fmv_maker/features/nodes/widgets/knot.dart';
import 'package:nutria_fmv_maker/features/preferences/providers/preferences_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:nutria_fmv_maker/features/project/providers/graph_editor.dart';
import 'package:nutria_fmv_maker/features/selection/providers/selection_provider.dart';

import 'app_tester.dart';

/// Adds a node at canvas (0, 0), the middle of the screen.
Future<String> addNode(WidgetTester tester, ProviderContainer container,
    {DefaultNodeType type = DefaultNodeType.simpleVideo}) async {
  final id = container
      .read(graphEditorProvider)
      .addVideoNode(Position.zero, type: type);
  await tester.pumpAndSettle();
  return id;
}

Node nodeOf(ProviderContainer container, String id) =>
    container.read(projectDocumentProvider).nodes[id]!;

void main() {
  testWidgets('nodes appear on the canvas', (tester) async {
    final container = await pumpApp(tester);
    await addNode(tester, container);
    expect(find.text('No Video'), findsOneWidget);
    expect(find.text('Convert to Branching Node'), findsOneWidget);
  });

  testWidgets('clicking a node selects it, clicking the canvas deselects',
      (tester) async {
    final container = await pumpApp(tester);
    final id = await addNode(tester, container);

    await tester.tap(find.text('No Video'));
    await tester.pumpAndSettle();
    expect(container.read(selectionProvider).selected, {id});

    await tester.tapAt(const Offset(800, 150));
    await tester.pumpAndSettle();
    expect(container.read(selectionProvider).selected, isEmpty);
  });

  testWidgets("using a node's text field or buttons selects the node",
      (tester) async {
    final container = await pumpApp(tester);
    final id = await addNode(tester, container,
        type: DefaultNodeType.branchedVideo);
    expect(container.read(selectionProvider).selected, isEmpty);

    await tester.tap(find.ancestor(
        of: find.text('Option 1'), matching: find.byType(TextField)));
    await tester.pumpAndSettle();
    expect(container.read(selectionProvider).selected, {id});
  });

  testWidgets('dragging a node moves it, and undo puts it back in one step',
      (tester) async {
    final container = await pumpApp(tester);
    final id = await addNode(tester, container);
    if (container.read(preferencesProvider).gridSnapping) {
      container.read(preferencesProvider.notifier).toggleGridSnapping();
    }

    final gesture = await tester.startGesture(
        tester.getCenter(find.text('No Video')),
        kind: PointerDeviceKind.mouse);
    for (var i = 0; i < 10; i++) {
      await gesture.moveBy(const Offset(10, 5));
      await tester.pump();
    }
    await gesture.up();
    await tester.pumpAndSettle();

    // The first few pixels are the drag threshold.
    final moved = nodeOf(container, id).position;
    expect(moved.x, greaterThan(80));
    expect(moved.y, greaterThan(35));

    container.read(documentProvider.notifier).undo();
    await tester.pumpAndSettle();
    expect(nodeOf(container, id).position, Position.zero);
  });

  testWidgets('dragging the right edge resizes the node', (tester) async {
    final container = await pumpApp(tester);
    final id = await addNode(tester, container);
    final edge = tester.getTopRight(find.text('No Video'));
    // The file name is centered; aim at the node's right border instead.
    final nodeRight = tester.getCenter(find.text('No Video')).dx +
        kDefaultNodeWidth / 2 -
        2;
    await tester.dragFrom(
        Offset(nodeRight, edge.dy), const Offset(100, 0),
        kind: PointerDeviceKind.mouse);
    await tester.pumpAndSettle();
    expect(nodeOf(container, id).width, greaterThan(kDefaultNodeWidth + 50));
  });

  testWidgets('a branched node has a knot per choice plus its input',
      (tester) async {
    final container = await pumpApp(tester);
    await addNode(tester, container, type: DefaultNodeType.branchedVideo);
    // Origin output + branched input + 2 choices.
    expect(find.byType(Knot), findsNWidgets(4));
    expect(find.text('Option 3'), findsOneWidget); // the empty typing row

    await tester.enterText(
        find.ancestor(
            of: find.text('Option 3'), matching: find.byType(TextField)),
        'Run');
    await tester.pumpAndSettle();
    expect(find.byType(Knot), findsNWidgets(5));
  });
}
