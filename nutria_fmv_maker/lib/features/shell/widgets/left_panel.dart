// The left panel: a dropdown to pick a section, and that section.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/features/media_library/widgets/media_library_panel.dart';
import 'package:nutria_fmv_maker/features/preferences/widgets/preferences_panel.dart';
import 'package:nutria_fmv_maker/features/project_info/widgets/project_panel.dart';
import 'package:nutria_fmv_maker/features/project_settings/widgets/project_settings_panel.dart';
import 'package:nutria_fmv_maker/features/screens/providers/screens_provider.dart';
import 'package:nutria_fmv_maker/features/screens/widgets/screen_panel.dart';
import 'package:nutria_fmv_maker/features/shell/providers/panel_layout_provider.dart';
import 'package:nutria_fmv_maker/features/variables/widgets/variables_panel.dart';
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
    // Each view has its own sections; the screen designer hides those about
    // the story (variables, project, defaults).
    final available = ref.watch(editorViewProvider) == EditorView.screens
        ? const [
            LeftPanelSection.screen,
            LeftPanelSection.media,
            LeftPanelSection.preferences,
          ]
        : [
            for (final s in LeftPanelSection.values)
              if (s != LeftPanelSection.screen) s,
          ];
    final chosen = ref.watch(panelLayoutProvider.select((l) => l.section));
    final section = available.contains(chosen) ? chosen : available.first;
    return Padding(
      padding: EdgeInsets.only(top: theme.dSectionPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: theme.dSectionPadding),
            child: NutriaDropdown(
              options: [
                for (final s in available)
                  switch (s) {
                    LeftPanelSection.media => NutriaDropdownOption(
                      icon: Icons.camera_roll,
                      text: t.boardImportedMedia,
                    ),
                    LeftPanelSection.variables => NutriaDropdownOption(
                      icon: Icons.data_object,
                      text: t.boardVariables,
                    ),
                    LeftPanelSection.screen => NutriaDropdownOption(
                      icon: Icons.palette,
                      text: t.screenDesign,
                    ),
                    LeftPanelSection.project => NutriaDropdownOption(
                      icon: Icons.info_outline,
                      text: t.boardProject,
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
              selectedIndex: available.indexOf(section),
              onSelected: (i) => ref
                  .read(panelLayoutProvider.notifier)
                  .showSection(available[i]),
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
                  LeftPanelSection.media => const MediaLibraryPanel(),
                  LeftPanelSection.variables => const VariablesPanel(),
                  LeftPanelSection.screen => const ScreenPanel(),
                  LeftPanelSection.project => const ProjectPanel(),
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
