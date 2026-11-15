// The built-in themes.
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';

/// The default theme.
const kDarkTheme = AppTheme();

/// Experimental light theme.
const kLightTheme = AppTheme(
  cPanel: Color.fromARGB(255, 216, 216, 216),
  cPanelTransparent: Color(0xf1d0d0d0),
  cButton: Color(0xffe0e0e0),
  cButtonHovered: Color(0xffe0e0e0),
  cButtonPressed: Color.fromARGB(255, 243, 243, 243),
  cMenuBar: Color(0xffbdbdbd),
  cMenuBarText: Color(0xff000000),
  cAccentButton: Color.fromARGB(170, 255, 255, 255),
  cAccentButtonHovered: Color.fromARGB(204, 255, 255, 255),
  cAccentButtonPressed: Color.fromARGB(255, 255, 255, 255),
  cButtonContentUnhovered: Color.fromARGB(75, 0, 0, 0),
  cBackground: Color.fromARGB(255, 173, 173, 173),
  cBackgroundDots: Color(0xffbdbdbd),
  cAccent: Color(0xffff4e6a),
  cText: Color(0xe0000000),
  cTextActive: Color(0xff000000),
  cTextInactive: Color.fromARGB(204, 139, 139, 139),
  cOutlines: Color(0x65000000),
  cButtonOutlines: Color(0xf1bdbdbd),
  cTextField: Color(0x00000000),
  cTextFieldActive: Color(0xffe0e0e0),
  dOutlinesWidth: 1.5,
);

/// Playground theme for trying out token changes.
const kCustomTheme = AppTheme(
  dButtonHeight: 21,
  cBackgroundDots: Colors.white,
  cBackground: Colors.white,
);

/// Builds the Material [ThemeData] that carries [appTheme], so Material
/// widgets (menus, scrollbars, text selection) match it too.
ThemeData buildThemeData(AppTheme appTheme, {required bool dark}) => ThemeData(
      brightness: dark ? Brightness.dark : Brightness.light,
      fontFamily: 'SourceSans',
      scaffoldBackgroundColor: appTheme.cBackground,
      extensions: [appTheme],
    );
