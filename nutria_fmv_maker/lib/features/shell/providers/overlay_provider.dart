// What floats above the editor: open menus, context menu and modal dialogs.
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'overlay_provider.freezed.dart';
part 'overlay_provider.g.dart';

/// Modal dialogs the app can show.
enum AppModal { about }

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

@Riverpod(keepAlive: true)
class OverlayNotifier extends _$OverlayNotifier {
  @override
  ShellOverlays build() => const ShellOverlays();

  void setMenuOpen(bool open) {
    if (state.menuOpen != open) state = state.copyWith(menuOpen: open);
  }

  void setContextMenuOpen(bool open) {
    if (state.contextMenuOpen != open) {
      state = state.copyWith(contextMenuOpen: open);
    }
  }

  void showModal(AppModal modal) => state = state.copyWith(modal: modal);
  void closeModal() => state = state.copyWith(modal: null);
}
