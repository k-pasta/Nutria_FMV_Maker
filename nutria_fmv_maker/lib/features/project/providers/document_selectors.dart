// Narrow read-only views of the document, so widgets rebuild only when their
// own slice changes.
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutria_fmv_maker/core/document/edge.dart';
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/core/document/project_document.dart';
import 'package:nutria_fmv_maker/core/document/video_settings.dart';
import 'package:nutria_fmv_maker/core/graph/graph_ops.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_provider.dart';
import 'package:nutria_fmv_maker/features/selection/providers/selection_provider.dart';
import 'package:path/path.dart' as p;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'document_selectors.g.dart';

/// The current document. Prefer the narrower providers below in widgets.
@riverpod
ProjectDocument projectDocument(Ref ref) =>
    ref.watch(documentProvider.select((s) => s.document));

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
        documentProvider.select((s) => s.document.nodes.keys.toList()));
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

/// Every connection, for drawing noodles.
@riverpod
List<Edge> edges(Ref ref) =>
    ref.watch(documentProvider.select((s) => s.document.edges));

/// Whether output [port] is connected.
@riverpod
bool isPortConnected(Ref ref, PortRef port) => ref.watch(
    documentProvider.select((s) => s.document.edgeFrom(port) != null));

/// Imported video [id], or `null`.
@riverpod
VideoAsset? videoAsset(Ref ref, String id) =>
    ref.watch(documentProvider.select((s) => s.document.videoById(id)));

/// All imported videos, in import order.
@riverpod
List<VideoAsset> videoAssets(Ref ref) =>
    ref.watch(documentProvider.select((s) => s.document.videos));

/// Project title and description.
@riverpod
ProjectInfo projectInfo(Ref ref) =>
    ref.watch(documentProvider.select((s) => s.document.info));

/// Project-wide playback settings.
@riverpod
VideoSettings projectSettings(Ref ref) =>
    ref.watch(documentProvider.select((s) => s.document.settings));

/// The settings node [nodeId] actually plays with: the project settings with
/// the node's overrides applied.
@riverpod
VideoSettings effectiveSettings(Ref ref, String nodeId) {
  final base = ref.watch(projectSettingsProvider);
  final overrides =
      ref.watch(nodeProvider(nodeId).select((n) => n?.overridesOrNull));
  return overrides?.applyTo(base) ?? base;
}

/// Undo/redo availability and the names of the steps, for menus.
@riverpod
({bool canUndo, bool canRedo, String? undoLabel, String? redoLabel})
    historyStatus(Ref ref) => ref.watch(documentProvider.select((s) => (
          canUndo: s.timeline.canUndo,
          canRedo: s.timeline.canRedo,
          undoLabel: s.timeline.undoLabel,
          redoLabel: s.timeline.redoLabel,
        )));

/// Whether there are unsaved changes.
@riverpod
bool isDirty(Ref ref) => ref.watch(documentProvider.select((s) => s.isDirty));

/// File name of the open project, or `null` if it has never been saved.
@riverpod
String? projectFileName(Ref ref) {
  final path = ref.watch(documentProvider.select((s) => s.savePath));
  return path == null ? null : p.basename(path);
}
