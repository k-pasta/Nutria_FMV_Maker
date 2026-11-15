// Cached file information and thumbnails for imported videos, keyed by path.
import 'dart:typed_data';

import 'package:nutria_fmv_maker/services/media_info_service.dart';
import 'package:nutria_fmv_maker/services/thumbnail_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'video_library_providers.g.dart';

/// Technical information about the video at [path]. Not saved in the
/// project; read once per session. `null` if the file is missing.
@Riverpod(keepAlive: true)
Future<VideoInfo?> videoInfo(Ref ref, String path) =>
    ref.watch(mediaInfoServiceProvider).read(path);

/// Thumbnail image bytes for the video at [path], or `null` if none could be
/// made. Kept for the session so scrolling the library doesn't regenerate.
@Riverpod(keepAlive: true)
Future<Uint8List?> videoThumbnail(Ref ref, String path) =>
    ref.watch(thumbnailServiceProvider).thumbnailFor(path);
