// Playback settings for video nodes: project-wide defaults and per-node overrides.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'video_settings.freezed.dart';
part 'video_settings.g.dart';

/// How a video is fitted into the player frame.
enum VideoFit { fit, fill, fillWidth, fillHeight, stretch }

/// Which choice the Player picks when the viewer doesn't choose in time.
enum DefaultSelectionMethod { first, last, lastSelected, random, specified }

/// Every setting a video node can override. The enum names are the keys used
/// in exported `.fmv` files, so renaming one is a protocol change.
enum VideoSettingType {
  selectionTime,
  pauseOnEnd,
  showTimer,
  videoFit,
  defaultSelection,
}

/// The full set of playback settings. Used as the project defaults, and as the
/// result of merging a node's [VideoSettingsOverride] onto those defaults.
@freezed
abstract class VideoSettings with _$VideoSettings {
  const VideoSettings._();

  const factory VideoSettings({
    /// Time, in milliseconds before the end of the video, when choices appear.
    @Default(6000) int selectionTimeMs,

    /// Whether playback pauses when the choices appear instead of auto-selecting.
    @Default(false) bool pauseOnEnd,

    /// Whether the Player shows the remaining-time bar.
    @Default(true) bool showTimer,
    @Default(VideoFit.fit) VideoFit videoFit,
    @Default(DefaultSelectionMethod.first)
    DefaultSelectionMethod defaultSelection,
  }) = _VideoSettings;

  factory VideoSettings.fromJson(Map<String, dynamic> json) =>
      _$VideoSettingsFromJson(json);

  /// The value of setting [type], for comparing two sets of settings.
  Object valueOf(VideoSettingType type) => switch (type) {
    VideoSettingType.selectionTime => selectionTimeMs,
    VideoSettingType.pauseOnEnd => pauseOnEnd,
    VideoSettingType.showTimer => showTimer,
    VideoSettingType.videoFit => videoFit,
    VideoSettingType.defaultSelection => defaultSelection,
  };
}

/// A node's deviations from the project [VideoSettings]. A `null` field means
/// "use the project default".
@freezed
abstract class VideoSettingsOverride with _$VideoSettingsOverride {
  const VideoSettingsOverride._();

  const factory VideoSettingsOverride({
    int? selectionTimeMs,
    bool? pauseOnEnd,
    bool? showTimer,
    VideoFit? videoFit,
    DefaultSelectionMethod? defaultSelection,
  }) = _VideoSettingsOverride;

  factory VideoSettingsOverride.fromJson(Map<String, dynamic> json) =>
      _$VideoSettingsOverrideFromJson(json);

  /// The setting types this override actually changes, in display order.
  List<VideoSettingType> get activeTypes => [
    if (selectionTimeMs != null) VideoSettingType.selectionTime,
    if (pauseOnEnd != null) VideoSettingType.pauseOnEnd,
    if (showTimer != null) VideoSettingType.showTimer,
    if (videoFit != null) VideoSettingType.videoFit,
    if (defaultSelection != null) VideoSettingType.defaultSelection,
  ];

  bool get isEmpty => activeTypes.isEmpty;

  /// Returns [base] with every non-null field of this override applied.
  VideoSettings applyTo(VideoSettings base) => base.copyWith(
    selectionTimeMs: selectionTimeMs ?? base.selectionTimeMs,
    pauseOnEnd: pauseOnEnd ?? base.pauseOnEnd,
    showTimer: showTimer ?? base.showTimer,
    videoFit: videoFit ?? base.videoFit,
    defaultSelection: defaultSelection ?? base.defaultSelection,
  );

  /// Starts overriding [type], copying its current value from [base] so the
  /// effective behavior doesn't change until the user edits it.
  VideoSettingsOverride enable(VideoSettingType type, VideoSettings base) =>
      switch (type) {
        VideoSettingType.selectionTime => copyWith(
          selectionTimeMs: base.selectionTimeMs,
        ),
        VideoSettingType.pauseOnEnd => copyWith(pauseOnEnd: base.pauseOnEnd),
        VideoSettingType.showTimer => copyWith(showTimer: base.showTimer),
        VideoSettingType.videoFit => copyWith(videoFit: base.videoFit),
        VideoSettingType.defaultSelection => copyWith(
          defaultSelection: base.defaultSelection,
        ),
      };

  /// This override, plus every setting of [types] it leaves alone in which
  /// [layer] differs from [base]. Used to export a node whose color has its
  /// own defaults ([layer]) as overrides of the project defaults ([base]).
  VideoSettingsOverride layeredOver(
    VideoSettings base,
    VideoSettings layer,
    Iterable<VideoSettingType> types,
  ) {
    var result = this;
    final own = activeTypes;
    for (final type in types) {
      if (!own.contains(type) && base.valueOf(type) != layer.valueOf(type)) {
        result = result.enable(type, layer);
      }
    }
    return result;
  }

  /// Stops overriding [type] (falls back to the project default).
  VideoSettingsOverride disable(VideoSettingType type) => switch (type) {
    VideoSettingType.selectionTime => copyWith(selectionTimeMs: null),
    VideoSettingType.pauseOnEnd => copyWith(pauseOnEnd: null),
    VideoSettingType.showTimer => copyWith(showTimer: null),
    VideoSettingType.videoFit => copyWith(videoFit: null),
    VideoSettingType.defaultSelection => copyWith(defaultSelection: null),
  };
}
