// The keyboard shortcut table. Menus show the same activators.
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:nutria_fmv_maker/app/app_commands.dart';
import 'package:nutria_fmv_maker/features/shell/providers/panel_layout_provider.dart';

const kShortcutNew = SingleActivator(LogicalKeyboardKey.keyN, control: true);
const kShortcutOpen = SingleActivator(LogicalKeyboardKey.keyO, control: true);
const kShortcutSave = SingleActivator(LogicalKeyboardKey.keyS, control: true);
const kShortcutSaveAs =
    SingleActivator(LogicalKeyboardKey.keyS, control: true, shift: true);
const kShortcutExport = SingleActivator(LogicalKeyboardKey.keyE, control: true);
const kShortcutExit = SingleActivator(LogicalKeyboardKey.keyQ, control: true);
const kShortcutUndo = SingleActivator(LogicalKeyboardKey.keyZ, control: true);
const kShortcutRedo = SingleActivator(LogicalKeyboardKey.keyY, control: true);
const kShortcutRedoAlt =
    SingleActivator(LogicalKeyboardKey.keyZ, control: true, shift: true);
const kShortcutDelete = SingleActivator(LogicalKeyboardKey.delete);
const kShortcutGridSnapping =
    SingleActivator(LogicalKeyboardKey.keyG, control: true);

/// Single-key shortcuts. `NutriaTextField` blocks these while typing.
const kShortcutLeftPanel = SingleActivator(LogicalKeyboardKey.keyT);
const kShortcutRightPanel = SingleActivator(LogicalKeyboardKey.keyN);
const kShortcutZoomIn = [
  SingleActivator(LogicalKeyboardKey.add),
  SingleActivator(LogicalKeyboardKey.numpadAdd),
  // "+" shares the "=" key on most layouts.
  SingleActivator(LogicalKeyboardKey.equal),
];
const kShortcutZoomOut = [
  SingleActivator(LogicalKeyboardKey.minus),
  SingleActivator(LogicalKeyboardKey.numpadSubtract),
];

/// Arrow keys pan the canvas. Text fields consume them while typing.
const kPanKeys = [
  (key: SingleActivator(LogicalKeyboardKey.arrowLeft), direction: Offset(-1, 0)),
  (key: SingleActivator(LogicalKeyboardKey.arrowRight), direction: Offset(1, 0)),
  (key: SingleActivator(LogicalKeyboardKey.arrowUp), direction: Offset(0, -1)),
  (key: SingleActivator(LogicalKeyboardKey.arrowDown), direction: Offset(0, 1)),
];

/// Key bindings for [commands].
Map<ShortcutActivator, VoidCallback> appShortcuts(AppCommands commands) => {
      kShortcutNew: commands.newProject,
      kShortcutOpen: commands.open,
      kShortcutSave: commands.save,
      kShortcutSaveAs: commands.saveAs,
      kShortcutExport: commands.export,
      kShortcutExit: commands.exitApp,
      kShortcutUndo: commands.undo,
      kShortcutRedo: commands.redo,
      kShortcutRedoAlt: commands.redo,
      kShortcutDelete: commands.deleteSelection,
      kShortcutGridSnapping: commands.toggleGridSnapping,
      kShortcutLeftPanel: () => commands.togglePanel(PanelSide.left),
      kShortcutRightPanel: () => commands.togglePanel(PanelSide.right),
      for (final key in kShortcutZoomIn)
        key: () => commands.zoomCanvas(zoomIn: true),
      for (final key in kShortcutZoomOut)
        key: () => commands.zoomCanvas(zoomIn: false),
      for (final (:key, :direction) in kPanKeys)
        key: () => commands.panCanvas(direction),
    };
