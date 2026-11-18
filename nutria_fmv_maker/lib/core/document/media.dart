// Files imported into a project (videos, audio, images, subtitles, fonts).
import 'package:freezed_annotation/freezed_annotation.dart';

part 'media.freezed.dart';
part 'media.g.dart';

/// What kind of file a [MediaAsset] is, decided by its extension.
enum MediaKind { video, audio, image, subtitle, font }

/// The file extensions (lower case, without the dot) of each [MediaKind].
const kMediaExtensions = <MediaKind, List<String>>{
  MediaKind.video: [
    'mp4', 'mkv', 'mov', 'avi', 'webm', 'wmv', 'm4v', 'mpg', 'mpeg', 'flv',
  ],
  MediaKind.audio: ['mp3', 'wav', 'ogg', 'flac', 'm4a', 'aac', 'opus', 'wma'],
  MediaKind.image: ['png', 'jpg', 'jpeg', 'webp', 'bmp', 'gif'],
  MediaKind.subtitle: ['srt'],
  MediaKind.font: ['ttf', 'otf'],
};

/// Every extension the media library imports.
final List<String> kAllMediaExtensions = [
  for (final list in kMediaExtensions.values) ...list,
];

/// The lower-case extension of [path] without the dot, or '' if none.
String extensionOf(String path) {
  final name = fileNameOf(path);
  final dot = name.lastIndexOf('.');
  return dot <= 0 ? '' : name.substring(dot + 1).toLowerCase();
}

/// The file name of [path] including the extension, for either separator.
String fileNameOf(String path) {
  final slash = path.lastIndexOf('/');
  final backslash = path.lastIndexOf(r'\');
  return path.substring((slash > backslash ? slash : backslash) + 1);
}

/// The kind of the file at [path]. Unknown extensions count as videos:
/// projects from before the media library only had videos.
MediaKind mediaKindOf(String path) => mediaKindOfExtension(extensionOf(path));

/// The kind of files with [extension] (lower case, without the dot).
MediaKind mediaKindOfExtension(String extension) {
  for (final MapEntry(:key, :value) in kMediaExtensions.entries) {
    if (value.contains(extension)) return key;
  }
  return MediaKind.video;
}

/// A file imported into the project.
///
/// Only the location is saved. Thumbnails and metadata are re-read from the
/// file at runtime, so they never go stale. The kind comes from the
/// extension, so it can't disagree with the file.
@freezed
abstract class MediaAsset with _$MediaAsset {
  const MediaAsset._();

  const factory MediaAsset({
    required String id,

    /// Absolute path on the machine that last saved the project.
    required String path,
  }) = _MediaAsset;

  factory MediaAsset.fromJson(Map<String, dynamic> json) =>
      _$MediaAssetFromJson(json);

  /// File name including extension, independent of the path separator.
  String get fileName => fileNameOf(path);

  /// Lower-case extension without the dot.
  String get extension => extensionOf(path);

  MediaKind get kind => mediaKindOf(path);

  bool get isVideo => kind == MediaKind.video;
}
