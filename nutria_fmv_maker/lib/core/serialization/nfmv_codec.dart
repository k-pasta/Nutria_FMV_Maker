// Reads and writes the .nfmv project save format (JSON, versioned).
import 'dart:convert';

import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/core/document/project_document.dart';
import 'package:path/path.dart' as p;

/// Thrown when a `.nfmv` file can't be turned into a [ProjectDocument].
class NfmvFormatException implements Exception {
  const NfmvFormatException(this.reason, {this.foundVersion});

  /// Why decoding failed (for logs and user-facing notifications).
  final NfmvReason reason;

  /// The `formatVersion` found in the file, when relevant.
  final int? foundVersion;

  @override
  String toString() => 'NfmvFormatException($reason, version: $foundVersion)';
}

/// Machine-readable reasons a `.nfmv` file was rejected.
enum NfmvReason {
  /// Not JSON, or not the expected shape.
  invalidData,

  /// Written by an older Nutria FMV Maker (before format versioning).
  unsupportedOldVersion,

  /// Written by a newer Nutria FMV Maker than this one.
  unsupportedNewVersion,
}

/// Converts between [ProjectDocument] and `.nfmv` text.
///
/// Video paths are stored twice: absolute, and relative to the project file.
/// On load the relative path wins when that file exists, so a project folder
/// can be moved or copied to another machine together with its videos.
abstract final class NfmvCodec {
  /// Encodes [document]. Pass [projectDir] (the folder the `.nfmv` is saved
  /// in) to also store project-relative video paths.
  static String encode(ProjectDocument document, {String? projectDir}) {
    final json = document.toJson();
    json['media'] = [
      for (final video in document.media)
        {
          ...video.toJson(),
          if (projectDir != null)
            'relativePath': p.relative(video.path, from: projectDir),
        },
    ];
    return const JsonEncoder.withIndent('  ').convert(json);
  }

  /// Decodes `.nfmv` [source]. [fileExists] is used to pick between the
  /// stored relative and absolute video paths; it is injected so this stays
  /// free of file-system access.
  ///
  /// Throws [NfmvFormatException] if the file isn't a supported `.nfmv`.
  static ProjectDocument decode(
    String source, {
    String? projectDir,
    bool Function(String path)? fileExists,
  }) {
    final Object? decoded;
    try {
      decoded = jsonDecode(source);
    } on FormatException {
      throw const NfmvFormatException(NfmvReason.invalidData);
    }
    if (decoded is! Map<String, dynamic>) {
      throw const NfmvFormatException(NfmvReason.invalidData);
    }

    final version = decoded['formatVersion'];
    if (version == null) {
      throw const NfmvFormatException(NfmvReason.unsupportedOldVersion);
    }
    if (version is! int) {
      throw const NfmvFormatException(NfmvReason.invalidData);
    }
    if (version > kNfmvFormatVersion) {
      throw NfmvFormatException(
        NfmvReason.unsupportedNewVersion,
        foundVersion: version,
      );
    }
    var upgraded = decoded;
    if (version < 2) upgraded = _v1ToV2(upgraded);
    if (version < 3) upgraded = _v2ToV3(upgraded);

    final ProjectDocument document;
    try {
      document = ProjectDocument.fromJson(upgraded);
    } catch (_) {
      throw NfmvFormatException(NfmvReason.invalidData, foundVersion: version);
    }
    // Every project needs exactly one origin node to start from.
    if (document.nodes.values.whereType<OriginNode>().length != 1) {
      throw NfmvFormatException(NfmvReason.invalidData, foundVersion: version);
    }

    if (projectDir == null || fileExists == null) return document;
    final rawVideos = (upgraded['media'] as List?) ?? const [];
    return document.copyWith(
      media: [
        for (final (index, video) in document.media.indexed)
          video.copyWith(
            path: _resolvePath(
              absolute: video.path,
              relative: index < rawVideos.length
                  ? (rawVideos[index] as Map)['relativePath'] as String?
                  : null,
              projectDir: projectDir,
              fileExists: fileExists,
            ),
          ),
      ],
    );
  }

  /// Version 1 called the imported files "videos" (it had no other kinds).
  static Map<String, dynamic> _v1ToV2(Map<String, dynamic> json) => {
    for (final MapEntry(:key, :value) in json.entries)
      key == 'videos' ? 'media' : key: value,
    'formatVersion': 2,
  };

  /// Version 2 linked one subtitle file to a video (`subtitleId`); version
  /// 3 links one per language (`subtitles`), where `''` is "no language".
  static Map<String, dynamic> _v2ToV3(Map<String, dynamic> json) => {
    ...json,
    'media': [
      for (final asset in (json['media'] as List?) ?? const [])
        if (asset is Map<String, dynamic>)
          {
            for (final MapEntry(:key, :value) in asset.entries)
              if (key != 'subtitleId') key: value,
            if (asset['subtitleId'] case final String id) 'subtitles': {'': id},
          }
        else
          asset,
    ],
    'formatVersion': 3,
  };

  static String _resolvePath({
    required String absolute,
    required String? relative,
    required String projectDir,
    required bool Function(String path) fileExists,
  }) {
    if (relative != null) {
      final candidate = p.normalize(p.join(projectDir, relative));
      if (fileExists(candidate)) return candidate;
    }
    return absolute;
  }
}
