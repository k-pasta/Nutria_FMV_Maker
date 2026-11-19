// The MaterialApp: theme and language from preferences, home is the shell.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/app/app_info.dart';
import 'package:nutria_fmv_maker/features/preferences/providers/preferences_provider.dart';
import 'package:nutria_fmv_maker/features/shell/widgets/app_shell.dart';
import 'package:nutria_fmv_maker/l10n/generated/app_localizations.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme_presets.dart';

/// The [AppTheme] for a [ThemeChoice].
AppTheme appThemeFor(ThemeChoice choice) => switch (choice) {
  ThemeChoice.dark => kDarkTheme,
  ThemeChoice.light => kLightTheme,
  ThemeChoice.custom => kCustomTheme,
};

/// The root widget: theme and language from the preferences, around the
/// [AppShell].
class NutriaApp extends ConsumerWidget {
  const NutriaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(preferencesProvider.select((p) => p.theme));
    final language = ref.watch(
      preferencesProvider.select((p) => p.languageCode),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: kAppName,
      locale: Locale(language),
      // Not AppLocalizations.localizationsDelegates: that list uses the
      // flutter_localizations delegates for the deprecated material.dart
      // types, which material_ui widgets don't read.
      localizationsDelegates: const [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: buildThemeData(
        appThemeFor(theme),
        dark: theme == ThemeChoice.dark,
      ),
      home: const AppShell(),
    );
  }
}
