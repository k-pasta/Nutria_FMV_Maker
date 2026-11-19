// The open project: its document, undo history, save path and file actions.
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nutria_fmv_maker/core/document/project_document.dart';
import 'package:nutria_fmv_maker/core/history/document_timeline.dart';
import 'package:nutria_fmv_maker/core/protocol/fmv_exporter.dart';
import 'package:nutria_fmv_maker/features/preferences/providers/preferences_provider.dart';
import 'package:nutria_fmv_maker/services/project_file_service.dart';
import 'package:path/path.dart' as p;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'document_provider.freezed.dart';
part 'document_provider.g.dart';

/// Makes unique ids for nodes, choices and videos. Override in tests.
@Riverpod(keepAlive: true)
String Function() idGenerator(Ref ref) => const Uuid().v4;

/// Result of a file action. Failures are thrown, not returned (see
/// [ProjectFileService]).
enum FileOutcome { done, cancelled }

/// Everything about the open project that isn't editor UI state.
@freezed
abstract class DocumentState with _$DocumentState {
  const DocumentState._();

  const factory DocumentState({
    required DocumentTimeline timeline,

    /// The document as last saved or loaded; [isDirty] compares against it.
    required ProjectDocument savedDocument,

    /// Where the project was last saved or loaded from. `null` if never saved.
    String? savePath,

    /// Increments whenever a different project is opened or created, so
    /// editor state (selection, preview…) can reset itself.
    @Default(0) int generation,
  }) = _DocumentState;

  ProjectDocument get document => timeline.current;

  /// Whether there are unsaved changes. Identity is enough: every edit makes a
  /// new document, and undoing back to the saved state restores that instance.
  bool get isDirty => !identical(timeline.current, savedDocument);
}

/// Owns the open project. **Every** document change goes through [apply] (or a
/// transaction), which is what makes undo/redo work for every edit.
@Riverpod(keepAlive: true)
class DocumentNotifier extends _$DocumentNotifier {
  @override
  DocumentState build() => _fresh(ProjectDocument.empty(), generation: 0);

  ProjectFileService get _files => ref.read(projectFileServiceProvider);

  // ---------------------------------------------------------------- editing

  /// Applies [edit] as one undo step named [label] (or as part of the open
  /// transaction). See [DocumentTimeline.apply] for [mergeKey].
  void apply(
    String label,
    ProjectDocument Function(ProjectDocument document) edit, {
    Object? mergeKey,
  }) => _setTimeline(state.timeline.apply(label, edit, mergeKey: mergeKey));

  /// Starts grouping edits into one undo step, for continuous gestures.
  void beginTransaction(String label) =>
      _setTimeline(state.timeline.beginTransaction(label));

  /// Ends the gesture started with [beginTransaction].
  void commit() => _setTimeline(state.timeline.commit());

  /// Abandons the gesture and restores the document from before it.
  void cancel() => _setTimeline(state.timeline.cancel());

  void undo() => _setTimeline(state.timeline.undo());
  void redo() => _setTimeline(state.timeline.redo());

  void _setTimeline(DocumentTimeline timeline) {
    if (!identical(timeline, state.timeline)) {
      state = state.copyWith(timeline: timeline);
    }
  }

  // ------------------------------------------------------------------ files

  /// Replaces the project with an empty one. Callers ask about unsaved
  /// changes first.
  void newProject() =>
      state = _fresh(ProjectDocument.empty(), generation: state.generation + 1);

  /// Asks for a project file and opens it.
  Future<FileOutcome> open() async {
    final path = await _files.pickProject();
    if (path == null) return FileOutcome.cancelled;
    await openPath(path);
    return FileOutcome.done;
  }

  /// Opens the project at [path].
  Future<void> openPath(String path) async {
    final document = await _files.readProject(path);
    state = _fresh(document, generation: state.generation + 1, path: path);
  }

  /// Saves to the current path, or asks for one if the project is new.
  Future<FileOutcome> save() async {
    final path = state.savePath;
    if (path == null) return saveAs();
    final document = state.document;
    await _files.writeProject(path, document);
    state = state.copyWith(savedDocument: document);
    return FileOutcome.done;
  }

  /// Asks where to save and saves there.
  Future<FileOutcome> saveAs() async {
    final document = state.document;
    final path = await _files.saveProjectAs(
      document,
      suggestedName: _suggestedName(),
    );
    if (path == null) return FileOutcome.cancelled;
    state = state.copyWith(savedDocument: document, savePath: path);
    return FileOutcome.done;
  }

  /// Exports a `.fmv` for the Player. Problems such as nodes without a video
  /// don't stop the export; they're returned so the UI can report them.
  Future<({FileOutcome outcome, String? path, List<ExportIssue> issues})>
  export() async {
    final export = exportFmv(
      state.document,
      allowSingleChoice: ref.read(preferencesProvider).allowNoBrainers,
    );
    final path = await _files.saveExportAs(
      export,
      suggestedName: _suggestedName(),
    );
    return (
      outcome: path == null ? FileOutcome.cancelled : FileOutcome.done,
      path: path,
      issues: export.issues,
    );
  }

  String _suggestedName() {
    final path = state.savePath;
    if (path != null) return p.basenameWithoutExtension(path);
    final title = state.document.info.title?.trim() ?? '';
    return title.isEmpty ? 'project' : title;
  }

  DocumentState _fresh(
    ProjectDocument document, {
    required int generation,
    String? path,
  }) => DocumentState(
    timeline: DocumentTimeline.start(document),
    savedDocument: document,
    savePath: path,
    generation: generation,
  );
}
