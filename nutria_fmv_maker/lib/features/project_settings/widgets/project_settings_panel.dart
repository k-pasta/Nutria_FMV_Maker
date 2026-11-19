// The Defaults section: playback settings every video node starts from, for
// the first color and, optionally, per color. Saved in the project.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/core/document/video_setting_steps.dart';
import 'package:nutria_fmv_maker/core/document/video_settings.dart';
import 'package:nutria_fmv_maker/core/graph/graph_ops.dart';
import 'package:nutria_fmv_maker/features/nodes/widgets/music_rows.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:nutria_fmv_maker/features/project/providers/graph_editor.dart';
import 'package:nutria_fmv_maker/features/project_settings/widgets/video_setting_row.dart';
import 'package:nutria_fmv_maker/features/shell/providers/overlay_provider.dart';
import 'package:nutria_fmv_maker/l10n/generated/app_localizations.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_button.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_scroll_area.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_text.dart';

/// The Defaults section. With only the first color's defaults it is a plain
/// list of settings; once other colors have their own, each set is a group
/// with its color at the side. The + button adds the next color's.
class ProjectSettingsPanel extends ConsumerWidget {
  const ProjectSettingsPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.appTheme;
    final t = AppLocalizations.of(context);
    final settings = ref.watch(projectSettingsProvider);
    final colors = ref.watch(colorDefaultsProvider);
    final swatches = colors.keys.toList()..sort();
    final next = ref.watch(
      projectDocumentProvider.select((d) => d.nextColorWithoutDefaults),
    );
    return Stack(
      children: [
        Positioned.fill(
          child: NutriaScrollArea(
            padding: EdgeInsets.fromLTRB(
              theme.dSectionPadding,
              0,
              theme.dSectionPadding,
              theme.dButtonHeight + theme.dSectionPadding * 2,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Story-wide, not per color: the pause menu's music.
                const PauseMenuMusicRow(),
                SizedBox(height: theme.dSectionPadding),
                swatches.isEmpty
                    ? _DefaultsRows(swatch: 0, settings: settings)
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _DefaultsGroup(swatch: 0, settings: settings),
                          for (final swatch in swatches) ...[
                            SizedBox(height: theme.dSectionPadding),
                            _DefaultsGroup(
                              swatch: swatch,
                              settings: colors[swatch]!,
                            ),
                          ],
                        ],
                      ),
              ],
            ),
          ),
        ),
        if (next != null)
          Positioned(
            right: theme.dSectionPadding + theme.dScrollbarWidth,
            bottom: theme.dSectionPadding,
            child: NutriaButton.icon(
              icon: Icons.add,
              isAccented: true,
              tooltip: t.tooltipAddColorDefaults(next + 1),
              onTap: ref.read(graphEditorProvider).addColorDefaults,
            ),
          ),
      ],
    );
  }
}

/// One color's defaults with a bar of that color at the side and a title.
class _DefaultsGroup extends ConsumerWidget {
  const _DefaultsGroup({required this.swatch, required this.settings});

  final int swatch;
  final VideoSettings settings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.appTheme;
    final t = AppLocalizations.of(context);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: theme.dPanelPadding,
            decoration: BoxDecoration(
              color: theme.swatch(swatch),
              borderRadius: BorderRadius.circular(theme.dButtonBorderRadius),
            ),
          ),
          SizedBox(width: theme.dPanelPadding),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: theme.dButtonHeight,
                  child: Row(
                    children: [
                      Expanded(
                        child: NutriaText(
                          text: swatch == 0
                              ? t.defaultsFirstColor
                              : t.defaultsColor(swatch + 1),
                          state: NutriaTextState.inactive,
                        ),
                      ),
                      if (swatch > 0)
                        NutriaButton.icon(
                          icon: Icons.close,
                          tooltip: t.tooltipRemoveColorDefaults(swatch + 1),
                          onTap: () => ref
                              .read(graphEditorProvider)
                              .removeColorDefaults(swatch),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: theme.dPanelPadding),
                _DefaultsRows(swatch: swatch, settings: settings),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Every video setting of one color's defaults.
class _DefaultsRows extends ConsumerWidget {
  const _DefaultsRows({required this.swatch, required this.settings});

  final int swatch;
  final VideoSettings settings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.appTheme;
    final editor = ref.read(graphEditorProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final type in kPlaybackSettingTypes) ...[
          if (type.index > 0) SizedBox(height: theme.dPanelPadding),
          VideoSettingRow(
            onDragStart: editor.beginValueDrag,
            onDragEnd: editor.endValueDrag,
            type: type,
            settings: settings,
            onStep: (direction) =>
                editor.editDefaults(swatch, (s) => s.step(type, direction)),
            onChanged: (next, {mergeKey}) =>
                editor.editDefaults(swatch, (_) => next, mergeKey: mergeKey),
            onMenuOpenChanged: ref
                .read(overlayProvider.notifier)
                .setContextMenuOpen,
          ),
        ],
        for (final row in pauseMusicRows(
          context,
          ref,
          settings: settings,
          onChanged: (_, next, {mergeKey}) =>
              editor.editDefaults(swatch, (_) => next, mergeKey: mergeKey),
          fadeMergeKey: ('defaults pause fade', swatch),
        )) ...[SizedBox(height: theme.dPanelPadding), row],
      ],
    );
  }
}
