// Renaming a node in place, in its color strip.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutria_fmv_maker/core/graph/graph_ops.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'rename_provider.g.dart';

/// The node whose name is being edited in its strip, or `null`.
///
/// The whole edit is one undo transaction: the name is written as it's typed
/// (so the strip and the knots below it move together), [commit] keeps it
/// and [cancel] restores the old one.
@Riverpod(keepAlive: true)
class RenamingNodeNotifier extends _$RenamingNodeNotifier {
  @override
  String? build() {
    // A new or opened project ends any rename.
    ref.watch(documentProvider.select((s) => s.generation));
    return null;
  }

  DocumentNotifier get _document => ref.read(documentProvider.notifier);

  /// Starts editing node [id]'s name (ending any other rename first).
  void start(String id) {
    if (state == id) return;
    commit();
    if (!ref.read(documentProvider).document.nodes.containsKey(id)) return;
    _document.beginTransaction('Rename node');
    // An unnamed node gets an empty name while editing, so its strip is
    // already tall enough for the text field.
    _document.apply(
      'Rename node',
      (d) => d.nodes[id]?.name == null ? d.setNodeName(id, '') : d,
    );
    state = id;
  }

  /// The typed text, as it is typed.
  void update(String name) {
    final id = state;
    if (id != null) {
      _document.apply('Rename node', (d) => d.setNodeName(id, name));
    }
  }

  /// Keeps the typed name (an empty one removes the name) and ends editing.
  void commit() {
    final id = state;
    if (id == null) return;
    state = null;
    _document.apply('Rename node', (d) => d.renameNode(id, d.nodes[id]?.name));
    _document.commit();
  }

  /// Restores the name from before editing.
  void cancel() {
    if (state == null) return;
    state = null;
    _document.cancel();
  }
}
