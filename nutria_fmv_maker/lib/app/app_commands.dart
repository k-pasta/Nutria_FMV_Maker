// Every app-level command (menus, shortcuts), with its user feedback.
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/app/app_info.dart';
import 'package:nutria_fmv_maker/core/document/languages.dart';
import 'package:nutria_fmv_maker/core/document/media.dart';
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/core/protocol/fmv_exporter.dart';
import 'package:nutria_fmv_maker/core/serialization/nfmv_codec.dart';
import 'package:nutria_fmv_maker/features/canvas/canvas_framing.dart';
import 'package:nutria_fmv_maker/features/canvas/providers/canvas_view_provider.dart';
import 'package:nutria_fmv_maker/features/nodes/node_bounds.dart';
import 'package:nutria_fmv_maker/features/nodes/providers/comment_provider.dart';
import 'package:nutria_fmv_maker/features/nodes/providers/rename_provider.dart';
import 'package:nutria_fmv_maker/features/preferences/providers/preferences_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:nutria_fmv_maker/features/project/providers/graph_editor.dart';
import 'package:nutria_fmv_maker/features/screens/providers/screens_provider.dart';
import 'package:nutria_fmv_maker/features/selection/providers/selection_provider.dart';
import 'package:nutria_fmv_maker/features/shell/providers/notifications_provider.dart';
import 'package:nutria_fmv_maker/features/shell/providers/overlay_provider.dart';
import 'package:nutria_fmv_maker/features/shell/providers/panel_layout_provider.dart';
import 'package:nutria_fmv_maker/features/video_library/providers/video_library_providers.dart';
import 'package:nutria_fmv_maker/features/video_preview/providers/video_preview_provider.dart';
import 'package:nutria_fmv_maker/l10n/generated/app_localizations.dart';
import 'package:nutria_fmv_maker/services/project_file_service.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_confirm_dialog.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_context_menu.dart';
import 'package:nutria_fmv_protocol/nutria_fmv_protocol.dart';
import 'package:path/path.dart' as p;
import 'package:url_launcher/url_launcher.dart';

/// Answers to "save the changes?".
enum _UnsavedChoice { save, discard, cancel }

/// The commands behind the menu bar and keyboard shortcuts. This is where
/// file results and errors become localized notifications, and where the
/// user is asked before unsaved changes are thrown away.
class AppCommands {
  AppCommands(this._context, this._ref);

  final BuildContext _context;
  final WidgetRef _ref;

  AppLocalizations get _t => AppLocalizations.of(_context);
  DocumentNotifier get _document => _ref.read(documentProvider.notifier);
  void _notify(String message) =>
      _ref.read(notificationsProvider.notifier).post(message);

  // ------------------------------------------------------------------ files

  Future<void> newProject() async {
    if (await _confirmDiscard()) _document.newProject();
  }

  Future<void> open() => _guard(() async {
    if (!await _confirmDiscard()) return;
    if (await _document.open() == FileOutcome.done &&
        _ref.read(missingMediaProvider).isNotEmpty) {
      _ref.read(overlayProvider.notifier).showModal(AppModal.missingFiles);
    }
  });

  /// Points the missing files at same-named files in a folder the user
  /// picks (not its subfolders).
  Future<void> locateMissingFiles() async {
    final missing = _ref.read(missingMediaProvider);
    if (missing.isEmpty) {
      _notify(_t.notifyNoMissingFiles);
      return;
    }
    final folder = await _ref.read(projectFileServiceProvider).pickFolder();
    if (folder == null) return;
    final found = _ref
        .read(graphEditorProvider)
        .relinkFromFolder(missing, folder);
    _notify(_t.notifyLocatedFiles(found, missing.length));
  }

  /// Links subtitle file [subtitleId] to video [videoId], with a notice if
  /// the subtitles go on after the video ends. When the story has more than
  /// one language, a menu at [at] (global) first asks which one they are.
  Future<void> linkSubtitle(
    String videoId,
    String subtitleId, {
    Offset? at,
  }) async {
    final languages = _ref.read(projectDocumentProvider).info.languages;
    if (languages.length < 2 || at == null) {
      return _linkSubtitle(videoId, subtitleId, '');
    }
    showNutriaMenu(_context, at, [
      for (final code in languages)
        NutriaContextMenuItem(
          icon: Icons.closed_caption,
          label: languageLabel(code),
          onSelected: () => _linkSubtitle(videoId, subtitleId, code),
        ),
    ], onOpenChanged: _ref.read(overlayProvider.notifier).setContextMenuOpen);
  }

