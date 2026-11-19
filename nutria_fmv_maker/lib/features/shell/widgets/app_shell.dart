// The desktop window layout: menu bar, canvas with side panels, status bar.
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/app/app_commands.dart';
import 'package:nutria_fmv_maker/app/app_menus.dart';
import 'package:nutria_fmv_maker/app/app_shortcuts.dart';
import 'package:nutria_fmv_maker/features/about/widgets/about_window.dart';
import 'package:nutria_fmv_maker/features/canvas/widgets/canvas_view.dart';
import 'package:nutria_fmv_maker/features/canvas/widgets/marquee_layer.dart';
import 'package:nutria_fmv_maker/features/canvas/widgets/noodle_layer.dart';
import 'package:nutria_fmv_maker/features/nodes/widgets/node_layer.dart';
import 'package:nutria_fmv_maker/features/preferences/providers/preferences_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/clipboard_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:nutria_fmv_maker/features/screens/providers/screens_provider.dart';
import 'package:nutria_fmv_maker/features/screens/widgets/screens_view.dart';
import 'package:nutria_fmv_maker/features/shell/providers/overlay_provider.dart';
import 'package:nutria_fmv_maker/features/shell/providers/panel_layout_provider.dart';
import 'package:nutria_fmv_maker/features/shell/widgets/notifications_window.dart';
import 'package:nutria_fmv_maker/features/shell/widgets/side_panels.dart';
import 'package:nutria_fmv_maker/features/shell/widgets/status_bar.dart';
import 'package:nutria_fmv_maker/features/video_library/providers/video_library_providers.dart';
import 'package:nutria_fmv_maker/features/video_library/widgets/missing_files_window.dart';
import 'package:nutria_fmv_maker/features/video_preview/providers/video_preview_provider.dart';
import 'package:nutria_fmv_maker/l10n/generated/app_localizations.dart';
import 'package:nutria_fmv_maker/services/window_service.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_button.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_context_menu.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_menu_bar.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_modal.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_window_buttons.dart';

