import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart' show AspectRatio;
import 'package:nutria_fmv_maker/core/document/project_document.dart';
import 'package:nutria_fmv_maker/core/document/screen.dart';
import 'package:nutria_fmv_maker/core/graph/screen_ops.dart';
import 'package:nutria_fmv_maker/core/protocol/fmv_exporter.dart';
import 'package:nutria_fmv_maker/core/serialization/nfmv_codec.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:nutria_fmv_maker/features/screens/providers/screens_provider.dart';
import 'package:nutria_fmv_maker/features/screens/widgets/screens_view.dart';

import '../core/fixtures.dart';
import 'app_tester.dart';

void main() {
  test('points snap to the middle and to other elements', () {
    const other = ScreenElement(
      id: 'o',
      kind: ScreenElementKind.quit,
      x: 0.3,
      y: 0.8,
    );
    final s = snapScreenPoint(0.495, 0.795, others: [other]);
    expect((s.x, s.y, s.guideX, s.guideY), (0.5, 0.8, 0.5, 0.8));
    final free = snapScreenPoint(0.42, 0.66, others: [other]);
    expect((free.x, free.guideX), (0.42, null));
  });

  test('the classic layout, styles and export', () {
    var doc = ProjectDocument.empty().applyClassicMenu(sequentialIds('e'));
    expect(doc.menuScreen.elements.map((e) => e.kind), [
      ScreenElementKind.title,
      ScreenElementKind.description,
      ScreenElementKind.start,
      ScreenElementKind.load,
      ScreenElementKind.settings,
      ScreenElementKind.quit,
    ]);
    doc = doc.editScreenStyle(
      'button',
      (s) => s.copyWith(textColor: 0xFFFF0000),
    );
    final start = doc.menuScreen.elements[2];
    expect(doc.styleOf(start).textColor, 0xFFFF0000);
    expect(doc.styleOf(doc.menuScreen.elements.first).id, 'heading');

    final exported = exportFmv(doc).project.menuScreen;
    expect(exported.elements, hasLength(6));
    expect(exported.elements[2].kind, 'start');
    expect(exported.elements[2].style.textColor, 0xFFFF0000);
    expect(NfmvCodec.decode(NfmvCodec.encode(doc)), doc);
    expect(
      exportFmv(
        ProjectDocument.empty(),
      ).project.toJson().containsKey('Screens'),
      isFalse,
      reason: 'nothing designed, nothing written',
    );
  });

  test('every screen has its elements; presets, styles and export', () {
    var doc = ProjectDocument.empty();
    final ids = sequentialIds('e');
    doc = doc.applyScreenPreset(ScreenPreset.bottomChoices, ids);
    final choices = doc.choiceScreen.elements.firstWhere(
      (e) => e.kind == ScreenElementKind.choices,
    );
    expect(doc.screenKindOf(choices.id), ScreenKind.choice);
    expect(doc.menuScreen.elements, isEmpty);

    // Element edits find the element on its screen.
    doc = doc
        .setScreenElementGap(choices.id, 0.03)
        .duplicateScreenStyle('button', 'mine', 'Mine')
        .setScreenElementStyle(choices.id, 'mine');
    expect(doc.screenElement(choices.id)!.gap, 0.03);
    expect(doc.usesOfStyle('mine'), 1);

    // Deleting a style gives its elements back their default.
    final deleted = doc.removeScreenStyle('mine');
    expect(deleted.styles.map((s) => s.id), isNot(contains('mine')));
    expect(deleted.screenElement(choices.id)!.styleId, isNull);
    expect(deleted.removeScreenStyle('button').styles, deleted.styles);

    final exported = exportFmv(doc).project;
    expect(exported.choiceScreen.elements.map((e) => e.kind), [
      'question',
      'choices',
      'timer',
    ]);
    expect(exported.choiceScreen.elements[1].gap, 0.03);
    expect(exported.menuScreen.isEmpty, isTrue);
    expect(NfmvCodec.decode(NfmvCodec.encode(doc)), doc);
  });

  testWidgets('the switch button opens the designer; the right panel picks '
      'the screen; a tray button dragged onto the stage lands there', (
    tester,
  ) async {
    final c = await pumpApp(tester);
    await tester.tap(find.byTooltip('Screen Designer (Ctrl+2)'));
    await tester.pumpAndSettle();
    expect(c.read(editorViewProvider), EditorView.screens);
    expect(find.byTooltip('Story Graph (Ctrl+1)'), findsOneWidget);

    await tester.tap(find.text('Choice Screen'));
    await tester.pumpAndSettle();
    expect(c.read(selectedScreenProvider), ScreenKind.choice);
    expect(find.text('+ Answers'), findsOneWidget);
    expect(find.text('+ Start'), findsNothing, reason: 'a main menu button');

    final stage = tester.getRect(
      find.descendant(
        of: find.byType(ScreensView),
        matching: find.byType(AspectRatio),
      ),
    );
    final target = stage.topLeft + Offset(stage.width / 4, stage.height / 4);
    final gesture = await tester.startGesture(
      tester.getCenter(find.text('+ Answers')),
      kind: PointerDeviceKind.mouse,
    );
    final from = tester.getCenter(find.text('+ Answers'));
    for (var i = 1; i <= 10; i++) {
      await gesture.moveTo(Offset.lerp(from, target, i / 10)!);
      await tester.pump();
    }
    await gesture.up();
    await tester.pumpAndSettle();
    final added = c.read(projectDocumentProvider).choiceScreen.elements.single;
    expect(added.kind, ScreenElementKind.choices);
    // The drop point is the feedback's top left, close to a quarter in.
    expect(added.x, closeTo(0.25, 0.08));
    expect(added.y, closeTo(0.25, 0.08));

    // A layout over existing elements asks first.
    await tester.tap(find.text('Answers Below'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Replace'));
    await tester.pumpAndSettle();
    expect(c.read(projectDocumentProvider).choiceScreen.elements, hasLength(3));
  });

  testWidgets('Ctrl+2 opens the designer; elements are added, dragged with '
      'snapping, and deleted', (tester) async {
    final c = await pumpApp(tester);
    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.digit2);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await tester.pumpAndSettle();
    expect(find.byType(ScreensView), findsOneWidget);
    expect(c.read(editorViewProvider), EditorView.screens);

    await tester.tap(find.text('+ Quit'));
    await tester.pumpAndSettle();
    final quit = find.descendant(
      of: find.byType(ScreensView),
      matching: find.text('Quit'),
    );
    expect(quit, findsOneWidget);

    // Dragging a little off the middle snaps back to it.
    final from = tester.getCenter(quit);
    final gesture = await tester.startGesture(
      from,
      kind: PointerDeviceKind.mouse,
    );
    for (var i = 1; i <= 5; i++) {
      await gesture.moveTo(from + Offset(1.5 * i, 40.0 * i));
      await tester.pump();
    }
    await gesture.up();
    await tester.pumpAndSettle();
    final element = c.read(projectDocumentProvider).menuScreen.elements.single;
    expect(element.x, 0.5);
    expect(element.y, greaterThan(0.6));

    await tester.sendKeyEvent(LogicalKeyboardKey.delete);
    await tester.pumpAndSettle();
    expect(c.read(projectDocumentProvider).menuScreen.elements, isEmpty);
  });
}