  Future<void> _linkSubtitle(
    String videoId,
    String subtitleId,
    String language,
  ) async {
    _ref
        .read(graphEditorProvider)
        .linkSubtitle(videoId, subtitleId, language: language);
    final doc = _ref.read(projectDocumentProvider);
    final video = doc.mediaById(videoId);
    final subtitles = doc.mediaById(subtitleId);
    if (video == null ||
        subtitles == null ||
        !video.subtitles.containsValue(subtitleId)) {
      return;
    }
    final cues = await _ref.read(subtitleCuesProvider(subtitles.path).future);
    final info = await _ref.read(videoInfoProvider(video.path).future);
    final duration = info?.duration;
    if (cues == null || duration == null || !_context.mounted) return;
    final over = subtitlesEnd(cues) - duration;
    if (over > Duration.zero) {
      _notify(_t.notifySubtitlesLonger(_clock(over)));
    }
  }

  /// m:ss, rounded up to the second.
  static String _clock(Duration d) {
    final seconds = (d.inMilliseconds / 1000).ceil();
    return '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}';
  }

  /// Asks for the file that missing file [id] should point at. A file with
  /// another name is used too, with a notice.
  Future<void> findMissingFile(String id) => _relink(id, noticeIfRenamed: true);

  /// Asks for a file of the same kind to use instead of [id]'s.
  Future<void> replaceMedia(String id) => _relink(id, noticeIfRenamed: false);

  Future<void> _relink(String id, {required bool noticeIfRenamed}) async {
    final asset = _ref.read(projectDocumentProvider).mediaById(id);
    if (asset == null) return;
    final path = await _ref
        .read(projectFileServiceProvider)
        .pickFileOf(asset.kind);
    if (path == null) return;
    _ref.read(graphEditorProvider).relinkMedia(id, path);
    final name = fileNameOf(path);
    if (noticeIfRenamed && name.toLowerCase() != asset.fileName.toLowerCase()) {
      _notify(_t.notifyFileNameDiffers(name));
    }
  }

  Future<void> save() => _guard(() async {
    if (await _document.save() == FileOutcome.done) _notifySaved();
  });

  Future<void> saveAs() => _guard(() async {
    if (await _document.saveAs() == FileOutcome.done) _notifySaved();
  });

  Future<void> export() => _guard(() async {
    final result = await _document.export();
    if (result.outcome == FileOutcome.cancelled) return;
    _notify(
      result.issues.isEmpty
          ? _t.notifyExported(p.basename(result.path!))
          : result.issues.any((i) => i.type == ExportIssueType.invalidLogic)
          ? _t.notifyExportLogicIssues
          : result.issues.every((i) => i.type == ExportIssueType.singleChoice)
          ? _t.notifyExportSingleChoice
          : _t.notifyExportWarnings(result.issues.length),
    );
  });

  Future<void> exitApp() async {
    if (await _confirmDiscard()) exit(0);
  }

  void _notifySaved() =>
      _notify(_t.notifySaved(_ref.read(projectFileNameProvider) ?? ''));

  /// Runs a file action, turning its errors into notifications.
  Future<void> _guard(Future<void> Function() action) async {
    try {
      await action();
    } on ProjectIoException catch (e) {
      _notify(_t.notifyFileError(e.path));
    } on NfmvFormatException catch (e) {
      _notify(switch (e.reason) {
        NfmvReason.unsupportedOldVersion => _t.notifyOldProject,
        NfmvReason.unsupportedNewVersion => _t.notifyNewerProject,
        NfmvReason.invalidData => _t.notifyInvalidProject,
      });
    }
  }

  /// Whether the open project may be replaced or closed: `true` if it has
  /// no unsaved changes, or the user saved them (successfully) or chose not
  /// to; `false` if they cancelled.
  Future<bool> _confirmDiscard() async {
    if (!_ref.read(isDirtyProvider)) return true;
    final choice = await showNutriaChoiceDialog<_UnsavedChoice>(
      _context,
      message: _t.dialogUnsavedChanges,
      choices: [
        (
          value: _UnsavedChoice.cancel,
          label: _t.essentialsCancel,
          isAccented: false,
        ),
        (
          value: _UnsavedChoice.discard,
          label: _t.dialogDontSave,
          isAccented: false,
        ),
        (value: _UnsavedChoice.save, label: _t.dialogSave, isAccented: true),
      ],
    );
    if (!_context.mounted) return false;
    switch (choice) {
      case _UnsavedChoice.discard:
        return true;
      case _UnsavedChoice.save:
        var saved = false;
        await _guard(() async {
          saved = await _document.save() == FileOutcome.done;
          if (saved) _notifySaved();
        });
        return saved && _context.mounted;
      case _UnsavedChoice.cancel || null:
        return false;
    }
  }

  // ------------------------------------------------------------------- edit

  void undo() => _document.undo();
  void redo() => _document.redo();
  void disconnectSelection() =>
      _ref.read(graphEditorProvider).disconnectSelection();

