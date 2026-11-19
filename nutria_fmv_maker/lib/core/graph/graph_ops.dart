// Pure edit operations on a ProjectDocument. Every edit in the app goes through here.
import 'package:nutria_fmv_maker/core/document/edge.dart';
import 'package:nutria_fmv_maker/core/document/media.dart';
import 'package:nutria_fmv_maker/core/document/music.dart';
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/core/document/position.dart';
import 'package:nutria_fmv_maker/core/document/project_document.dart';
import 'package:nutria_fmv_maker/core/document/video_settings.dart';
import 'package:nutria_fmv_maker/core/graph/ports.dart';

/// Generates unique ids. Injected so tests can be deterministic.
typedef IdGenerator = String Function();

/// Creates a branched video node with the minimum number of empty choices.
BranchedVideoNode newBranchedVideoNode({
  required String id,
  required Position position,
  String? videoId,
  required IdGenerator newId,
}) => BranchedVideoNode(
  id: id,
  position: position,
  videoId: videoId,
  choices: [for (var i = 0; i < kMinChoices; i++) Choice(id: newId())],
);

/// Edges by output port, built once per document (documents never change).
final _edgeIndex = Expando<Map<PortRef, Edge>>('edges by output');

/// Edit operations. Each returns a new document; the receiver is never changed.
extension GraphOps on ProjectDocument {
  // ---------------------------------------------------------------- queries

  /// The node with [id]. Throws [StateError] if it doesn't exist.
  Node node(String id) =>
      nodes[id] ?? (throw StateError('Node "$id" does not exist'));

  /// The edge leaving [from], if that output is connected. Indexed, since
  /// it's asked for every output while drawing.
  Edge? edgeFrom(PortRef from) {
    final index = _edgeIndex[this] ??= {
      // An output has at most one edge; keep the first like a scan would.
      for (final edge in edges.reversed) edge.from: edge,
    };
    return index[from];
  }

  /// Every edge entering [nodeId]'s input.
  Iterable<Edge> edgesInto(String nodeId) =>
      edges.where((e) => e.to.nodeId == nodeId);

  // ------------------------------------------------------------------ nodes

  /// Adds [node], or replaces the node with the same id.
  ProjectDocument putNode(Node node) =>
      copyWith(nodes: {...nodes, node.id: node});

  /// Replaces node [id] with the result of [update].
  ProjectDocument updateNode(String id, Node Function(Node node) update) =>
      putNode(update(node(id)));

  /// Removes the given nodes and every edge touching them.
  /// The origin node can't be removed and is silently skipped.
  ProjectDocument removeNodes(Iterable<String> ids) {
    final hosts = {
      for (final id in ids)
        if (nodes[id] != null && nodes[id] is! OriginNode) id,
    };
    // A comment goes with the node it is attached to.
    final removable = {
      ...hosts,
      for (final node in nodes.values)
        if (node is CommentNode && hosts.contains(node.attachedTo)) node.id,
    };
    if (removable.isEmpty) return this;
    return copyWith(
      nodes: {
        for (final entry in nodes.entries)
          if (!removable.contains(entry.key)) entry.key: entry.value,
      },
      edges: [
        for (final edge in edges)
          if (!removable.contains(edge.from.nodeId) &&
              !removable.contains(edge.to.nodeId))
            edge,
      ],
    );
  }

  /// Moves nodes to new positions.
  ProjectDocument moveNodes(Map<String, Position> positions) => copyWith(
    nodes: {
      for (final entry in nodes.entries)
        entry.key: positions.containsKey(entry.key)
            ? entry.value.copyWith(position: positions[entry.key]!)
            : entry.value,
    },
  );

  /// Sets a node's width, clamped to [kMinNodeWidth]..[kMaxNodeWidth].
  ProjectDocument setNodeWidth(String id, double width) => updateNode(
    id,
    (n) => n.copyWith(width: width.clamp(kMinNodeWidth, kMaxNodeWidth)),
  );

  /// Sets the color swatch index shown on a node.
  // ------------------------------------------------------------------ music

  /// Gives video node [id] music [audioId], keeping its other music
  /// settings if it had music.
  ProjectDocument setMusic(String id, String audioId) => updateMusic(
    id,
    (cue) => cue?.copyWith(audioId: audioId) ?? MusicCue(audioId: audioId),
  );

