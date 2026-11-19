import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart' show TextField;
import 'package:nutria_fmv_maker/core/document/variable.dart';
import 'package:nutria_fmv_maker/core/document/video_settings.dart';
import 'package:nutria_fmv_maker/features/preferences/providers/preferences_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:nutria_fmv_maker/features/project/providers/graph_editor.dart';
import 'package:nutria_fmv_maker/features/shell/providers/panel_layout_provider.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_number_field.dart';

import 'app_tester.dart';

void main() {
  Future<void> tapArrow(
    WidgetTester tester,
    Finder field, {
    required bool up,
  }) => tester.tapAt(
    up
        ? tester.getRect(field).centerRight - const Offset(8, 0)
        : tester.getRect(field).centerLeft + const Offset(8, 0),
  );

  testWidgets('a variable number: pick the type by right-click, step, type', (
    tester,
  ) async {
    final c = await pumpApp(tester);
    c
        .read(panelLayoutProvider.notifier)
        .showSection(LeftPanelSection.variables);
    c.read(graphEditorProvider).addVariable('variable');
    await tester.pumpAndSettle();
    Variable variable() => c.read(variablesProvider).single;

    await rightClickAt(tester, tester.getCenter(find.text('Bool')));
    await tester.tap(find.text('Float'));
    await tester.pumpAndSettle();
    expect(variable(), isA<DecimalVariable>());

    final field = find.byType(NutriaNumberField);
    await tapArrow(tester, field, up: true);
    await tapArrow(tester, field, up: true);
    await tapArrow(tester, field, up: true);
    await tapArrow(tester, field, up: false);
    await tester.pumpAndSettle();
    expect((variable() as DecimalVariable).initial, 0.2);

    await tester.enterText(
      find.descendant(of: field, matching: find.byType(TextField)),
      '-3,5',
    );
    await tester.pumpAndSettle();
    expect((variable() as DecimalVariable).initial, -3.5);
  });

  testWidgets('selection time: type seconds or step; options by right-click', (
    tester,
  ) async {
    final c = await pumpApp(tester);
    c
        .read(panelLayoutProvider.notifier)
        .showSection(LeftPanelSection.projectSettings);
    await tester.pumpAndSettle();
    VideoSettings settings() => c.read(projectSettingsProvider);

    final field = find.byType(NutriaNumberField);
    expect(find.text('6.00'), findsOneWidget);
    await tapArrow(tester, field, up: true);
    await tester.pumpAndSettle();
    expect(settings().selectionTimeMs, 7000);
    await tester.enterText(
      find.descendant(of: field, matching: find.byType(TextField)),
      '2,5',
    );
    await tester.pumpAndSettle();
    expect(settings().selectionTimeMs, 2500);

    await rightClickAt(tester, tester.getCenter(find.text('Fit')));
    await tester.tap(find.text('Stretch'));
    await tester.pumpAndSettle();
    expect(settings().videoFit, VideoFit.stretch);
  });

  testWidgets('preferences list their values on right-click', (tester) async {
    final c = await pumpApp(tester);
    c
        .read(panelLayoutProvider.notifier)
        .showSection(LeftPanelSection.preferences);
    await tester.pumpAndSettle();
    await rightClickAt(tester, tester.getCenter(find.text('50')));
    await tester.tap(find.text('200'));
    await tester.pumpAndSettle();
    expect(c.read(preferencesProvider).gridSize, 200);
  });
}
