import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/core/document/position.dart';
import 'package:nutria_fmv_maker/core/document/variable.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:nutria_fmv_maker/features/project/providers/graph_editor.dart';
import 'package:nutria_fmv_maker/ui/text/expression_text.dart';

import 'app_tester.dart';

void main() {
  test('completion finds the shortest name the typed word starts', () {
    const names = ['coins', 'coin_bonus', 'has_key'];
    expect(completionAt('1 + co', 6, names), (4, 'coins'));
    expect(completionAt('1 + Has', 7, names), (4, 'has_key'));
    expect(completionAt('coins', 5, names), isNull, reason: 'already whole');
    expect(completionAt('1 + 2', 5, names), isNull);
    expect(completionAt('', 0, names), isNull);
  });

  testWidgets('Tab completes a variable in a value; the text is coloured', (
    tester,
  ) async {
    final c = await pumpApp(tester);
    c
        .read(documentProvider.notifier)
        .apply(
          'variables',
          (d) => d.copyWith(
            variables: const [Variable.integer(id: 'c', name: 'coins')],
          ),
        );
    final editor = c.read(graphEditorProvider);
    final id = editor.addChangeNode(const Position(-100, -100));
    editor.setChangeVariable(id, 'c');
    await tester.pumpAndSettle();

    final field = find.ancestor(
      of: find.text('New value…'),
      matching: find.byType(TextField),
    );
    await tester.enterText(field, 'coi');
    await tester.pumpAndSettle();
    final editable = tester.widget<EditableText>(
      find.descendant(of: field, matching: find.byType(EditableText)),
    );
    final controller = editable.controller as ExpressionTextEditingController;
    // The completion is shown faintly after the cursor.
    final span = controller.buildTextSpan(
      context: tester.element(field),
      withComposing: false,
    );
    expect(span.toPlainText(), 'coins');

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();
    final node =
        c.read(projectDocumentProvider).nodes[id] as ChangeVariableNode;
    expect(node.value, 'coins');
  });
}
