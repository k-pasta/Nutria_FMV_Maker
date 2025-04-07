import 'package:flutter/material.dart';
import '../models/app_theme.dart';
import '../models/enums_ui.dart';

class ThemeProvider extends ChangeNotifier {
  static const AppTheme _appThemeDark = AppTheme();
  static const AppTheme _appThemeLight = AppTheme(
  // ... keep all previous background/text colors from darker version ...
  cPanel: Color.fromARGB(255, 216, 216, 216),               // Maintain panel color
  cPanelTransparent: Color(0xf1d0d0d0),    // Keep panel transparency
  
  // Darker buttons progression
  cButton: Color(0xffe0e0e0),              // Darker than panel (Grey 400)
  cButtonHovered: Color(0xffe0e0e0),       // Medium-dark (Grey 500)
  cButtonPressed: Color.fromARGB(255, 243, 243, 243),       // Dark pressed (Grey 600)
  
  // Darker menu bar
  cMenuBar: Color(0xffbdbdbd),             // Matches button base (Grey 400)
  cMenuBarText: Color(0xff000000),         // Keep black text
  
// cAccentButton: Color(0xaaff4e6a),
// cAccentButtonHovered: Color(0xccff4e6a),
// cAccentButtonPressed: Color(0xffff4e6a),
cAccentButton: Color.fromARGB(170, 255, 255, 255),
cAccentButtonHovered: Color.fromARGB(204, 255, 255, 255),
cAccentButtonPressed: Color.fromARGB(255, 255, 255, 255),
cButtonContentUnhovered: Color.fromARGB(75, 0, 0, 0),
  // Rest remains same as previous darker version:
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

  static const AppTheme _appThemeCustom = AppTheme(
      dButtonHeight: 21,
      cBackgroundDots: Colors.white,
      cBackground: Colors.white);
//   AppTheme _customAppThemeDark;
//   AppTheme _customAppThemeLight;
  AppTheme _currentAppTheme = _appThemeDark;
  bool _isThemeDark = true;

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
