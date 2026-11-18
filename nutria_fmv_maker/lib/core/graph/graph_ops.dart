// Pure edit operations on a ProjectDocument. Every edit in the app goes through here.
import 'package:nutria_fmv_maker/core/document/edge.dart';
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
    final removable = {
      for (final id in ids)
        if (nodes[id] != null && nodes[id] is! OriginNode) id,
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
      nodes[id]?.name == name ? this : updateNode(id, (n) => n.copyWith(name: name));

  /// Turns the question of branched node [id] on (an empty text) or off.
  ProjectDocument setQuestionEnabled(String id, bool enabled) =>
      updateNode(id, (n) => switch (n) {
            BranchedVideoNode() => n.copyWith(
                question: enabled ? (n.question ?? '') : null),
            _ => n,
          });

  /// Sets the question text of branched node [id] (if it has a question).
  ProjectDocument setQuestion(String id, String text) =>
      updateNode(id, (n) => switch (n) {
            BranchedVideoNode(:final question?) when question != text =>
              n.copyWith(question: text),
            _ => n,
          });

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
      OriginNode() => n,
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
      OriginNode() => n,
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
      case OriginNode():
        throw ArgumentError('The origin node cannot be converted');
    }
  }

  // ---------------------------------------------------------------- choices

  /// Sets the text of choice [index] on a branched node.
  ///
  /// Typing into the slot just past the last choice ([index] == choice count)
  /// creates a new choice, up to [kMaxChoices]. Afterwards, trailing empty and
  /// unconnected choices are trimmed back to [kMinChoices], which mirrors how
  /// the editor shows "one empty slot to type the next answer into".
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

  // ----------------------------------------------------------------- videos

  /// Adds [video] unless a video with the same path is already imported.
  /// Returns the document and the id of the (new or existing) asset.
  (ProjectDocument, String) importVideo(VideoAsset video) {
    for (final existing in videos) {
      if (existing.path == video.path) return (this, existing.id);
    }
    return (copyWith(videos: [...videos, video]), video.id);
  }
}
