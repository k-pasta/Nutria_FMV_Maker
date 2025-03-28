enum VideoOverrides {
  selectionTime,
  pauseOnEnd,
  showTimer,
  videoFit,
  defaultSelection,
  pauseMusicPath,
}


String getVideoOverrideKey(VideoOverrides key) {
  const keyMap = {
    VideoOverrides.selectionTime: 'SelectionTime',
    VideoOverrides.pauseOnEnd: 'PauseOnEnd',
    VideoOverrides.showTimer: 'ShowTimer',
    VideoOverrides.videoFit: 'VideoFit',
    VideoOverrides.defaultSelection: 'DefaultSelection',
    VideoOverrides.pauseMusicPath: 'PauseMusicPath',
  };

  return keyMap[key] ?? 'invalid key';
}

String getOverrideString(String key, dynamic value) {
  final Map<String, String Function(dynamic)> keyToStringMap = {
    getVideoOverrideKey(VideoOverrides.selectionTime): (value) =>
        value is Duration
            ? '${(value.inMilliseconds / 1000).toStringAsFixed(2)} s'
            : 'Invalid Time',
    getVideoOverrideKey(VideoOverrides.pauseOnEnd): (value) =>
        value is bool ? (value ? 'Yes' : 'No') : 'Invalid Bool',
    getVideoOverrideKey(VideoOverrides.showTimer): (value) =>
        value is bool ? (value ? 'Yes' : 'No') : 'Invalid Bool',
    getVideoOverrideKey(VideoOverrides.videoFit): (value) =>
        value is VideoFit ? _getVideoFitString(value) : 'Invalid VideoFit',
    getVideoOverrideKey(VideoOverrides.defaultSelection): (value) =>
        value is DefaultSelectionMethod
            ? _getDefaultSelectionMethodString(value)
            : 'Invalid Selection Method',
    getVideoOverrideKey(VideoOverrides.pauseMusicPath): (value) =>
        value is String && value.isNotEmpty
            ? Uri.file(value).pathSegments.last
            : 'None',
  };

  if (keyToStringMap.containsKey(key)) {
    return keyToStringMap[key]!(value);
  } else {
    return 'Unknown Key';
  }
}

String _getVideoFitString(VideoFit fit) {
  switch (fit) {
    case VideoFit.fit:
      return 'Fit';
    case VideoFit.fitwidth:
      return 'Fit Width';
    case VideoFit.fitheight:
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

enum NodeDataType{ branchedVideo, simpleVideo, originNode }


enum VideoFit { fit, fitwidth, fitheight, fill, fillWidth, fillHeight, stretch }

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
