// The desktop window layout: menu bar, canvas with side panels, status bar.
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
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:nutria_fmv_maker/features/shell/providers/overlay_provider.dart';
import 'package:nutria_fmv_maker/features/shell/widgets/side_panels.dart';
import 'package:nutria_fmv_maker/features/shell/widgets/status_bar.dart';
import 'package:nutria_fmv_maker/features/video_preview/providers/video_preview_provider.dart';
import 'package:nutria_fmv_maker/l10n/generated/app_localizations.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_menu_bar.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_modal.dart';

class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  /// Holds keyboard focus whenever nothing more specific (a text field, a
  /// menu, a dialog) has it, so the shortcuts above it receive key presses.
  final _shellFocus = FocusNode(debugLabel: 'AppShell');

  @override
  void initState() {
    super.initState();
    FocusManager.instance.addListener(_reclaimFocus);
  }

  @override
  void dispose() {
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
    final fellBack = primary == null ||
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
    return CallbackShortcuts(
      bindings: appShortcuts(commands),
      child: Focus(
        focusNode: _shellFocus,
        autofocus: true,
        child: Scaffold(
          body: Column(children: [
            NutriaMenuBar(
              menus: buildAppMenus(
                commands: commands,
                t: AppLocalizations.of(context),
                preferences: preferences,
                canUndo: history.canUndo,
                canRedo: history.canRedo,
                canPlay: ref.watch(
                    videoPreviewProvider.select((p) => p != null)),
              ),
              onLogoTap: commands.showAbout,
              onOpenChanged: overlays.setMenuOpen,
            ),
            const Expanded(
              child: ClipRect(
                child: Stack(children: [
                  CanvasView(
                      layers: [NoodleLayer(), NodeLayer(), MarqueeLayer()]),
                  SidePanels(),
                  _LogoTail(),
                  _Dimmer(),
                  _ModalLayer(),
                ]),
              ),
            ),
            const StatusBar(),
          ]),
        ),
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
      AppModal.about =>
        NutriaModal(onClose: close, child: const AboutWindow()),
    };
  }
}
