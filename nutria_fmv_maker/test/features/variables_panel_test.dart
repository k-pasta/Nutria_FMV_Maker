import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart' show TextField;
import 'package:nutria_fmv_maker/core/document/variable.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:nutria_fmv_maker/features/shell/providers/panel_layout_provider.dart';

import 'app_tester.dart';

void main() {
  testWidgets('add, rename, retype and set a variable; undo steps back',
      (tester) async {
    final c = await pumpApp(tester);
    c.read(panelLayoutProvider.notifier).showSection(LeftPanelSection.variables);
    await tester.pumpAndSettle();
    expect(find.text('No variables yet. Add one with +.'), findsOneWidget);
    List<Variable> variables() => c.read(variablesProvider);

    await tester.tap(find.byTooltip('Add a variable'));
    await tester.pumpAndSettle();
    expect(variables().single,
        isA<BoolVariable>().having((v) => v.name, 'name', 'variable 1'));

    await tester.tap(find.text('False'));
    await tester.pumpAndSettle();
    expect((variables().single as BoolVariable).initial, isTrue);

    final name = find.ancestor(
        of: find.text('variable 1'), matching: find.byType(TextField));
    await tester.enterText(name.first, 'score');
    await tester.tap(find.text('Float'));
    await tester.pumpAndSettle();
    expect(variables().single,
        const Variable.decimal(id: 'x', name: 'score', initial: 1)
            .copyWith(id: variables().single.id));

    final value = find.ancestor(
        of: find.text('1.0'), matching: find.byType(TextField));
    await tester.enterText(value.first, '2.5');
    await tester.pumpAndSettle();
    expect((variables().single as DecimalVariable).initial, 2.5);

    // Done typing (a field being typed in keeps its text), then undo.
    await tester.tapAt(kCanvasPoint);
    await tester.pumpAndSettle();
    c.read(documentProvider.notifier).undo();
    await tester.pumpAndSettle();
    expect((variables().single as DecimalVariable).initial, 1);
    expect(find.text('1.0'), findsOneWidget, reason: 'the field follows undo');
  });

  testWidgets('a repeated name is flagged', (tester) async {
    final c = await pumpApp(tester);
    c.read(panelLayoutProvider.notifier).showSection(LeftPanelSection.variables);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Add a variable'));
    await tester.tap(find.byTooltip('Add a variable'));
    await tester.pumpAndSettle();
    expect(c.read(conflictingVariableNamesProvider), isEmpty);
    await tester.enterText(
        find.ancestor(of: find.text('variable 2'), matching: find.byType(TextField)).first,
        'variable 1');
    await tester.pumpAndSettle();
    expect(c.read(conflictingVariableNamesProvider), {'variable 1'});
    expect(find.byTooltip('Each variable needs its own name'), findsNWidgets(2));
  });
}
