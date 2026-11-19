// The music that goes with a video node.
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nutria_fmv_protocol/nutria_fmv_protocol.dart';

part 'music.freezed.dart';
part 'music.g.dart';

/// Fade-out lengths offered, in milliseconds.
const kMusicFadeSteps = [0, 250, 500, 1000, 2000, 3000, 5000];

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
