// The left panel: a dropdown to pick a section, and that section.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/features/preferences/widgets/preferences_panel.dart';
import 'package:nutria_fmv_maker/features/project_settings/widgets/project_settings_panel.dart';
import 'package:nutria_fmv_maker/features/shell/providers/panel_layout_provider.dart';
import 'package:nutria_fmv_maker/features/variables/widgets/variables_panel.dart';
import 'package:nutria_fmv_maker/features/video_library/widgets/video_library_panel.dart';
import 'package:nutria_fmv_maker/l10n/generated/app_localizations.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';
import 'package:nutria_fmv_maker/ui/theme/ui_constants.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_dropdown.dart';

/// The left panel: a dropdown to pick a section, and that section.
class LeftPanel extends ConsumerWidget {
  const LeftPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.appTheme;
    final t = AppLocalizations.of(context);
    final section = ref.watch(panelLayoutProvider.select((l) => l.section));
    return Padding(
      padding: EdgeInsets.only(top: theme.dSectionPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: theme.dSectionPadding),
            child: NutriaDropdown(
              options: [
                for (final s in LeftPanelSection.values)
                  switch (s) {
                    LeftPanelSection.videos => NutriaDropdownOption(
                      icon: Icons.camera_roll,
                      text: t.boardImportedVideos,
                    ),
                    LeftPanelSection.variables => NutriaDropdownOption(
                      icon: Icons.data_object,
                      text: t.boardVariables,
                    ),
                    LeftPanelSection.projectSettings => NutriaDropdownOption(
                      icon: Icons.tune,
                      text: t.boardProjectSettings,
                    ),
                    LeftPanelSection.preferences => NutriaDropdownOption(
                      icon: Icons.settings,
                      text: t.boardPreferences,
                    ),
                  },
              ],
              selectedIndex: section.index,
              onSelected: (i) => ref
                  .read(panelLayoutProvider.notifier)
                  .showSection(LeftPanelSection.values[i]),
            ),
          ),
          SizedBox(height: theme.dPanelPadding),
          Expanded(
            child: AnimatedSwitcher(
              duration: kBaseAnimation,
              // Expanded to the panel, or the switcher would center sections
              // shorter than the panel.
              child: SizedBox.expand(
                key: ValueKey(section),
                child: switch (section) {
                  LeftPanelSection.videos => const VideoLibraryPanel(),
                  LeftPanelSection.variables => const VariablesPanel(),
                  LeftPanelSection.projectSettings =>
                    const ProjectSettingsPanel(),
                  LeftPanelSection.preferences => const PreferencesPanel(),
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
