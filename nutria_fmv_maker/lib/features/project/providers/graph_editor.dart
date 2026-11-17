// Named, undoable editing commands for the node graph and project.
import 'package:flutter/painting.dart';
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/core/document/position.dart';
import 'package:nutria_fmv_maker/core/document/project_document.dart';
import 'package:nutria_fmv_maker/core/document/variable.dart';
import 'package:nutria_fmv_maker/core/document/video_settings.dart';
import 'package:nutria_fmv_maker/core/graph/fragment.dart';
import 'package:nutria_fmv_maker/core/graph/graph_ops.dart';
import 'package:nutria_fmv_maker/core/graph/variable_ops.dart';
import 'package:nutria_fmv_maker/features/preferences/providers/preferences_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/clipboard_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_provider.dart';
import 'package:nutria_fmv_maker/features/selection/providers/selection_provider.dart';
import 'package:nutria_fmv_maker/services/clipboard_service.dart';
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

  /// Deletes node [id] from its context menu: the whole selection if [id]
  /// is part of it, otherwise just [id].
  void removeNodeOrSelection(String id) {
    final selection = _ref.read(selectionProvider.notifier);
    if (!_ref.read(selectionProvider).selected.contains(id)) {
      selection.selectOnly(id);
    }
    removeSelection();
  }

  /// Selects every node.
  void selectAll() => _ref
      .read(selectionProvider.notifier)
      .setSelected(_current.nodes.keys.toSet());

  /// Closes the settings of every node.
  void collapseAll() =>
      _document.apply('Collapse all', (d) => d.collapseAll());

  // -------------------------------------------------------------- clipboard

  /// Puts the selected nodes (not the origin) on the clipboard, with their
  /// connections among each other and their videos.
  Future<void> copySelection() async {
    final fragment =
        _current.copyFragment(_ref.read(selectionProvider).selected);
    if (fragment.isEmpty) return;
    if (await _ref.read(clipboardServiceProvider).write(fragment.encode())) {
      _ref.read(clipboardHasNodesProvider.notifier).copied();
    }
  }

  /// Pastes copied nodes centered on [at] (node coordinates) and selects
  /// them. Clipboard text that isn't copied nodes is ignored.
  Future<void> paste(Offset at) async {
    final fragment =
        NodeFragment.decode(await _ref.read(clipboardServiceProvider).read());
    if (fragment == null || fragment.isEmpty) return;
    final center = fragment.center;
    _insert('Paste nodes', fragment,
        Position(at.dx - center.x, at.dy - center.y));
  }

  /// Copies the selected nodes in place, one grid step down and right, and
  /// selects the copies. Doesn't touch the clipboard.
  void duplicateSelection() {
    final fragment =
        _current.copyFragment(_ref.read(selectionProvider).selected);
    if (fragment.isEmpty) return;
    final step = _ref.read(preferencesProvider).gridSize;
    _insert('Duplicate nodes', fragment, Position(step, step));
  }

  void _insert(String label, NodeFragment fragment, Position offset) {
    var pasted = const <String>[];
    _document.apply(label, (d) {
      final (doc, ids) =
          d.pasteFragment(fragment, offset: offset, newId: _newId);
      pasted = ids;
      return doc;
    });
    final selection = _ref.read(selectionProvider.notifier)
      ..setSelected(pasted.toSet());
    for (final id in pasted) {
      selection.raise(id);
    }
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
          VideoSettingsOverride Function(VideoSettingsOverride o) edit,
          {Object? mergeKey}) =>
      _updateOverrides('Change setting', nodeId, edit, mergeKey: mergeKey);

  void clearOverrides(String nodeId) => _updateOverrides(
      'Remove overrides', nodeId, (_) => const VideoSettingsOverride());

  void _updateOverrides(String label, String nodeId,
      VideoSettingsOverride Function(VideoSettingsOverride o) edit,
      {Object? mergeKey}) {
    _document.apply(label, (d) {
      final current = d.node(nodeId).overridesOrNull;
      if (current == null) return d;
      return d.setOverrides(nodeId, edit(current));
    }, mergeKey: mergeKey);
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
  /// Pass the same [mergeKey] for every keystroke of one typing session.
  void editProjectSettings(VideoSettings Function(VideoSettings s) edit,
          {Object? mergeKey}) =>
      _document.apply('Change project settings',
          (d) => d.copyWith(settings: edit(d.settings)),
          mergeKey: mergeKey);

  // -------------------------------------------------------------- variables

  /// Adds a true/false variable named [baseName] plus a free number, and
  /// returns its id.
  String addVariable(String baseName) {
    final id = _newId();
    _document.apply(
        'Add variable',
        (d) => d.addVariable(
            Variable.boolean(id: id, name: d.freeVariableName(baseName))));
    return id;
  }

  void removeVariable(String id) =>
      _document.apply('Delete variable', (d) => d.removeVariable(id));

  /// Pass the same [mergeKey] for every keystroke of one editing session.
  void renameVariable(String id, String name, {Object? mergeKey}) =>
      _document.apply('Rename variable', (d) => d.renameVariable(id, name),
          mergeKey: mergeKey);

  /// Changes the type, converting the starting value.
  void setVariableType(String id, VariableType type) => _document.apply(
      'Change variable type', (d) => d.setVariableType(id, type));

  /// Sets the starting value from typed [text]. Text that isn't a value of
  /// the variable's type (e.g. half-typed "-") changes nothing.
  void setVariableInitialText(String id, String text, {Object? mergeKey}) =>
      _document.apply(
          'Edit variable',
          (d) => d.updateVariable(id, (v) => v.withInitialText(text) ?? v),
          mergeKey: mergeKey);

  /// Steps the starting value with the field's arrows (see
  /// [Variable.stepped]).
  void stepVariable(String id, int direction) => _document.apply(
      'Edit variable', (d) => d.updateVariable(id, (v) => v.stepped(direction)));

  /// Sets a true/false variable's starting value.
  void setVariableBool(String id, bool value) => _document.apply(
      'Edit variable',
      (d) => d.updateVariable(
          id, (v) => v is BoolVariable ? v.copyWith(initial: value) : v));

  /// Flips a true/false variable's starting value.
  void toggleVariable(String id) => _document.apply(
      'Edit variable',
      (d) => d.updateVariable(
          id, (v) => v is BoolVariable ? v.copyWith(initial: !v.initial) : v));

  // ----------------------------------------------------------------- videos

  /// Asks for video files and imports them. Returns the ids of the assets.
  Future<List<String>> pickAndImportVideos() async {
    final paths = await _ref.read(projectFileServiceProvider).pickVideos();
    return importVideos(paths);
  }

  /// Asks for video files, imports them and gives the first one to video
  /// node [nodeId], as one undo step.
  Future<void> pickVideoFor(String nodeId) async {
    final paths = await _ref.read(projectFileServiceProvider).pickVideos();
    if (paths.isEmpty) return;
    _document.beginTransaction('Set video');
    final ids = importVideos(paths);
    setVideo(nodeId, ids.first);
    _document.commit();
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
