import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart' show Icons;
import 'package:nutria_fmv_maker/core/document/position.dart';
import 'package:nutria_fmv_maker/core/document/project_document.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:nutria_fmv_maker/features/project/providers/graph_editor.dart';
import 'package:nutria_fmv_maker/features/shell/providers/panel_layout_provider.dart';

import 'app_tester.dart';

void main() {
  testWidgets('+ adds defaults for the next color, in their own group', (
    tester,
  ) async {
    final c = await pumpApp(tester);
    c
        .read(panelLayoutProvider.notifier)
        .showSection(LeftPanelSection.projectSettings);
    await tester.pumpAndSettle();
    expect(find.text('Defaults'), findsWidgets);
    expect(find.text('Color 2'), findsNothing, reason: 'no groups yet');

    await tester.tap(find.byTooltip('Add defaults for color 2'));
    await tester.pumpAndSettle();
    expect(find.text('Color 1 and colors without their own'), findsOneWidget);
    expect(find.text('Color 2'), findsOneWidget);
    expect(c.read(colorDefaultsProvider).keys, [1]);

    // A node of color 2 follows that group.
    final editor = c.read(graphEditorProvider);
    final id = editor.addVideoNode(const Position(200, 0));
    editor.setSwatch(id, 1);
    editor.editDefaults(1, (s) => s.copyWith(selectionTimeMs: 1234));
    expect(c.read(effectiveSettingsProvider(id)).selectionTimeMs, 1234);
    expect(c.read(projectSettingsProvider).selectionTimeMs, isNot(1234));

    await tester.tap(find.byTooltip('Remove the defaults of color 2'));
    await tester.pumpAndSettle();
    expect(find.text('Color 2'), findsNothing);
    expect(
      c.read(effectiveSettingsProvider(id)).selectionTimeMs,
      c.read(projectSettingsProvider).selectionTimeMs,
    );

    c.read(documentProvider.notifier).undo();
    expect(c.read(colorDefaultsProvider).keys, [1]);
  });

  testWidgets('the + button hides once every color has defaults', (
    tester,
  ) async {
    final c = await pumpApp(tester);
    c
        .read(panelLayoutProvider.notifier)
        .showSection(LeftPanelSection.projectSettings);
    for (var i = 0; i < kMaxColorDefaults; i++) {
      c.read(graphEditorProvider).addColorDefaults();
    }
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.add), findsNothing);
  });

  testWidgets('node color squares mark colors with their own defaults', (
    tester,
  ) async {
    final c = await pumpApp(tester);
    final editor = c.read(graphEditorProvider);
    final id = editor.addVideoNode(const Position(200, 0));
    editor.toggleExpanded(id);
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.more_horiz), findsNothing);

    editor.addColorDefaults();
    editor.addColorDefaults();
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.more_horiz), findsNWidgets(2));
  });
}
