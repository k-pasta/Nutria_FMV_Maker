// Playback settings for video nodes: project-wide defaults and per-node overrides.
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nutria_fmv_maker/core/document/music.dart';

part 'video_settings.freezed.dart';
part 'video_settings.g.dart';

/// How a video is fitted into the player frame.
enum VideoFit { fit, fill, fillWidth, fillHeight, stretch }

/// Which choice the Player picks when the viewer doesn't choose in time.
enum DefaultSelectionMethod { first, last, lastSelected, random, specified }

/// Every setting a video node can override. The ones in [kFmvSettingTypes]
/// are the keys used in exported `.fmv` files (renaming one is a protocol
/// change); the others are resolved per node when exporting.
enum VideoSettingType {
  selectionTime,
  pauseOnEnd,
  showTimer,

  /// Whether a branched node shows its question above the answers.
  showQuestion,
  videoFit,
  defaultSelection,

  /// The music that goes with the video (track, when it ends, …).
  music,

  /// The music that loops while the viewer chooses at the end of a video.
  pauseMusic,

  /// How long that music fades out once an answer is picked.
  pauseMusicFadeOut,

  /// The answer screen the node uses.
  choiceScreen;

  /// Music settings, which have their own rows (a track picker).
  bool get isMusic =>
      this == music || this == pauseMusic || this == pauseMusicFadeOut;

  /// Screen settings, which have their own rows (a list of the screens).
  bool get isScreen => this == choiceScreen;
}

/// The settings shown as ordinary setting rows (not music or screens).
const kPlaybackSettingTypes = [
  VideoSettingType.selectionTime,
  VideoSettingType.pauseOnEnd,
  VideoSettingType.showTimer,
  VideoSettingType.showQuestion,
  VideoSettingType.videoFit,
  VideoSettingType.defaultSelection,
];

/// The settings the `.fmv` format has as playback settings ("overrides").
const kFmvSettingTypes = [
  VideoSettingType.selectionTime,
  VideoSettingType.pauseOnEnd,
  VideoSettingType.showTimer,
  VideoSettingType.videoFit,
  VideoSettingType.defaultSelection,
];

