// Turns a project into the .fmv that Nutria FMV Player plays. The file format
// itself (and reading it) lives in the shared nutria_fmv_protocol package.
import 'package:nutria_fmv_maker/core/document/edge.dart';
import 'package:nutria_fmv_maker/core/document/music.dart';
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/core/document/project_document.dart';
import 'package:nutria_fmv_maker/core/document/variable.dart';
import 'package:nutria_fmv_maker/core/document/video_setting_steps.dart';
import 'package:nutria_fmv_maker/core/document/video_settings.dart';
import 'package:nutria_fmv_maker/core/graph/graph_ops.dart';
import 'package:nutria_fmv_maker/core/graph/logic_check.dart';
import 'package:nutria_fmv_maker/core/graph/ports.dart';
import 'package:nutria_fmv_maker/core/graph/screen_ops.dart';
import 'package:nutria_fmv_protocol/nutria_fmv_protocol.dart';

/// A problem found while exporting. Export still succeeds; the editor can
/// show these so the author can fix them.
enum ExportIssueType {
  /// A reachable video node has no video assigned.
  missingVideo,

  /// A choice has text but leads nowhere, so the Player won't offer it.
  unconnectedChoice,

  /// A logic node has no variable, an unknown one, or a value or condition
  /// that isn't a valid expression; the Player would skip what it does.
  invalidLogic,

  /// A branched node offers a single answer ("no-brainer") while that isn't
  /// allowed in the preferences.
  singleChoice,
}

/// One [ExportIssueType] on a specific node (by its editor id).
typedef ExportIssue = ({ExportIssueType type, String nodeId});

/// The exported project plus any issues found along the way.
typedef FmvExport = ({FmvProject project, List<ExportIssue> issues});

/// Exports [document] for the Player (see [FmvProject] for the format).
///
/// Only nodes reachable from the origin are exported. Nodes get short
/// sequential ids in breadth-first order; the origin is `000` and is itself
/// left out, so playback starts at `001`. Only connected choices are kept;
/// a branched node left with one is an issue unless [allowSingleChoice].
FmvExport exportFmv(
  ProjectDocument document, {
  bool allowSingleChoice = false,
}) {
  final order = _reachableInBfsOrder(document);
  final ids = {
    for (final (index, nodeId) in order.indexed)
      nodeId: index.toString().padLeft(3, '0'),
  };
  final issues = <ExportIssue>[];

  String? targetOf(PortRef port) {
    final edge = document.edgeFrom(port);
    return edge == null ? null : ids[edge.to.nodeId];
  }

  final names = {for (final v in document.variables) v.id: v.name};
  final nodes = <String, FmvNode>{};
  for (final nodeId in order) {
    final node = document.node(nodeId);
    switch (node) {
      // Comments are for the author; they have no connections anyway.
      case OriginNode() || CommentNode():
        continue;
      case ChangeVariableNode():
        final variable = names[node.variableId];
        if (logicProblem(document, node) != null) {
          issues.add((type: ExportIssueType.invalidLogic, nodeId: nodeId));
        }
        nodes[ids[nodeId]!] = FmvNode(
          type: FmvNodeType.change,
          variable: variable,
          operation: node.operation,
          value: node.operation.takesValue ? node.value : null,
          target: targetOf(PortRef(nodeId: nodeId, port: kNextPortKey)),
        );
      case CompareNode():
        if (logicProblem(document, node) != null) {
          issues.add((type: ExportIssueType.invalidLogic, nodeId: nodeId));
        }
        nodes[ids[nodeId]!] = FmvNode(
          type: FmvNodeType.compare,
          expression: node.expression,
          conditions: [
            if (node.expression == null)
              for (final c in node.conditions)
                if (names[c.variableId] case final name?)
                  FmvCondition(
                    variable: name,
                    comparison: c.comparison,
                    value: c.value,
                  ),
          ],
          matchAny: node.matchAny,
          whenTrue: targetOf(PortRef(nodeId: nodeId, port: kTruePortKey)),
          whenFalse: targetOf(PortRef(nodeId: nodeId, port: kFalsePortKey)),
        );
      case SimpleVideoNode():
        nodes[ids[nodeId]!] = FmvNode(
          video: _videoPath(document, node, issues),
          subtitles: _subtitlesPath(document, node),
          subtitleTracks: _moreTracks(document, node),
          target: targetOf(PortRef(nodeId: nodeId, port: kNextPortKey)),
          overrides: _overrides(document, node, kSimpleNodeSettings),
          music: _music(document, node.music),
        );
      case BranchedVideoNode():
        final choices = <FmvChoice>[];
        for (final choice in node.choices) {
          final target = targetOf(PortRef(nodeId: nodeId, port: choice.id));
          if (target != null) {
            choices.add(FmvChoice(text: choice.text, target: target));
          } else if (choice.text.isNotEmpty) {
            issues.add((
              type: ExportIssueType.unconnectedChoice,
              nodeId: nodeId,
            ));
          }
        }
        if (choices.length == 1 && !allowSingleChoice) {
          issues.add((type: ExportIssueType.singleChoice, nodeId: nodeId));
        }
        nodes[ids[nodeId]!] = FmvNode(
          video: _videoPath(document, node, issues),
          subtitles: _subtitlesPath(document, node),
          subtitleTracks: _moreTracks(document, node),
          // An empty question (turned on, never written) isn't exported.
          question: switch (node.question?.trim()) {
            final q? when q.isNotEmpty => node.question,
            _ => null,
          },
          choices: choices.isEmpty ? null : choices,
          overrides: _overrides(document, node, kBranchedNodeSettings),
          music: _music(document, node.music),
          pauseMusic: switch (document.mediaById(node.pauseMusicId)) {
            final audio? => FmvLoopMusic(
              track: audio.path,
              fadeOutMs: node.pauseMusicFadeOutMs,
            ),
            null => null,
          },
        );
    }
  }

  final settings = document.settings;
  return (
    project: FmvProject(
      info: FmvProjectInfo(
        title: document.info.title,
        description: document.info.description,
        languages: document.info.languages,
        menuMusic: switch (document.mediaById(document.origin.menuMusicId)) {
          final audio? => FmvLoopMusic(track: audio.path),
          null => null,
        },
      ),
      settings: FmvSettings(
        selectionTimeMs: settings.selectionTimeMs,
        pauseOnEnd: settings.pauseOnEnd,
        showTimer: settings.showTimer,
        videoFit: _videoFit(settings.videoFit),
        defaultSelection: _defaultSelection(settings.defaultSelection),
      ),
      nodes: nodes,
      variables: {for (final v in document.variables) v.name: _variable(v)},
      menuScreen: _menuScreen(document),
    ),
    issues: issues,
  );
}

