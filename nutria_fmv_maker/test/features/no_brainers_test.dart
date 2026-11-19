import 'package:flutter_test/flutter_test.dart';
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/core/document/position.dart';
import 'package:nutria_fmv_maker/features/preferences/providers/preferences_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/graph_editor.dart';
import 'package:nutria_fmv_maker/features/shell/providers/panel_layout_provider.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_setting_row.dart';

import 'app_tester.dart';
import 'harness.dart';

void main() {
  for (final allowed in [false, true]) {
    test('a branched node keeps two answer slots when no-brainers are '
        '${allowed ? '' : 'not '}allowed', () async {
      final h = await Harness.create(
        preferences: Preferences(allowNoBrainers: allowed),
      );
      final editor = h.container.read(graphEditorProvider);
      final id = editor.addVideoNode(
        Position.zero,
        type: DefaultNodeType.branchedVideo,
      );
      BranchedVideoNode node() => h.document.nodes[id] as BranchedVideoNode;
      expect(node().choices, hasLength(2), reason: 'an empty node');
      editor.setChoiceText(id, 0, 'Go');
      editor.setChoiceText(id, 1, 'Stay');
      editor.setChoiceText(id, 1, '');
      expect(node().choices, hasLength(2));
    });
  }

  testWidgets('preferences are grouped; Allow No-Brainers toggles', (
    tester,
  ) async {
    final c = await pumpApp(tester);
    c
        .read(panelLayoutProvider.notifier)
        .showSection(LeftPanelSection.preferences);
    await tester.pumpAndSettle();
    for (final header in ['Appearance', 'Canvas', 'Story Logic', 'Media']) {
      expect(find.text(header), findsOneWidget);
    }
    final row = find.ancestor(
      of: find.text('Allow No-Brainers'),
      matching: find.byType(NutriaSettingRow),
    );
    await tester.tap(find.descendant(of: row, matching: find.text('No')));
    await tester.pumpAndSettle();
    expect(c.read(preferencesProvider).allowNoBrainers, isTrue);
  });
}
