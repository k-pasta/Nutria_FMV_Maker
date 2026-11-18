import 'package:flutter_test/flutter_test.dart';
import 'package:nutria_fmv_maker/features/shell/providers/notifications_provider.dart';
import 'package:nutria_fmv_maker/features/shell/widgets/notifications_window.dart';
import 'package:nutria_fmv_maker/features/shell/widgets/status_bar.dart';

import 'app_tester.dart';
import 'harness.dart';

void main() {
  testWidgets('right-clicking the status bar lists every notification', (
    tester,
  ) async {
    final c = await pumpApp(tester);
    final notifications = c.read(notificationsProvider.notifier);
    notifications.post('First message');
    notifications.post('Second message');
    // Let both show and fade, so only the history has them.
    await tester.pump(const Duration(seconds: 30));
    await tester.pumpAndSettle();

    await rightClickAt(tester, tester.getCenter(find.byType(StatusBar)));
    await tester.tap(find.text('Show All Notifications…'));
    await tester.pumpAndSettle();

    final window = find.byType(NotificationsWindow);
    expect(window, findsOneWidget);
    final first = find.descendant(
      of: window,
      matching: find.text('First message'),
    );
    final second = find.descendant(
      of: window,
      matching: find.text('Second message'),
    );
    expect(first, findsOneWidget);
    expect(second, findsOneWidget);
    expect(
      tester.getTopLeft(second).dy,
      lessThan(tester.getTopLeft(first).dy),
      reason: 'newest first',
    );
  });

  test('the history keeps only the latest notifications', () async {
    final c = (await Harness.create()).container;
    final notifications = c.read(notificationsProvider.notifier);
    for (var i = 0; i < kNotificationHistoryLength + 5; i++) {
      notifications.post('n$i');
    }
    final history = c.read(notificationHistoryProvider);
    expect(history, hasLength(kNotificationHistoryLength));
    expect(history.last.message, 'n${kNotificationHistoryLength + 4}');
  });
}
