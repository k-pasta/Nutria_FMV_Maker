/// script for all enums used for data clarity

/// Enum of defined and acceptable video node behavior overrides by the app.
///
/// - `selectionTime` (`double`): The time available for selection in milliseconds **before the end** of the video.
/// - `pauseOnEnd` (`bool`): Whether the video will pause when the `selectionTime` is reached (or at the end of the video if `selectionTime` is not set).
/// - `showTimer` (`bool`): Whether a UI timer displaying the remaining time is visible.
/// - `videoFit` [VideoFit]: the video fitting algorithm.
/// - `defaultSelection` [DefaultSelectionMethod]: The algorithm used to auto-select when `pauseOnEnd` is `false`.
/// - `pauseMusicPath` (`string`): is to reference an audio file for when paused. currently unused
enum VideoOverrideType {
  selectionTime,
  pauseOnEnd,
  showTimer,
  videoFit,
  defaultSelection,
  pauseMusicPath,
}

/// TODO reference localization

enum LoadErrors {
  userCancelled,
  invalidData,
  unknownError,
}

enum NodeDataType { branchedVideo, simpleVideo, originNode }

enum VideoFit { fit, fill, fillWidth, fillHeight, stretch }
// fitWidth & fitHeight removed as they are essentially identical to fit

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
