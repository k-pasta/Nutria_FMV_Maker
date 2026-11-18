// The content of a .fmv file and its JSON form.
import 'dart:convert';

import 'package:nutria_fmv_protocol/src/enums.dart';

/// Thrown by [FmvProject.decode] for text that isn't a .fmv project.
class FmvFormatException implements Exception {
  const FmvFormatException(this.message);

  final String message;

  @override
  String toString() => 'FmvFormatException: $message';
}

/// A whole .fmv file:
///
/// ```json
/// {
///   "ProjectInfo": {"title": "...", "description": "..."},
///   "ProjectSettings": {"selectionTime": 6000, "pauseOnEnd": false,
///                       "showTimer": true, "videoFit": "fit",
///                       "defaultSelection": "first"},
///   "Nodes": {
///     "001": {"video": "C:/a.mp4", "choices": [{"option": "Yes", "target": "002"}],
///             "overrides": {"showTimer": false}},
///     "002": {"video": "C:/b.mp4", "target": "003"},
///     "003": {"video": "C:/c.mp4"}
///   }
/// }
/// ```
///
/// Playback starts at the first node of [nodes] (map order is kept; the
/// Maker writes "001" first).
class FmvProject {
  const FmvProject({
    this.info = const FmvProjectInfo(),
    this.settings = const FmvSettings(),
    this.nodes = const {},
  });

  final FmvProjectInfo info;
  final FmvSettings settings;

  /// Nodes by id, in file order.
  final Map<String, FmvNode> nodes;

  /// The id of the node playback starts at, or `null` for an empty project.
  String? get startNodeId => nodes.isEmpty ? null : nodes.keys.first;

  Map<String, Object?> toJson() => {
        'ProjectInfo': info.toJson(),
        'ProjectSettings': settings.toJson(),
        'Nodes': {
          for (final entry in nodes.entries) entry.key: entry.value.toJson(),
        },
      };

  /// Reads the JSON object of a .fmv file. Missing parts get their defaults.
  factory FmvProject.fromJson(Map<String, Object?> json) {
    final nodes = json['Nodes'];
    if (nodes is! Map) {
      throw const FmvFormatException('"Nodes" is missing or not an object');
    }
    return FmvProject(
      info: FmvProjectInfo.fromJson(_map(json['ProjectInfo'])),
      settings: FmvSettings.fromJson(_map(json['ProjectSettings'])),
      nodes: {
        for (final entry in nodes.entries)
          '${entry.key}': FmvNode.fromJson(_map(entry.value)),
      },
    );
  }

  /// The text of a .fmv file (indented JSON).
  String encode() => const JsonEncoder.withIndent('  ').convert(toJson());

  /// Reads the text of a .fmv file.
  static FmvProject decode(String source) {
    final Object? json;
    try {
      json = jsonDecode(source);
    } on FormatException catch (e) {
      throw FmvFormatException('not JSON: ${e.message}');
    }
    if (json is! Map) throw const FmvFormatException('not a JSON object');
    return FmvProject.fromJson(Map<String, Object?>.from(json));
  }
}

/// Title and description of the project.
class FmvProjectInfo {
  const FmvProjectInfo({this.title, this.description});

  final String? title;
  final String? description;

  Map<String, Object?> toJson() => {
        if (title != null) 'title': title,
        if (description != null) 'description': description,
      };

  factory FmvProjectInfo.fromJson(Map<String, Object?> json) => FmvProjectInfo(
        title: _string(json['title']),
        description: _string(json['description']),
      );
}

/// Playback settings of the whole project. Each node can override any of
/// them ([FmvOverrides]).
class FmvSettings {
  const FmvSettings({
    this.selectionTimeMs = defaultSelectionTimeMs,
    this.pauseOnEnd = false,
    this.showTimer = true,
    this.videoFit = FmvVideoFit.fit,
    this.defaultSelection = FmvDefaultSelection.first,
  });

  /// Used when a file doesn't say (the Player's long-standing default).
  static const defaultSelectionTimeMs = 8000;

  /// How long the viewer has to pick a choice, in milliseconds.
  final int selectionTimeMs;

  /// Whether a video without choices stops on its last frame.
  final bool pauseOnEnd;

  /// Whether a countdown is shown while the choices are offered.
  final bool showTimer;
  final FmvVideoFit videoFit;
  final FmvDefaultSelection defaultSelection;

  Map<String, Object?> toJson() => {
        FmvKeys.selectionTime: selectionTimeMs,
        FmvKeys.pauseOnEnd: pauseOnEnd,
        FmvKeys.showTimer: showTimer,
        FmvKeys.videoFit: videoFit.name,
        FmvKeys.defaultSelection: defaultSelection.name,
      };

  factory FmvSettings.fromJson(Map<String, Object?> json) => FmvSettings(
        selectionTimeMs:
            _int(json[FmvKeys.selectionTime]) ?? defaultSelectionTimeMs,
        pauseOnEnd: _bool(json[FmvKeys.pauseOnEnd]) ?? false,
        showTimer: _bool(json[FmvKeys.showTimer]) ?? true,
        videoFit: FmvVideoFit.parse(json[FmvKeys.videoFit]) ?? FmvVideoFit.fit,
        defaultSelection:
            FmvDefaultSelection.parse(json[FmvKeys.defaultSelection]) ??
                FmvDefaultSelection.first,
      );

