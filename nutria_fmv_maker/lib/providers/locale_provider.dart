import 'package:material_ui/material_ui.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en', ''); // Default locale is English

  Locale get locale => _locale;

  void changeLocale(Locale newLocale) {
    if (_locale != newLocale) {
      _locale = newLocale;
      notifyListeners();
    }
  }
}