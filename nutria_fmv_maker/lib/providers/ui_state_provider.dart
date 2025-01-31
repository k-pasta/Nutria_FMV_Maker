import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class UiStateProvider extends ChangeNotifier {
  bool _isModalOrMenuOpen = false;
  bool get isModalOrMenuOpen => _isModalOrMenuOpen;
  void setModalOrMenuOpen(bool value) {
    _isModalOrMenuOpen = value;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
}
