// Facts about a story for the project overview: which files it uses and how
// long a viewer can spend in it.
import 'dart:collection';

import 'package:nutria_fmv_maker/core/document/edge.dart';
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/core/document/project_document.dart';
import 'package:nutria_fmv_maker/core/graph/graph_ops.dart';
import 'package:nutria_fmv_maker/core/graph/ports.dart';
import 'package:nutria_fmv_maker/core/graph/screen_ops.dart';

/// Node ids reachable from the origin, breadth-first, following each node's
/// outputs in port order: what an export contains. Edges into deleted
/// nodes are ignored.
List<String> reachableNodeIds(ProjectDocument document) {
  final start = document.origin.id;
  final visited = <String>{start};
  final order = <String>[];
  final queue = Queue.of([start]);
  while (queue.isNotEmpty) {
    final nodeId = queue.removeFirst();
    order.add(nodeId);
    for (final next in _nextOf(document, nodeId)) {
      if (visited.add(next)) queue.add(next);
    }
  }
  return order;
}

/// The nodes [nodeId] can go on to, in port order.
List<String> _nextOf(ProjectDocument document, String nodeId) => [
  for (final PortRef port in outputRefsOf(document.node(nodeId)))
    if (document.edgeFrom(port)?.to.nodeId case final next?
        when document.nodes.containsKey(next))
      next,
];

/// The imported files an export of [document] uses: the videos, subtitles
/// and music of reachable nodes (pause music from their defaults too), the
/// menu music, and the backgrounds and fonts of the designed screens.
Set<String> usedMediaIds(ProjectDocument document) {
  final ids = <String>{};
  for (final nodeId in reachableNodeIds(document)) {
    final node = document.node(nodeId);
    ids.addAll(node.mediaIds);
    ids.addAll(document.subtitlesOf(node.videoIdOrNull).values);
    // Music from the defaults counts too.
    if (node.overridesOrNull case final overrides?) {
      final settings = overrides.applyTo(document.defaultsFor(node.swatch));
      ids.add(settings.music.audioId);
      if (node is BranchedVideoNode) ids.add(settings.pauseMusicId);
    }
  }
  for (final screen in document.screens) {
    if (screen.backgroundId case final id?) ids.add(id);
    for (final element in screen.elements) {
      if (document.styleOf(element).fontId case final id?) ids.add(id);
    }
  }
  return {
    for (final id in ids)
      if (document.mediaById(id) != null) id,
  };
}

/// How long the story plays, counting the videos only (not the time spent
/// choosing).
typedef StoryLength = ({
  /// The quickest way from the start to an end; `null` if no end can be
  /// reached.
  Duration? shortest,

  /// The longest way without going round a loop; `null` when there are
  /// loops (any length is possible) or no end.
  Duration? longest,

  /// Whether a viewer can come back to a node they've seen.
  bool hasLoops,

  /// Reachable videos whose length isn't known (missing or unreadable
  /// files), counted as zero.
  int unknown,

  /// How many videos the shortest and longest ways play (`null` with no
  /// such way).
  int? shortestVideos,
  int? longestVideos,
});

/// The [StoryLength] of [document]; [durationOf] gives a video's length by
/// media id (`null` if unknown).
StoryLength storyLength(
  ProjectDocument document,
  Duration? Function(String videoId) durationOf,
) {
  final reachable = reachableNodeIds(document);
  var unknown = 0;
  final weight = <String, Duration>{};
  // The nodes that play a video.
  final videos = <String>{};
  for (final nodeId in reachable) {
    final videoId = document.node(nodeId).videoIdOrNull;
    final length = videoId == null ? null : durationOf(videoId);
    if (videoId != null && length == null) unknown++;
    weight[nodeId] = length ?? Duration.zero;
    if (videoId != null) videos.add(nodeId);
  }
  int videosIn(String nodeId) => videos.contains(nodeId) ? 1 : 0;
  final start = document.origin.id;
  bool isEnd(String nodeId) =>
      nodeId != start && _nextOf(document, nodeId).isEmpty;

  // Shortest: Dijkstra over node lengths (small graphs, so a plain scan).
  final best = <String, Duration>{start: Duration.zero};
  final count = <String, int>{start: 0};
  final done = <String>{};
  Duration? shortest;
  int? shortestVideos;
  while (true) {
    String? current;
    for (final MapEntry(:key, :value) in best.entries) {
      if (done.contains(key)) continue;
      if (current == null || value < best[current]!) current = key;
    }
    if (current == null) break;
    done.add(current);
    final here = best[current]!;
    if (isEnd(current)) {
      shortest = here;
      shortestVideos = count[current];
      break;
    }
    for (final next in _nextOf(document, current)) {
      final through = here + weight[next]!;
      if (best[next] == null || through < best[next]!) {
        best[next] = through;
        count[next] = count[current]! + videosIn(next);
      }
    }
  }

  // Longest: depth-first with memory, giving up on the first loop.
  // Each node's longest way on: its length and how many videos it plays.
  final longestFrom = <String, (Duration, int)?>{};
  final onPath = <String>{};
  var hasLoops = false;
  (Duration, int)? longestOf(String nodeId) {
    if (longestFrom.containsKey(nodeId)) return longestFrom[nodeId];
    if (!onPath.add(nodeId)) {
      hasLoops = true;
      return null;
    }
    (Duration, int)? best;
    final next = _nextOf(document, nodeId);
    if (next.isEmpty && nodeId != start) best = (Duration.zero, 0);
    for (final n in next) {
      final rest = longestOf(n);
      if (rest == null) continue;
      final total = (weight[n]! + rest.$1, rest.$2 + videosIn(n));
      if (best == null || total.$1 > best.$1) best = total;
    }
    onPath.remove(nodeId);
    longestFrom[nodeId] = best;
    return best;
  }

  final longest = longestOf(start);
  return (
    shortest: shortest,
    longest: hasLoops ? null : longest?.$1,
    hasLoops: hasLoops,
    unknown: unknown,
    shortestVideos: shortestVideos,
    longestVideos: hasLoops ? null : longest?.$2,
  );
}

/// The story's nodes (videos and logic; not the origin or comments) that
/// can't be reached from the origin: they aren't exported.
Set<String> nodesOutsideMainBranch(ProjectDocument document) {
  final reachable = reachableNodeIds(document).toSet();
  return {
    for (final node in document.nodes.values)
      if (node is! OriginNode &&
          node is! CommentNode &&
          !reachable.contains(node.id))
        node.id,
  };
}

/// How many story nodes there are (videos and logic), and how many of
/// them the origin reaches (the main branch).
({int total, int main}) storyNodeCounts(ProjectDocument document) {
  final total = document.nodes.values
      .where((n) => n is! OriginNode && n is! CommentNode)
      .length;
  return (total: total, main: total - nodesOutsideMainBranch(document).length);
}
