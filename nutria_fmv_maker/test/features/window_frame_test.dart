import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_window_buttons.dart';

import 'app_tester.dart';
import 'harness.dart';

void main() {
  testWidgets('with the system title bar there are no window buttons', (
    tester,
  ) async {
    await pumpApp(tester);
    expect(find.byType(NutriaWindowButtons), findsNothing);
  });

  testWidgets('the menu bar is the title bar: buttons, double-click, drag '
      'and a right-click menu', (tester) async {
    final window = FakeWindowControls(hasCustomFrame: true);
    await pumpApp(tester, window: window);
    expect(find.byType(NutriaWindowButtons), findsOneWidget);

    await tester.tap(find.byTooltip('Minimize'));
    await tester.tap(find.byTooltip('Maximize'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Restore'), findsOneWidget, reason: 'now maximized');
    await tester.tap(find.byTooltip('Close'));
    expect(window.calls, ['minimize', 'toggleMaximize', 'close']);

    // An empty spot of the bar, left of the buttons.
    final bar =
        tester.getTopLeft(find.byType(NutriaWindowButtons)) +
        const Offset(-100, 10);
    window.calls.clear();
    final drag = await tester.startGesture(bar, kind: PointerDeviceKind.mouse);
    for (var i = 0; i < 5; i++) {
      await drag.moveBy(const Offset(8, 4));
      await tester.pump();
    }
    await drag.up();
    await tester.pumpAndSettle();
    expect(window.calls, ['drag']);

    window.calls.clear();
    await tester.tapAt(bar);
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tapAt(bar);
    await tester.pumpAndSettle();
    expect(window.calls, ['toggleMaximize']);

    window.calls.clear();
    await tester.tapAt(bar, buttons: kSecondaryButton);
    await tester.pumpAndSettle();
    expect(find.text('Maximize'), findsOneWidget, reason: 'restored again');
    await tester.tap(find.text('Minimize'));
    await tester.pumpAndSettle();
    expect(window.calls, ['minimize']);
  });
}
