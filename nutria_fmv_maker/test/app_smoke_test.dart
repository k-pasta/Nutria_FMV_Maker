// Pumps the whole app with fakes and exercises the shell.
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutria_fmv_maker/app/app.dart';
import 'package:nutria_fmv_maker/features/preferences/providers/preferences_provider.dart';
import 'package:nutria_fmv_maker/features/shell/providers/panel_layout_provider.dart';
import 'package:nutria_fmv_maker/features/video_preview/providers/video_preview_provider.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/harness.dart';

void main() {
  late ProviderContainer container;

  Future<void> pumpApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1600, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    container = ProviderContainer.test(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        previewPlayerProvider.overrideWithValue(FakePlayer()),
      ],
    );
    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const NutriaApp()),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('the shell renders with menus and status bar', (tester) async {
    await pumpApp(tester);
    for (final menu in ['File', 'Edit', 'View', 'Help']) {
      expect(find.text(menu), findsOneWidget);
    }
    expect(find.text('Unsaved File'), findsOneWidget);
  });

  testWidgets('Help > About opens and closes the About dialog', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.text('Help'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('About Nutria FMV Maker'));
    await tester.pumpAndSettle();
    expect(find.byType(NutriaModal), findsOneWidget);

    await tester.tapAt(const Offset(1500, 800)); // the dimmer
    await tester.pumpAndSettle();
    expect(find.byType(NutriaModal), findsNothing);
  });

  testWidgets('clicking the logo opens the About dialog', (tester) async {
    await pumpApp(tester);
    await tester.tapAt(const Offset(30, 15));
    await tester.pumpAndSettle();
    expect(find.byType(NutriaModal), findsOneWidget);
  });

  testWidgets('T toggles the left panel', (tester) async {
    await pumpApp(tester);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyT);
    await tester.pump();
    expect(container.read(panelLayoutProvider).leftClosed, isTrue);
  });

  testWidgets('switching language updates the menus', (tester) async {
    await pumpApp(tester);
    container.read(preferencesProvider.notifier).setLanguage('el');
    await tester.pumpAndSettle();
    expect(find.text('File'), findsNothing);
  });
}
