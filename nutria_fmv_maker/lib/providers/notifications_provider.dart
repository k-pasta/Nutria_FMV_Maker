import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nutria_fmv_maker/static_data/data_static_properties.dart';

class NotificationProvider with ChangeNotifier {
  final List<String> _notifications = [];
  String? _currentNotification;

  String? get currentNotification => _currentNotification;

  void addNotification(String message) {
    _notifications.add(message);
    if (_currentNotification == null) {
      _showNext();
    }
  }

  void _showNext() {
    if (_notifications.isEmpty) {
      _currentNotification = null;
      notifyListeners();
      return;
    }

    _currentNotification = _notifications.removeAt(0);
    notifyListeners();

    Timer(const Duration(milliseconds: DataStaticProperties.notificationTimeInMs), () {
      _currentNotification = null;
      notifyListeners();

      // Delay the next notification to allow fade-out
      Timer(const Duration(milliseconds: 200), () {
        _showNext();
      });
    });
  }
}