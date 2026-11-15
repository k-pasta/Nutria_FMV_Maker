// The user's editor preferences (kept between sessions, not in projects).
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/features/preferences/providers/preferences_provider.dart';
import 'package:nutria_fmv_maker/l10n/generated/app_localizations.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_scroll_area.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_setting_row.dart';

T _cycle<T>(List<T> values, T current, int direction) =>
    values[(values.indexOf(current) + direction) % values.length];

class PreferencesPanel extends ConsumerWidget {
  const PreferencesPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.appTheme;
    final t = AppLocalizations.of(context);
    final prefs = ref.watch(preferencesProvider);
    final notifier = ref.read(preferencesProvider.notifier);

    String themeName(ThemeChoice choice) => switch (choice) {
          ThemeChoice.dark => t.viewDarkTheme,
          ThemeChoice.light => t.viewLightTheme,
          ThemeChoice.custom => t.viewCustomTheme,
        };
    void stepTheme(int direction) =>
        notifier.setTheme(_cycle(ThemeChoice.values, prefs.theme, direction));
    void stepLanguage(int direction) => notifier.setLanguage(
        _cycle(kSupportedLanguages, prefs.languageCode, direction));

    final rows = [
      NutriaSettingRow(
        label: t.prefGridSnapping,
        value: prefs.gridSnapping ? t.essentialsYes : t.essentialsNo,
        onTap: notifier.toggleGridSnapping,
      ),
      NutriaSettingRow(
        label: t.prefGridSize,
        value: prefs.gridSize.round().toString(),
        onPrevious: () => notifier.stepGridSize(-1),
        onNext: () => notifier.stepGridSize(1),
      ),
      NutriaSettingRow(
        label: t.prefDefaultNodeType,
        value: switch (prefs.defaultNodeType) {
          DefaultNodeType.simpleVideo => t.contextSimpleVideoNode,
          DefaultNodeType.branchedVideo => t.contextBranchingVideoNode,
        },
        onTap: () => notifier.setDefaultNodeType(
            _cycle(DefaultNodeType.values, prefs.defaultNodeType, 1)),
      ),
      NutriaSettingRow(
        label: t.viewTheme,
        value: themeName(prefs.theme),
        onPrevious: () => stepTheme(-1),
        onNext: () => stepTheme(1),
      ),
      NutriaSettingRow(
        label: t.viewLanguage,
        value: kLanguageNames[prefs.languageCode] ?? prefs.languageCode,
        onPrevious: () => stepLanguage(-1),
        onNext: () => stepLanguage(1),
      ),
    ];
    return NutriaScrollArea(
      padding: EdgeInsets.symmetric(horizontal: theme.dSectionPadding),
      child: Column(children: [
        for (var i = 0; i < rows.length; i++) ...[
          if (i > 0) SizedBox(height: theme.dPanelPadding),
          rows[i],
        ],
      ]),
    );
  }
}