  /// Edits video node [id]'s music; returning `null` removes it.
  ProjectDocument updateMusic(
    String id,
    MusicCue? Function(MusicCue? cue) edit,
  ) => updateNode(
    id,
    (n) => switch (n) {
      SimpleVideoNode() => n.copyWith(music: edit(n.music)),
      BranchedVideoNode() => n.copyWith(music: edit(n.music)),
      _ => n,
    },
  );

  /// Sets (or with `null` removes) the main menu music.
  ProjectDocument setMenuMusic(String? audioId) => updateNode(
    origin.id,
    (n) => n is OriginNode ? n.copyWith(menuMusicId: audioId) : n,
  );

  /// Sets (or with `null` removes) the pause menu music.
  ProjectDocument setPauseMenuMusic(String? audioId) => updateNode(
    origin.id,
    (n) => n is OriginNode ? n.copyWith(pauseMenuMusicId: audioId) : n,
  );

  // ------------------------------------------------------------------ logic

  /// Edits change node [id] (no-op for other nodes).
  ProjectDocument updateChange(
    String id,
    ChangeVariableNode Function(ChangeVariableNode n) edit,
  ) => updateNode(id, (n) => n is ChangeVariableNode ? edit(n) : n);

  /// Edits compare node [id] (no-op for other nodes).
  ProjectDocument updateCompare(
    String id,
    CompareNode Function(CompareNode n) edit,
  ) => updateNode(id, (n) => n is CompareNode ? edit(n) : n);

  /// Edits condition [conditionId] of compare node [id].
  ProjectDocument updateCondition(
    String id,
    String conditionId,
    LogicCondition Function(LogicCondition c) edit,
  ) => updateCompare(
    id,
    (n) => n.copyWith(
      conditions: [
        for (final c in n.conditions) c.id == conditionId ? edit(c) : c,
      ],
    ),
  );

  // --------------------------------------------------------------- comments

  /// The comment attached to node [hostId], if any.
  CommentNode? commentOf(String hostId) => nodes.values
      .whereType<CommentNode>()
      .where((c) => c.attachedTo == hostId)
      .firstOrNull;

  ProjectDocument setCommentText(String id, String text) =>
      updateNode(id, (n) => n is CommentNode ? n.copyWith(text: text) : n);

  /// Attaches comment [id] on top of node [hostId]. Does nothing unless
  /// [hostId] is another node that isn't a comment and has no comment yet.
  ProjectDocument attachComment(String id, String hostId) {
    final comment = nodes[id];
    final host = nodes[hostId];
    if (comment is! CommentNode ||
        host == null ||
        host is CommentNode ||
        commentOf(hostId) != null) {
      return this;
    }
    return putNode(comment.copyWith(attachedTo: hostId));
  }

  /// Makes comment [id] stand on its own at [position], [width] wide.
  ProjectDocument detachComment(String id, Position position, double width) {
    final comment = nodes[id];
    if (comment is! CommentNode || comment.attachedTo == null) return this;
    return putNode(
      comment.copyWith(attachedTo: null, position: position, width: width),
    );
  }

  /// Gives color [swatch] its own defaults, starting as a copy of the first
  /// color's. Does nothing for the first color or one that has them already.
  ProjectDocument addColorDefaults(int swatch) {
    if (swatch < 1 ||
        swatch > kMaxColorDefaults ||
        colorDefaults.containsKey(swatch)) {
      return this;
    }
    return copyWith(colorDefaults: {...colorDefaults, swatch: settings});
  }

  /// Color [swatch] goes back to using the first color's defaults.
  ProjectDocument removeColorDefaults(int swatch) {
    if (!colorDefaults.containsKey(swatch)) return this;
    return copyWith(colorDefaults: {...colorDefaults}..remove(swatch));
  }

  /// Edits the defaults of color [swatch] (the first color's for 0 or a
  /// color without its own).
  ProjectDocument editDefaults(
    int swatch,
    VideoSettings Function(VideoSettings s) edit,
  ) {
    if (!colorDefaults.containsKey(swatch)) {
      return copyWith(settings: edit(settings));
    }
    return copyWith(
      colorDefaults: {...colorDefaults, swatch: edit(colorDefaults[swatch]!)},
    );
  }

  /// The first color, after the first, that has no defaults of its own yet,
  /// or `null` when they all do.
  int? get nextColorWithoutDefaults {
    for (var i = 1; i <= kMaxColorDefaults; i++) {
      if (!colorDefaults.containsKey(i)) return i;
    }
    return null;
  }

