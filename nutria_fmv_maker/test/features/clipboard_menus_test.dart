import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart' show TextField;
import 'package:nutria_fmv_maker/core/document/position.dart';
import 'package:nutria_fmv_maker/features/canvas/widgets/canvas_view.dart';
import 'package:nutria_fmv_maker/features/preferences/providers/preferences_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:nutria_fmv_maker/features/project/providers/graph_editor.dart';
import 'package:nutria_fmv_maker/services/clipboard_service.dart';

import 'app_tester.dart';
import 'clipboard_test.dart' show MemoryClipboard;

void main() {
  testWidgets('a node menu offers Copy, and Paste only once nodes are copied', (
    tester,
  ) async {
    final clipboard = MemoryClipboard();
    final c = await pumpApp(
      tester,
      overrides: [clipboardServiceProvider.overrideWithValue(clipboard)],
    );
    c
        .read(graphEditorProvider)
        .addVideoNode(Position.zero, type: DefaultNodeType.simpleVideo);
    await tester.pumpAndSettle();
    final node = tester.getCenter(find.text(kNoVideo));

    await rightClickAt(tester, node);
    expect(find.text('Copy'), findsOneWidget);
    expect(find.text('Paste'), findsNothing, reason: 'nothing copied yet');
    await tester.tap(find.text('Copy'));
    await tester.pumpAndSettle();

    await rightClickAt(tester, node);
    expect(find.text('Paste'), findsOneWidget);
  });

  testWidgets('the origin node offers no Copy or Duplicate', (tester) async {
    await pumpApp(tester, startView: true);
    // The view starts centered on the origin node.
    await rightClickAt(tester, tester.getCenter(find.byType(CanvasView)));
    expect(find.text('Copy'), findsNothing);
    expect(find.text('Duplicate'), findsNothing);
  });

  testWidgets('Ctrl+V in a text field pastes text, not nodes', (tester) async {
    final clipboard = MemoryClipboard();
    final c = await pumpApp(
      tester,
      overrides: [clipboardServiceProvider.overrideWithValue(clipboard)],
    );
    c
        .read(graphEditorProvider)
        .addVideoNode(Position.zero, type: DefaultNodeType.branchedVideo);
    await tester.pumpAndSettle();
    // Nodes on the clipboard, copied earlier.
    final editor = c.read(graphEditorProvider);
    editor.selectAll();
    await editor.copySelection();
    expect(clipboard.text, contains('nutriaFmvNodes'));
    final nodesBefore = c.read(projectDocumentProvider).nodes.length;

    final field = find
        .ancestor(of: find.text('Option 1'), matching: find.byType(TextField))
        .first;
    await tester.tap(field);
    await tester.pumpAndSettle();
    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyV);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await tester.pumpAndSettle();
    expect(
      c.read(projectDocumentProvider).nodes,
      hasLength(nodesBefore),
      reason: 'the app did not paste nodes',
    );
  });
}
