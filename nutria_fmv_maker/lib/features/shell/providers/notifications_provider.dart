// Short messages shown one at a time in the status bar.
import 'dart:async';
import 'dart:collection';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notifications_provider.g.dart';

/// How long a message stays visible.
const kNotificationDuration = Duration(milliseconds: 2000);

/// Gap between messages, long enough for the fade-out animation.
const kNotificationGap = Duration(milliseconds: 200);

/// The message currently shown (`null` for none). Messages posted while one
/// is visible wait in a queue. Messages are already localized by the caller.
@Riverpod(keepAlive: true)
class NotificationsNotifier extends _$NotificationsNotifier {
  final Queue<String> _queue = Queue();
  Timer? _timer;

  @override
  String? build() {
    ref.onDispose(() => _timer?.cancel());
    return null;
  }

  /// Shows [message] now, or after the messages already waiting.
  void post(String message) {
    _queue.add(message);
    if (_timer == null) _showNext();
  }

  void _showNext() {
    if (_queue.isEmpty) {
      _timer = null;
      return;
    }
    state = _queue.removeFirst();
    _timer = Timer(kNotificationDuration, () {
      state = null;
      _timer = Timer(kNotificationGap, _showNext);
    });
  }
}
