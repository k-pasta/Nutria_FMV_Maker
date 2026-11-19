// The app window's own title bar on Windows: minimizing, maximizing,
// dragging and closing the window from the menu bar.
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:window_manager/window_manager.dart';

part 'window_service.g.dart';

/// The app window. On Windows the system title bar is hidden and the menu
/// bar does its work ([hasCustomFrame]); elsewhere the system's stays and
/// these controls aren't shown.
abstract interface class WindowControls {
  /// Whether the app draws the title bar buttons itself.
  bool get hasCustomFrame;

  /// Whether the window fills the screen (maximized).
  ValueListenable<bool> get isMaximized;

  void minimize();
  void toggleMaximize();

  /// Moves the window with the mouse, from a press on the title area.
  void startDragging();

  /// Asks to close: calls the close handler, which decides (unsaved work).
  void close();

  /// What closing the window does, from the app's button, Alt+F4 or the
  /// taskbar. Without one, the window just closes.
  set onCloseRequested(Future<void> Function()? handler);
}

/// [WindowControls] through `window_manager`, with a custom frame on
/// Windows only.
class NativeWindowControls with WindowListener implements WindowControls {
  NativeWindowControls._();

  static final instance = NativeWindowControls._();

  final _maximized = ValueNotifier(false);
  Future<void> Function()? _onClose;

  @override
  bool get hasCustomFrame => Platform.isWindows;

  @override
  ValueListenable<bool> get isMaximized => _maximized;

  @override
  set onCloseRequested(Future<void> Function()? handler) => _onClose = handler;

  /// Hides the system title bar (Windows) and takes over closing. Called
  /// once in `main`, before `runApp`.
  Future<void> init() async {
    if (!hasCustomFrame) return;
    await windowManager.ensureInitialized();
    windowManager.addListener(this);
    await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
    await windowManager.setPreventClose(true);
    _maximized.value = await windowManager.isMaximized();
  }

  @override
  void minimize() => windowManager.minimize();

  @override
  Future<void> toggleMaximize() async {
    if (await windowManager.isMaximized()) {
      await windowManager.unmaximize();
    } else {
      await windowManager.maximize();
    }
  }

  @override
  void startDragging() => windowManager.startDragging();

  @override
  void close() => onWindowClose();

  @override
  Future<void> onWindowClose() async {
    final handler = _onClose;
    if (handler == null) {
      await windowManager.destroy();
    } else {
      await handler();
    }
  }

  @override
  void onWindowMaximize() => _maximized.value = true;

  @override
  void onWindowUnmaximize() => _maximized.value = false;

  @override
  void onWindowRestore() => _updateMaximized();

  @override
  void onWindowResized() => _updateMaximized();

  Future<void> _updateMaximized() async =>
      _maximized.value = await windowManager.isMaximized();
}

@Riverpod(keepAlive: true)
WindowControls windowControls(Ref ref) => NativeWindowControls.instance;
