// The menu bar contents: File, Edit, View, Help.
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/app/app_commands.dart';
import 'package:nutria_fmv_maker/app/app_shortcuts.dart';
import 'package:nutria_fmv_maker/features/preferences/providers/preferences_provider.dart';
import 'package:nutria_fmv_maker/features/shell/providers/panel_layout_provider.dart';
import 'package:nutria_fmv_maker/l10n/generated/app_localizations.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_menu_bar.dart';


/// Builds the menus. [canUndo]/[canRedo] grey out Undo/Redo; [preferences]
/// marks the current language and theme.
List<NutriaMenu> buildAppMenus({
  required AppCommands commands,
  required AppLocalizations t,
  required Preferences preferences,
  required bool canUndo,
  required bool canRedo,
}) =>
    [
      NutriaMenu(title: t.menuBarFile, entries: [
        NutriaMenuEntry(
            label: t.fileNewProject,
            icon: Icons.create_new_folder,
            shortcut: kShortcutNew,
            onPressed: commands.newProject),
        NutriaMenuEntry(
            label: t.fileLoadProject,
            icon: Icons.folder_open,
            shortcut: kShortcutOpen,
            onPressed: commands.open),
        NutriaMenuEntry(
            label: t.fileSaveProject,
            icon: Icons.save,
            shortcut: kShortcutSave,
            onPressed: commands.save),
        NutriaMenuEntry(
            label: t.fileSaveProjectAs,
            icon: Icons.save,
            shortcut: kShortcutSaveAs,
            onPressed: commands.saveAs),
        NutriaMenuEntry(
            label: t.fileExportProject,
            icon: Icons.arrow_forward,
            shortcut: kShortcutExport,
            onPressed: commands.export),
        NutriaMenuEntry(
            label: t.fileExit,
            icon: Icons.close,
            shortcut: kShortcutExit,
            onPressed: commands.exitApp),
      ]),
      NutriaMenu(title: t.menuBarEdit, entries: [
        NutriaMenuEntry(
            label: t.editUndo,
            icon: Icons.undo,
            shortcut: kShortcutUndo,
            onPressed: canUndo ? commands.undo : null),
        NutriaMenuEntry(
            label: t.editRedo,
            icon: Icons.redo,
            shortcut: kShortcutRedo,
            onPressed: canRedo ? commands.redo : null),
        NutriaMenuEntry(
            label: t.editDeleteSelectedNodes,
            icon: Icons.delete_forever,
            shortcut: kShortcutDelete,
            onPressed: commands.deleteSelection),
        NutriaMenuEntry(
            label: t.editToggleGridSnapping,
            icon: preferences.gridSnapping ? Icons.check : Icons.grid_on_rounded,
            shortcut: kShortcutGridSnapping,
            onPressed: commands.toggleGridSnapping),
      ]),
      NutriaMenu(title: t.menuBarView, entries: [
        NutriaMenuEntry(label: t.viewLanguage, icon: Icons.language, children: [
          for (final MapEntry(key: code, value: name) in kLanguageNames.entries)
            NutriaMenuEntry(
              label: name,
              icon: preferences.languageCode == code ? Icons.check : null,
              onPressed: () => commands.setLanguage(code),
            ),
        ]),
        NutriaMenuEntry(label: t.viewTheme, icon: Icons.brush, children: [
          for (final (choice, label, icon) in [
            (ThemeChoice.dark, t.viewDarkTheme, Icons.dark_mode),
            (ThemeChoice.light, t.viewLightTheme, Icons.light_mode),
            (ThemeChoice.custom, t.viewCustomTheme, Icons.question_mark),
          ])
            NutriaMenuEntry(
              label: label,
              icon: preferences.theme == choice ? Icons.check : icon,
              onPressed: () => commands.setTheme(choice),
            ),
        ]),
        NutriaMenuEntry(
            label: t.viewProperties,
            icon: Icons.tab,
            shortcut: kShortcutLeftPanel,
            onPressed: () => commands.togglePanel(PanelSide.left)),
        NutriaMenuEntry(
            label: t.viewVideoPlayer,
            icon: Icons.tab,
            shortcut: kShortcutRightPanel,
            onPressed: () => commands.togglePanel(PanelSide.right)),
      ]),
      NutriaMenu(title: t.menuBarHelp, entries: [
        NutriaMenuEntry(
            label: t.helpAbout, icon: Icons.info, onPressed: commands.showAbout),
        NutriaMenuEntry(
            label: t.helpDocumentation,
            icon: Icons.link,
            onPressed: commands.openDocumentation),
        NutriaMenuEntry(
            label: t.helpGithub, icon: Icons.link, onPressed: commands.openGitHub),
      ]),
    ];
