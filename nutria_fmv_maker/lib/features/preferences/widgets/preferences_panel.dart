// The user's editor preferences (kept between sessions, not in projects).
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/features/preferences/providers/preferences_provider.dart';
import 'package:nutria_fmv_maker/features/shell/providers/overlay_provider.dart';
import 'package:nutria_fmv_maker/l10n/generated/app_localizations.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_context_menu.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_scroll_area.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_setting_row.dart';

T _cycle<T>(List<T> values, T current, int direction) =>
    values[(values.indexOf(current) + direction) % values.length];

/// A right-click menu of every value, the [current] one checked.
List<NutriaContextMenuItem> optionsMenu<T>(
  List<T> values,
  T current,
  String Function(T value) label,
  void Function(T value) select,
) => [
  for (final value in values)
    NutriaContextMenuItem(
      icon: value == current ? Icons.check : Icons.circle_outlined,
      label: label(value),
      onSelected: () => select(value),
    ),
];

/// The Preferences section of the left panel.
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
      _cycle(kSupportedLanguages, prefs.languageCode, direction),
    );

    final menuOpen = ref.read(overlayProvider.notifier).setContextMenuOpen;
    String yesNo(bool value) => value ? t.essentialsYes : t.essentialsNo;
    String nodeTypeName(DefaultNodeType type) => switch (type) {
      DefaultNodeType.simpleVideo => t.contextSimpleVideoNode,
      DefaultNodeType.branchedVideo => t.contextBranchingVideoNode,
    };
    String noodleStyleName(NoodleStyle style) => switch (style) {
      NoodleStyle.straight => t.prefNoodleStraight,
      NoodleStyle.curved => t.prefNoodleCurved,
    };

    final rows = [
      NutriaSettingRow(
        label: t.prefGridSnapping,
        value: yesNo(prefs.gridSnapping),
        onTap: notifier.toggleGridSnapping,
        options: optionsMenu([true, false], prefs.gridSnapping, yesNo, (on) {
          if (on != prefs.gridSnapping) notifier.toggleGridSnapping();
        }),
        onOptionsOpenChanged: menuOpen,
      ),
      NutriaSettingRow(
        label: t.prefGridSize,
        value: prefs.gridSize.round().toString(),
        onPrevious: () => notifier.stepGridSize(-1),
        onNext: () => notifier.stepGridSize(1),
        options: optionsMenu(
          kGridSizes,
          prefs.gridSize,
          (size) => size.round().toString(),
          notifier.setGridSize,
        ),
        onOptionsOpenChanged: menuOpen,
      ),
      NutriaSettingRow(
        label: t.prefDefaultNodeType,
        value: nodeTypeName(prefs.defaultNodeType),
        onTap: () => notifier.setDefaultNodeType(
          _cycle(DefaultNodeType.values, prefs.defaultNodeType, 1),
        ),
        options: optionsMenu(
          DefaultNodeType.values,
          prefs.defaultNodeType,
          nodeTypeName,
          notifier.setDefaultNodeType,
        ),
        onOptionsOpenChanged: menuOpen,
      ),
      NutriaSettingRow(
        label: t.prefSimpleMath,
        value: yesNo(prefs.simpleMath),
        onTap: () => notifier.setSimpleMath(!prefs.simpleMath),
        options: optionsMenu(
          [true, false],
          prefs.simpleMath,
          yesNo,
          notifier.setSimpleMath,
        ),
        onOptionsOpenChanged: menuOpen,
      ),
      NutriaSettingRow(
        label: t.prefAutoLinkSubtitles,
        value: yesNo(prefs.autoLinkSubtitles),
        onTap: () => notifier.setAutoLinkSubtitles(!prefs.autoLinkSubtitles),
        options: optionsMenu(
          [true, false],
          prefs.autoLinkSubtitles,
          yesNo,
          notifier.setAutoLinkSubtitles,
        ),
        onOptionsOpenChanged: menuOpen,
      ),
      NutriaSettingRow(
        label: t.prefNoodleStyle,
        value: noodleStyleName(prefs.noodleStyle),
        onTap: () => notifier.setNoodleStyle(
          _cycle(NoodleStyle.values, prefs.noodleStyle, 1),
        ),
        options: optionsMenu(
          NoodleStyle.values,
          prefs.noodleStyle,
          noodleStyleName,
          notifier.setNoodleStyle,
        ),
        onOptionsOpenChanged: menuOpen,
      ),
      NutriaSettingRow(
        label: t.viewTheme,
        value: themeName(prefs.theme),
        onPrevious: () => stepTheme(-1),
        onNext: () => stepTheme(1),
        options: optionsMenu(
          ThemeChoice.values,
          prefs.theme,
          themeName,
          notifier.setTheme,
        ),
        onOptionsOpenChanged: menuOpen,
      ),
      NutriaSettingRow(
        label: t.viewLanguage,
        value: kLanguageNames[prefs.languageCode] ?? prefs.languageCode,
        onPrevious: () => stepLanguage(-1),
        onNext: () => stepLanguage(1),
        options: optionsMenu(
          kSupportedLanguages,
          prefs.languageCode,
          (code) => kLanguageNames[code] ?? code,
          notifier.setLanguage,
        ),
        onOptionsOpenChanged: menuOpen,
      ),
    ];
    return NutriaScrollArea(
      padding: EdgeInsets.symmetric(horizontal: theme.dSectionPadding),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) SizedBox(height: theme.dPanelPadding),
            rows[i],
          ],
        ],
      ),
    );
  }
}
