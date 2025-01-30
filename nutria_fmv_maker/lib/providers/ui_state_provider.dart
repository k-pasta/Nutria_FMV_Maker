import 'package:flutter/material.dart';

class UiStateProvider extends ChangeNotifier {
  bool _isModalOrMenuOpen = false;
  bool get isModalOrMenuOpen => _isModalOrMenuOpen;
  set isModalOrMenuOpen(bool value) {
    _isModalOrMenuOpen = value;
    notifyListeners();
  }
}
