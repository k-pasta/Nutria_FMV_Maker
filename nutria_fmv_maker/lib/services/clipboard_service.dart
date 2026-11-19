// Text on the system clipboard, behind an interface so tests don't touch it.
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'clipboard_service.g.dart';

/// Reads and writes plain text on a clipboard.
abstract interface class ClipboardService {
  /// Returns whether the text was written.
  Future<bool> write(String text);

  /// The clipboard's text, or `null` if it has none or can't be read.
  Future<String?> read();
}

/// How often a busy clipboard is tried, and how long to wait in between.
const _kAttempts = 5;
const _kRetryDelay = Duration(milliseconds: 40);

/// The operating system's clipboard, so copied nodes can be pasted into
/// another project or another window of the app.
///
/// On Windows only one program can open the clipboard at a time; while
/// another one (or a clipboard manager) has it open, access fails with
/// "Unable to open clipboard". Each access is retried a few times and then
/// given up quietly instead of throwing.
class SystemClipboardService implements ClipboardService {
  const SystemClipboardService();

  @override
  Future<bool> write(String text) async =>
      await _retry(() async {
        await Clipboard.setData(ClipboardData(text: text));
        return true;
      }) ??
      false;

  @override
  Future<String?> read() => _retry<String?>(
    () async => (await Clipboard.getData(Clipboard.kTextPlain))?.text,
  );

  static Future<T?> _retry<T>(Future<T> Function() access) async {
    for (var attempt = 1; ; attempt++) {
      try {
        return await access();
      } on PlatformException {
        if (attempt == _kAttempts) return null;
        await Future<void>.delayed(_kRetryDelay);
      }
    }
  }
}

/// The app's clipboard.
@Riverpod(keepAlive: true)
ClipboardService clipboardService(Ref ref) => const SystemClipboardService();
