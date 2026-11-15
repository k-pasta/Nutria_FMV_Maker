// Produces thumbnail images for video files, in memory (no temp files).
import 'dart:io';
import 'dart:typed_data';

import 'package:fc_native_video_thumbnail/fc_native_video_thumbnail.dart';
import 'package:media_metadata/media_metadata.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'thumbnail_service.g.dart';

/// Longest side of generated thumbnails, in pixels.
const kThumbnailSize = 500;

/// Creates thumbnail images for videos.
abstract interface class ThumbnailService {
  /// Encoded image bytes (JPEG/PNG) for the video at [path], or `null` if
  /// none could be made.
  Future<Uint8List?> thumbnailFor(String path);
}

/// Uses the video's embedded cover or a captured frame (`media_metadata`),
/// and falls back to `fc_native_video_thumbnail` for files it can't read.
class OsThumbnailService implements ThumbnailService {
  const OsThumbnailService();

  @override
  Future<Uint8List?> thumbnailFor(String path) async {
    if (!await File(path).exists()) return null;
    return await _fromMediaMetadata(path) ?? await _fromNative(path);
  }

  Future<Uint8List?> _fromMediaMetadata(String path) async {
    if (!MediaMetadata.isSupported(path)) return null;
    try {
      final meta = await MediaMetadata.read(path, createThumbnail: true);
      return meta?.imageMetadata?.data;
    } on Exception {
      return null;
    }
  }

  Future<Uint8List?> _fromNative(String path) async {
    try {
      return await FcNativeVideoThumbnail().saveThumbnailToBytes(
        srcFile: path,
        width: kThumbnailSize,
        height: kThumbnailSize,
        format: 'jpeg',
      );
    } on Exception {
      return null;
    }
  }
}

/// The app's [ThumbnailService].
@Riverpod(keepAlive: true)
ThumbnailService thumbnailService(Ref ref) => const OsThumbnailService();
