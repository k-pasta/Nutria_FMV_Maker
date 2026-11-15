// Reads technical information about video files (no FFmpeg).
import 'dart:io';

import 'package:media_metadata/media_metadata.dart';
import 'package:path/path.dart' as p;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'media_info_service.g.dart';

/// What the video library shows about a file. Every field except [path] and
/// [fileName] can be missing, depending on the file and the platform.
/// Not saved in projects: it is re-read whenever it's needed.
class VideoInfo {
  const VideoInfo({
    required this.path,
    this.fileSizeBytes,
    this.created,
    this.duration,
    this.width,
    this.height,
    this.frameRate,
    this.videoCodec,
    this.videoBitrate,
    this.audioCodec,
    this.audioBitrate,
    this.audioSampleRate,
    this.audioChannels,
    this.audioBitDepth,
  });

  final String path;
  final int? fileSizeBytes;
  final DateTime? created;
  final Duration? duration;
  final int? width;
  final int? height;
  final double? frameRate;
  final String? videoCodec;

  /// Bits per second.
  final int? videoBitrate;
  final String? audioCodec;

  /// Bits per second.
  final int? audioBitrate;

  /// Hz.
  final int? audioSampleRate;
  final int? audioChannels;
  final int? audioBitDepth;

  String get fileName => p.basename(path);
}

/// Reads [VideoInfo] for a file.
abstract interface class MediaInfoService {
  /// Returns `null` if the file doesn't exist.
  Future<VideoInfo?> read(String path);
}

/// [MediaInfoService] using the OS media APIs (via `media_metadata`) and
/// `dart:io` file stats.
class OsMediaInfoService implements MediaInfoService {
  const OsMediaInfoService();

  @override
  Future<VideoInfo?> read(String path) async {
    final file = File(path);
    if (!await file.exists()) return null;
    final stat = await file.stat();

    Metadata? meta;
    try {
      meta = await MediaMetadata.read(path);
    } on Exception {
      // Unsupported format or a platform error: show the file stats only.
      meta = null;
    }

    return VideoInfo(
      path: path,
      fileSizeBytes: stat.size,
      // dart:io has no creation time; on Windows `changed` is the closest.
      created: stat.changed,
      duration: meta?.duration,
      width: meta?.videoWidth,
      height: meta?.videoHeight,
      frameRate: meta?.frameRate,
      videoCodec: meta?.videoCodec,
      videoBitrate: meta?.videoBitrate,
      audioCodec: meta?.audioCodec,
      audioBitrate: meta?.audioBitrate,
      audioSampleRate: meta?.sampleRate,
      audioChannels: meta?.audioChannels,
      audioBitDepth: meta?.bitsPerSample,
    );
  }
}

/// The app's [MediaInfoService].
@Riverpod(keepAlive: true)
MediaInfoService mediaInfoService(Ref ref) => const OsMediaInfoService();
