// Text on the system clipboard, behind an interface so tests don't touch it.
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'clipboard_service.g.dart';

/// Reads and writes plain text on a clipboard.
abstract interface class ClipboardService {
  Future<void> write(String text);
  Future<String?> read();
}

/// The operating system's clipboard, so copied nodes can be pasted into
/// another project or another window of the app.
class SystemClipboardService implements ClipboardService {
  const SystemClipboardService();

  @override
  Future<void> write(String text) =>
      Clipboard.setData(ClipboardData(text: text));

  @override
  Future<String?> read() async =>
      (await Clipboard.getData(Clipboard.kTextPlain))?.text;
}

/// The app's clipboard.
@Riverpod(keepAlive: true)
ClipboardService clipboardService(Ref ref) => const SystemClipboardService();