/// The window layout (menu bar, canvas between the side panels, status bar),
/// with the app's keyboard shortcuts and dialogs.
class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  /// Holds keyboard focus whenever nothing more specific (a text field, a
  /// menu, a dialog) has it, so the shortcuts above it receive key presses.
  final _shellFocus = FocusNode(debugLabel: 'AppShell');

  /// Re-reads the clipboard and checks the media files again when the
  /// window comes back to the front: the user may have copied something, or
  /// moved or restored files, in another app.
  late final _lifecycle = AppLifecycleListener(onResume: _onResume);

  void _onResume() {
    _refreshClipboard();
    ref.invalidate(missingMediaProvider);
  }

  void _refreshClipboard() =>
      ref.read(clipboardHasNodesProvider.notifier).refresh();

  @override
  void initState() {
    super.initState();
    FocusManager.instance.addListener(_reclaimFocus);
    _lifecycle;
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    FocusManager.instance.removeListener(_reclaimFocus);
    _shellFocus.dispose();
    super.dispose();
  }

  /// When focus falls back to this page's scope (a text field was left or
  /// removed), it would sit above the shortcuts and they'd stop working.
  /// Dialogs have their own scope, so they keep their focus.
  void _reclaimFocus() {
    final primary = FocusManager.instance.primaryFocus;
    final ownScope = _shellFocus.enclosingScope;
    final fellBack =
        primary == null ||
        primary == ownScope ||
        primary == FocusManager.instance.rootScope;
    if (!fellBack) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final now = FocusManager.instance.primaryFocus;
      if (mounted &&
          (now == null ||
              now == _shellFocus.enclosingScope ||
              now == FocusManager.instance.rootScope)) {
        _shellFocus.requestFocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final commands = AppCommands(context, ref);
    final history = ref.watch(historyStatusProvider);
    final preferences = ref.watch(preferencesProvider);
    final overlays = ref.read(overlayProvider.notifier);
    final window = ref.watch(windowControlsProvider);
    // Closing the window (its button, Alt+F4, the taskbar) asks about
    // unsaved changes first, like File > Exit.
    window.onCloseRequested = commands.exitApp;
    // A right-click is about to open a context menu: re-read the clipboard
    // so the menu knows whether it can offer Paste.
    return Listener(
      onPointerDown: (event) {
        if (event.buttons & kSecondaryMouseButton != 0) _refreshClipboard();
      },
      child: CallbackShortcuts(
        bindings: appShortcuts(commands),
        child: Focus(
          focusNode: _shellFocus,
          autofocus: true,
          child: Scaffold(
            body: Column(
              children: [
                NutriaMenuBar(
                  menus: buildAppMenus(
                    commands: commands,
                    t: AppLocalizations.of(context),
                    preferences: preferences,
                    canUndo: history.canUndo,
                    canRedo: history.canRedo,
                    canPlay: ref.watch(previewIsPlayableProvider),
                    canCopy: ref.watch(canCopySelectionProvider),
                    canPaste: ref.watch(clipboardHasNodesProvider),
                  ),
                  onLogoTap: commands.showAbout,
                  onOpenChanged: (open) {
                    overlays.setMenuOpen(open);
                    if (open) _refreshClipboard();
                  },
                  trailing: window.hasCustomFrame
                      ? _WindowButtons(window: window)
                      : null,
                  onTitleDragStart: window.hasCustomFrame
                      ? window.startDragging
                      : null,
                  onTitleDoubleTap: window.hasCustomFrame
                      ? window.toggleMaximize
                      : null,
                  onTitleSecondaryTap: window.hasCustomFrame
                      ? (at) => _windowMenu(context, window, at)
                      : null,
                ),
                const Expanded(
                  child: ClipRect(
                    child: Stack(
                      children: [
                        _MainView(),
                        SidePanels(),
                        _ViewSwitch(),
                        _LogoTail(),
                        _Dimmer(),
                        _ModalLayer(),
                      ],
                    ),
                  ),
                ),
                const StatusBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Restore or maximize, minimize and close, from a right-click on the
/// title area of the menu bar.
void _windowMenu(BuildContext context, WindowControls window, Offset at) {
  final t = AppLocalizations.of(context);
  final maximized = window.isMaximized.value;
  showNutriaMenu(context, at, [
    NutriaContextMenuItem(
      icon: maximized ? Icons.filter_none : Icons.crop_square,
      label: maximized ? t.windowRestore : t.windowMaximize,
      onSelected: window.toggleMaximize,
    ),
    NutriaContextMenuItem(
      icon: Icons.remove,
      label: t.windowMinimize,
      onSelected: window.minimize,
    ),
    const NutriaContextMenuItem.divider(),
    NutriaContextMenuItem(
      icon: Icons.close,
      label: t.windowClose,
      onSelected: window.close,
    ),
  ]);
}

/// The window buttons at the right of the menu bar, following whether the
/// window is maximized.
class _WindowButtons extends StatelessWidget {
  const _WindowButtons({required this.window});

  final WindowControls window;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return ValueListenableBuilder(
      valueListenable: window.isMaximized,
      builder: (context, maximized, _) => NutriaWindowButtons(
        isMaximized: maximized,
        labels: (
          minimize: t.windowMinimize,
          maximize: t.windowMaximize,
          restore: t.windowRestore,
          close: t.windowClose,
        ),
        onMinimize: window.minimize,
        onToggleMaximize: window.toggleMaximize,
        onClose: window.close,
      ),
    );
  }
}

/// The button at the top right of the main area, next to the right panel,
/// that switches between the story graph and the screen designer. It shows
/// the other view's icon.
class _ViewSwitch extends ConsumerWidget {
  const _ViewSwitch();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.appTheme;
    final t = AppLocalizations.of(context);
    final designing = ref.watch(editorViewProvider) == EditorView.screens;
    final layout = ref.watch(panelLayoutProvider);
    return Positioned(
      top: theme.dSectionPadding,
      right:
          (layout.rightClosed ? 0 : layout.right + kPanelHandleWidth) +
          theme.dSectionPadding,
      child: NutriaButton.icon(
        icon: designing ? Icons.polyline : Icons.palette,
        tooltip: designing ? t.screenSwitchToGraph : t.screenSwitchToDesigner,
        onTap: AppCommands(context, ref).toggleView,
      ),
    );
  }
}

/// The lower half of the logo, which hangs below the menu bar.
class _LogoTail extends StatelessWidget {
  const _LogoTail();

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    return Positioned(
      top: -theme.dMenuBarHeight + theme.dLogoPadding,
      left: theme.dLogoPadding,
      child: IgnorePointer(
        child: SvgPicture.asset(
          'assets/icons/nutria_logo_top.svg',
          width: theme.dMenuBarHeight * 2.2,
          height: (theme.dMenuBarHeight - theme.dLogoPadding) * 2,
          colorFilter: ColorFilter.mode(theme.cAccentButton, BlendMode.srcIn),
        ),
      ),
    );
  }
}

/// Darkens the editor while a menu or dialog is open. Clicking it closes the
/// dialog.
class _Dimmer extends ConsumerWidget {
  const _Dimmer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blocks = ref.watch(overlayProvider.select((o) => o.blocksCanvas));
    if (!blocks) return const SizedBox.shrink();
    return Positioned.fill(
      child: GestureDetector(
        onTap: ref.read(overlayProvider.notifier).closeModal,
        child: ColoredBox(color: context.appTheme.cDimmer),
      ),
    );
  }
}

class _ModalLayer extends ConsumerWidget {
  const _ModalLayer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modal = ref.watch(overlayProvider.select((o) => o.modal));
    final close = ref.read(overlayProvider.notifier).closeModal;
    return switch (modal) {
      null => const SizedBox.shrink(),
      AppModal.about => NutriaModal(onClose: close, child: const AboutWindow()),
      AppModal.notifications => NutriaModal(
        onClose: close,
        child: const NotificationsWindow(),
      ),
      AppModal.missingFiles => NutriaModal(
        onClose: close,
        child: const MissingFilesWindow(),
      ),
    };
  }
}

/// The story graph, or the screen designer.
class _MainView extends ConsumerWidget {
  const _MainView();

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      switch (ref.watch(editorViewProvider)) {
        EditorView.graph => const CanvasView(
          layers: [NoodleLayer(), NodeLayer(), MarqueeLayer()],
        ),
        EditorView.screens => const ScreensView(),
      };
}
