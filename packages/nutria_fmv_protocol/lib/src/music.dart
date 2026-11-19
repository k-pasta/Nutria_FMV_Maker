// Music: the main menu's, the music that goes with a video, and the music
// while the viewer chooses.
import 'package:nutria_fmv_protocol/src/enums.dart';

/// When a video's music stops.
enum FmvMusicEnd {
  /// When the track has played once (never, if it loops).
  trackEnds,

  /// When the choices appear.
  choicesAppear,

  /// When the video ends.
  videoEnds,

  /// It goes on into the next nodes, until one with music of its own.
  laterNodeChanges;

  static FmvMusicEnd? parse(Object? value) =>
      value is String ? fmvParseEnum(values, value) : null;
}

/// The music that plays with a video.
class FmvMusic {
  const FmvMusic({
    required this.track,
    this.end = FmvMusicEnd.videoEnds,
    this.loop = false,
    this.fadeOutMs = 1000,
    this.pauseWithVideo = true,
  });

  /// Path of the audio file.
  final String track;
  final FmvMusicEnd end;
  final bool loop;

  /// How long it fades out when it stops, in milliseconds.
  final int fadeOutMs;

  /// Whether it pauses while the video is paused at its end (see
  /// "pauseOnEnd"), not when the player is paused.
  final bool pauseWithVideo;

  Map<String, Object?> toJson() => {
        'track': track,
        'end': end.name,
        'loop': loop,
        'fadeOut': fadeOutMs,
        'pauseWithVideo': pauseWithVideo,
      };

  /// Reads music; `null` without a track.
  static FmvMusic? fromJson(Map<String, Object?> json) {
    final track = json['track'];
    if (track is! String) return null;
    final fadeOut = json['fadeOut'];
    return FmvMusic(
      track: track,
      end: FmvMusicEnd.parse(json['end']) ?? FmvMusicEnd.videoEnds,
      loop: json['loop'] == true,
      fadeOutMs: fadeOut is num ? fadeOut.round() : 1000,
      pauseWithVideo: json['pauseWithVideo'] != false,
    );
  }
}

/// The music that loops while the viewer chooses (ending when they have),
/// or in the main menu.
class FmvLoopMusic {
  const FmvLoopMusic({required this.track, this.fadeOutMs = 1000});

  final String track;

  /// How long it fades out when it stops, in milliseconds.
  final int fadeOutMs;

  Map<String, Object?> toJson() => {'track': track, 'fadeOut': fadeOutMs};

  static FmvLoopMusic? fromJson(Map<String, Object?> json) {
    final track = json['track'];
    if (track is! String) return null;
    final fadeOut = json['fadeOut'];
    return FmvLoopMusic(
      track: track,
      fadeOutMs: fadeOut is num ? fadeOut.round() : 1000,
    );
  }
}
