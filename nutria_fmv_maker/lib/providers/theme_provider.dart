import 'package:flutter/material.dart';
import '../models/app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  static const AppTheme _appThemeDark = AppTheme();
  static const AppTheme _appThemeLight = AppTheme(dButtonHeight: 20,
  cBackgroundDots: Colors.white, cBackground: Colors.white);
  static const AppTheme _appThemeCustom = AppTheme(dButtonHeight: 21,
  cBackgroundDots: Colors.white, cBackground: Colors.white);
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

enum ThemeType {
  dark,
  light,
  custom,
}
