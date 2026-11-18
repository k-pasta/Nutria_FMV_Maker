import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/core/document/position.dart';
import 'package:nutria_fmv_maker/features/preferences/providers/preferences_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:nutria_fmv_maker/features/project/providers/graph_editor.dart';
import 'package:nutria_fmv_maker/ui/text/markdown_text.dart';

import 'app_tester.dart';

void main() {
  test('markdownSpan styles the text and keeps or drops the markers', () {
    const base = TextStyle(fontSize: 10);
    final editing = markdownSpan('a **b**', base, markerColor: Colors.grey);
    final spans = editing.children!.cast<TextSpan>();
    expect(spans.map((s) => s.text), ['a ', '**', 'b', '**']);
    expect(spans[2].style!.fontWeight, FontWeight.bold);
    expect(spans[1].style!.color, Colors.grey);
    final shown = markdownSpan('a **b**', base);
    expect(shown.toPlainText(), 'a b');
  });

  testWidgets('Ctrl+B in a choice makes the selection bold', (tester) async {
    final c = await pumpApp(tester);
    final id = c
        .read(graphEditorProvider)
        .addVideoNode(
          const Position(-100, -200),
          type: DefaultNodeType.branchedVideo,
        );
    await tester.pumpAndSettle();
    final field = find.ancestor(
      of: find.text('Option 1'),
      matching: find.byType(TextField),
    );
    await tester.enterText(field, 'Go left');
    await tester.pumpAndSettle();
    final editable = tester.widget<EditableText>(
      find.descendant(of: field, matching: find.byType(EditableText)),
    );
    expect(editable.controller, isA<MarkdownTextEditingController>());
    editable.controller.selection = const TextSelection(
      baseOffset: 3,
      extentOffset: 7,
    );

    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyB);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await tester.pumpAndSettle();
    final node = c.read(projectDocumentProvider).nodes[id] as BranchedVideoNode;
    expect(node.choices.first.text, 'Go **left**');
    expect(
      editable.controller.selection,
      const TextSelection(baseOffset: 5, extentOffset: 9),
    );
  });
}
