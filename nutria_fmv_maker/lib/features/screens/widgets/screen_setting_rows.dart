// The rows that pick a node's answer screens, for a node's settings and for
// the Defaults section.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/core/document/screen.dart';
import 'package:nutria_fmv_maker/core/document/video_settings.dart';
import 'package:nutria_fmv_maker/core/graph/screen_ops.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:nutria_fmv_maker/features/screens/widgets/screens_view.dart';
import 'package:nutria_fmv_maker/features/shell/providers/overlay_provider.dart';
import 'package:nutria_fmv_maker/l10n/generated/app_localizations.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_context_menu.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_setting_row.dart';

/// The answer screen over the video and, when the video waits at its end
/// ("pause on end"), the one over its last frame. [settings] are the values
/// shown; like the other settings, on a node [onReset] removes an override
/// and the settings in [overridden] are accented.
List<Widget> screenSettingRows(
  BuildContext context,
  WidgetRef ref, {
  required VideoSettings settings,
  required void Function(VideoSettingType type, VideoSettings next) onChanged,
  Set<VideoSettingType> overridden = const {},
  void Function(VideoSettingType type)? onReset,
}) {
  final t = AppLocalizations.of(context);
  final doc = ref.watch(projectDocumentProvider);
  final menuOpen = ref.read(overlayProvider.notifier).setContextMenuOpen;

  Widget row(
    VideoSettingType type,
    ScreenKind kind,
    String label,
    String currentId,
    VideoSettings Function(String id) withId,
  ) {
    final screens = doc.screensOf(kind);
    final current = doc.resolveScreen(currentId, kind);
    String step(int direction) {
      final i = screens.indexWhere((s) => s.id == current.id);
      return screens[(i + direction) % screens.length].id;
    }

    final isOverridden = overridden.contains(type);
    return NutriaSettingRow(
      label: label,
      value: screenLabel(current, t),
      isAccented: isOverridden,
      onReset: isOverridden && onReset != null ? () => onReset(type) : null,
      resetTooltip: t.tooltipResetOverride,
      onPrevious: () => onChanged(type, withId(step(-1))),
      onNext: () => onChanged(type, withId(step(1))),
      options: [
        for (final s in screens)
          NutriaContextMenuItem(
            icon: s.id == current.id ? Icons.check : Icons.circle_outlined,
            label: screenLabel(s, t),
            onSelected: () => onChanged(type, withId(s.id)),
          ),
      ],
      onOptionsOpenChanged: menuOpen,
    );
  }

  return [
    row(
      VideoSettingType.choiceScreen,
      ScreenKind.choice,
      t.overrideChoiceScreen,
      settings.choiceScreenId,
      (id) => settings.copyWith(choiceScreenId: id),
    ),
    if (settings.pauseOnEnd)
      row(
        VideoSettingType.endChoiceScreen,
        ScreenKind.endChoice,
        t.overrideEndChoiceScreen,
        settings.endChoiceScreenId,
        (id) => settings.copyWith(endChoiceScreenId: id),
      ),
  ];
}
