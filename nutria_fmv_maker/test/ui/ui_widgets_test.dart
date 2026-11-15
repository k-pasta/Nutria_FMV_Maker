import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme_presets.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_button.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_text_field.dart';

Widget _app(Widget child, {AppTheme theme = kDarkTheme}) => MaterialApp(
      theme: buildThemeData(theme, dark: true),
      home: Material(child: Center(child: SizedBox(width: 200, child: child))),
    );

void main() {
  test('ui/ stays presentational: no Riverpod, features, services or core', () {
    const forbidden = [
      "import 'package:flutter_riverpod/",
      "import 'package:riverpod",
      "import 'package:nutria_fmv_maker/features/",
      "import 'package:nutria_fmv_maker/services/",
      "import 'package:nutria_fmv_maker/core/",
      "import 'package:nutria_fmv_maker/app/",
    ];
    final offenders = <String>[];
    for (final file in Directory('lib/ui').listSync(recursive: true)) {
      if (file is! File || !file.path.endsWith('.dart')) continue;
      for (final line in file.readAsLinesSync()) {
        if (forbidden.any(line.startsWith)) offenders.add('${file.path}: $line');
      }
    }
    expect(offenders, isEmpty);
  });

  testWidgets('context.appTheme reads the registered theme', (tester) async {
    late AppTheme seen;
    await tester.pumpWidget(_app(
      Builder(builder: (context) {
        seen = context.appTheme;
        return const SizedBox();
      }),
      theme: kLightTheme,
    ));
    expect(seen.cPanel, kLightTheme.cPanel);
  });

  testWidgets('stepper button calls the half that was clicked', (tester) async {
    final calls = <String>[];
    await tester.pumpWidget(_app(NutriaButton.leftRight(
      onTapLeft: () => calls.add('left'),
      onTapRight: () => calls.add('right'),
    )));
    final box = tester.getRect(find.byType(NutriaButton));
    await tester.tapAt(box.centerLeft + const Offset(5, 0));
    await tester.tapAt(box.centerRight - const Offset(5, 0));
    expect(calls, ['left', 'right']);
  });

  testWidgets('inactive buttons ignore taps', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
        _app(NutriaButton(onTap: () => taps++, isActive: false)));
    await tester.tap(find.byType(NutriaButton), warnIfMissed: false);
    expect(taps, 0);
  });

  group('NutriaTextField', () {
    testWidgets('follows external changes when not focused', (tester) async {
      await tester.pumpWidget(_app(const NutriaTextField(text: 'one')));
      await tester.pumpWidget(_app(const NutriaTextField(text: 'two')));
      expect(find.text('two'), findsOneWidget);
    });

    testWidgets('does not overwrite what the user is typing', (tester) async {
      final focus = <bool>[];
      await tester.pumpWidget(_app(NutriaTextField(
          text: 'start', onFocusChanged: focus.add)));
      await tester.tap(find.byType(TextField));
      await tester.enterText(find.byType(TextField), 'typing');
      await tester.pumpWidget(_app(NutriaTextField(
          text: 'stale', onFocusChanged: focus.add)));
      expect(find.text('typing'), findsOneWidget);
      expect(focus, [true]);
    });
  });
}