  ProjectDocument setSwatch(String id, int swatch) =>
      updateNode(id, (n) => n.copyWith(swatch: swatch));

  /// Names node [id]; an empty or blank [name] removes the name.
  ProjectDocument renameNode(String id, String? name) {
    final trimmed = name?.trim();
    return setNodeName(id, trimmed == null || trimmed.isEmpty ? null : name);
  }

  /// Sets node [id]'s name exactly as given (even empty, while it's being
  /// typed). Unchanged documents stay the same instance.
  ProjectDocument setNodeName(String id, String? name) =>
      nodes[id]?.name == name
      ? this
      : updateNode(id, (n) => n.copyWith(name: name));

  /// Turns the question of branched node [id] on (an empty text) or off.
  ProjectDocument setQuestionEnabled(String id, bool enabled) => updateNode(
    id,
    (n) => switch (n) {
      BranchedVideoNode() => n.copyWith(
        question: enabled ? (n.question ?? '') : null,
      ),
      _ => n,
    },
  );

  /// Sets the question text of branched node [id] (if it has a question).
  ProjectDocument setQuestion(String id, String text) => updateNode(
    id,
    (n) => switch (n) {
      BranchedVideoNode(:final question?) when question != text => n.copyWith(
        question: text,
      ),
      _ => n,
    },
  );

  /// Shows or hides a node's settings panel.
  ProjectDocument toggleExpanded(String id) =>
      updateNode(id, (n) => n.copyWith(isExpanded: !n.isExpanded));

  /// Closes the settings of every node. Unchanged (the same instance) if
  /// none was open, so it records no undo step.
  ProjectDocument collapseAll() {
    if (!nodes.values.any((n) => n.isExpanded)) return this;
    return copyWith(
      nodes: {
        for (final MapEntry(:key, :value) in nodes.entries)
          key: value.isExpanded ? value.copyWith(isExpanded: false) : value,
      },
    );
  }

  /// Points a video node at [videoId]. No-op for non-video nodes.
  ProjectDocument setVideo(String nodeId, String videoId) => updateNode(
    nodeId,
    (n) => switch (n) {
      SimpleVideoNode() => n.copyWith(videoId: videoId),
      BranchedVideoNode() => n.copyWith(videoId: videoId),
      _ => n,
    },
  );

  /// Replaces a video node's setting overrides. No-op for non-video nodes.
  ProjectDocument setOverrides(
    String nodeId,
    VideoSettingsOverride overrides,
  ) => updateNode(
    nodeId,
    (n) => switch (n) {
      SimpleVideoNode() => n.copyWith(overrides: overrides),
      BranchedVideoNode() => n.copyWith(overrides: overrides),
      _ => n,
    },
  );

  /// Switches a node between simple and branched video, keeping its id,
  /// video, overrides and appearance.
  ///
  /// Connections: simple → branched moves the "next" edge to the first
  /// choice; branched → simple keeps only the first choice's edge.
  ProjectDocument convertVideoNode(String id, {required IdGenerator newId}) {
    final current = node(id);
    switch (current) {
      case SimpleVideoNode():
        final firstChoice = Choice(id: newId());
        final converted = BranchedVideoNode(
          id: current.id,
          position: current.position,
          width: current.width,
          name: current.name,
          swatch: current.swatch,
          videoId: current.videoId,
          overrides: current.overrides,
          music: current.music,
          choices: [
            firstChoice,
            for (var i = 1; i < kMinChoices; i++) Choice(id: newId()),
          ],
        );
        return putNode(converted).copyWith(
          edges: [
            for (final edge in edges)
              edge.from == PortRef(nodeId: id, port: kNextPortKey)
                  ? edge.copyWith(
                      from: PortRef(nodeId: id, port: firstChoice.id),
                    )
                  : edge,
          ],
        );
      case BranchedVideoNode():
        final firstPort = current.choices.isEmpty
            ? null
            : current.choices.first.id;
        final converted = SimpleVideoNode(
          id: current.id,
          position: current.position,
          width: current.width,
          name: current.name,
          swatch: current.swatch,
          videoId: current.videoId,
          overrides: current.overrides,
          music: current.music,
        );
        return putNode(converted).copyWith(
          edges: [
            for (final edge in edges)
              if (edge.from.nodeId != id)
                edge
              else if (edge.from.port == firstPort)
                edge.copyWith(
                  from: PortRef(nodeId: id, port: kNextPortKey),
                ),
          ],
        );
      case OriginNode() ||
          CommentNode() ||
          ChangeVariableNode() ||
          CompareNode():
        throw ArgumentError('Only video nodes can be converted');
    }
  }

