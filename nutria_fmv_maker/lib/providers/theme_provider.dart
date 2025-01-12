import 'package:flutter/material.dart';
import '../models/app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  static const AppTheme _appThemeDark = AppTheme();
  static const AppTheme _appThemeLight = AppTheme(dButtonHeight: 20,
  cBackgroundDots: Colors.white);
//   AppTheme _customAppThemeDark;
//   AppTheme _customAppThemeLight;
  AppTheme _currentAppTheme = _appThemeDark;
  bool _isThemeDark = true;

  ThemeProvider();

  get currentAppTheme => _currentAppTheme;

  void toggleThemeMode() {
    _currentAppTheme = _isThemeDark ? _appThemeLight : _appThemeDark;
    _isThemeDark = !_isThemeDark;
    notifyListeners();
  }
}
