// Named, undoable editing commands for the node graph and project.
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/core/document/position.dart';
import 'package:nutria_fmv_maker/core/document/project_document.dart';
import 'package:nutria_fmv_maker/core/document/video_settings.dart';
import 'package:nutria_fmv_maker/core/graph/graph_ops.dart';
import 'package:nutria_fmv_maker/features/preferences/providers/preferences_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_provider.dart';
import 'package:nutria_fmv_maker/features/selection/providers/selection_provider.dart';
import 'package:nutria_fmv_maker/services/project_file_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'graph_editor.g.dart';

/// One method per user command. Each is a single undo step whose label is
/// shown in the Edit menu. Continuous gestures (move, resize, connect) live in
/// their own notifiers because they need gesture state.
class GraphEditor {
  GraphEditor(this._ref);

  final Ref _ref;

  DocumentNotifier get _document => _ref.read(documentProvider.notifier);
  ProjectDocument get _current => _ref.read(documentProvider).document;
  IdGenerator get _newId => _ref.read(idGeneratorProvider);

  // ------------------------------------------------------------------ nodes

  /// Adds a video node at [position] and returns its id. The node is of
  /// [type], or of the type chosen in the preferences.
  String addVideoNode(Position position,
      {String? videoId, DefaultNodeType? type}) {
    final id = _newId();
    final node = switch (type ?? _ref.read(preferencesProvider).defaultNodeType) {
      DefaultNodeType.simpleVideo =>
        SimpleVideoNode(id: id, position: position, videoId: videoId),
      DefaultNodeType.branchedVideo => newBranchedVideoNode(
          id: id, position: position, videoId: videoId, newId: _newId),
    };
    _document.apply('Add node', (d) => d.putNode(node));
    return id;
  }

  /// Deletes the selected nodes (except the origin) and their connections.
  void removeSelection() {
    final ids = _ref.read(selectionProvider).selected;
    _document.apply('Delete nodes', (d) => d.removeNodes(ids));
    _ref.read(selectionProvider.notifier).clear();
  }

  /// Switches a video node between simple and branched.
  void convertNode(String id) => _document.apply(
      'Convert node', (d) => d.convertVideoNode(id, newId: _newId));

  void setSwatch(String id, int swatch) =>
      _document.apply('Change color', (d) => d.setSwatch(id, swatch));

  void toggleExpanded(String id) =>
      _document.apply('Toggle settings', (d) => d.toggleExpanded(id));

  /// Sets the video a node plays.
  void setVideo(String nodeId, String videoId) =>
      _document.apply('Set video', (d) => d.setVideo(nodeId, videoId));

  /// Sets the text of choice [index]; typing just past the last choice adds
  /// one. Pass the same [mergeKey] for every keystroke of one editing session.
  void setChoiceText(String nodeId, int index, String text,
          {Object? mergeKey}) =>
      _document.apply(
        'Edit choice',
        (d) => d.setChoiceText(nodeId, index, text, newId: _newId),
        mergeKey: mergeKey,
      );

  // -------------------------------------------------------------- overrides

  /// Starts overriding [type] on a node, starting from the project value.
  void enableOverride(String nodeId, VideoSettingType type) =>
      _updateOverrides('Override setting', nodeId,
          (o) => o.enable(type, _current.settings));

  /// Stops overriding [type] on a node.
  void disableOverride(String nodeId, VideoSettingType type) =>
      _updateOverrides('Remove override', nodeId, (o) => o.disable(type));

  /// Changes override values, e.g. `(o) => o.copyWith(showTimer: false)`.
  void editOverrides(String nodeId,
          VideoSettingsOverride Function(VideoSettingsOverride o) edit) =>
      _updateOverrides('Change setting', nodeId, edit);

  void clearOverrides(String nodeId) => _updateOverrides(
      'Remove overrides', nodeId, (_) => const VideoSettingsOverride());

  void _updateOverrides(String label, String nodeId,
      VideoSettingsOverride Function(VideoSettingsOverride o) edit) {
    _document.apply(label, (d) {
      final current = d.node(nodeId).overridesOrNull;
      if (current == null) return d;
      return d.setOverrides(nodeId, edit(current));
    });
  }

  // ---------------------------------------------------------------- project

  void setProjectTitle(String title, {Object? mergeKey}) => _document.apply(
        'Edit title',
        (d) => d.copyWith(info: d.info.copyWith(title: title)),
        mergeKey: mergeKey,
      );

  void setProjectDescription(String description, {Object? mergeKey}) =>
      _document.apply(
        'Edit description',
        (d) => d.copyWith(info: d.info.copyWith(description: description)),
        mergeKey: mergeKey,
      );

  /// Changes project-wide settings, e.g. `(s) => s.copyWith(showTimer: true)`.
  void editProjectSettings(VideoSettings Function(VideoSettings s) edit) =>
      _document.apply('Change project settings',
          (d) => d.copyWith(settings: edit(d.settings)));

  // ----------------------------------------------------------------- videos

  /// Asks for video files and imports them. Returns the ids of the assets.
  Future<List<String>> pickAndImportVideos() async {
    final paths = await _ref.read(projectFileServiceProvider).pickVideos();
    return importVideos(paths);
  }

  /// Imports [paths] as one undo step. Already imported files are reused.
  /// Returns the asset id for each path, in order.
  List<String> importVideos(List<String> paths) {
    final ids = <String>[];
    _document.apply('Import videos', (d) {
      var doc = d;
      for (final path in paths) {
        final (next, id) = doc.importVideo(VideoAsset(id: _newId(), path: path));
        doc = next;
        ids.add(id);
      }
      return doc;
    });
    return ids;
  }
}

/// The app's [GraphEditor].
@Riverpod(keepAlive: true)
GraphEditor graphEditor(Ref ref) => GraphEditor(ref);