  // ---------------------------------------------------------------- choices

  /// Sets the text of choice [index] on a branched node.
  ///
  /// Typing into the slot just past the last choice ([index] == choice count)
  /// creates a new choice, up to [kMaxChoices]. Afterwards, trailing empty and
  /// unconnected choices are trimmed back to [kMinChoices], which mirrors how
  /// the editor shows "one empty slot to type the next answer into". (A node
  /// with one answer still has two slots; the export keeps only connected
  /// choices, so the empty one is dropped there.)
  ProjectDocument setChoiceText(
    String nodeId,
    int index,
    String text, {
    required IdGenerator newId,
  }) {
    final current = node(nodeId);
    if (current is! BranchedVideoNode) {
      throw ArgumentError('Node "$nodeId" is not a branched video node');
    }
    final choices = [...current.choices];
    if (index < 0 || index > choices.length) return this;
    if (index == choices.length) {
      if (choices.length >= kMaxChoices || text.isEmpty) return this;
      choices.add(Choice(id: newId(), text: text));
    } else {
      choices[index] = choices[index].copyWith(text: text);
    }
    return putNode(current.copyWith(choices: choices))._trimChoices(nodeId);
  }

  ProjectDocument _trimChoices(String nodeId) {
    final current = node(nodeId) as BranchedVideoNode;
    final choices = [...current.choices];
    while (choices.length > kMinChoices &&
        choices.last.text.isEmpty &&
        edgeFrom(PortRef(nodeId: nodeId, port: choices.last.id)) == null) {
      choices.removeLast();
    }
    if (choices.length == current.choices.length) return this;
    return putNode(current.copyWith(choices: choices));
  }

  // ------------------------------------------------------------ connections

  /// Connects output [from] to input [to], replacing any edge already leaving
  /// [from] (a flow output has a single target).
  ///
  /// Returns the document unchanged if the connection is invalid: unknown
  /// node or port, target without input, or a node connected to itself.
  ProjectDocument connect(PortRef from, PortRef to) {
    final source = nodes[from.nodeId];
    final target = nodes[to.nodeId];
    if (source == null || target == null) return this;
    if (from.nodeId == to.nodeId) return this;
    if (!isOutputPortOf(source, from.port)) return this;
    if (!hasInputPort(target) || to.port != PortRef.inputPortKey) return this;
    return copyWith(
      edges: [
        for (final edge in edges)
          if (edge.from != from) edge,
        Edge(from: from, to: to),
      ],
    );
  }

  /// Removes every connection into or out of the nodes [ids].
  ProjectDocument disconnectNodes(Set<String> ids) {
    final kept = [
      for (final edge in edges)
        if (!ids.contains(edge.from.nodeId) && !ids.contains(edge.to.nodeId))
          edge,
    ];
    return kept.length == edges.length ? this : copyWith(edges: kept);
  }

  /// Removes the edge leaving [from], if any.
  ProjectDocument disconnect(PortRef from) {
    if (edgeFrom(from) == null) return this;
    return copyWith(
      edges: [
        for (final edge in edges)
          if (edge.from != from) edge,
      ],
    );
  }

  // ------------------------------------------------------------------ media

  /// Adds [asset] unless a file with the same path is already imported.
  /// Returns the document and the id of the (new or existing) asset.
  (ProjectDocument, String) importMedia(MediaAsset asset) {
    for (final existing in media) {
      if (existing.path == asset.path) return (this, existing.id);
    }
    return (copyWith(media: [...media, asset]), asset.id);
  }

  /// The ids of the subtitle files that are linked to a video.
  Set<String> get linkedSubtitleIds => {
    for (final asset in media) ...asset.subtitles.values,
  };

  /// The language a subtitle link is stored under: `''` while the project
  /// has no languages, and the main language for `''` once it has some.
  String _subtitleKey(String language) =>
      language.isEmpty ? (info.languages.firstOrNull ?? '') : language;

  /// The subtitle files of video [videoId] by language: links made before
  /// languages were chosen count as the main language's.
  Map<String, String> subtitlesOf(String? videoId) {
    final video = mediaById(videoId);
    if (video == null) return const {};
    return {
      for (final MapEntry(:key, :value) in video.subtitles.entries)
        _subtitleKey(key): value,
    };
  }