  /// Renames the selected node in place (the first one, if several are).
  /// F2: renames the first selected node, or edits it if it's a comment.
  void renameSelected() {
    final selected = _ref.read(selectionProvider).selected;
    if (selected.isEmpty) return;
    final id = selected.first;
    if (_ref.read(projectDocumentProvider).nodes[id] is CommentNode) {
      _ref.read(editingCommentProvider.notifier).start(id);
    } else {
      _ref.read(renamingNodeProvider.notifier).start(id);
    }
  }

  /// Delete: the selected nodes, or in the Screens view the selected
  /// element.
  void deleteSelection() {
    if (_ref.read(editorViewProvider) == EditorView.screens) {
      final id = _ref.read(selectedScreenElementProvider);
      if (id != null) _ref.read(graphEditorProvider).removeScreenElement(id);
      return;
    }
    _ref.read(graphEditorProvider).removeSelection();
  }

  /// Shows the story graph or the screen designer (with its Design
  /// section).
  void showView(EditorView view) {
    _ref.read(editorViewProvider.notifier).show(view);
    if (view == EditorView.screens) {
      _ref
          .read(panelLayoutProvider.notifier)
          .showSection(LeftPanelSection.screen);
    }
  }

  /// Switches between the story graph and the screen designer.
  void toggleView() => showView(
    _ref.read(editorViewProvider) == EditorView.screens
        ? EditorView.graph
        : EditorView.screens,
  );

  Future<void> copy() => _ref.read(graphEditorProvider).copySelection();
  Future<void> cut() => _ref.read(graphEditorProvider).cutSelection();
  void duplicate() => _ref.read(graphEditorProvider).duplicateSelection();
  void selectAll() => _ref.read(graphEditorProvider).selectAll();
  void collapseAll() => _ref.read(graphEditorProvider).collapseAll();

  /// Pastes under the mouse if it's over the canvas, otherwise in the middle
  /// of the view.
  Future<void> paste() {
    final view = _ref.read(canvasViewProvider);
    return _ref.read(graphEditorProvider).paste(view.pointer ?? view.center);
  }

  void toggleGridSnapping() =>
      _ref.read(preferencesProvider.notifier).toggleGridSnapping();

  // ----------------------------------------------------------------- player

  /// The preview player, if a video is loaded in it.
  PreviewPlayer? get _loadedPlayer => _ref.read(previewIsPlayableProvider)
      ? _ref.read(previewPlayerProvider)
      : null;

  void playPause() => _loadedPlayer?.playOrPause();

  /// Jumps [by] forward (or back, if negative) in the previewed video.
  void seekBy(Duration by) {
    final player = _loadedPlayer;
    if (player != null) player.seek(player.status.value.position + by);
  }

  /// Changes the preview volume by [delta] percentage points.
  void changeVolume(double delta) {
    final player = _loadedPlayer;
    if (player == null) return;
    player.setVolume((player.status.value.volume + delta).clamp(0, 100));
  }

  // ------------------------------------------------------------------- view

  /// Moves the view one step in [direction] (e.g. `Offset(1, 0)` = right).
  void panCanvas(Offset direction) =>
      _ref.read(canvasViewProvider).panBy(-direction * kArrowPanStep);

  void zoomCanvas({required bool zoomIn}) =>
      _ref.read(canvasViewProvider).zoomCentered(zoomIn: zoomIn);

  /// Glides the view so every node is on screen.
  void frameAll() => frameNodes(
    _ref.read(canvasViewProvider),
    _ref.read(documentProvider).document,
    _ref.read(nodeBoundsProvider),
    animate: true,
  );

  /// Glides the view to the selected nodes (all nodes if none is selected).
  void frameSelected() {
    final selected = _ref.read(selectionProvider).selected;
    frameNodes(
      _ref.read(canvasViewProvider),
      _ref.read(documentProvider).document,
      _ref.read(nodeBoundsProvider),
      ids: selected.isEmpty ? null : selected,
      animate: true,
    );
  }

  void togglePanel(PanelSide side) => _ref
      .read(panelLayoutProvider.notifier)
      .toggle(side, MediaQuery.sizeOf(_context).width);

  void setLanguage(String code) =>
      _ref.read(preferencesProvider.notifier).setLanguage(code);

  void setTheme(ThemeChoice theme) =>
      _ref.read(preferencesProvider.notifier).setTheme(theme);

  // ------------------------------------------------------------------- help

  void showAbout() =>
      _ref.read(overlayProvider.notifier).showModal(AppModal.about);

  Future<void> openDocumentation() => launchUrl(kDocumentationUrl);
  Future<void> openGitHub() => launchUrl(kGitHubUrl);
}
