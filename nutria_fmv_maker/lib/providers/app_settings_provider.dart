import 'package:flutter/material.dart';
import 'package:nutria_fmv_maker/custom_widgets/branched_video_node.dart';
import 'package:nutria_fmv_maker/models/node_data/video_node_overrides.dart';

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

  List<VideoNodeOverride> _currentVideoSettings = defaultVideoSettings;
  List<VideoNodeOverride> get currentVideoSettings => _currentVideoSettings;

  void updateVideoSetting(VideoNodeOverride newsetting) {
    _currentVideoSettings = _currentVideoSettings
        .map((setting) =>
            setting.videoOverrideType == newsetting.videoOverrideType
                ? newsetting
                : setting)
        .toList();
    notifyListeners();
  }

  void toggleSnapping() {
    _snapSettings = SnapSettings(gridSnapping: !_snapSettings.gridSnapping);
  }
}

//TODO move to models

List<VideoNodeOverride> get defaultVideoSettings => const [
      VideoNodeOverrideSelectionTime(selectionTime: Duration(seconds: 6)),
      VideoNodeOverridePauseOnEnd(pauseOnEnd: false),
      VideoNodeOverrideShowTimer(showTimer: true),
      VideoNodeOverrideVideoFit(videoFit: VideoFit.fit),
      VideoNodeOverrideDefaultSelection(
          defaultSelection: DefaultSelectionMethod.first),
    ];
