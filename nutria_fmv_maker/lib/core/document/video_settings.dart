// Playback settings for video nodes: project-wide defaults and per-node overrides.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'video_settings.freezed.dart';
part 'video_settings.g.dart';

/// How a video is fitted into the player frame.
enum VideoFit { fit, fill, fillWidth, fillHeight, stretch }

/// Which choice the Player picks when the viewer doesn't choose in time.
enum DefaultSelectionMethod { first, last, lastSelected, random, specified }

/// Every setting a video node can override. The playback ones' names are the
/// keys used in exported `.fmv` files, so renaming one is a protocol change;
/// the pause music ones ([isMusic]) are exported as each node's
/// `pauseMusic` instead.
enum VideoSettingType {
  selectionTime,
  pauseOnEnd,
  showTimer,
  videoFit,
  defaultSelection,

  /// The music that loops while the viewer chooses at the end of a video.
  pauseMusic,

  /// How long that music fades out once an answer is picked.
  pauseMusicFadeOut;

  /// Pause music settings, which have their own rows (a track picker).
  bool get isMusic => this == pauseMusic || this == pauseMusicFadeOut;
}

/// The settings shown as ordinary setting rows (everything but music).
const kPlaybackSettingTypes = [
  VideoSettingType.selectionTime,
  VideoSettingType.pauseOnEnd,
  VideoSettingType.showTimer,
  VideoSettingType.videoFit,
  VideoSettingType.defaultSelection,
];

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

    /// Imported audio that loops while the viewer chooses; `''` for none
    /// (so a node can override it to "no music").
    @Default('') String pauseMusicId,
    @Default(1000) int pauseMusicFadeOutMs,
  }) = _VideoSettings;

  /// [pauseMusicId], or `null` when there is no pause music.
  String? get pauseMusicOrNull => pauseMusicId.isEmpty ? null : pauseMusicId;

  factory VideoSettings.fromJson(Map<String, dynamic> json) =>
      _$VideoSettingsFromJson(json);

  /// The value of setting [type], for comparing two sets of settings.
  Object valueOf(VideoSettingType type) => switch (type) {
    VideoSettingType.selectionTime => selectionTimeMs,
    VideoSettingType.pauseOnEnd => pauseOnEnd,
    VideoSettingType.showTimer => showTimer,
    VideoSettingType.videoFit => videoFit,
    VideoSettingType.defaultSelection => defaultSelection,
    VideoSettingType.pauseMusic => pauseMusicId,
    VideoSettingType.pauseMusicFadeOut => pauseMusicFadeOutMs,
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
    String? pauseMusicId,
    int? pauseMusicFadeOutMs,
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
    if (pauseMusicId != null) VideoSettingType.pauseMusic,
    if (pauseMusicFadeOutMs != null) VideoSettingType.pauseMusicFadeOut,
  ];

  bool get isEmpty => activeTypes.isEmpty;

  /// Returns [base] with every non-null field of this override applied.
  VideoSettings applyTo(VideoSettings base) => base.copyWith(
    selectionTimeMs: selectionTimeMs ?? base.selectionTimeMs,
    pauseOnEnd: pauseOnEnd ?? base.pauseOnEnd,
    showTimer: showTimer ?? base.showTimer,
    videoFit: videoFit ?? base.videoFit,
    defaultSelection: defaultSelection ?? base.defaultSelection,
    pauseMusicId: pauseMusicId ?? base.pauseMusicId,
    pauseMusicFadeOutMs: pauseMusicFadeOutMs ?? base.pauseMusicFadeOutMs,
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
        VideoSettingType.pauseMusic => copyWith(
          pauseMusicId: base.pauseMusicId,
        ),
        VideoSettingType.pauseMusicFadeOut => copyWith(
          pauseMusicFadeOutMs: base.pauseMusicFadeOutMs,
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
    VideoSettingType.pauseMusic => copyWith(pauseMusicId: null),
    VideoSettingType.pauseMusicFadeOut => copyWith(pauseMusicFadeOutMs: null),
  };
}
