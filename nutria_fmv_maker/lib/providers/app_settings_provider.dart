import 'package:flutter/material.dart';
import 'package:nutria_fmv_maker/custom_widgets/branched_video_node.dart';

import '../models/enums_data.dart';
import '../models/snap_settings.dart';

class AppSettingsProvider extends ChangeNotifier {
  static const SnapSettings defaultSnapSettings =
      SnapSettings(gridSnapping: false);

  NodeDataType _defaultNodeType = NodeDataType.branchedVideo;

  NodeDataType get defaultNodeType => _defaultNodeType;

  set defaultNodeType(NodeDataType value) {
    if (_defaultNodeType == value) return;
    if (value != NodeDataType.branchedVideo &&
        value != NodeDataType.simpleVideo) {
      //  throw ArgumentError(
      //   'Invalid node type: $value. Must be either NodeDataType.branchedVideo or NodeDataType.simpleVideo.');
      return;
    }
    _defaultNodeType = value;
  }

  SnapSettings _snapSettings = defaultSnapSettings;
  SnapSettings get snapSettings => _snapSettings;

  Map<VideoOverrides, dynamic> _currentVideoSettings = defaultVideoSettings;
  Map<VideoOverrides, dynamic> get currentVideoSettings =>
      _currentVideoSettings;

  void updateVideoSetting(VideoOverrides key, dynamic value) {
    _currentVideoSettings = {
      ..._currentVideoSettings, //overwrites the value
      key: value,
    };
    notifyListeners();
  }

  void toggleSnapping() {
    _snapSettings = SnapSettings(gridSnapping: !_snapSettings.gridSnapping);
  }
}

//TODO move to models

const Map<VideoOverrides, dynamic> defaultVideoSettings = {
  VideoOverrides.pauseOnEnd: false,
  VideoOverrides.showTimer: true,
  VideoOverrides.selectionTime: Duration(seconds: 6),
  // VideoOverrides.pauseMusicPath: '',
  VideoOverrides.videoFit: VideoFit.fit,
  VideoOverrides.defaultSelection: DefaultSelectionMethod.first,
};
