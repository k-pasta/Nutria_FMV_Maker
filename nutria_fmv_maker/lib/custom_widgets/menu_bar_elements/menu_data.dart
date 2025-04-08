import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nutria_fmv_maker/models/enums_data.dart';
import 'package:nutria_fmv_maker/providers/app_settings_provider.dart';
import 'package:nutria_fmv_maker/providers/nodes_provider.dart';
import 'package:nutria_fmv_maker/providers/project_version_provider.dart';
import 'package:nutria_fmv_maker/providers/theme_provider.dart';
import 'package:nutria_fmv_maker/providers/ui_state_provider.dart';
import 'package:nutria_fmv_maker/static_data/data_static_properties.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/enums_ui.dart';
import '../../models/node_data/branched_video_node_data.dart';
import '../../models/node_data/node_data.dart';
import '../../models/node_data/origin_node_data.dart';
import '../../models/node_data/simple_video_node_data.dart';
import '../../models/node_data/video_data.dart';
import '../../providers/notifications_provider.dart';
import '../../providers/video_player_provider.dart';
import 'nutria_menu_button.dart';
import 'package:flutter/services.dart';
import '../../providers/locale_provider.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class MenuData {
  static List<NutriaMenuButton> menuData(BuildContext context) {
    AppLocalizations t = AppLocalizations.of(context)!;
    final AppSettingsProvider appSettingsProvider =
        context.read<AppSettingsProvider>();
    final ProjectVersionProvider projectVersionProvider =
        context.read<ProjectVersionProvider>();
    final NotificationProvider notificationProvider =
        context.read<NotificationProvider>();
    final NodesProvider nodesProvider = context.read<NodesProvider>();
    final VideoPlayerProvider videoPlayerProvider =
        context.read<VideoPlayerProvider>();
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
            function: () {
              String serializedData = projectVersionProvider.makeSaveFile(
                  nodesProvider.nodes, nodesProvider.videos);
              if (projectVersionProvider.hasFileChanged(serializedData)) {
                notificationProvider.addNotification(
                    'Unsaved File: ${projectVersionProvider.currentSavePath ?? ''}');
              }

              projectVersionProvider.loadFile().then((jsonData) {
                // Directly assign the already parsed objects.
                List<NodeData> nodes =
                    (jsonData['nodes'] as List?)?.cast<NodeData>() ?? [];
                List<VideoData> videos =
                    (jsonData['videos'] as List?)?.cast<VideoData>() ?? [];
                LoadErrors? error = jsonData['error'] as LoadErrors?;
                // Check if both lists are empty.
                if (nodes.isEmpty && videos.isEmpty) {
                  jsonData['error'] =
                      LoadErrors.invalidData; // Set the error to fileEmpty.
                }
                if (error != null) {
                  switch (error) {
                    case LoadErrors.userCancelled:
                      notificationProvider
                          .addNotification('File loading cancelled by user.');
                      break;
                    case LoadErrors.invalidData:
                      notificationProvider
                          .addNotification('Invalid Save File.');
                      break;
                    default:
                      notificationProvider
                          .addNotification('Error Loading File.');
                  }
                  return;
                }

                // Replace nodes and videos if data is valid.
                nodesProvider.replaceNodesAndVideos(
                  nodes: nodes,
                  newVideos: videos,
                );
              }).catchError((e) {
                // Handle error if necessary.
                // notifyError("Error processing file: $e");
              });
            },
            shortcut: SingleActivator(LogicalKeyboardKey.keyO, control: true),
            icon: Icons.folder_open,
          ),
          // NutriaSubmenuButton(
          //   text: t.fileRecentProjects,
          //   function: () => debugPrint("Save File selected"),
          //   icon: Icons.folder_open,
          // ),
          NutriaSubmenuButton(
            text: t.fileSaveProject,
            function: () {
              String serializedData = projectVersionProvider.makeSaveFile(
                  nodesProvider.nodes, nodesProvider.videos);
              projectVersionProvider.saveFile(serializedData).then((_) {
                notificationProvider.addNotification(
                    'file saved at: ${projectVersionProvider.currentSavePath!}');
              });
            },
            shortcut: SingleActivator(LogicalKeyboardKey.keyS, control: true),
            icon: Icons.save,
          ),
          NutriaSubmenuButton(
            text: t.fileSaveProjectAs,
            function: () {
              String serializedData = projectVersionProvider.makeSaveFile(
                  nodesProvider.nodes, nodesProvider.videos);
              projectVersionProvider.saveFileAs(serializedData);
            },
            shortcut: SingleActivator(LogicalKeyboardKey.keyS,
                control: true, shift: true),
            icon: Icons.save,
          ),
          NutriaSubmenuButton(
            text: 'Export Project',
            function: () => projectVersionProvider.exportFile(
                nodesProvider.nodes, nodesProvider.videos),
            shortcut: SingleActivator(LogicalKeyboardKey.keyE, control: true),
            icon: Icons.arrow_forward,
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
          // NutriaSubmenuButton(
          //   text: t.editUndo,
          //   function: () => {
          //     Provider.of<NotificationProvider>(context, listen: false)
          //         .addNotification(
          //             "Something happened! Something happened! Something happened! Something happened! ")
          //   },
          //   shortcut: SingleActivator(LogicalKeyboardKey.keyZ, control: true),
          //   icon: Icons.undo,
          // ),
          // NutriaSubmenuButton(
          //   text: t.editRedo,
          //   function: () => debugPrint("Copy selected"),
          //   shortcut: SingleActivator(LogicalKeyboardKey.keyZ,
          //       control: true, shift: true),
          //   icon: Icons.redo,
          // ),
          NutriaSubmenuButton(
            // text: '',
            text: t.editDeleteSelectedNodes,
            function: () {
              debugPrint("Delete");
              List<NodeData> selectedList =
                  nodesProvider.nodes.where((nodedata) {
                return nodedata.isSelected;
              }).toList();

              for (var node in selectedList) {
                if (videoPlayerProvider.currentNodeId == node.id) {
                  videoPlayerProvider.unloadVideos();
                }
              }
              nodesProvider.removeSelected();
            },
            shortcut: SingleActivator(LogicalKeyboardKey.delete),
            icon: Icons.delete_forever,
          ),
          NutriaSubmenuButton(
            text: t.editToggleGridSnapping,
            function: () {
              context.read<AppSettingsProvider>().toggleSnapping();
            },
            shortcut:
                const SingleActivator(LogicalKeyboardKey.keyG, control: true),
            icon: Icons.grid_on_rounded,
          ),
          // NutriaSubmenuButton(
          //   text: t.editProjectSettings,
          //   function: () => debugPrint("Paste selected"),
          //   icon: Icons.settings,
          // ),
          // NutriaSubmenuButton(
          //   text: t.editPreferences,
          //   function: () => debugPrint("Paste selected"),
          //   icon: Icons.settings,
          // ),
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
              function: () {},
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
            function: () {
              context.read<UiStateProvider>().isModalInfoOpen = true;
            },
            icon: Icons.info,
          ),
          NutriaSubmenuButton(
            text: t.helpDocumentation,
            function: () {
              launchUrl(Uri.parse(DataStaticProperties.documentationPath));
            },
            icon: Icons.link,
          ),
          NutriaSubmenuButton(
            text: t.helpGithub,
            function: () {
              launchUrl(Uri.parse(DataStaticProperties.gitHubPath));
            },
            icon: Icons.link,
          ),
        ],
      ),
    ];
  }
}