  /// Sets the story's [languages] (main first). Subtitle links without a
  /// language are pinned to the main language first, so changing which
  /// language is main doesn't move them.
  ProjectDocument setLanguages(List<String> languages) {
    final unique = [
      ...{...languages},
    ];
    final main = info.languages.firstOrNull ?? unique.firstOrNull;
    return copyWith(
      info: info.copyWith(languages: unique),
      media: main == null
          ? media
          : [
              for (final asset in media)
                if (asset.subtitles.containsKey(''))
                  asset.copyWith(
                    subtitles: {
                      for (final MapEntry(:key, :value)
                          in asset.subtitles.entries)
                        key.isEmpty ? main : key: value,
                    },
                  )
                else
                  asset,
            ],
    );
  }

  /// Links subtitle file [subtitleId] to video [videoId] for [language]
  /// (`''`: the main language, or none), replacing that language's file
  /// and unlinking [subtitleId] from anywhere else. Does nothing unless the
  /// kinds fit.
  ProjectDocument linkSubtitle(
    String videoId,
    String subtitleId, {
    String language = '',
  }) {
    final video = mediaById(videoId);
    final subtitle = mediaById(subtitleId);
    final key = _subtitleKey(language);
    if (video == null ||
        !video.isVideo ||
        subtitle?.kind != MediaKind.subtitle ||
        subtitlesOf(videoId)[key] == subtitleId) {
      return this;
    }
    return copyWith(
      media: [
        for (final asset in media)
          if (asset.id == videoId)
            asset.copyWith(
              subtitles: {
                for (final MapEntry(key: k, :value) in subtitlesOf(
                  videoId,
                ).entries)
                  if (k != key && value != subtitleId) k: value,
                key: subtitleId,
              },
            )
          else if (asset.subtitles.containsValue(subtitleId))
            asset.copyWith(
              subtitles: {
                for (final MapEntry(:key, :value) in asset.subtitles.entries)
                  if (value != subtitleId) key: value,
              },
            )
          else
            asset,
      ],
    );
  }

  /// Video [videoId] no longer has subtitles (in any language, or only in
  /// [language]); the files stay imported.
  ProjectDocument unlinkSubtitle(String videoId, {String? language}) {
    final video = mediaById(videoId);
    if (video == null || video.subtitles.isEmpty) return this;
    final kept = language == null
        ? const <String, String>{}
        : {
            for (final MapEntry(:key, :value) in subtitlesOf(videoId).entries)
              if (key != _subtitleKey(language)) key: value,
          };
    return copyWith(
      media: [
        for (final asset in media)
          asset.id == videoId ? asset.copyWith(subtitles: kept) : asset,
      ],
    );
  }

  /// Links every video without subtitles to an unlinked subtitle file of
  /// the same name (ignoring case and extension), if there is one.
  ProjectDocument autoLinkSubtitles() {
    var doc = this;
    for (final video in media.where((m) => m.isVideo)) {
      if (video.subtitleId != null) continue;
      final linked = doc.linkedSubtitleIds;
      for (final subtitle in media) {
        if (subtitle.kind == MediaKind.subtitle &&
            !linked.contains(subtitle.id) &&
            subtitle.baseName == video.baseName) {
          doc = doc.linkSubtitle(video.id, subtitle.id);
          break;
        }
      }
    }
    return doc;
  }

  /// Points asset [id] at the file at [path]; nodes using it follow.
  ProjectDocument setMediaPath(String id, String path) => copyWith(
    media: [
      for (final asset in media)
        asset.id == id ? asset.copyWith(path: path) : asset,
    ],
  );

  /// Points each asset of [ids] at the file in [files] with the same name
  /// (ignoring case). Returns the document and the ids that were found.
  (ProjectDocument, Set<String>) relinkByName(
    Set<String> ids,
    Iterable<String> files,
  ) {
    final byName = {for (final f in files) fileNameOf(f).toLowerCase(): f};
    final found = <String>{};
    final next = <MediaAsset>[];
    for (final asset in media) {
      final path = ids.contains(asset.id)
          ? byName[asset.fileName.toLowerCase()]
          : null;
      if (path == null) {
        next.add(asset);
      } else {
        next.add(asset.copyWith(path: path));
        found.add(asset.id);
      }
    }
    return (found.isEmpty ? this : copyWith(media: next), found);
  }
}
