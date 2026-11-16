// The built-in themes.
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';

/// The default theme: near-black canvas, dark panels, lighter cards.
const kDarkTheme = AppTheme();

/// Light theme: light grey canvas, off-white panels, white cards with soft
/// shadows.
const kLightTheme = AppTheme(
  cBackground: Color(0xffeceef2),
  cBackgroundDots: Color(0xffcfd3db),
  cText: Color(0xd91b1b22),
  cTextActive: Color(0xff111116),
  cTextInactive: Color(0x701b1b22),
  cPanel: Color(0xfff7f8fa),
  cCard: Color(0xffffffff),
  cCardHovered: Color(0xfffafbfc),
  cButton: Color(0xffeef0f4),
  cButtonHovered: Color(0xffe5e8ee),
  cButtonPressed: Color(0xffdbdfe6),
  cButtonContentUnhovered: Color(0x991b1b22),
  cTextField: Color(0xffeef0f4),
  cTextFieldActive: Color(0xffe5e8ee),
  cDivider: Color(0x14000000),
  cOutlines: Color(0x26000000),
  cShadow: Color(0x24252a3a),
  cMenuBar: Color(0xfff7f8fa),
  cMenuBarText: Color(0xff1b1b22),
  cDimmer: Color(0x40000000),
);

/// Playground theme for trying out token changes.
const kCustomTheme = AppTheme(
  dButtonHeight: 32,
  dPanelBorderRadius: 10,
  dButtonBorderRadius: 8,
);

/// Builds the Material [ThemeData] that carries [appTheme], so Material
/// widgets (menus, scrollbars, text selection) match it too.
ThemeData buildThemeData(AppTheme appTheme, {required bool dark}) => ThemeData(
      brightness: dark ? Brightness.dark : Brightness.light,
      fontFamily: 'SourceSans',
      scaffoldBackgroundColor: appTheme.cBackground,
      splashFactory: NoSplash.splashFactory,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontWeight: FontWeight.w600),
        bodyMedium: TextStyle(fontWeight: FontWeight.w600),
        bodySmall: TextStyle(fontWeight: FontWeight.w600),
        headlineLarge: TextStyle(fontWeight: FontWeight.w800),
      ),
      extensions: [appTheme],
    );
