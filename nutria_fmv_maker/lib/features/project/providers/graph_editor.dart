// Named, undoable editing commands for the node graph and project.
import 'package:flutter/painting.dart';
import 'package:nutria_fmv_maker/core/document/media.dart';
import 'package:nutria_fmv_maker/core/document/music.dart';
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/core/document/position.dart';
import 'package:nutria_fmv_maker/core/document/project_document.dart';
import 'package:nutria_fmv_maker/core/document/screen.dart';
import 'package:nutria_fmv_maker/core/document/variable.dart';
import 'package:nutria_fmv_maker/core/document/video_settings.dart';
import 'package:nutria_fmv_maker/core/graph/fragment.dart';
import 'package:nutria_fmv_maker/core/graph/graph_ops.dart';
import 'package:nutria_fmv_maker/core/graph/screen_ops.dart';
import 'package:nutria_fmv_maker/core/graph/variable_ops.dart';
import 'package:nutria_fmv_maker/features/nodes/node_bounds.dart';
import 'package:nutria_fmv_maker/features/nodes/providers/node_gesture_provider.dart';
import 'package:nutria_fmv_maker/features/preferences/providers/preferences_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/clipboard_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_provider.dart';
import 'package:nutria_fmv_maker/features/screens/providers/screens_provider.dart';
import 'package:nutria_fmv_maker/features/selection/providers/selection_provider.dart';
import 'package:nutria_fmv_maker/services/clipboard_service.dart';
import 'package:nutria_fmv_maker/services/media_files_service.dart';
import 'package:nutria_fmv_maker/services/project_file_service.dart';
import 'package:nutria_fmv_protocol/nutria_fmv_protocol.dart';
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
  String addVideoNode(
    Position position, {
    String? videoId,
    DefaultNodeType? type,
  }) {
    final id = _newId();
    final node = switch (type ??
        _ref.read(preferencesProvider).defaultNodeType) {
      DefaultNodeType.simpleVideo => SimpleVideoNode(
        id: id,
        position: position,
        videoId: videoId,
      ),
      DefaultNodeType.branchedVideo => newBranchedVideoNode(
        id: id,
        position: position,
        videoId: videoId,
        newId: _newId,
      ),
    };
    _document.apply('Add node', (d) => d.putNode(node));
    return id;
  }

  /// A number field is being dragged: the steps until [endValueDrag] are
  /// one undo step.
  void beginValueDrag() => _document.beginTransaction('Change value');

  /// Ends the drag started with [beginValueDrag].
  void endValueDrag() => _document.commit();

  /// Gives video node [id] music [audioId] (keeping its music settings).
  void setMusic(String id, String audioId) =>
      _document.apply('Set music', (d) => d.setMusic(id, audioId));

  /// Edits video node [id]'s music settings.
  void editMusic(
    String id,
    MusicCue Function(MusicCue cue) edit, {
    Object? mergeKey,
  }) => _document.apply(
    'Change music',
    (d) => d.updateMusic(id, (cue) => cue == null ? null : edit(cue)),
    mergeKey: mergeKey,
  );

  void removeMusic(String id) =>
      _document.apply('Remove music', (d) => d.updateMusic(id, (_) => null));

  /// Sets (or with `null` removes) branched node [id]'s pause music.
  void setPauseMusic(String id, String? audioId) =>
      _document.apply('Set pause music', (d) => d.setPauseMusic(id, audioId));

  void setPauseMusicFadeOut(String id, int ms, {Object? mergeKey}) =>
      _document.apply(
        'Change pause music',
        (d) => d.setPauseMusicFadeOut(id, ms),
        mergeKey: mergeKey,
      );

  /// Sets (or with `null` removes) the main menu music.
  void setMenuMusic(String? audioId) =>
      _document.apply('Set menu music', (d) => d.setMenuMusic(audioId));

  // ---------------------------------------------------------------- screens

  ScreenKind get _screen => _ref.read(selectedScreenProvider);

  /// Adds an element of [kind] to the screen being designed, at ([x], [y])
  /// if given (fractions of the screen), and selects it.
  void addScreenElement(ScreenElementKind kind, {double? x, double? y}) {
    final id = _newId();
    final screen = _screen;
    _document.apply(
      'Add element',
      (d) => d.addScreenElement(screen, id, kind, x: x, y: y),
    );
    _ref.read(selectedScreenElementProvider.notifier).select(id);
  }

  void removeScreenElement(String id) {
    _document.apply('Remove element', (d) => d.removeScreenElement(id));
    _ref.read(selectedScreenElementProvider.notifier).select(null);
  }

  /// The background of the screen being designed.
  void setScreenBackground(String? mediaId) {
    final screen = _screen;
    _document.apply(
      'Set background',
      (d) => d.setScreenBackground(screen, mediaId),
    );
  }

  /// The main menu's background.
  void setMenuBackground(String? mediaId) =>
      _document.apply('Set background', (d) => d.setMenuBackground(mediaId));

  /// Replaces the elements of [preset]'s screen with its layout.
  void applyScreenPreset(ScreenPreset preset) {
    _document.apply('Layout', (d) => d.applyScreenPreset(preset, _newId));
    _ref.read(selectedScreenElementProvider.notifier).select(null);
  }

  /// Replaces the menu's elements with the classic layout.
  void applyClassicMenu() => applyScreenPreset(ScreenPreset.classicMenu);

  void setScreenElementWidth(String id, double width) => _document.apply(
    'Change element',
    (d) => d.setScreenElementWidth(id, width),
  );

  void setScreenElementGap(String id, double gap) =>
      _document.apply('Change element', (d) => d.setScreenElementGap(id, gap));

  void setScreenElementStyle(String id, String? styleId) => _document.apply(
    'Change element',
    (d) => d.setScreenElementStyle(id, styleId),
  );

  void setScreenElementText(String id, String text, {Object? mergeKey}) =>
      _document.apply(
        'Change element',
        (d) => d.setScreenElementText(id, text),
        mergeKey: mergeKey,
      );

  /// Edits screen style [id] (every element using it changes).
  void editScreenStyle(String id, ScreenStyle Function(ScreenStyle s) edit) =>
      _document.apply('Change style', (d) => d.editScreenStyle(id, edit));

  /// Adds a style copied from [fromId] (or the plain button style), named
  /// [name], gives it to the selected element if there is one, and returns
  /// its id.
  String addScreenStyle(String name, {String fromId = 'button'}) {
    final id = _newId();
    final element = _ref.read(selectedScreenElementProvider);
    _document.apply('New style', (d) {
      final added = d.duplicateScreenStyle(fromId, id, name);
      return element == null ? added : added.setScreenElementStyle(element, id);
    });
    if (element == null) {
      _ref.read(selectedScreenStyleProvider.notifier).select(id);
    }
    return id;
  }

  void renameScreenStyle(String id, String name, {Object? mergeKey}) =>
      _document.apply(
        'Rename style',
        (d) => d.renameScreenStyle(id, name),
        mergeKey: mergeKey,
      );

  void removeScreenStyle(String id) {
    _document.apply('Delete style', (d) => d.removeScreenStyle(id));
    if (_ref.read(selectedScreenStyleProvider) == id) {
      _ref.read(selectedScreenStyleProvider.notifier).select(null);
    }
  }

  /// Adds a Change Variable node at [position] and returns its id.
  String addChangeNode(Position position) {
    final id = _newId();
    _document.apply(
      'Add node',
      (d) => d.putNode(ChangeVariableNode(id: id, position: position)),
    );
    return id;
  }

  /// Adds a Compare node with one empty condition at [position] and
  /// returns its id.
  String addCompareNode(Position position) {
    final id = _newId();
    _document.apply(
      'Add node',
      (d) => d.putNode(
        CompareNode(
          id: id,
          position: position,
          conditions: [LogicCondition(id: _newId())],
        ),
      ),
    );
    return id;
  }

  /// Picks the variable change node [id] changes. An operation that
  /// doesn't fit the variable's kind becomes "set".
  void setChangeVariable(String id, String variableId) =>
      _document.apply('Change variable', (d) {
        final isBool =
            d.variables.where((v) => v.id == variableId).firstOrNull
                is BoolVariable;
        return d.updateChange(id, (n) {
          final fits = isBool
              ? n.operation.isForBooleans
              : n.operation.isForNumbers;
          return n.copyWith(
            variableId: variableId,
            operation: fits ? n.operation : FmvChangeOperation.set,
            value: isBool && n.value.trim().isEmpty ? 'true' : n.value,
          );
        });
      });

  void setChangeOperation(String id, FmvChangeOperation operation) =>
      _document.apply(
        'Change operation',
        (d) => d.updateChange(id, (n) => n.copyWith(operation: operation)),
      );

  void setChangeValue(String id, String value, {Object? mergeKey}) =>
      _document.apply(
        'Change value',
        (d) => d.updateChange(id, (n) => n.copyWith(value: value)),
        mergeKey: mergeKey,
      );

  void setConditionVariable(String id, String conditionId, String variableId) =>
      _document.apply('Change condition', (d) {
        final isBool =
            d.variables.where((v) => v.id == variableId).firstOrNull
                is BoolVariable;
        return d.updateCondition(
          id,
          conditionId,
          (c) => c.copyWith(
            variableId: variableId,
            comparison: isBool && !c.comparison.isForBooleans
                ? FmvComparison.equal
                : c.comparison,
            value: isBool && c.value.trim().isEmpty ? 'true' : c.value,
          ),
        );
      });

  void setConditionComparison(
    String id,
    String conditionId,
    FmvComparison comparison,
  ) => _document.apply(
    'Change condition',
    (d) => d.updateCondition(
      id,
      conditionId,
      (c) => c.copyWith(comparison: comparison),
    ),
  );

  void setConditionValue(
    String id,
    String conditionId,
    String value, {
    Object? mergeKey,
  }) => _document.apply(
    'Change condition',
    (d) => d.updateCondition(id, conditionId, (c) => c.copyWith(value: value)),
    mergeKey: mergeKey,
  );

  void addCondition(String id) => _document.apply(
    'Add condition',
    (d) => d.updateCompare(
      id,
      (n) => n.copyWith(
        conditions: [
          ...n.conditions,
          LogicCondition(id: _newId()),
        ],
      ),
    ),
  );

  void removeCondition(String id, String conditionId) => _document.apply(
    'Remove condition',
    (d) => d.updateCompare(
      id,
      (n) => n.copyWith(
        conditions: [
          for (final c in n.conditions)
            if (c.id != conditionId) c,
        ],
      ),
    ),
  );

  void setMatchAny(String id, bool any) => _document.apply(
    'Change condition',
    (d) => d.updateCompare(id, (n) => n.copyWith(matchAny: any)),
  );

  /// Sets compare node [id]'s expression; `null` goes back to conditions.
  void setCompareExpression(
    String id,
    String? expression, {
    Object? mergeKey,
  }) => _document.apply(
    'Change expression',
    (d) => d.updateCompare(id, (n) => n.copyWith(expression: expression)),
    mergeKey: mergeKey,
  );

  /// Adds an empty comment at [position], or on top of node [attachTo], and
  /// returns its id.
  String addComment(Position position, {String? attachTo}) {
    final id = _newId();
    _document.apply('Add comment', (d) {
      final doc = d.putNode(CommentNode(id: id, position: position));
      return attachTo == null ? doc : doc.attachComment(id, attachTo);
    });
    _ref.read(selectionProvider.notifier).selectOnly(id);
    return id;
  }

  /// Sets comment [id]'s text. Pass the same [mergeKey] for every keystroke
  /// of one editing session.
  void setCommentText(String id, String text, {Object? mergeKey}) =>
      _document.apply(
        'Edit comment',
        (d) => d.setCommentText(id, text),
        mergeKey: mergeKey,
      );

  /// Takes comment [id] off its node; it stays where it is.
  void detachComment(String id) {
    final doc = _ref.read(documentProvider).document;
    final comment = doc.nodes[id];
    final host = comment == null ? null : doc.hostOf(comment);
    if (host == null) return;
    final rect = _ref.read(nodeBoundsProvider).rectOf(comment!, host: host);
    _document.apply(
      'Detach comment',
      (d) => d.detachComment(
        id,
        Position(rect.left - kNodePadding, rect.top - kNodePadding),
        host.width,
      ),
    );
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
  void collapseAll() => _document.apply('Collapse all', (d) => d.collapseAll());

  // -------------------------------------------------------------- clipboard

  /// Puts the selected nodes (not the origin) on the clipboard, with their
  /// connections among each other and their videos.
  Future<void> copySelection() async {
    final fragment = _current.copyFragment(
      _ref.read(selectionProvider).selected,
    );
    if (fragment.isEmpty) return;
    if (await _ref.read(clipboardServiceProvider).write(fragment.encode())) {
      _ref.read(clipboardHasNodesProvider.notifier).copied();
    }
  }

  /// Copies the selected nodes (see [copySelection]) and deletes them, once
  /// they are on the clipboard. The origin is neither copied nor deleted.
  Future<void> cutSelection() async {
    final ids = _ref.read(selectionProvider).selected;
    final fragment = _current.copyFragment(ids);
    if (fragment.isEmpty) return;
    if (!await _ref.read(clipboardServiceProvider).write(fragment.encode())) {
      return;
    }
    _ref.read(clipboardHasNodesProvider.notifier).copied();
    _document.apply('Cut nodes', (d) => d.removeNodes(ids));
    _ref.read(selectionProvider.notifier).clear();
  }

  /// Pastes copied nodes centered on [at] (node coordinates) and selects
  /// them. Clipboard text that isn't copied nodes is ignored.
  Future<void> paste(Offset at) async {
    final fragment = NodeFragment.decode(
      await _ref.read(clipboardServiceProvider).read(),
    );
    if (fragment == null || fragment.isEmpty) return;
    final center = fragment.center;
    _insert(
      'Paste nodes',
      fragment,
      Position(at.dx - center.x, at.dy - center.y),
    );
  }

  /// Copies the selected nodes in place, one grid step down and right, and
  /// selects the copies. Doesn't touch the clipboard.
  void duplicateSelection() {
    final fragment = _current.copyFragment(
      _ref.read(selectionProvider).selected,
    );
    if (fragment.isEmpty) return;
    final step = _ref.read(preferencesProvider).gridSize;
    _insert('Duplicate nodes', fragment, Position(step, step));
  }

  void _insert(String label, NodeFragment fragment, Position offset) {
    var pasted = const <String>[];
    _document.apply(label, (d) {
      final (doc, ids) = d.pasteFragment(
        fragment,
        offset: offset,
        newId: _newId,
      );
      pasted = ids;
      return doc;
    });
    final selection = _ref.read(selectionProvider.notifier)
      ..setSelected(pasted.toSet());
    for (final id in pasted) {
      selection.raise(id);
    }
  }

  /// Removes every connection into or out of the selected nodes.
  void disconnectSelection() => _document.apply(
    'Disconnect nodes',
    (d) => d.disconnectNodes(_ref.read(selectionProvider).selected),
  );

  /// From node [id]'s menu: disconnects the whole selection if [id] is part
  /// of it, otherwise just [id].
  void disconnectNodeOrSelection(String id) {
    final selected = _ref.read(selectionProvider).selected;
    _document.apply(
      'Disconnect nodes',
      (d) => d.disconnectNodes(selected.contains(id) ? selected : {id}),
    );
  }

  /// Turns the question of branched node [id] on or off.
  void setQuestionEnabled(String id, bool enabled) => _document.apply(
    'Toggle question',
    (d) => d.setQuestionEnabled(id, enabled),
  );

  /// Pass the same [mergeKey] for every keystroke of one typing session.
  void setQuestion(String id, String text, {Object? mergeKey}) =>
      _document.apply(
        'Edit question',
        (d) => d.setQuestion(id, text),
        mergeKey: mergeKey,
      );

  /// Switches a video node between simple and branched.
  void convertNode(String id) => _document.apply(
    'Convert node',
    (d) => d.convertVideoNode(id, newId: _newId),
  );

  void setSwatch(String id, int swatch) =>
      _document.apply('Change color', (d) => d.setSwatch(id, swatch));

  void toggleExpanded(String id) =>
      _document.apply('Toggle settings', (d) => d.toggleExpanded(id));

  /// Sets the video a node plays.
  void setVideo(String nodeId, String videoId) =>
      _document.apply('Set video', (d) => d.setVideo(nodeId, videoId));

  /// Sets the text of choice [index]; typing just past the last choice adds
  /// one. Pass the same [mergeKey] for every keystroke of one editing session.
  void setChoiceText(
    String nodeId,
    int index,
    String text, {
    Object? mergeKey,
  }) => _document.apply(
    'Edit choice',
    (d) => d.setChoiceText(nodeId, index, text, newId: _newId),
    mergeKey: mergeKey,
  );

  // -------------------------------------------------------------- overrides

  /// Starts overriding [type] on a node, starting from the project value.
  void enableOverride(String nodeId, VideoSettingType type) => _updateOverrides(
    'Override setting',
    nodeId,
    (o) => o.enable(type, _current.settings),
  );

  /// Stops overriding [type] on a node.
  void disableOverride(String nodeId, VideoSettingType type) =>
      _updateOverrides('Remove override', nodeId, (o) => o.disable(type));

  /// Changes override values, e.g. `(o) => o.copyWith(showTimer: false)`.
  void editOverrides(
    String nodeId,
    VideoSettingsOverride Function(VideoSettingsOverride o) edit, {
    Object? mergeKey,
  }) => _updateOverrides('Change setting', nodeId, edit, mergeKey: mergeKey);

  void clearOverrides(String nodeId) => _updateOverrides(
    'Remove overrides',
    nodeId,
    (_) => const VideoSettingsOverride(),
  );

  void _updateOverrides(
    String label,
    String nodeId,
    VideoSettingsOverride Function(VideoSettingsOverride o) edit, {
    Object? mergeKey,
  }) {
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

  /// Adds language [code] to the story (last, or first if it's the only).
  void addLanguage(String code) => _document.apply(
    'Add language',
    (d) => d.setLanguages([...d.info.languages, code]),
  );

  void removeLanguage(String code) => _document.apply(
    'Remove language',
    (d) => d.setLanguages([
      for (final l in d.info.languages)
        if (l != code) l,
    ]),
  );

  /// Makes [code] the story's main language (the first).
  void makeMainLanguage(String code) => _document.apply(
    'Change main language',
    (d) => d.setLanguages([
      code,
      for (final l in d.info.languages)
        if (l != code) l,
    ]),
  );

  void setProjectDescription(String description, {Object? mergeKey}) =>
      _document.apply(
        'Edit description',
        (d) => d.copyWith(info: d.info.copyWith(description: description)),
        mergeKey: mergeKey,
      );

  /// Changes project-wide settings, e.g. `(s) => s.copyWith(showTimer: true)`.
  /// Pass the same [mergeKey] for every keystroke of one typing session.
  void editProjectSettings(
    VideoSettings Function(VideoSettings s) edit, {
    Object? mergeKey,
  }) => editDefaults(0, edit, mergeKey: mergeKey);

  /// Edits the defaults of color [swatch] (0, or a color without its own,
  /// edits the first color's).
  void editDefaults(
    int swatch,
    VideoSettings Function(VideoSettings s) edit, {
    Object? mergeKey,
  }) => _document.apply(
    'Change defaults',
    (d) => d.editDefaults(swatch, edit),
    mergeKey: mergeKey,
  );

  /// Gives the next color without defaults its own, a copy of the first
  /// color's. Does nothing when every color has them.
  void addColorDefaults() => _document.apply('Add color defaults', (d) {
    final swatch = d.nextColorWithoutDefaults;
    return swatch == null ? d : d.addColorDefaults(swatch);
  });

  /// Color [swatch] goes back to the first color's defaults.
  void removeColorDefaults(int swatch) => _document.apply(
    'Remove color defaults',
    (d) => d.removeColorDefaults(swatch),
  );

  // -------------------------------------------------------------- variables

  /// Adds a true/false variable named [baseName] plus a free number, and
  /// returns its id.
  String addVariable(String baseName) {
    final id = _newId();
    _document.apply(
      'Add variable',
      (d) => d.addVariable(
        Variable.boolean(id: id, name: d.freeVariableName(baseName)),
      ),
    );
    return id;
  }

  void removeVariable(String id) =>
      _document.apply('Delete variable', (d) => d.removeVariable(id));

  /// Pass the same [mergeKey] for every keystroke of one editing session.
  void renameVariable(String id, String name, {Object? mergeKey}) =>
      _document.apply(
        'Rename variable',
        (d) => d.renameVariable(id, name),
        mergeKey: mergeKey,
      );

  /// Changes the type, converting the starting value.
  void setVariableType(String id, VariableType type) => _document.apply(
    'Change variable type',
    (d) => d.setVariableType(id, type),
  );

  /// Sets the starting value from typed [text]. Text that isn't a value of
  /// the variable's type (e.g. half-typed "-") changes nothing.
  void setVariableInitialText(String id, String text, {Object? mergeKey}) =>
      _document.apply(
        'Edit variable',
        (d) => d.updateVariable(id, (v) => v.withInitialText(text) ?? v),
        mergeKey: mergeKey,
      );

  /// Sets the minimum ([isMin]) or maximum of a number variable from typed
  /// [text]; empty removes the limit.
  void setVariableLimit(
    String id, {
    required bool isMin,
    required String text,
    Object? mergeKey,
  }) => _document.apply(
    'Edit variable',
    (d) => d.setVariableLimit(id, isMin: isMin, text: text),
    mergeKey: mergeKey,
  );

  /// Steps the starting value with the field's arrows (see
  /// [Variable.stepped]).
  void stepVariable(String id, int direction) => _document.apply(
    'Edit variable',
    (d) => d.updateVariable(id, (v) => v.stepped(direction)),
  );

  /// Sets a true/false variable's starting value.
  void setVariableBool(String id, bool value) => _document.apply(
    'Edit variable',
    (d) => d.updateVariable(
      id,
      (v) => v is BoolVariable ? v.copyWith(initial: value) : v,
    ),
  );

  /// Flips a true/false variable's starting value.
  void toggleVariable(String id) => _document.apply(
    'Edit variable',
    (d) => d.updateVariable(
      id,
      (v) => v is BoolVariable ? v.copyWith(initial: !v.initial) : v,
    ),
  );

  // ------------------------------------------------------------------ media

  /// Asks for files of any kind and imports them. Returns their asset ids.
  Future<List<String>> pickAndImportMedia() async {
    final paths = await _ref.read(projectFileServiceProvider).pickMedia();
    return importFiles(paths);
  }

  /// Asks for video files, imports them and gives the first one to video
  /// node [nodeId], as one undo step.
  Future<void> pickVideoFor(String nodeId) async {
    final paths = await _ref.read(projectFileServiceProvider).pickVideoFiles();
    if (paths.isEmpty) return;
    _document.beginTransaction('Set video');
    final ids = importFiles(paths);
    setVideo(nodeId, ids.first);
    _document.commit();
  }

  /// Links subtitle file [subtitleId] to video [videoId] for [language]
  /// (`''`: the main one), as one undo step.
  void linkSubtitle(
    String videoId,
    String subtitleId, {
    String language = '',
  }) => _document.apply(
    'Link subtitles',
    (d) => d.linkSubtitle(videoId, subtitleId, language: language),
  );

  /// Video [videoId] no longer has subtitles.
  void unlinkSubtitle(String videoId) =>
      _document.apply('Unlink subtitles', (d) => d.unlinkSubtitle(videoId));

  /// Points imported file [id] at [path] instead, as one undo step. Nodes
  /// using it follow.
  void relinkMedia(String id, String path) =>
      _document.apply('Relink file', (d) => d.setMediaPath(id, path));

  /// Points each missing file of [ids] at the file of the same name directly
  /// in [folder], as one undo step. Returns how many were found.
  int relinkFromFolder(Set<String> ids, String folder) {
    final files = _ref.read(mediaFilesProvider).filesIn(folder);
    var found = 0;
    _document.apply('Locate missing files', (d) {
      final (next, relinked) = d.relinkByName(ids, files);
      found = relinked.length;
      return next;
    });
    return found;
  }

  /// Imports [paths] as one undo step. Already imported files are reused.
  /// Returns the asset id for each path, in order.
  List<String> importFiles(List<String> paths) {
    final ids = <String>[];
    _document.apply('Import files', (d) {
      var doc = d;
      for (final path in paths) {
        final (next, id) = doc.importMedia(
          MediaAsset(id: _newId(), path: path),
        );
        doc = next;
        ids.add(id);
      }
      final autoLink = _ref.read(preferencesProvider).autoLinkSubtitles;
      return autoLink ? doc.autoLinkSubtitles() : doc;
    });
    return ids;
  }
}

/// The app's [GraphEditor].
@Riverpod(keepAlive: true)
GraphEditor graphEditor(Ref ref) => GraphEditor(ref);
