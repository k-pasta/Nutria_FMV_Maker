// What the Project section shows about the story: the size of the files it
// uses and how long it plays.
import 'package:nutria_fmv_maker/core/graph/graph_ops.dart';
import 'package:nutria_fmv_maker/core/graph/story_stats.dart';
import 'package:nutria_fmv_maker/core/protocol/fmv_exporter.dart';
import 'package:nutria_fmv_maker/features/media_library/providers/media_library_providers.dart';
import 'package:nutria_fmv_maker/features/preferences/providers/preferences_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:nutria_fmv_maker/services/media_files_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'project_overview_provider.g.dart';

/// How many files an export uses ([usedMediaIds]), their total size in
/// bytes, and how many of them couldn't be read.
@riverpod
({int count, int bytes, int unreadable}) usedMediaSize(Ref ref) {
  final doc = ref.watch(projectDocumentProvider);
  final files = ref.watch(mediaFilesProvider);
  final ids = usedMediaIds(doc);
  var bytes = 0;
  var unreadable = 0;
  for (final id in ids) {
    final size = files.sizeOf(doc.mediaById(id)!.path);
    if (size == null) {
      unreadable++;
    } else {
      bytes += size;
    }
  }
  return (count: ids.length, bytes: bytes, unreadable: unreadable);
}

/// The shortest and longest ways through the story, once the lengths of
/// its videos are read.
@riverpod
Future<StoryLength> storyLengthOverview(Ref ref) async {
  final doc = ref.watch(projectDocumentProvider);
  final durations = <String, Duration?>{};
  for (final nodeId in reachableNodeIds(doc)) {
    final video = doc.mediaById(doc.node(nodeId).videoIdOrNull);
    if (video == null || durations.containsKey(video.id)) continue;
    final info = await ref.watch(videoInfoProvider(video.path).future);
    durations[video.id] = info?.duration;
  }
  return storyLength(doc, (id) => durations[id]);
}

/// The problems the export would find in the main branch (the part of the
/// story the origin reaches): videos missing, answers leading nowhere,
/// logic that can't run.
@riverpod
List<ExportIssue> storyProblems(Ref ref) => exportFmv(
  ref.watch(projectDocumentProvider),
  allowSingleChoice: ref.watch(preferencesProvider).allowNoBrainers,
).issues;

/// How many story nodes there are, and how many the origin reaches.
@riverpod
({int total, int main}) storyNodeCountsOverview(Ref ref) =>
    storyNodeCounts(ref.watch(projectDocumentProvider));
