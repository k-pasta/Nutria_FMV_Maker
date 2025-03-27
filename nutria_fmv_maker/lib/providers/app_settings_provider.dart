import 'package:flutter/material.dart';

import '../models/enums_data.dart';
import '../models/snap_settings.dart';

class AppSettingsProvider extends ChangeNotifier {
  static const SnapSettings defaultSnapSettings =
      SnapSettings(gridSnapping: false);

  SnapSettings _snapSettings = defaultSnapSettings;
  SnapSettings get snapSettings => _snapSettings;

  Map<VideoOverrides, dynamic> _currentVideoSettings = defaultVideoSettings;
  Map<VideoOverrides, dynamic> get currentVideoSettings => _currentVideoSettings;

  void toggleSnapping() {
    _snapSettings = SnapSettings(gridSnapping: !_snapSettings.gridSnapping);
  }
}

//TODO move to models

const Map<VideoOverrides, dynamic> defaultVideoSettings = {
  VideoOverrides.pauseOnEnd: false,
  VideoOverrides.showTimer: true,
  VideoOverrides.selectionTime: Duration(seconds: 6),
  VideoOverrides.pauseMusicPath: '',
  VideoOverrides.videoFit: VideoFit.fit,
  VideoOverrides.defaultSelection: DefaultSelectionMethod.first,
};

// class VideoNodeOverrides {
//   final bool pauseOnEnd;
//   final bool showTimer;
//   final Duration selectionTime;
//   final String pauseMusicPath;
//   final VideoFit videofit;
//   final DefaultSelectionMethod defaultSelectionMethod;

//   const VideoNodeOverrides({
//     this.pauseOnEnd = false,
//     this.showTimer = true,
//     this.selectionTime = const Duration(seconds: 6),
//     this.pauseMusicPath = '',
//     this.videofit = VideoFit.fit,
//     this.defaultSelectionMethod = DefaultSelectionMethod.first,
//   });
// }

// extension VideoNodeOverrideStrings on VideoNodeOverrides {
//   String getStringForEnum(VideoNodeOverrideKeys enumValue) {
//     final Map<VideoNodeOverrideKeys, String> enumToString = {
//       VideoNodeOverrideKeys.videoFit: _getVideoFitString(videofit),
//       VideoNodeOverrideKeys.defaultSelection: _getDefaultSelectionMethodString(defaultSelectionMethod),
//       VideoNodeOverrideKeys.pauseOnEnd: pauseOnEnd ? 'Yes' : 'No',
//       VideoNodeOverrideKeys.showTimer: showTimer ? 'Yes' : 'No',
//       VideoNodeOverrideKeys.selectionTime: '${(selectionTime.inMilliseconds / 1000).toStringAsFixed(2)} s',
//       VideoNodeOverrideKeys.pauseMusicPath: pauseMusicPath.isNotEmpty ? Uri.file(pauseMusicPath).pathSegments.last : 'No path provided',
//     };

//     return enumToString[enumValue] ?? 'Unknown';
//   }

//   String _getVideoFitString(VideoFit fit) {
//     switch (fit) {
//       case VideoFit.fit:
//         return 'Fit';
//       case VideoFit.fitwidth:
//         return 'Fit Width';
//       case VideoFit.fitheight:
//         return 'Fit Height';
//       case VideoFit.fill:
//         return 'Fill';
//       case VideoFit.fillWidth:
//         return 'Fill Width'; // Corrected typo here
//       case VideoFit.fillHeight:
//         return 'Fill Height';
//       case VideoFit.stretch:
//         return 'Stretch';
//       default:
//         return 'Unknown';
//     }
//   }

//   String _getDefaultSelectionMethodString(DefaultSelectionMethod method) {
//     switch (method) {
//       case DefaultSelectionMethod.first:
//         return 'First';
//       case DefaultSelectionMethod.last:
//         return 'Last';
//       case DefaultSelectionMethod.lastSelected:
//         return 'Last Selected';
//       case DefaultSelectionMethod.random:
//         return 'Random';
//       case DefaultSelectionMethod.specified:
//         return 'Specified';
//       default:
//         return 'Unknown';
//     }
//   }
// }

