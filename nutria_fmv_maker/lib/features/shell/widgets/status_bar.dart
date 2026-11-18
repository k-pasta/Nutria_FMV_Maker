// Bottom bar: project file name on the left, notifications on the right.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:nutria_fmv_maker/features/shell/providers/notifications_provider.dart';
import 'package:nutria_fmv_maker/features/shell/providers/overlay_provider.dart';
import 'package:nutria_fmv_maker/l10n/generated/app_localizations.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';
import 'package:nutria_fmv_maker/ui/theme/ui_constants.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_context_menu.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_text.dart';

/// The bar at the bottom: the project's file name and the latest
/// notification. Right-click it for every notification so far.
class StatusBar extends ConsumerWidget {
  const StatusBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.appTheme;
    final overlays = ref.read(overlayProvider.notifier);
    return NutriaContextMenuArea(
      behavior: HitTestBehavior.opaque,
      onOpenChanged: overlays.setContextMenuOpen,
      itemsAt: (_) => [
        NutriaContextMenuItem(
          icon: Icons.notifications,
          label: AppLocalizations.of(context).statusShowNotifications,
          onSelected: () => overlays.showModal(AppModal.notifications),
        ),
      ],
      child: Container(
        height: theme.dStatusBarHeight,
        decoration: BoxDecoration(
          color: theme.cPanel,
          border: Border(
            top: BorderSide(width: theme.dDividerWidth, color: theme.cDivider),
          ),
        ),
        // The notification is drawn over the file name if they meet.
        child: const Stack(
          children: [
            Align(alignment: Alignment.centerLeft, child: _FileName()),
            Align(alignment: Alignment.centerRight, child: _Notification()),
          ],
        ),
      ),
    );
  }
}

/// "story.nfmv", with an asterisk while there are unsaved changes.
class _FileName extends ConsumerWidget {
  const _FileName();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name =
        ref.watch(projectFileNameProvider) ??
        AppLocalizations.of(context).statusUnsavedFile;
    final dirty = ref.watch(isDirtyProvider);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.appTheme.dSectionPadding,
      ),
      child: NutriaText(text: dirty ? '$name *' : name),
    );
  }
}

class _Notification extends ConsumerWidget {
  const _Notification();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final message = ref.watch(notificationsProvider);
    if (message == null) return const SizedBox.shrink();
    // A new key per message restarts the fade-out.
    return _FadingBadge(key: ValueKey(message), text: message);
  }
}

/// Fully visible, then fades out just before the notification expires.
class _FadingBadge extends StatefulWidget {
  const _FadingBadge({super.key, required this.text});

  final String text;

  @override
  State<_FadingBadge> createState() => _FadingBadgeState();
}

class _FadingBadgeState extends State<_FadingBadge> {
  double _opacity = 1;

  @override
  void initState() {
    super.initState();
    Future.delayed(kNotificationDuration - kBaseAnimation, () {
      if (mounted) setState(() => _opacity = 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    return AnimatedOpacity(
      duration: kBaseAnimation,
      opacity: _opacity,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: theme.dSectionPadding),
        height: theme.dStatusBarHeight - theme.dDividerWidth,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: theme.cAccentButton.withValues(alpha: 1),
          borderRadius: BorderRadius.circular(theme.dPanelBorderRadius),
        ),
        child: NutriaText(text: widget.text),
      ),
    );
  }
}
