import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart' show TextField;
import 'package:nutria_fmv_maker/core/document/position.dart';
import 'package:nutria_fmv_maker/features/preferences/providers/preferences_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/graph_editor.dart';
import 'package:nutria_fmv_maker/features/shell/providers/panel_layout_provider.dart';

import 'app_tester.dart';

void main() {
  testWidgets('shortcuts work again after typing in a node and clicking away', (
    tester,
  ) async {
    final container = await pumpApp(tester);
    container
        .read(graphEditorProvider)
        .addVideoNode(
          const Position(-100, -300),
          type: DefaultNodeType.branchedVideo,
        );
    await tester.pumpAndSettle();

    final field = find.ancestor(
      of: find.text('Option 1'),
      matching: find.byType(TextField),
    );
    await tester.tap(field);
    await tester.enterText(field, 'Go left');
    await tester.pumpAndSettle();

    // Typing "t" in the field must not toggle the panel...
    await tester.sendKeyEvent(LogicalKeyboardKey.keyT);
    await tester.pump();
    expect(container.read(panelLayoutProvider).leftClosed, isFalse);

    // ...but after clicking the canvas, T is a shortcut again.
    await tester.tapAt(const Offset(800, 800));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.keyT);
    await tester.pump();
    expect(container.read(panelLayoutProvider).leftClosed, isTrue);
  });

  testWidgets('shortcuts work after the focused node is deleted', (
    tester,
  ) async {
    final container = await pumpApp(tester);
    final editor = container.read(graphEditorProvider);
    final id = editor.addVideoNode(
      const Position(-100, -300),
      type: DefaultNodeType.branchedVideo,
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.ancestor(
        of: find.text('Option 1'),
        matching: find.byType(TextField),
      ),
    );
    await tester.pumpAndSettle();

    editor.removeNodeOrSelection(id);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.keyT);
    await tester.pump();
    expect(container.read(panelLayoutProvider).leftClosed, isTrue);
  });
}
