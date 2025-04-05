import 'package:flutter/material.dart';
import '../models/app_theme.dart';
import '../models/enums_ui.dart';

class ThemeProvider extends ChangeNotifier {
  static const AppTheme _appThemeDark = AppTheme();
  static const AppTheme _appThemeLight = AppTheme(
  // ... keep all previous background/text colors from darker version ...
  cPanel: Color(0xffd0d0d0),               // Maintain panel color
  cPanelTransparent: Color(0xf1d0d0d0),    // Keep panel transparency
  
  // Darker buttons progression
  cButton: Color(0xffbdbdbd),              // Darker than panel (Grey 400)
  cButtonHovered: Color(0xff9e9e9e),       // Medium-dark (Grey 500)
  cButtonPressed: Color(0xff757575),       // Dark pressed (Grey 600)
  
  // Darker menu bar
  cMenuBar: Color(0xffbdbdbd),             // Matches button base (Grey 400)
  cMenuBarText: Color(0xff000000),         // Keep black text
  
  // Rest remains same as previous darker version:
  cBackground: Color(0xffe0e0e0),
  cBackgroundDots: Color(0xffbdbdbd),
  cAccent: Color(0xffff4e6a),
  cAccentButton: Color(0xaaff4e6a),
  cAccentButtonHovered: Color(0xccff4e6a),
  cAccentButtonPressed: Color(0xffff4e6a),
  cText: Color(0xe0000000),
  cTextActive: Color(0xff000000),
  cTextInactive: Color(0xcc000000),
  cOutlines: Color(0x65000000),
  cButtonOutlines: Color(0xf1bdbdbd),
  cTextField: Color(0x00000000),
  cTextFieldActive: Color(0x2a000000),
);

  // AppTheme(
  //   cBackground: const Color(0xfffafafa), // light grey background
  //   cBackgroundDots: const Color(0xffe0e0e0), // subtle light grey for dots
  //   cAccent: const Color(0xffe91e63), // vibrant pink accent
  //   cAccentButton: const Color(0xaae91e63),
  //   cAccentButtonHovered: const Color(0xcce91e63),
  //   cAccentButtonPressed: const Color(0xffe91e63),
  //   cText: const Color(0xdd000000), // mostly opaque dark text
  //   cTextActive: const Color(0xff000000), // solid dark for active text
  //   cTextInactive: const Color.fromARGB(
  //       65, 0, 0, 0), // very transparent dark for inactive text
  //   dTextHeight: 14,
  //   dTextfieldPadding: 7,
  //   cPanel: const Color(0xffffffff), // white panels
  //   cPanelTransparent:
  //       const Color(0xf1ffffff), // nearly opaque white for transparent panels
  //   cOutlines: const Color(0x45000000), // subtle dark outlines
  //   dSectionPadding: 10,
  //   dOutlinesWidth: 1,
  //   cButtonOutlines: const Color(0xffbdbdbd), // light grey outlines for buttons
  //   dButtonOutlinesWidth: 1,
  //   cButton: const Color(0xfff0f0f0), // light grey button background
  //   cButtonHovered: const Color(0xffe0e0e0), // slightly darker on hover
  //   cButtonPressed: const Color(0xffd0d0d0), // even darker when pressed
  //   cTextField: const Color(0x00000000), // transparent text field background
  //   cTextFieldActive: const Color(0x4a000000), // subtle dark tint when active
  //   dPanelPadding: 7,
  //   dPanelRowDistance: 7,
  //   dPanelBorderRadius: 7,
  //   dSwatchHeight: 10,
  //   dButtonHeight: 45,
  //   dButtonBorderRadius: 5,
  //   dScrollbarWidth: 11,
  //   cMenuBar: const Color(0xffffffff), // white menu bar
  //   cMenuBarText: const Color(0xff000000), // dark text for menu bar
  //   dMenuBarHeight: 67,
  // );

  static const AppTheme _appThemeCustom = AppTheme(
      dButtonHeight: 21,
      cBackgroundDots: Colors.white,
      cBackground: Colors.white);
//   AppTheme _customAppThemeDark;
//   AppTheme _customAppThemeLight;
  AppTheme _currentAppTheme = _appThemeDark;
  bool _isThemeDark = true;

  ThemeProvider();

  get currentAppTheme => _currentAppTheme;
  get isThemeDark => _isThemeDark;

  void setTheme(ThemeType themeType) {
    AppTheme newTheme;
    bool newIsThemeDark;

    switch (themeType) {
      case ThemeType.dark:
        newTheme = _appThemeDark;
        newIsThemeDark = true;
        break;
      case ThemeType.light:
        newTheme = _appThemeLight;
        newIsThemeDark = false;
        break;
      case ThemeType.custom:
        newTheme = _appThemeCustom;
        newIsThemeDark = false;
        break;
    }

    if (_currentAppTheme != newTheme) {
      _currentAppTheme = newTheme;
      _isThemeDark = newIsThemeDark;
      notifyListeners();
    }
  }

  void toggleThemeMode() {
    _currentAppTheme = _isThemeDark ? _appThemeLight : _appThemeDark;
    _isThemeDark = !_isThemeDark;
    notifyListeners();
  }
}
