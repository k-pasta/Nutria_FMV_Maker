// Whether imported files exist, and what a folder holds, for finding files
// that were moved.
import 'dart:io';
import 'dart:typed_data';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'media_files_service.g.dart';

/// Read-only questions about files on disk. Never throws.
abstract interface class MediaFiles {
  bool exists(String path);

  /// The files directly in [folder] (not in its subfolders); empty if the
  /// folder can't be read.
  List<String> filesIn(String folder);

  /// The contents of the file at [path], or `null` if it can't be read.
  Future<Uint8List?> readBytes(String path);
}

/// [MediaFiles] on the local disk.
class LocalMediaFiles implements MediaFiles {
  const LocalMediaFiles();

  @override
  bool exists(String path) => File(path).existsSync();

  @override
  List<String> filesIn(String folder) {
    try {
      return [
        for (final entity in Directory(folder).listSync(followLinks: false))
          if (entity is File) entity.path,
      ];
    } on FileSystemException {
      return const [];
    }
  }

  @override
  Future<Uint8List?> readBytes(String path) async {
    try {
      return await File(path).readAsBytes();
    } on FileSystemException {
      return null;
    }
  }
}

/// The app's [MediaFiles]. Override in tests.
@Riverpod(keepAlive: true)
MediaFiles mediaFiles(Ref ref) => const LocalMediaFiles();
