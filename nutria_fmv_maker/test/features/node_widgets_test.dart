import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart' show TextField, Widget;
import 'package:nutria_fmv_maker/core/document/edge.dart';
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/core/document/position.dart';
import 'package:nutria_fmv_maker/features/nodes/widgets/knot.dart';
import 'package:nutria_fmv_maker/features/nodes/widgets/node_frame.dart';
import 'package:nutria_fmv_maker/features/preferences/providers/preferences_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:nutria_fmv_maker/features/project/providers/graph_editor.dart';
import 'package:nutria_fmv_maker/features/selection/providers/selection_provider.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_number_field.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_setting_row.dart';

import 'app_tester.dart';

/// Adds a node at canvas (0, 0), the middle of the screen.
Future<String> addNode(
  WidgetTester tester,
  ProviderContainer container, {
  DefaultNodeType type = DefaultNodeType.simpleVideo,
}) async {
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
    expect(find.text(kNoVideo), findsOneWidget);
    expect(find.text('Convert to Branching Node'), findsOneWidget);
  });

  testWidgets('clicking a node selects it, clicking the canvas deselects', (
    tester,
  ) async {
    final container = await pumpApp(tester);
    final id = await addNode(tester, container);

    await tester.tap(find.text(kNoVideo));
    await tester.pumpAndSettle();
    expect(container.read(selectionProvider).selected, {id});

    await tester.tapAt(const Offset(800, 150));
    await tester.pumpAndSettle();
    expect(container.read(selectionProvider).selected, isEmpty);
  });

  testWidgets("using a node's text field or buttons selects the node", (
    tester,
  ) async {
    final container = await pumpApp(tester);
    final id = await addNode(
      tester,
      container,
      type: DefaultNodeType.branchedVideo,
    );
    expect(container.read(selectionProvider).selected, isEmpty);

    await tester.tap(
      find.ancestor(
        of: find.text('Option 1'),
        matching: find.byType(TextField),
      ),
    );
    await tester.pumpAndSettle();
    expect(container.read(selectionProvider).selected, {id});
  });

  testWidgets('dragging a node moves it, and undo puts it back in one step', (
    tester,
  ) async {
    final container = await pumpApp(tester);
    final id = await addNode(tester, container);
    if (container.read(preferencesProvider).gridSnapping) {
      container.read(preferencesProvider.notifier).toggleGridSnapping();
    }

    final gesture = await tester.startGesture(
      tester.getCenter(find.text(kNoVideo)),
      kind: PointerDeviceKind.mouse,
    );
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

  testWidgets('a node can also be dragged by its expanded settings', (
    tester,
  ) async {
    final container = await pumpApp(tester);
    final id = await addNode(tester, container);
    if (container.read(preferencesProvider).gridSnapping) {
      container.read(preferencesProvider.notifier).toggleGridSnapping();
    }
    container.read(graphEditorProvider).toggleExpanded(id);
    await tester.pumpAndSettle();

    final gesture = await tester.startGesture(
      tester.getCenter(find.text('Music')),
      kind: PointerDeviceKind.mouse,
    );
    for (var i = 0; i < 10; i++) {
      await gesture.moveBy(const Offset(10, 0));
      await tester.pump();
    }
    await gesture.up();
    await tester.pumpAndSettle();
    expect(nodeOf(container, id).position.x, greaterThan(80));
  });

  testWidgets('dragging a number field sideways changes it, not the node; '
      'one undo step', (tester) async {
    final container = await pumpApp(tester);
    // High up, so its settings are in the window.
    const at = Position(0, -400);
    final id = container
        .read(graphEditorProvider)
        .addVideoNode(at, type: DefaultNodeType.branchedVideo);
    container.read(graphEditorProvider).toggleExpanded(id);
    await tester.pumpAndSettle();
    final row = find.ancestor(
      of: find.text('Selection Time'),
      matching: find.byType(NutriaSettingRow),
    );
    final field = find.descendant(
      of: row,
      matching: find.byType(NutriaNumberField),
    );
    int seconds() =>
        container.read(effectiveSettingsProvider(id)).selectionTimeMs ~/ 1000;
    final before = seconds();

    final gesture = await tester.startGesture(
      tester.getCenter(field),
      kind: PointerDeviceKind.mouse,
    );
    for (var i = 0; i < 4; i++) {
      await gesture.moveBy(const Offset(6, 0));
      await tester.pump();
    }
    await gesture.up();
    await tester.pumpAndSettle();
    expect(seconds(), before + 3, reason: '24px is three steps');
    expect(nodeOf(container, id).position, at);

    container.read(documentProvider.notifier).undo();
    await tester.pumpAndSettle();
    expect(seconds(), before);
  });

  testWidgets('moving a node rebuilds no node content', (tester) async {
    final container = await pumpApp(tester);
    await addNode(tester, container);
    container
        .read(graphEditorProvider)
        .addVideoNode(const Position(-400, -200));
    await tester.pumpAndSettle();
    // Same widget instances afterwards means Flutter skipped rebuilding them.
    List<Widget> frames() => tester.widgetList(find.byType(NodeFrame)).toList();
    final before = frames();

    final gesture = await tester.startGesture(
      tester.getCenter(find.text(kNoVideo).first),
      kind: PointerDeviceKind.mouse,
    );
    for (var i = 0; i < 10; i++) {
      await gesture.moveBy(const Offset(10, 5));
      await tester.pump();
    }
    await gesture.up();
    await tester.pumpAndSettle();

    final after = frames();
    expect(after, hasLength(before.length));
    for (final frame in before) {
      expect(after.any((f) => identical(f, frame)), isTrue);
    }
  });

  testWidgets('dragging the right edge resizes the node', (tester) async {
    final container = await pumpApp(tester);
    final id = await addNode(tester, container);
    // The file name is centered; aim at the node's right border instead,
    // on the button row (the output knot is higher up, by the thumbnail).
    final nodeRight =
        tester.getCenter(find.text(kNoVideo)).dx + kDefaultNodeWidth / 2 - 2;
    final row = tester.getCenter(find.text('Convert to Branching Node')).dy;
    await tester.dragFrom(
      Offset(nodeRight, row),
      const Offset(100, 0),
      kind: PointerDeviceKind.mouse,
    );
    await tester.pumpAndSettle();
    expect(nodeOf(container, id).width, greaterThan(kDefaultNodeWidth + 50));
  });

  for (final name in ['a.mp4', 'Recording 2026-04-01 12-54-49 final v2.mp4']) {
    testWidgets('choice knots line up with their rows (file name "$name")', (
      tester,
    ) async {
      final container = await pumpApp(tester);
      final editor = container.read(graphEditorProvider);
      final video = editor.importFiles(['C:/v/$name']).single;
      final id = editor.addVideoNode(
        const Position(-100, -300),
        videoId: video,
        type: DefaultNodeType.branchedVideo,
      );
      await tester.pumpAndSettle();

      final node = nodeOf(container, id) as BranchedVideoNode;
      for (final (i, choice) in node.choices.indexed) {
        final knot = find.byWidgetPredicate(
          (w) => w is Knot && w.port == PortRef(nodeId: id, port: choice.id),
        );
        final field = find.ancestor(
          of: find.text('Option ${i + 1}'),
          matching: find.byType(TextField),
        );
        expect(
          tester.getCenter(knot).dy,
          moreOrLessEquals(tester.getCenter(field).dy, epsilon: 0.5),
        );
      }
    });
  }

  testWidgets("a simple node's input and output knots are level", (
    tester,
  ) async {
    final container = await pumpApp(tester);
    final id = await addNode(tester, container);
    Finder knot(String port) => find.byWidgetPredicate(
      (w) => w is Knot && w.port == PortRef(nodeId: id, port: port),
    );
    expect(
      tester.getCenter(knot(PortRef.inputPortKey)).dy,
      moreOrLessEquals(tester.getCenter(knot('next')).dy, epsilon: 0.01),
    );
  });

  testWidgets('a branched node has a knot per choice plus its input', (
    tester,
  ) async {
    final container = await pumpApp(tester);
    await addNode(tester, container, type: DefaultNodeType.branchedVideo);
    // Origin output + branched input + 2 choices.
    expect(find.byType(Knot), findsNWidgets(4));
    expect(find.text('Option 3'), findsOneWidget); // the empty typing row

    await tester.enterText(
      find.ancestor(
        of: find.text('Option 3'),
        matching: find.byType(TextField),
      ),
      'Run',
    );
    await tester.pumpAndSettle();
    expect(find.byType(Knot), findsNWidgets(5));
  });
}
