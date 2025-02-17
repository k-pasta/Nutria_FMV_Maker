import 'package:flutter/material.dart';

class AppSettingsProvider extends ChangeNotifier {
  static const SnapSettings defaultSnapSettings =
      SnapSettings(gridSnapping: true);
      
  SnapSettings _snapSettings = defaultSnapSettings;
  SnapSettings get snapSettings => _snapSettings;

  void toggleSnapping() {
    _snapSettings = SnapSettings(gridSnapping: !_snapSettings.gridSnapping);
  }
}


//TODO move to models

class SnapSettings {
  final bool gridSnapping;
  final double gridSize;

  const SnapSettings({
    required this.gridSnapping,
    this.gridSize = 50,
  });
}

class VideoNodeOverrides {

}
