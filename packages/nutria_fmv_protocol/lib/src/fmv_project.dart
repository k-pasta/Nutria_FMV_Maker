// The content of a .fmv file and its JSON form.
import 'dart:convert';

import 'package:nutria_fmv_protocol/src/enums.dart';
import 'package:nutria_fmv_protocol/src/logic.dart';
import 'package:nutria_fmv_protocol/src/music.dart';
import 'package:nutria_fmv_protocol/src/screens.dart';

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
///   },
///   "Variables": {"coins": {"type": "integer", "initial": 0, "min": 0}}
/// }
/// ```
///
/// "Variables" and the logic nodes ("type": "change" or "compare") were
/// added after version 1.0; files without them are written as before.
///
/// Playback starts at the first node of [nodes] (map order is kept; the
/// Maker writes "001" first).
class FmvProject {
  const FmvProject({
    this.info = const FmvProjectInfo(),
    this.settings = const FmvSettings(),
    this.nodes = const {},
    this.variables = const {},
    this.menuScreen = const FmvMenuScreen(),
    this.choiceScreen = const FmvMenuScreen(),
    this.pauseScreen = const FmvMenuScreen(),
  });

  final FmvProjectInfo info;
  final FmvSettings settings;

  /// Nodes by id, in file order.
  final Map<String, FmvNode> nodes;

  /// The story's variables by name.
  final Map<String, FmvVariable> variables;

  /// The main menu's design ("Screens" → "menu"; added after 1.0).
  final FmvMenuScreen menuScreen;

  /// How choices are shown over the video ("Screens" → "choice"), and the
  /// pause menu ("Screens" → "pause"). Empty: the Player's own.
  final FmvMenuScreen choiceScreen;
  final FmvMenuScreen pauseScreen;

  /// The id of the node playback starts at, or `null` for an empty project.
  String? get startNodeId => nodes.isEmpty ? null : nodes.keys.first;

