// Every app-level command (menus, shortcuts), with its user feedback.
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/app/app_info.dart';
import 'package:nutria_fmv_maker/core/serialization/nfmv_codec.dart';
import 'package:nutria_fmv_maker/features/canvas/canvas_framing.dart';
import 'package:nutria_fmv_maker/features/canvas/providers/canvas_view_provider.dart';
import 'package:nutria_fmv_maker/features/nodes/node_bounds.dart';
import 'package:nutria_fmv_maker/features/preferences/providers/preferences_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_provider.dart';
import 'package:nutria_fmv_maker/features/project/providers/document_selectors.dart';
import 'package:nutria_fmv_maker/features/project/providers/graph_editor.dart';
import 'package:nutria_fmv_maker/features/selection/providers/selection_provider.dart';
import 'package:nutria_fmv_maker/features/shell/providers/notifications_provider.dart';
import 'package:nutria_fmv_maker/features/shell/providers/overlay_provider.dart';
import 'package:nutria_fmv_maker/features/shell/providers/panel_layout_provider.dart';
import 'package:nutria_fmv_maker/features/video_preview/providers/video_preview_provider.dart';
import 'package:nutria_fmv_maker/l10n/generated/app_localizations.dart';
import 'package:nutria_fmv_maker/services/project_file_service.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_confirm_dialog.dart';
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
        if (await _confirmDiscard()) await _document.open();
      });

  Future<void> save() => _guard(() async {
        if (await _document.save() == FileOutcome.done) _notifySaved();
      });

  Future<void> saveAs() => _guard(() async {
        if (await _document.saveAs() == FileOutcome.done) _notifySaved();
      });

  Future<void> export() => _guard(() async {
        final result = await _document.export();
        if (result.outcome == FileOutcome.cancelled) return;
        _notify(result.issues.isEmpty
            ? _t.notifyExported(p.basename(result.path!))
            : _t.notifyExportWarnings(result.issues.length));
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
        (value: _UnsavedChoice.cancel, label: _t.essentialsCancel,
            isAccented: false),
        (value: _UnsavedChoice.discard, label: _t.dialogDontSave,
            isAccented: false),
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
  void deleteSelection() => _ref.read(graphEditorProvider).removeSelection();
  Future<void> copy() => _ref.read(graphEditorProvider).copySelection();
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
  PreviewPlayer? get _loadedPlayer => _ref.read(videoPreviewProvider) == null
      ? null
      : _ref.read(previewPlayerProvider);

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
  void frameAll() => frameNodes(_ref.read(canvasViewProvider),
      _ref.read(documentProvider).document, _ref.read(nodeBoundsProvider),
      animate: true);

  /// Glides the view to the selected nodes (all nodes if none is selected).
  void frameSelected() {
    final selected = _ref.read(selectionProvider).selected;
    frameNodes(_ref.read(canvasViewProvider),
        _ref.read(documentProvider).document, _ref.read(nodeBoundsProvider),
        ids: selected.isEmpty ? null : selected, animate: true);
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
