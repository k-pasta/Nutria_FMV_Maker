// Narrow read-only views of the document, so widgets rebuild only when their
// own slice changes.
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutria_fmv_maker/core/document/media.dart';
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/core/document/position.dart';
import 'package:nutria_fmv_maker/core/document/project_document.dart';
import 'package:nutria_fmv_maker/core/document/variable.dart';
import 'package:nutria_fmv_maker/core/document/video_settings.dart';
import 'package:nutria_fmv_maker/core/graph/variable_ops.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_provider.dart';
import 'package:nutria_fmv_maker/features/selection/providers/selection_provider.dart';
import 'package:path/path.dart' as p;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'document_selectors.g.dart';

/// The current document. Prefer the narrower providers below in widgets.
///
/// Compared by identity: every edit makes a new document, and comparing two
/// documents field by field on every frame of a drag is slow.
@riverpod
class ProjectDocumentNotifier extends _$ProjectDocumentNotifier {
  @override
  ProjectDocument build() => ref.watch(documentProvider).document;

  @override
  bool updateShouldNotify(ProjectDocument previous, ProjectDocument next) =>
      !identical(previous, next);
}

/// Node [id] without its position: it stays equal while the node is dragged,
/// so the node's content doesn't rebuild on every frame of a move.
@riverpod
Node? nodeContent(Ref ref, String id) => ref.watch(
  nodeProvider(id).select((n) => n?.copyWith(position: Position.zero)),
);

/// Node [id], or `null` once it has been removed.
@riverpod
Node? node(Ref ref, String id) =>
    ref.watch(documentProvider.select((s) => s.document.nodes[id]));

/// Node ids in drawing order: document order, with raised nodes on top.
/// Only notifies when the order actually changes, not on every edit.
@riverpod
class NodePaintOrder extends _$NodePaintOrder {
  @override
  List<String> build() {
    final ids = ref.watch(
      documentProvider.select((s) => s.document.nodes.keys.toList()),
    );
    final raised = ref.watch(selectionProvider.select((s) => s.raised));
    final present = ids.toSet();
    final raisedPresent = [
      for (final id in raised)
        if (present.contains(id)) id,
    ];
    final raisedSet = raisedPresent.toSet();
    return [
      for (final id in ids)
        if (!raisedSet.contains(id)) id,
      ...raisedPresent,
    ];
  }

  @override
  bool updateShouldNotify(List<String> previous, List<String> next) =>
      !const ListEquality<String>().equals(previous, next);
}

/// Imported file [id], or `null`.
@riverpod
MediaAsset? mediaAsset(Ref ref, String id) =>
    ref.watch(documentProvider.select((s) => s.document.mediaById(id)));

/// All imported videos, in import order.
@riverpod
List<MediaAsset> mediaAssets(Ref ref) =>
    ref.watch(documentProvider.select((s) => s.document.media));

/// The project's variables, in the order they were added.
@riverpod
List<Variable> variables(Ref ref) =>
    ref.watch(documentProvider.select((s) => s.document.variables));

/// Variable names shown as errors: invalid or used twice.
@riverpod
Set<String> invalidVariableNames(Ref ref) =>
    ref.watch(projectDocumentProvider).invalidVariableNames;

/// Project title and description.
@riverpod
ProjectInfo projectInfo(Ref ref) =>
    ref.watch(documentProvider.select((s) => s.document.info));

/// Project-wide playback settings.
@riverpod
VideoSettings projectSettings(Ref ref) =>
    ref.watch(documentProvider.select((s) => s.document.settings));

/// Defaults for other colors than the first, by swatch index.
@riverpod
Map<int, VideoSettings> colorDefaults(Ref ref) =>
    ref.watch(documentProvider.select((s) => s.document.colorDefaults));

/// The settings node [nodeId] actually plays with: its color's defaults with
/// the node's overrides applied.
@riverpod
VideoSettings effectiveSettings(Ref ref, String nodeId) {
  final swatch = ref.watch(nodeProvider(nodeId).select((n) => n?.swatch));
  final VideoSettings base =
      ref.watch(colorDefaultsProvider)[swatch] ??
      ref.watch(projectSettingsProvider);
  final overrides = ref.watch(
    nodeProvider(nodeId).select((n) => n?.overridesOrNull),
  );
  return overrides?.applyTo(base) ?? base;
}

/// Undo/redo availability and the names of the steps, for menus.
@riverpod
({bool canUndo, bool canRedo, String? undoLabel, String? redoLabel})
historyStatus(Ref ref) => ref.watch(
  documentProvider.select(
    (s) => (
      canUndo: s.timeline.canUndo,
      canRedo: s.timeline.canRedo,
      undoLabel: s.timeline.undoLabel,
      redoLabel: s.timeline.redoLabel,
    ),
  ),
);

/// Whether there are unsaved changes.
@riverpod
bool isDirty(Ref ref) => ref.watch(documentProvider.select((s) => s.isDirty));

/// File name of the open project, or `null` if it has never been saved.
@riverpod
String? projectFileName(Ref ref) {
  final path = ref.watch(documentProvider.select((s) => s.savePath));
  return path == null ? null : p.basename(path);
}
