// The music that goes with a video node.
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nutria_fmv_protocol/nutria_fmv_protocol.dart';

part 'music.freezed.dart';
part 'music.g.dart';

/// Fade-out lengths offered in the right-click menu, in milliseconds.
const kMusicFadeSteps = [0, 250, 500, 1000, 2000, 3000, 5000];

/// One arrow click or drag step of a fade length, in milliseconds.
const kMusicFadeStepMs = 250;

/// The longest fade, in milliseconds.
const kMaxMusicFadeMs = 60000;

/// [ms] stepped [direction] (-1 or 1) by [kMusicFadeStepMs], onto the next
/// multiple of it, within 0 and [kMaxMusicFadeMs].
int stepFade(int ms, int direction) {
  final steps = direction > 0
      ? ms ~/ kMusicFadeStepMs + 1
      : (ms + kMusicFadeStepMs - 1) ~/ kMusicFadeStepMs - 1;
  return (steps * kMusicFadeStepMs).clamp(0, kMaxMusicFadeMs);
}

/// A typed fade length in seconds, as milliseconds; `null` if it isn't one.
int? fadeFromSeconds(double? seconds) => seconds == null || seconds < 0
    ? null
    : (seconds * 1000).round().clamp(0, kMaxMusicFadeMs);

/// Music that plays with a video: imported audio [audioId], until [end].
@freezed
abstract class MusicCue with _$MusicCue {
  const factory MusicCue({
    required String audioId,
    @Default(FmvMusicEnd.videoEnds) FmvMusicEnd end,
    @Default(false) bool loop,
    @Default(1000) int fadeOutMs,

    /// Pauses while the video is paused at its end ("pause on end").
    @Default(true) bool pauseWithVideo,
  }) = _MusicCue;

  factory MusicCue.fromJson(Map<String, dynamic> json) =>
      _$MusicCueFromJson(json);
}
