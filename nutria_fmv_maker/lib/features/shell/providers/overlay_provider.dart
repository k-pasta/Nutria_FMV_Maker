// What floats above the editor: open menus, context menu and modal dialogs.
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'overlay_provider.freezed.dart';
part 'overlay_provider.g.dart';

/// Modal dialogs the app can show.
enum AppModal { about, notifications, missingFiles }

/// What is open over the editor: the menu bar, a context menu, a dialog.
@freezed
abstract class ShellOverlays with _$ShellOverlays {
  const ShellOverlays._();

  const factory ShellOverlays({
    @Default(false) bool menuOpen,
    @Default(false) bool contextMenuOpen,
    AppModal? modal,
  }) = _ShellOverlays;

  /// Whether the canvas should be dimmed and ignore input.
  bool get blocksCanvas => menuOpen || modal != null;
}

/// Tracks [ShellOverlays], e.g. so canvas shortcuts pause while a menu is
/// open.
@Riverpod(keepAlive: true)
class OverlayNotifier extends _$OverlayNotifier {
  @override
  ShellOverlays build() => const ShellOverlays();

  /// How many menu-bar menus report being open.
  int _openMenus = 0;

  /// A menu-bar menu opened or closed. Counted rather than stored: moving
  /// from one menu to the next can report "open" for the new one before
  /// "closed" for the old one.
  void setMenuOpen(bool open) {
    _openMenus = open ? _openMenus + 1 : (_openMenus - 1).clamp(0, 1 << 20);
    final anyOpen = _openMenus > 0;
    if (state.menuOpen != anyOpen) state = state.copyWith(menuOpen: anyOpen);
  }

  void setContextMenuOpen(bool open) {
    if (state.contextMenuOpen != open) {
      state = state.copyWith(contextMenuOpen: open);
    }
  }

  void showModal(AppModal modal) => state = state.copyWith(modal: modal);
  void closeModal() => state = state.copyWith(modal: null);
}
