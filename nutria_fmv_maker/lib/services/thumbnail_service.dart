// Produces thumbnail images for video files, in memory (no temp files).
import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';

import 'package:fc_native_video_thumbnail/fc_native_video_thumbnail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'thumbnail_service.g.dart';

/// Longest side of generated thumbnails, in pixels.
const kThumbnailSize = 500;

/// How many thumbnails are made at the same time.
const kThumbnailConcurrency = 2;

/// Creates thumbnail images for videos.
abstract interface class ThumbnailService {
  /// Encoded image bytes (JPEG/PNG) for the video at [path], or `null` if
  /// none could be made.
  Future<Uint8List?> thumbnailFor(String path);
}

/// The operating system's video thumbnails (what Explorer shows), made on a
/// background thread by `fc_native_video_thumbnail`.
///
/// Not `media_metadata`: on Windows it makes thumbnails on the UI thread,
/// which froze the app while many videos were imported. Requests are queued
/// so a big import doesn't start dozens of threads at once.
class OsThumbnailService implements ThumbnailService {
  OsThumbnailService();

  final _queue = Queue<Future<void> Function()>();
  var _running = 0;

  @override
  Future<Uint8List?> thumbnailFor(String path) {
    final done = Completer<Uint8List?>();
    _queue.add(() async => done.complete(await _make(path)));
    _next();
    return done.future;
  }

  void _next() {
    while (_running < kThumbnailConcurrency && _queue.isNotEmpty) {
      final job = _queue.removeFirst();
      _running++;
      unawaited(
        job().whenComplete(() {
          _running--;
          _next();
        }),
      );
    }
  }

  Future<Uint8List?> _make(String path) async {
    try {
      if (!await File(path).exists()) return null;
      return await FcNativeVideoThumbnail().saveThumbnailToBytes(
        srcFile: path,
        width: kThumbnailSize,
        height: kThumbnailSize,
        format: 'jpeg',
      );
    } on Object {
      return null;
    }
  }
}

/// The app's [ThumbnailService].
@Riverpod(keepAlive: true)
ThumbnailService thumbnailService(Ref ref) => OsThumbnailService();