  Map<String, Object?> toJson() => {
        'ProjectInfo': info.toJson(),
        'ProjectSettings': settings.toJson(),
        'Nodes': {
          for (final entry in nodes.entries) entry.key: entry.value.toJson(),
        },
        if (!menuScreen.isEmpty ||
            !choiceScreen.isEmpty ||
            !pauseScreen.isEmpty)
          'Screens': {
            if (!menuScreen.isEmpty) 'menu': menuScreen.toJson(),
            if (!choiceScreen.isEmpty) 'choice': choiceScreen.toJson(),
            if (!pauseScreen.isEmpty) 'pause': pauseScreen.toJson(),
          },
        if (variables.isNotEmpty)
          'Variables': {
            for (final entry in variables.entries)
              entry.key: entry.value.toJson(),
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
      menuScreen: FmvMenuScreen.fromJson(_map(_map(json['Screens'])['menu'])),
      choiceScreen:
          FmvMenuScreen.fromJson(_map(_map(json['Screens'])['choice'])),
      pauseScreen: FmvMenuScreen.fromJson(_map(_map(json['Screens'])['pause'])),
      variables: {
        for (final entry in _map(json['Variables']).entries)
          if (FmvVariable.fromJson(_map(entry.value)) case final variable?)
            entry.key: variable,
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
  const FmvProjectInfo({
    this.title,
    this.description,
    this.menuMusic,
    this.pauseMenuMusic,
    this.languages = const [],
  });

  final String? title;
  final String? description;

  /// The languages of the story, as codes (`en`, `el`, …), the main one
  /// first. Empty when the author didn't say. (Added after version 1.0.)
  final List<String> languages;

  /// Music looping in the main menu. (Added after version 1.0.)
  final FmvLoopMusic? menuMusic;

  /// Music looping in the pause menu, when the viewer pauses the story.
  /// (Added after version 1.0.)
  final FmvLoopMusic? pauseMenuMusic;

  Map<String, Object?> toJson() => {
        if (title != null) 'title': title,
        if (description != null) 'description': description,
        if (menuMusic != null) 'menuMusic': menuMusic!.toJson(),
        if (pauseMenuMusic != null) 'pauseMenuMusic': pauseMenuMusic!.toJson(),
        if (languages.isNotEmpty) 'languages': languages,
      };

  factory FmvProjectInfo.fromJson(Map<String, Object?> json) {
    final languages = json['languages'];
    return FmvProjectInfo(
      title: _string(json['title']),
      description: _string(json['description']),
      menuMusic: FmvLoopMusic.fromJson(_map(json['menuMusic'])),
      pauseMenuMusic: FmvLoopMusic.fromJson(_map(json['pauseMenuMusic'])),
      languages: [
        if (languages is List)
          for (final code in languages)
            if (code is String) code,
      ],
    );
  }
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
        defaultSelection:
            FmvDefaultSelection.parse(json[FmvKeys.defaultSelection]),
      );
}

/// What a node does.
enum FmvNodeType {
  /// Plays a video (the only type before logic nodes; written without a
  /// "type").
  video,

  /// Changes a variable, then continues to [FmvNode.target].
  change,

  /// Tests variables, then continues to [FmvNode.whenTrue] or
  /// [FmvNode.whenFalse].
  compare,
}

/// One step of the story.
///
/// A video node with [choices] lets the viewer pick; otherwise playback
/// continues to [target], or ends if there is none. Only choices that lead
/// somewhere are written, so a branched node whose choices are all
/// unconnected is written (and read) like an ending.
///
/// Change nodes ([FmvNodeType.change]) set [variable] by [operation] and
/// [value], then go on to [target]. Compare nodes test [conditions] (all,
/// or any with [matchAny]) or, if set, [expression], and go on to
/// [whenTrue] or [whenFalse].
class FmvNode {
  const FmvNode({
    this.type = FmvNodeType.video,
    this.video,
    this.subtitles,
    this.subtitleTracks = const {},
    this.question,
    this.target,
    this.choices,
    this.overrides = const FmvOverrides(),
    this.music,
    this.pauseMusic,
    this.variable,
    this.operation,
    this.value,
    this.conditions = const [],
    this.matchAny = false,
    this.expression,
    this.whenTrue,
    this.whenFalse,
  });

  final FmvNodeType type;

  /// Video nodes: music that goes with the video. (Added after 1.0.)
  final FmvMusic? music;

  /// Video nodes with choices: music looping while the viewer chooses.
  /// (Added after 1.0.)
  final FmvLoopMusic? pauseMusic;

  /// Change nodes: the variable changed.
  final String? variable;

  /// Change nodes: how it is changed.
  final FmvChangeOperation? operation;

  /// Change nodes: the expression the operation uses, if it takes one.
  final String? value;

  /// Compare nodes: the conditions tested.
  final List<FmvCondition> conditions;

  /// Compare nodes: whether one true condition is enough.
  final bool matchAny;

  /// Compare nodes: a true/false expression used instead of [conditions].
  final String? expression;

  /// Compare nodes: where to go when the test holds, or doesn't.
  final String? whenTrue;
  final String? whenFalse;

  /// Path of the video file; `null` if the author didn't pick one.
  final String? video;

  /// Path of a SubRip (.srt) file for the video; `null` for none. (Added
  /// after version 1.0; older readers ignore it.)
  final String? subtitles;

  /// SubRip files by language code, when the video has subtitles in more
  /// than one language; [subtitles] is then the main language's. (Added
  /// after version 1.0; older readers ignore it.)
  final Map<String, String> subtitleTracks;

  /// A question shown above the [choices]; `null` for none. (Added after
  /// version 1.0; older readers ignore it.)
  final String? question;

  /// The next node of a node without choices; `null` ends the story.
  final String? target;

  /// The options offered after the video, or `null` for no choice.
  final List<FmvChoice>? choices;
  final FmvOverrides overrides;

  bool get isBranched => choices != null;

  Map<String, Object?> toJson() => switch (type) {
        FmvNodeType.video => _videoJson(),
        FmvNodeType.change => {
            'type': type.name,
            'variable': variable,
            'operation': operation?.name,
            if (value != null) 'value': value,
            if (target != null) 'target': target,
          },
        FmvNodeType.compare => {
            'type': type.name,
            if (expression != null)
              'expression': expression
            else ...{
              'conditions': [for (final c in conditions) c.toJson()],
              'match': matchAny ? 'any' : 'all',
            },
            if (whenTrue != null) 'true': whenTrue,
            if (whenFalse != null) 'false': whenFalse,
          },
      };

  Map<String, Object?> _videoJson() => {
        'video': video,
        if (subtitles != null) 'subtitles': subtitles,
        if (subtitleTracks.isNotEmpty) 'subtitleTracks': subtitleTracks,
        if (question != null) 'question': question,
        if (target != null) 'target': target,
        if (choices != null)
          'choices': [for (final choice in choices!) choice.toJson()],
        if (!overrides.isEmpty) 'overrides': overrides.toJson(),
        if (music != null) 'music': music!.toJson(),
        if (pauseMusic != null) 'pauseMusic': pauseMusic!.toJson(),
      };

  factory FmvNode.fromJson(Map<String, Object?> json) {
    final type = switch (json['type']) {
      final String name => fmvParseEnum(FmvNodeType.values, name),
      _ => FmvNodeType.video,
    };
    if (type == FmvNodeType.change) {
      return FmvNode(
        type: type!,
        variable: _string(json['variable']),
        operation: FmvChangeOperation.parse(json['operation']),
        value: _string(json['value']),
        target: _string(json['target']),
      );
    }
    if (type == FmvNodeType.compare) {
      final conditions = json['conditions'];
      return FmvNode(
        type: type!,
        conditions: [
          if (conditions is List)
            for (final c in conditions)
              if (FmvCondition.fromJson(_map(c)) case final condition?)
                condition,
        ],
        matchAny: json['match'] == 'any',
        expression: _string(json['expression']),
        whenTrue: _string(json['true']),
        whenFalse: _string(json['false']),
      );
    }
    final choices = json['choices'];
    final tracks = json['subtitleTracks'];
    return FmvNode(
      video: _string(json['video']),
      subtitles: _string(json['subtitles']),
      subtitleTracks: {
        if (tracks is Map)
          for (final entry in tracks.entries)
            if (entry.key is String && entry.value is String)
              entry.key as String: entry.value as String,
      },
      question: _string(json['question']),
      target: _string(json['target']),
      choices: choices is List
          ? [for (final choice in choices) FmvChoice.fromJson(_map(choice))]
          : null,
      overrides: FmvOverrides.fromJson(_map(json['overrides'])),
      music: FmvMusic.fromJson(_map(json['music'])),
      pauseMusic: FmvLoopMusic.fromJson(_map(json['pauseMusic'])),
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
