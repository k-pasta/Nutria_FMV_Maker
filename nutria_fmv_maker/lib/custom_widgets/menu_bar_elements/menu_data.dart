import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nutria_fmv_maker/providers/app_settings_provider.dart';
import 'package:nutria_fmv_maker/providers/theme_provider.dart';
import 'package:nutria_fmv_maker/providers/ui_state_provider.dart';
import 'nutria_menu_button.dart';
import 'package:flutter/services.dart';
import '../../providers/locale_provider.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class MenuData {
  static List<NutriaMenuButton> menuData(BuildContext context) {
    var t = AppLocalizations.of(context)!;
    return [
      NutriaMenuButton(
        //File
        title: t.menuBarFile,
        submenuButtons: [
          NutriaSubmenuButton(
            text: t.fileNewProject,
            shortcut: SingleActivator(LogicalKeyboardKey.keyN, control: true),
            function: () {
              debugPrint("New Project selected");
            },
            icon: Icons.create_new_folder,
          ),
          NutriaSubmenuButton(
            text: t.fileLoadProject,
            function: () => debugPrint("Open File selected"),
            shortcut: SingleActivator(LogicalKeyboardKey.keyO, control: true),
            icon: Icons.folder_open,
          ),
          NutriaSubmenuButton(
            text: t.fileRecentProjects,
            function: () => debugPrint("Save File selected"),
            icon: Icons.folder_open,
          ),
          NutriaSubmenuButton(
            text: t.fileSaveProject,
            function: () => debugPrint("Save File selected"),
            shortcut: SingleActivator(LogicalKeyboardKey.keyS, control: true),
            icon: Icons.save,
          ),
          NutriaSubmenuButton(
            text: t.fileSaveProjectAs,
            function: () => debugPrint("Save File selected"),
            shortcut: SingleActivator(LogicalKeyboardKey.keyS,
                control: true, shift: true),
            icon: Icons.save,
          ),
          NutriaSubmenuButton(
            text: t.fileExit,
            function: () {
              exit(0);
            },
            shortcut: SingleActivator(LogicalKeyboardKey.keyQ, control: true),
            icon: Icons.close,
          ),
        ],
      ),
      NutriaMenuButton(
        //Edit
        title: t.menuBarEdit,
        submenuButtons: [
          NutriaSubmenuButton(
            text: t.editUndo,
            function: () => debugPrint("Cut selected"),
            shortcut: SingleActivator(LogicalKeyboardKey.keyZ, control: true),
            icon: Icons.undo,
          ),
          NutriaSubmenuButton(
            text: t.editRedo,
            function: () => debugPrint("Copy selected"),
            shortcut: SingleActivator(LogicalKeyboardKey.keyZ,
                control: true, shift: true),
            icon: Icons.redo,
          ),
          NutriaSubmenuButton(
            text: 'toggle grid snapping',
            function: () { context
                        .read<AppSettingsProvider>()
                        .toggleSnapping();},
            shortcut: const SingleActivator(LogicalKeyboardKey.keyG,
                control: true),
            icon: Icons.grid_on_rounded,
          ),
          NutriaSubmenuButton(
            text: t.editProjectSettings,
            function: () => debugPrint("Paste selected"),
            icon: Icons.settings,
          ),
          NutriaSubmenuButton(
            text: t.editPreferences,
            function: () => debugPrint("Paste selected"),
            icon: Icons.settings,
          ),
        ],
      ),
      NutriaMenuButton(
        //View
        title: t.menuBarView,
        submenuButtons: [
          NutriaSubmenuButton(
              text: t.viewLanguage,
              function: () => debugPrint("Cut selected"),
              icon: Icons.language,
              submenuButtons: [
                //languages
                NutriaSubmenuButton(
                  text: 'English',
                  function: () {
                    context
                        .read<LocaleProvider>()
                        .changeLocale(const Locale('en'));
                  },
                  icon: context.read<LocaleProvider>().locale ==
                          const Locale('en')
                      ? Icons.check
                      : null,
                ),
                NutriaSubmenuButton(
                  text: 'Français',
                  function: () {
                    context
                        .read<LocaleProvider>()
                        .changeLocale(const Locale('fr'));
                  },
                  icon: context.read<LocaleProvider>().locale ==
                          const Locale('fr')
                      ? Icons.check
                      : null,
                ),
                NutriaSubmenuButton(
                  text: 'Ελληνικά',
                  function: () {
                    context
                        .read<LocaleProvider>()
                        .changeLocale(const Locale('el'));
                  },
                  icon: context.read<LocaleProvider>().locale ==
                          const Locale('el')
                      ? Icons.check
                      : null,
                ),
              ]),
          NutriaSubmenuButton(
              text: t.viewTheme,
              function: () => debugPrint("Copy selected"),
              icon: Icons.brush,
              submenuButtons: [
                NutriaSubmenuButton(
                  text: t.viewDarkTheme,
                  function: () {
                    context.read<ThemeProvider>().setTheme(ThemeType.dark);
                  },
                  icon: Icons.dark_mode,
                ),
                NutriaSubmenuButton(
                  text: t.viewLightTheme,
                  function: () {
                    context.read<ThemeProvider>().setTheme(ThemeType.light);
                  },
                  icon: Icons.light_mode,
                ),
                NutriaSubmenuButton(
                  text: t.viewCustomTheme,
                  function: () {
                    context.read<ThemeProvider>().setTheme(ThemeType.custom);
                  },
                  icon: Icons.question_mark,
                ),
              ]),
          NutriaSubmenuButton(
            text: t.viewProperties,
            function: () {
              print('tttttt');
              context
                  .read<UiStateProvider>()
                  .toggleLeft(MediaQuery.of(context).size.width);
            },
            shortcut: SingleActivator(LogicalKeyboardKey.keyT),
            icon: Icons.tab,
          ),
          NutriaSubmenuButton(
            text: t.viewVideoPlayer,
            function: () {
              print('nnnn');
              context
                  .read<UiStateProvider>()
                  .toggleRight(MediaQuery.of(context).size.width);
            },
            shortcut: SingleActivator(LogicalKeyboardKey.keyN),
            icon: Icons.tab,
          ),
        ],
      ),
      NutriaMenuButton(
        //Help
        title: t.menuBarHelp,
        submenuButtons: [
          NutriaSubmenuButton(
            text: t.helpAbout,
            function: () => debugPrint("Cut selected"),
            icon: Icons.info,
          ),
          NutriaSubmenuButton(
            text: t.helpDocumentation,
            function: () => debugPrint("Copy selected"),
            icon: Icons.link,
          ),
          NutriaSubmenuButton(
            text: t.helpGithub,
            function: () => debugPrint("Paste selected"),
            icon: Icons.link,
          ),
        ],
      ),
    ];
  }
}