/// The main menu design, with every element's style written out.
FmvMenuScreen _menuScreen(ProjectDocument document) {
  final screen = document.menuScreen;
  return FmvMenuScreen(
    background: document.mediaById(screen.backgroundId)?.path,
    elements: [
      for (final e in screen.elements)
        if (document.styleOf(e) case final style)
          FmvScreenElement(
            kind: e.kind.name,
            x: e.x,
            y: e.y,
            width: e.width,
            text: e.text,
            style: FmvScreenStyle(
              fontSize: style.fontSize,
              bold: style.bold,
              font: document.mediaById(style.fontId)?.path,
              textColor: style.textColor,
              backgroundColor: style.backgroundColor,
              backgroundOpacity: style.backgroundOpacity,
              radius: style.radius,
              padding: style.padding,
            ),
          ),
    ],
  );
}

FmvVariable _variable(Variable v) => switch (v) {
  BoolVariable(:final initial) => FmvVariable(
    type: FmvVariableType.boolean,
    initial: initial,
  ),
  IntVariable(:final initial, :final min, :final max) => FmvVariable(
    type: FmvVariableType.integer,
    initial: initial,
    min: min,
    max: max,
  ),
  DecimalVariable(:final initial, :final min, :final max) => FmvVariable(
    type: FmvVariableType.decimal,
    initial: initial,
    min: min,
    max: max,
  ),
};

/// [cue] as the Player reads it; `null` without one or if its audio is
/// gone.
FmvMusic? _music(ProjectDocument document, MusicCue? cue) {
  final audio = document.mediaById(cue?.audioId);
  if (cue == null || audio == null) return null;
  return FmvMusic(
    track: audio.path,
    end: cue.end,
    loop: cue.loop,
    fadeOutMs: cue.fadeOutMs,
    pauseWithVideo: cue.pauseWithVideo,
  );
}

/// The paths of the subtitles linked to [node]'s video, by language.
Map<String, String> _subtitleTracks(ProjectDocument document, Node node) => {
  for (final MapEntry(:key, :value) in document
      .subtitlesOf(node.videoIdOrNull)
      .entries)
    if (document.mediaById(value) case final file?) key: file.path,
};

/// The path of the subtitles in the main language (or the only ones) of
/// [node]'s video, for Players that know one subtitle file per video.
String? _subtitlesPath(ProjectDocument document, Node node) {
  final tracks = _subtitleTracks(document, node);
  return tracks[document.info.languages.firstOrNull ?? ''] ??
      tracks.values.firstOrNull;
}

/// Every language's subtitles, when there are more than one.
Map<String, String> _moreTracks(ProjectDocument document, Node node) {
  final tracks = _subtitleTracks(document, node);
  return tracks.length > 1 ? tracks : const {};
}

/// The node's own overrides plus its color's defaults, as overrides of the
/// project defaults: the Player knows nothing about colors.
FmvOverrides _overrides(
  ProjectDocument document,
  Node node,
  List<VideoSettingType> types,
) {
  final o = node.overridesOrNull!.layeredOver(
    document.settings,
    document.defaultsFor(node.swatch),
    types,
  );
  return FmvOverrides(
    selectionTimeMs: o.selectionTimeMs,
    pauseOnEnd: o.pauseOnEnd,
    showTimer: o.showTimer,
    videoFit: o.videoFit == null ? null : _videoFit(o.videoFit!),
    defaultSelection: o.defaultSelection == null
        ? null
        : _defaultSelection(o.defaultSelection!),
  );
}

/// The editor's values all exist in the protocol under the same names.
FmvVideoFit _videoFit(VideoFit fit) => FmvVideoFit.values.byName(fit.name);

FmvDefaultSelection _defaultSelection(DefaultSelectionMethod method) =>
    FmvDefaultSelection.values.byName(method.name);

/// Node ids reachable from the origin, breadth-first, following each node's
/// outputs in port order. Edges into deleted nodes are ignored.
List<String> _reachableInBfsOrder(ProjectDocument document) {
  final start = document.origin.id;
  final visited = <String>{start};
  final order = <String>[];
  final queue = <String>[start];
  while (queue.isNotEmpty) {
    final nodeId = queue.removeAt(0);
    order.add(nodeId);
    for (final port in outputRefsOf(document.node(nodeId))) {
      final next = document.edgeFrom(port)?.to.nodeId;
      if (next != null &&
          document.nodes.containsKey(next) &&
          visited.add(next)) {
        queue.add(next);
      }
    }
  }
  return order;
}

String? _videoPath(
  ProjectDocument document,
  Node node,
  List<ExportIssue> issues,
) {
  final path = document.mediaById(node.videoIdOrNull)?.path;
  if (path == null) {
    issues.add((type: ExportIssueType.missingVideo, nodeId: node.id));
  }
  return path;
}
