// Every notification of this session, newest first, with its time.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/features/shell/providers/notifications_provider.dart';
import 'package:nutria_fmv_maker/l10n/generated/app_localizations.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_text.dart';

/// The contents of the notifications window (inside a `NutriaModal`, which
/// scrolls when the list is taller than the window).
class NotificationsWindow extends ConsumerWidget {
  const NotificationsWindow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.appTheme;
    final t = AppLocalizations.of(context);
    final history = ref.watch(notificationHistoryProvider).reversed.toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        NutriaText(
          text: t.statusNotificationsTitle,
          state: NutriaTextState.accented,
          textStyle: NutriaTextStyle.bold,
        ),
        SizedBox(height: theme.dSectionPadding),
        if (history.isEmpty)
          NutriaText(
            text: t.statusNoNotifications,
            state: NutriaTextState.inactive,
          )
        else
          for (final (i, entry) in history.indexed) ...[
            if (i > 0) SizedBox(height: theme.dPanelPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Small and quiet, so the messages stand out.
                SizedBox(
                  width: theme.dTextHeight * 4.5,
                  child: NutriaText(
                    text: _time(entry.at),
                    state: NutriaTextState.inactive,
                    sizeMultiplier: 0.85,
                  ),
                ),
                Expanded(child: NutriaText(text: entry.message, maxLines: 6)),
              ],
            ),
          ],
      ],
    );
  }

  static String _time(DateTime at) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(at.hour)}:${two(at.minute)}:${two(at.second)}';
  }
}