/// No music: the [MusicCue] of settings without any.
const kNoMusic = MusicCue(audioId: '');

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

    /// Whether branched nodes show their question above the answers.
    @Default(false) bool showQuestion,
    @Default(VideoFit.fit) VideoFit videoFit,
    @Default(DefaultSelectionMethod.first)
    DefaultSelectionMethod defaultSelection,

    /// The music with the video; [kNoMusic] (an empty track) for none, so a
    /// node can override its defaults' music with silence.
    @Default(kNoMusic) MusicCue music,

    /// Imported audio that loops while the viewer chooses; `''` for none
    /// (so a node can override it to "no music").
    @Default('') String pauseMusicId,
    @Default(1000) int pauseMusicFadeOutMs,

    /// The id of the answer screen. A screen that's gone falls back to the
    /// first one.
    @Default('choice') String choiceScreenId,
  }) = _VideoSettings;

  /// [music], or `null` when there is none.
  MusicCue? get musicOrNull => music.audioId.isEmpty ? null : music;

  /// [pauseMusicId], or `null` when there is no pause music.
  String? get pauseMusicOrNull => pauseMusicId.isEmpty ? null : pauseMusicId;

  factory VideoSettings.fromJson(Map<String, dynamic> json) =>
      _$VideoSettingsFromJson(json);

  /// The value of setting [type], for comparing two sets of settings.
  Object valueOf(VideoSettingType type) => switch (type) {
    VideoSettingType.selectionTime => selectionTimeMs,
    VideoSettingType.pauseOnEnd => pauseOnEnd,
    VideoSettingType.showTimer => showTimer,
    VideoSettingType.showQuestion => showQuestion,
    VideoSettingType.videoFit => videoFit,
    VideoSettingType.defaultSelection => defaultSelection,
    VideoSettingType.music => music,
    VideoSettingType.pauseMusic => pauseMusicId,
    VideoSettingType.pauseMusicFadeOut => pauseMusicFadeOutMs,
    VideoSettingType.choiceScreen => choiceScreenId,
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
    bool? showQuestion,
    VideoFit? videoFit,
    DefaultSelectionMethod? defaultSelection,
    MusicCue? music,
    String? pauseMusicId,
    int? pauseMusicFadeOutMs,
    String? choiceScreenId,
  }) = _VideoSettingsOverride;

  factory VideoSettingsOverride.fromJson(Map<String, dynamic> json) =>
      _$VideoSettingsOverrideFromJson(json);

  /// The setting types this override actually changes, in display order.
  List<VideoSettingType> get activeTypes => [
    if (selectionTimeMs != null) VideoSettingType.selectionTime,
    if (pauseOnEnd != null) VideoSettingType.pauseOnEnd,
    if (showTimer != null) VideoSettingType.showTimer,
    if (showQuestion != null) VideoSettingType.showQuestion,
    if (videoFit != null) VideoSettingType.videoFit,
    if (defaultSelection != null) VideoSettingType.defaultSelection,
    if (music != null) VideoSettingType.music,
    if (pauseMusicId != null) VideoSettingType.pauseMusic,
    if (pauseMusicFadeOutMs != null) VideoSettingType.pauseMusicFadeOut,
    if (choiceScreenId != null) VideoSettingType.choiceScreen,
  ];

  bool get isEmpty => activeTypes.isEmpty;

  /// Returns [base] with every non-null field of this override applied.
  VideoSettings applyTo(VideoSettings base) => base.copyWith(
    selectionTimeMs: selectionTimeMs ?? base.selectionTimeMs,
    pauseOnEnd: pauseOnEnd ?? base.pauseOnEnd,
    showTimer: showTimer ?? base.showTimer,
    showQuestion: showQuestion ?? base.showQuestion,
    videoFit: videoFit ?? base.videoFit,
    defaultSelection: defaultSelection ?? base.defaultSelection,
    music: music ?? base.music,
    pauseMusicId: pauseMusicId ?? base.pauseMusicId,
    pauseMusicFadeOutMs: pauseMusicFadeOutMs ?? base.pauseMusicFadeOutMs,
    choiceScreenId: choiceScreenId ?? base.choiceScreenId,
  );

  /// Starts overriding [type], copying its current value from [base] so the
  /// effective behavior doesn't change until the user edits it.
  VideoSettingsOverride enable(
    VideoSettingType type,
    VideoSettings base,
  ) => switch (type) {
    VideoSettingType.selectionTime => copyWith(
      selectionTimeMs: base.selectionTimeMs,
    ),
    VideoSettingType.pauseOnEnd => copyWith(pauseOnEnd: base.pauseOnEnd),
    VideoSettingType.showTimer => copyWith(showTimer: base.showTimer),
    VideoSettingType.showQuestion => copyWith(showQuestion: base.showQuestion),
    VideoSettingType.videoFit => copyWith(videoFit: base.videoFit),
    VideoSettingType.defaultSelection => copyWith(
      defaultSelection: base.defaultSelection,
    ),
    VideoSettingType.music => copyWith(music: base.music),
    VideoSettingType.pauseMusic => copyWith(pauseMusicId: base.pauseMusicId),
    VideoSettingType.pauseMusicFadeOut => copyWith(
      pauseMusicFadeOutMs: base.pauseMusicFadeOutMs,
    ),
    VideoSettingType.choiceScreen => copyWith(
      choiceScreenId: base.choiceScreenId,
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
    VideoSettingType.showQuestion => copyWith(showQuestion: null),
    VideoSettingType.videoFit => copyWith(videoFit: null),
    VideoSettingType.defaultSelection => copyWith(defaultSelection: null),
    VideoSettingType.music => copyWith(music: null),
    VideoSettingType.pauseMusic => copyWith(pauseMusicId: null),
    VideoSettingType.pauseMusicFadeOut => copyWith(pauseMusicFadeOutMs: null),
    VideoSettingType.choiceScreen => copyWith(choiceScreenId: null),
  };
}
