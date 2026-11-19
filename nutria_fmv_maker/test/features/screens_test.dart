import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
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
