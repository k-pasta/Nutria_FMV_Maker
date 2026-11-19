import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart' show Icon, TextField;
import 'package:nutria_fmv_maker/core/document/edge.dart';
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/core/document/position.dart';
import 'package:nutria_fmv_maker/core/document/variable.dart';
import 'package:nutria_fmv_maker/core/graph/ports.dart';
import 'package:nutria_fmv_maker/features/nodes/widgets/knot.dart';
import 'package:nutria_fmv_maker/features/nodes/widgets/logic_node_views.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:nutria_fmv_maker/features/project/providers/graph_editor.dart';

import 'package:nutria_fmv_protocol/nutria_fmv_protocol.dart';

import 'app_tester.dart';

void main() {
  testWidgets('the canvas menu adds a Math node; its variable is '
      'picked by searching', (tester) async {
    final c = await pumpApp(tester);
    c
        .read(documentProvider.notifier)
        .apply(
          'variables',
          (d) => d.copyWith(
            variables: const [
              Variable.integer(id: 'c', name: 'coins'),
              Variable.boolean(id: 'k', name: 'has_key'),
            ],
          ),
        );
    await rightClickAt(tester, kCanvasPoint);
    await tester.tap(find.text('Math'));
    await tester.pumpAndSettle();
    expect(find.text('Set Variable'), findsOneWidget, reason: 'its title');
    final caution = find.byType(LogicIssueMark);
    expect(
      find.descendant(of: caution, matching: find.byType(Icon)),
      findsOneWidget,
      reason: 'no variable yet: a caution sign on the strip',
    );

    await tester.tap(find.text('Pick a Variable…'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, 'key');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    final node = c
        .read(projectDocumentProvider)
        .nodes
        .values
        .whereType<ChangeVariableNode>()
        .single;
    expect(node.variableId, 'k');
    expect(node.value, 'true', reason: 'a true/false variable starts true');
    expect(find.text('has_key'), findsOneWidget);
    expect(
      find.descendant(of: caution, matching: find.byType(Icon)),
      findsNothing,
    );
  });

  testWidgets('a compare node keeps its True and False knots level with '
      'their rows', (tester) async {
    final c = await pumpApp(tester);
    final editor = c.read(graphEditorProvider);
    final id = editor.addCompareNode(const Position(-100, -250));
    editor.addCondition(id);
    await tester.pumpAndSettle();

    for (final (port, label) in [
      (kTruePortKey, 'True'),
      (kFalsePortKey, 'False'),
    ]) {
      final knot = find.byWidgetPredicate(
        (w) => w is Knot && w.port == PortRef(nodeId: id, port: port),
      );
      expect(
        tester.getCenter(knot).dy,
        moreOrLessEquals(tester.getCenter(find.text(label)).dy, epsilon: 1),
        reason: label,
      );
    }
    // Two conditions: All/Any can be switched.
    await tester.tap(find.text('All Must Hold'));
    await tester.pumpAndSettle();
    expect(
      (c.read(projectDocumentProvider).nodes[id] as CompareNode).matchAny,
      isTrue,
    );
  });

  test('comparisons show the signs people write', () {
    expect(
      [for (final c in FmvComparison.values) comparisonSymbol(c)],
      containsAll(['=', '≠', '≥', '≤', '>', '<']),
    );
  });

  testWidgets('a compare condition takes three rows, with its x after the '
      'value', (tester) async {
    final c = await pumpApp(tester);
    final editor = c.read(graphEditorProvider);
    final id = editor.addCompareNode(const Position(-100, -250));
    editor.addCondition(id);
    await tester.pumpAndSettle();
    final remove = find.byTooltip('Remove this condition');
    expect(remove, findsNWidgets(2));
    final value = find.text('Value…');
    expect(
      tester.getCenter(remove.first).dy,
      moreOrLessEquals(tester.getCenter(value.first).dy, epsilon: 4),
      reason: 'the x is on the value row (text sits a little lower)',
    );
    expect(c.read(projectDocumentProvider).nodes[id], isA<CompareNode>());
  });
}
