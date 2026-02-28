/// script for all enums used for data clarity

/// Enum of defined and acceptable video node behavior overrides by the app.
///
/// - `selectionTime` (`double`): The time available for selection in milliseconds **before the end** of the video.
/// - `pauseOnEnd` (`bool`): Whether the video will pause when the `selectionTime` is reached (or at the end of the video if `selectionTime` is not set).
/// - `showTimer` (`bool`): Whether a UI timer displaying the remaining time is visible.
/// - `videoFit` [VideoFit]: the video fitting algorithm.
/// - `defaultSelection` [DefaultSelectionMethod]: The algorithm used to auto-select when `pauseOnEnd` is `false`.
/// - `pauseMusicPath` (`string`): is to reference an audio file for when paused. currently unused
enum VideoOverrides {
  selectionTime,
  pauseOnEnd,
  showTimer,
  videoFit,
  defaultSelection,
  pauseMusicPath,
}

/// TODO reference localization
String getOverrideString(String overrideKey, dynamic value) {
  final Map<String, String Function(dynamic)> keyToStringMap = {
    VideoOverrides.selectionTime.name: (value) => value is Duration
        ? '${(value.inMilliseconds / 1000).toStringAsFixed(2)} s'
        : 'Invalid Time',
    VideoOverrides.pauseOnEnd.name: (value) =>
        value is bool ? (value ? 'Yes' : 'No') : 'Invalid Bool',
    VideoOverrides.showTimer.name: (value) =>
        value is bool ? (value ? 'Yes' : 'No') : 'Invalid Bool',
    VideoOverrides.videoFit.name: (value) =>
        value is VideoFit ? _getVideoFitString(value) : 'Invalid VideoFit',
    VideoOverrides.defaultSelection.name: (value) =>
        value is DefaultSelectionMethod
            ? _getDefaultSelectionMethodString(value)
            : 'Invalid Selection Method',
    VideoOverrides.pauseMusicPath.name: (value) =>
        value is String && value.isNotEmpty
            ? Uri.file(value).pathSegments.last
            : 'None',
  };

  if (keyToStringMap.containsKey(overrideKey)) {
    return keyToStringMap[overrideKey]!(value);
  } else {
    return 'Unknown Key';
  }
}

dynamic getOverrideForJson(String overrideKey, dynamic value) {
  final Map<String, dynamic Function(dynamic)> keyToStringMap = {
    VideoOverrides.selectionTime.name: (value) =>
        value is Duration ? value.inMilliseconds : null,
    VideoOverrides.pauseOnEnd.name: (value) => value is bool ? value : null,
    VideoOverrides.showTimer.name: (value) => value is bool ? value : null,
    VideoOverrides.videoFit.name: (value) =>
        value is VideoFit ? _getVideoFitString(value) : null,
    VideoOverrides.defaultSelection.name: (value) =>
        value is DefaultSelectionMethod
            ? _getDefaultSelectionMethodString(value)
            : null,
    VideoOverrides.pauseMusicPath.name: (value) =>
        value is String && value.isNotEmpty
            ? Uri.file(value).pathSegments.last
            : null,
  };

  if (keyToStringMap.containsKey(overrideKey)) {
    return keyToStringMap[overrideKey]!(value);
  } else {
    return 'Unknown Key';
  }
}

String _getVideoFitString(VideoFit fit) {
  switch (fit) {
    case VideoFit.fit:
      return 'Fit';
    case VideoFit.fitWidth:
      return 'Fit Width';
    case VideoFit.fitHeight:
      return 'Fit Height';
    case VideoFit.fill:
      return 'Fill';
    case VideoFit.fillWidth:
      return 'Fill Width';
    case VideoFit.fillHeight:
      return 'Fill Height';
    case VideoFit.stretch:
      return 'Stretch';
    default:
      return 'Unknown';
  }
}

String _getDefaultSelectionMethodString(DefaultSelectionMethod method) {
  switch (method) {
    case DefaultSelectionMethod.first:
      return 'First';
    case DefaultSelectionMethod.last:
      return 'Last';
    case DefaultSelectionMethod.lastSelected:
      return 'Last Selected';
    case DefaultSelectionMethod.random:
      return 'Random';
    case DefaultSelectionMethod.specified:
      return 'Specified';
    default:
      return 'Unknown';
  }
}

enum LoadErrors {
  userCancelled,
  invalidData,
  unknownError,
}

enum NodeDataType { branchedVideo, simpleVideo, originNode }

enum VideoFit { fit, fitWidth, fitHeight, fill, fillWidth, fillHeight, stretch }

enum DefaultSelectionMethod { first, last, lastSelected, random, specified }

enum LogicalPositionType { output, input, node, empty }

enum MediaFileSource { videoFile, node, audioFile }

enum FileSizeUnit { bytes, kilobytes, megabytes, gigabytes }

enum VideoMetadataType {
  // Basic File Information
  filename, // Helps identify and locate the media file.
  filePath, // Useful for file management.
  fileSize, // Indicates storage impact.
  dateCreated, // Helps with version control.

  // Video Metadata
  resolution, // Determines quality and aspect ratio.
  frameRate, // Affects playback smoothness.
  codecFormat, // Determines compatibility.
  bitrate, // Affects quality and file size.
  aspectRatio, // Impacts composition.
  colorProfile, // Determines color grading workflow.
  duration, // Total length of the video.
  timecode, // Helps with precise editing and synchronization.

  // Audio Metadata
  audioSampleRate, // Impacts audio quality.
  audioBitDepth, // Affects dynamic range.
  audioChannels, // Determines audio configuration.
  audioCodecFormat, // Affects compression and quality.
}
