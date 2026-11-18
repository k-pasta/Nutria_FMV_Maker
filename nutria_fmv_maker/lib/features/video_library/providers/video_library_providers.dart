// Cached file information and thumbnails for imported videos, keyed by path,
// and the library's collapsed groups.
import 'dart:typed_data';

import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:nutria_fmv_maker/services/media_files_service.dart';
import 'package:nutria_fmv_maker/services/media_info_service.dart';
import 'package:nutria_fmv_maker/services/thumbnail_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'video_library_providers.g.dart';

/// Technical information about the video at [path]. Not saved in the
/// project; read once per session. `null` if the file is missing.
@Riverpod(keepAlive: true)
Future<VideoInfo?> videoInfo(Ref ref, String path) =>
    ref.watch(mediaInfoServiceProvider).read(path);

/// The ids of imported files that can't be found on disk. Checked again
/// whenever the media list changes (import, relink, undo).
@riverpod
Set<String> missingMedia(Ref ref) {
  final files = ref.watch(mediaFilesProvider);
  return {
    for (final asset in ref.watch(mediaAssetsProvider))
      if (!files.exists(asset.path)) asset.id,
  };
}

/// The library groups the user has collapsed this session (see
/// `LibraryGroup.key`). Not saved.
@Riverpod(keepAlive: true)
class CollapsedLibraryGroups extends _$CollapsedLibraryGroups {
  @override
  Set<Object> build() => const {};

  void toggle(Object key) => state = state.contains(key)
      ? ({...state}..remove(key))
      : {...state, key};
}

/// Thumbnail image bytes for the video at [path], or `null` if none could be
/// made. Kept for the session so scrolling the library doesn't regenerate.
@Riverpod(keepAlive: true)
Future<Uint8List?> videoThumbnail(Ref ref, String path) =>
    ref.watch(thumbnailServiceProvider).thumbnailFor(path);
