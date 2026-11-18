import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart' show InputBorder, TextField;
import 'package:nutria_fmv_maker/core/document/edge.dart';
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/core/document/position.dart';
import 'package:nutria_fmv_maker/core/document/project_document.dart';
import 'package:nutria_fmv_maker/core/graph/graph_ops.dart';
import 'package:nutria_fmv_maker/core/graph/ports.dart';
import 'package:nutria_fmv_maker/core/protocol/fmv_exporter.dart';
import 'package:nutria_fmv_maker/features/nodes/widgets/knot.dart';
import 'package:nutria_fmv_maker/features/preferences/providers/preferences_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:nutria_fmv_maker/features/project/providers/graph_editor.dart';
import 'package:nutria_fmv_maker/features/selection/providers/selection_provider.dart';

import 'app_tester.dart';

/// The in-place name editor (the only field with autofocus in a strip).
Finder renameField() => find.byWidgetPredicate(
    (w) => w is TextField && w.decoration?.border == InputBorder.none);

void main() {
  Node nodeOf(c, String id) => c.read(projectDocumentProvider).nodes[id]!;

  testWidgets('F2 renames the selected node in place; Escape cancels',
      (tester) async {
    final c = await pumpApp(tester);
    final id = c.read(graphEditorProvider).addVideoNode(Position.zero);
    c.read(selectionProvider.notifier).selectOnly(id);
    await tester.pumpAndSettle();

    await tester.sendKeyEvent(LogicalKeyboardKey.f2);
    await tester.pumpAndSettle();
    await tester.enterText(renameField(), 'Intro');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(nodeOf(c, id).name, 'Intro');
    expect(find.text('Intro'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.f2);
    await tester.pumpAndSettle();
    await tester.enterText(renameField(), 'Nope');
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(nodeOf(c, id).name, 'Intro', reason: 'Escape restores the name');

    // An empty name removes it; renaming is one undo step.
    await tester.sendKeyEvent(LogicalKeyboardKey.f2);
    await tester.pumpAndSettle();
    await tester.enterText(renameField(), '');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(nodeOf(c, id).name, isNull);
    c.read(documentProvider.notifier).undo();
    expect(nodeOf(c, id).name, 'Intro');
  });

  testWidgets('the origin shows "Origin Node" when it has no name',
      (tester) async {
    final c = await pumpApp(tester);
    expect(nodeOf(c, kOriginNodeId).name, isNull);
    expect(find.text('Origin Node'), findsOneWidget);
    await tester.tap(find.text('Origin Node'));
    await tester.pumpAndSettle();
    // A double-click on the strip renames it.
    await tester.tap(find.text('Origin Node'));
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(find.text('Origin Node'));
    await tester.pumpAndSettle();
    await tester.enterText(renameField(), 'Start');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(nodeOf(c, kOriginNodeId).name, 'Start');
  });

  testWidgets('Ctrl+Delete disconnects the selected nodes', (tester) async {
    final c = await pumpApp(tester);
    final editor = c.read(graphEditorProvider);
    final a = editor.addVideoNode(const Position(-200, 0),
        type: DefaultNodeType.simpleVideo);
    final b = editor.addVideoNode(const Position(200, 0),
        type: DefaultNodeType.simpleVideo);
    c.read(documentProvider.notifier).apply('connect', (d) => d
        .connect(const PortRef(nodeId: kOriginNodeId, port: kNextPortKey),
            PortRef.input(a))
        .connect(PortRef(nodeId: a, port: kNextPortKey), PortRef.input(b)));
    c.read(selectionProvider.notifier).selectOnly(a);
    await tester.pumpAndSettle();
    expect(c.read(projectDocumentProvider).edges, hasLength(2));

    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.delete);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await tester.pumpAndSettle();
    expect(c.read(projectDocumentProvider).edges, isEmpty);
    expect(c.read(projectDocumentProvider).nodes, contains(a),
        reason: 'disconnects, does not delete');
  });

  testWidgets('Alt+drag on a node pulls its first free output',
      (tester) async {
    final c = await pumpApp(tester);
    final editor = c.read(graphEditorProvider);
    final a = editor.addVideoNode(const Position(-300, -100),
        type: DefaultNodeType.simpleVideo);
    final b = editor.addVideoNode(const Position(150, -100),
        type: DefaultNodeType.simpleVideo);
    await tester.pumpAndSettle();
    final names = find.text(kNoVideo);
    final from = tester.getCenter(names.at(0));
    final to = tester.getCenter(names.at(1));

    await tester.sendKeyDownEvent(LogicalKeyboardKey.altLeft);
    final gesture =
        await tester.startGesture(from, kind: PointerDeviceKind.mouse);
    for (var i = 1; i <= 10; i++) {
      await gesture.moveTo(Offset.lerp(from, to, i / 10)!);
      await tester.pump();
    }
    await gesture.up();
    await tester.sendKeyUpEvent(LogicalKeyboardKey.altLeft);
    await tester.pumpAndSettle();

    final doc = c.read(projectDocumentProvider);
    expect(doc.edgeFrom(PortRef(nodeId: a, port: kNextPortKey))?.to,
        PortRef.input(b));
    expect(doc.nodes[a]!.position, const Position(-300, -100),
        reason: 'the node did not move');
  });

  testWidgets('a question row sits above the choices and is exported',
      (tester) async {
    final c = await pumpApp(tester);
    final editor = c.read(graphEditorProvider);
    final id = editor.addVideoNode(const Position(-100, -350),
        type: DefaultNodeType.branchedVideo);
    editor.setQuestionEnabled(id, true);
    await tester.pumpAndSettle();
    final question = find.ancestor(
        of: find.text('Question above the choices'),
        matching: find.byType(TextField));
    await tester.enterText(question.first, 'Which door?');
    await tester.pumpAndSettle();

    final node = nodeOf(c, id) as BranchedVideoNode;
    expect(node.question, 'Which door?');
    // The first choice's knot is level with its field, below the question.
    final knot = find.byWidgetPredicate((w) =>
        w is Knot && w.port == PortRef(nodeId: id, port: node.choices[0].id));
    final field = find.ancestor(
        of: find.text('Option 1'), matching: find.byType(TextField));
    expect(tester.getCenter(knot).dy,
        moreOrLessEquals(tester.getCenter(field).dy, epsilon: 0.5));

    c.read(documentProvider.notifier).apply('connect', (d) => d.connect(
        const PortRef(nodeId: kOriginNodeId, port: kNextPortKey),
        PortRef.input(id)));
    final exported = exportFmv(c.read(projectDocumentProvider)).project;
    expect(exported.nodes['001']!.question, 'Which door?');
  });
}
