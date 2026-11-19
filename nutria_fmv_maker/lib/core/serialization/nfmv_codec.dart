// Reads and writes the .nfmv project save format (JSON, versioned).
import 'dart:convert';

import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/core/document/project_document.dart';
import 'package:nutria_fmv_maker/core/graph/screen_ops.dart';
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
    if (version < 4) upgraded = _v3ToV4(upgraded);
    if (version < 5) upgraded = _v4ToV5(upgraded);
    if (version < 6) upgraded = _v5ToV6(upgraded);

    ProjectDocument document;
    try {
      document = ProjectDocument.fromJson(upgraded);
    } catch (_) {
      throw NfmvFormatException(NfmvReason.invalidData, foundVersion: version);
    }
    // Every project needs exactly one origin node to start from.
    if (document.nodes.values.whereType<OriginNode>().length != 1) {
      throw NfmvFormatException(NfmvReason.invalidData, foundVersion: version);
    }
    // And the screens every project has, with their required elements.
    document = document.withRequiredScreens();

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

  /// Version 3 kept a branched node's pause music on the node
  /// (`pauseMusicId`, `pauseMusicFadeOutMs`); version 4 makes it a setting,
  /// so it moves into the node's overrides.
  static Map<String, dynamic> _v3ToV4(Map<String, dynamic> json) {
    final nodes = json['nodes'];
    if (nodes is! Map<String, dynamic>) return {...json, 'formatVersion': 4};
    Object? upgrade(Object? node) {
      if (node is! Map<String, dynamic> ||
          node['type'] != 'branchedVideo' ||
          node['pauseMusicId'] is! String) {
        return node;
      }
      final overrides = node['overrides'];
      return <String, dynamic>{
        for (final MapEntry(:key, :value) in node.entries)
          if (key != 'pauseMusicId' && key != 'pauseMusicFadeOutMs') key: value,
        'overrides': <String, dynamic>{
          if (overrides is Map<String, dynamic>) ...overrides,
          'pauseMusicId': node['pauseMusicId'],
          'pauseMusicFadeOutMs': node['pauseMusicFadeOutMs'] ?? 1000,
        },
      };
    }

    return {
      ...json,
      'nodes': <String, dynamic>{
        for (final MapEntry(:key, :value) in nodes.entries) key: upgrade(value),
      },
      'formatVersion': 4,
    };
  }

  /// Version 4 had three screens (`menuScreen`, `choiceScreen`,
  /// `pauseScreen`); version 5 has a list of them, with ids, kinds and
  /// names. A screen never designed is left out: it gets its default
  /// layout instead of staying empty.
  static Map<String, dynamic> _v4ToV5(Map<String, dynamic> json) => {
    for (final MapEntry(:key, :value) in json.entries)
      if (key != 'menuScreen' && key != 'choiceScreen' && key != 'pauseScreen')
        key: value,
    'screens': [
      for (final (key, kind) in const [
        ('menuScreen', 'menu'),
        ('choiceScreen', 'choice'),
        ('pauseScreen', 'pause'),
      ])
        if (json[key] case final Map<String, dynamic> screen
            when ((screen['elements'] as List?)?.isNotEmpty ?? false) ||
                screen['backgroundId'] != null)
          <String, dynamic>{...screen, 'id': kind, 'kind': kind},
    ],
    'formatVersion': 5,
  };

  /// Version 5 had separate screens for answers over a video that waits
  /// (`endChoice`, with their own `endChoiceScreenId` setting), and kept a
  /// node's music and question on the node. Version 6 has one kind of
  /// answer screen, and makes music and showing the question settings.
  static Map<String, dynamic> _v5ToV6(Map<String, dynamic> json) {
    // Settings that waited at the end used the end screen: keep it.
    Map<String, dynamic> settings(Object? value, {bool? waits}) {
      if (value is! Map<String, dynamic>) return const {};
      final end = value['endChoiceScreenId'];
      return {
        for (final MapEntry(:key, :value) in value.entries)
          if (key != 'endChoiceScreenId') key: value,
        if (end is String && (value['pauseOnEnd'] ?? waits) == true)
          'choiceScreenId': end,
      };
    }

    final project = settings(json['settings']);
    final projectWaits = project['pauseOnEnd'] == true;
    Object? node(Object? value) {
      if (value is! Map<String, dynamic>) return value;
      final type = value['type'];
      if (type != 'simpleVideo' && type != 'branchedVideo') return value;
      final overrides = settings(value['overrides'], waits: projectWaits);
      final question = value['question'];
      return <String, dynamic>{
        for (final MapEntry(:key, :value) in value.entries)
          if (key != 'music' && key != 'overrides' && key != 'question')
            key: value,
        if (type == 'branchedVideo') 'question': question ?? '',
        'overrides': <String, dynamic>{
          ...overrides,
          if (value['music'] case final Map<String, dynamic> music)
            'music': music,
          if (type == 'branchedVideo' && question is String)
            'showQuestion': true,
        },
      };
    }

    final nodes = json['nodes'];
    final colors = json['colorDefaults'];
    return {
      ...json,
      if (json['settings'] != null) 'settings': project,
      if (colors is Map<String, dynamic>)
        'colorDefaults': {
          for (final MapEntry(:key, :value) in colors.entries)
            key: settings(value),
        },
      if (nodes is Map<String, dynamic>)
        'nodes': <String, dynamic>{
          for (final MapEntry(:key, :value) in nodes.entries) key: node(value),
        },
      'screens': [
        for (final screen in (json['screens'] as List?) ?? const [])
          if (screen is Map<String, dynamic> && screen['kind'] == 'endChoice')
            {
              ...screen,
              'kind': 'choice',
              'name': screen['name'] ?? 'Pause Choice Screen',
            }
          else
            screen,
      ],
      'formatVersion': 6,
    };
  }

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
