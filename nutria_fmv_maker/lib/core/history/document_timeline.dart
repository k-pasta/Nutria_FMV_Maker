// Snapshot-based undo/redo with transactions, as a pure immutable value.
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nutria_fmv_maker/core/document/project_document.dart';

/// A labeled document snapshot in the undo or redo stack.
@immutable
class HistoryEntry {
  const HistoryEntry(this.label, this.document);

  /// Human-readable name of the edit, e.g. "Move nodes".
  final String label;

  /// The document as it was before (undo stack) or after (redo stack) the edit.
  final ProjectDocument document;
}

/// The current document plus its undo/redo history.
///
/// Because [ProjectDocument] is immutable, history entries are just earlier
/// documents; unchanged parts are shared, so snapshots are cheap.
///
/// Continuous gestures (dragging, resizing, typing) are wrapped in a
/// transaction so the whole gesture becomes a single undo step:
/// [beginTransaction] → many [apply] calls → [commit].
@immutable
class DocumentTimeline {
  const DocumentTimeline._({
    required this.current,
    required this.undoStack,
    required this.redoStack,
    required this.capacity,
    this.transaction,
  });

  /// Starts a timeline at [document] with empty history.
  factory DocumentTimeline.start(ProjectDocument document, {int capacity = 200}) =>
      DocumentTimeline._(
        current: document,
        undoStack: const [],
        redoStack: const [],
        capacity: capacity,
      );

  /// The document as the user currently sees it.
  final ProjectDocument current;

  /// Most recent edit last.
  final List<HistoryEntry> undoStack;

  /// Most recently undone edit last.
  final List<HistoryEntry> redoStack;

  /// Maximum number of undo steps kept.
  final int capacity;

  /// The open transaction, if any: its label and the document before it began.
  final HistoryEntry? transaction;

  bool get canUndo => transaction == null && undoStack.isNotEmpty;
  bool get canRedo => transaction == null && redoStack.isNotEmpty;
  String? get undoLabel => canUndo ? undoStack.last.label : null;
  String? get redoLabel => canRedo ? redoStack.last.label : null;
  bool get inTransaction => transaction != null;

  /// Applies [edit]. Outside a transaction this records one undo step named
  /// [label]; inside a transaction it only updates [current].
  /// Edits that don't change the document record nothing.
  DocumentTimeline apply(
    String label,
    ProjectDocument Function(ProjectDocument document) edit,
  ) {
    final next = edit(current);
    if (identical(next, current) || next == current) return this;
    if (inTransaction) return _copy(current: next);
    return _copy(
      current: next,
      undoStack: _pushCapped(undoStack, HistoryEntry(label, current)),
      redoStack: const [],
    );
  }

  /// Opens a transaction named [label]. Nested calls are ignored, so a
  /// gesture can't accidentally split itself into several steps.
  DocumentTimeline beginTransaction(String label) => inTransaction
      ? this
      : _copy(transaction: HistoryEntry(label, current));

  /// Closes the open transaction as one undo step (or nothing if the
  /// document ended up unchanged).
  DocumentTimeline commit() {
    final open = transaction;
    if (open == null) return this;
    if (open.document == current) return _copy(clearTransaction: true);
    return _copy(
      clearTransaction: true,
      undoStack: _pushCapped(undoStack, open),
      redoStack: const [],
    );
  }

  /// Abandons the open transaction and restores the document from before it.
  DocumentTimeline cancel() {
    final open = transaction;
    if (open == null) return this;
    return _copy(current: open.document, clearTransaction: true);
  }

  /// Steps back one edit. No-op if there's nothing to undo or a transaction
  /// is open.
  DocumentTimeline undo() {
    if (!canUndo) return this;
    final entry = undoStack.last;
    return _copy(
      current: entry.document,
      undoStack: undoStack.sublist(0, undoStack.length - 1),
      redoStack: [...redoStack, HistoryEntry(entry.label, current)],
    );
  }

  /// Re-applies the last undone edit.
  DocumentTimeline redo() {
    if (!canRedo) return this;
    final entry = redoStack.last;
    return _copy(
      current: entry.document,
      redoStack: redoStack.sublist(0, redoStack.length - 1),
      undoStack: [...undoStack, HistoryEntry(entry.label, current)],
    );
  }

  List<HistoryEntry> _pushCapped(List<HistoryEntry> stack, HistoryEntry entry) {
    final next = [...stack, entry];
    return next.length > capacity ? next.sublist(next.length - capacity) : next;
  }

  DocumentTimeline _copy({
    ProjectDocument? current,
    List<HistoryEntry>? undoStack,
    List<HistoryEntry>? redoStack,
    HistoryEntry? transaction,
    bool clearTransaction = false,
  }) =>
      DocumentTimeline._(
        current: current ?? this.current,
        undoStack: undoStack ?? this.undoStack,
        redoStack: redoStack ?? this.redoStack,
        capacity: capacity,
        transaction: clearTransaction ? null : (transaction ?? this.transaction),
      );
}
