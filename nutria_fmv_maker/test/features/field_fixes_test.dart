import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart' show EditableText, TextField;
import 'package:nutria_fmv_maker/core/document/position.dart';
import 'package:nutria_fmv_maker/features/canvas/providers/canvas_view_provider.dart';
import 'package:nutria_fmv_maker/features/preferences/providers/preferences_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:nutria_fmv_maker/features/project/providers/graph_editor.dart';
import 'package:nutria_fmv_maker/features/shell/providers/overlay_provider.dart';
import 'package:nutria_fmv_maker/features/shell/providers/panel_layout_provider.dart';

import 'app_tester.dart';

void main() {
  testWidgets('a variable name keeps focus when it becomes a duplicate',
      (tester) async {
    final c = await pumpApp(tester);
    c.read(panelLayoutProvider.notifier).showSection(LeftPanelSection.variables);
    c.read(graphEditorProvider)
      ..addVariable('variable')
      ..addVariable('variable');
    await tester.pumpAndSettle();
    final names = [for (final v in c.read(variablesProvider)) v.name];
    final second = find
        .ancestor(of: find.text(names[1]), matching: find.byType(TextField))
        .first;
    await tester.tap(second);
    await tester.pumpAndSettle();
    // Typing the first variable's name makes a duplicate (an error).
    await tester.enterText(second, names[0]);
    await tester.pumpAndSettle();
    expect(c.read(invalidVariableNamesProvider), isNotEmpty);
    final focused = tester
        .widgetList<EditableText>(find.byType(EditableText))
        .where((e) => e.focusNode.hasFocus);
    expect(focused.map((e) => e.controller.text), [names[0]],
        reason: 'the error tooltip must not rebuild the field');
  });

  testWidgets('a text field right-click menu is not scaled by the canvas zoom',
      (tester) async {
    final c = await pumpApp(tester);
    c.read(graphEditorProvider).addVideoNode(Position.zero,
        type: DefaultNodeType.branchedVideo);
    await tester.pumpAndSettle();
    final view = c.read(canvasViewProvider);
    for (var i = 0; i < 10; i++) {
      view.zoomCentered(zoomIn: false);
    }
    await tester.pumpAndSettle();
    expect(view.scale, lessThan(0.4));

    final field = find.byType(TextField).last;
    final gesture = await tester.startGesture(tester.getCenter(field),
        kind: PointerDeviceKind.mouse, buttons: kSecondaryMouseButton);
    await gesture.up();
    await tester.pumpAndSettle();
    expect(find.text('Paste'), findsOneWidget);
    expect(tester.getSize(find.text('Paste')).height, greaterThan(10),
        reason: 'drawn at screen size, not at the node\'s zoom');
  });

  test('the menu bar stays "open" while moving from one menu to the next', () {
    final c = ProviderContainer.test();
    final overlays = c.read(overlayProvider.notifier);
    overlays.setMenuOpen(true); // File
    overlays.setMenuOpen(true); // Edit opens before File reports closing
    overlays.setMenuOpen(false); // File
    expect(c.read(overlayProvider).menuOpen, isTrue);
    overlays.setMenuOpen(false); // Edit
    expect(c.read(overlayProvider).menuOpen, isFalse);
  });
}