  /// These settings with a node's [overrides] applied.
  FmvSettings withOverrides(FmvOverrides overrides) => FmvSettings(
        selectionTimeMs: overrides.selectionTimeMs ?? selectionTimeMs,
        pauseOnEnd: overrides.pauseOnEnd ?? pauseOnEnd,
        showTimer: overrides.showTimer ?? showTimer,
        videoFit: overrides.videoFit ?? videoFit,
        defaultSelection: overrides.defaultSelection ?? defaultSelection,
      );
}

/// A node's own values for some settings; `null` means "the project's".
class FmvOverrides {
  const FmvOverrides({
    this.selectionTimeMs,
    this.pauseOnEnd,
    this.showTimer,
    this.videoFit,
    this.defaultSelection,
  });

  final int? selectionTimeMs;
  final bool? pauseOnEnd;
  final bool? showTimer;
  final FmvVideoFit? videoFit;
  final FmvDefaultSelection? defaultSelection;

  bool get isEmpty =>
      selectionTimeMs == null &&
      pauseOnEnd == null &&
      showTimer == null &&
      videoFit == null &&
      defaultSelection == null;

  Map<String, Object?> toJson() => {
        if (selectionTimeMs != null) FmvKeys.selectionTime: selectionTimeMs,
        if (pauseOnEnd != null) FmvKeys.pauseOnEnd: pauseOnEnd,
        if (showTimer != null) FmvKeys.showTimer: showTimer,
        if (videoFit != null) FmvKeys.videoFit: videoFit!.name,
        if (defaultSelection != null)
          FmvKeys.defaultSelection: defaultSelection!.name,
      };

  factory FmvOverrides.fromJson(Map<String, Object?> json) => FmvOverrides(
        selectionTimeMs: _int(json[FmvKeys.selectionTime]),
        pauseOnEnd: _bool(json[FmvKeys.pauseOnEnd]),
        showTimer: _bool(json[FmvKeys.showTimer]),
        videoFit: FmvVideoFit.parse(json[FmvKeys.videoFit]),
        defaultSelection: FmvDefaultSelection.parse(json[FmvKeys.defaultSelection]),
      );
}

/// One video and what follows it.
///
/// A node with [choices] lets the viewer pick; otherwise playback continues
/// to [target], or ends if there is none. Only choices that lead somewhere
/// are written, so a branched node whose choices are all unconnected is
/// written (and read) like an ending.
class FmvNode {
  const FmvNode({
    this.video,
    this.question,
    this.target,
    this.choices,
    this.overrides = const FmvOverrides(),
  });

  /// Path of the video file; `null` if the author didn't pick one.
  final String? video;

  /// A question shown above the [choices]; `null` for none. (Added after
  /// version 1.0; older readers ignore it.)
  final String? question;

  /// The next node of a node without choices; `null` ends the story.
  final String? target;

  /// The options offered after the video, or `null` for no choice.
  final List<FmvChoice>? choices;
  final FmvOverrides overrides;

  bool get isBranched => choices != null;

  Map<String, Object?> toJson() => {
        'video': video,
        if (question != null) 'question': question,
        if (target != null) 'target': target,
        if (choices != null)
          'choices': [for (final choice in choices!) choice.toJson()],
        if (!overrides.isEmpty) 'overrides': overrides.toJson(),
      };

  factory FmvNode.fromJson(Map<String, Object?> json) {
    final choices = json['choices'];
    return FmvNode(
      video: _string(json['video']),
      question: _string(json['question']),
      target: _string(json['target']),
      choices: choices is List
          ? [for (final choice in choices) FmvChoice.fromJson(_map(choice))]
          : null,
      overrides: FmvOverrides.fromJson(_map(json['overrides'])),
    );
  }
}

/// One option of a branched node.
class FmvChoice {
  const FmvChoice({required this.text, this.target});

  /// What the viewer reads.
  final String text;

  /// The node it leads to; `null` ends the story.
  final String? target;

  Map<String, Object?> toJson() => {
        'option': text,
        if (target != null) 'target': target,
      };

  factory FmvChoice.fromJson(Map<String, Object?> json) => FmvChoice(
        text: _string(json['option']) ?? '',
        target: _string(json['target']),
      );
}

/// The setting names used in "ProjectSettings" and "overrides".
abstract final class FmvKeys {
  static const selectionTime = 'selectionTime';
  static const pauseOnEnd = 'pauseOnEnd';
  static const showTimer = 'showTimer';
  static const videoFit = 'videoFit';
  static const defaultSelection = 'defaultSelection';
}

Map<String, Object?> _map(Object? value) =>
    value is Map ? Map<String, Object?>.from(value) : const {};

String? _string(Object? value) => value is String ? value : null;

bool? _bool(Object? value) => value is bool ? value : null;

int? _int(Object? value) => value is num ? value.round() : null;
