import 'dart:io';

// import 'package:file_selector/file_selector.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:nutria_fmv_maker/custom_widgets/nutria_button.dart';
import 'package:nutria_fmv_maker/models/app_theme.dart';
import 'package:nutria_fmv_maker/providers/theme_provider.dart';
import 'package:nutria_fmv_maker/providers/ui_state_provider.dart';
import 'package:nutria_fmv_maker/static_data/ui_static_properties.dart';
import 'package:nutria_fmv_maker/utilities/select_video.dart';
import 'package:provider/provider.dart';

import '../models/enums_ui.dart';
import '../providers/nodes_provider.dart';
import 'imported_videos_board.dart';
import 'nutria_text.dart';
import 'project_settings_board.dart';
import 'video_collection_elements/nutria_menu_dropdown.dart';
import 'video_collection_elements/video_collection_entry.dart';

class LeftSection extends StatelessWidget {
  const LeftSection({super.key});

  @override
  Widget build(BuildContext context) {
    final UiStateProvider uiStateProvider = context.read<UiStateProvider>();
    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;
    AppLocalizations t = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.only(top: theme.dSectionPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: theme.dSectionPadding,
                right: theme.dSectionPadding -
                            UiStaticProperties.splitViewDragWidgetSize >=
                        0
                    ? theme.dSectionPadding -
                        UiStaticProperties.splitViewDragWidgetSize
                    : 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                NutriaMenuDropdown(
                  options: [
                    DropdownOption(
                      icon: Icons.camera_roll,
                      text: t.boardImportedVideos,
                      onTap: () {
                        uiStateProvider.leftPanelSection =
                            LeftPanelSection.videos;
                      },
                    ),
                    // DropdownOption(
                    //   icon: Icons.list_alt,
                    //   text: t.boardVariables,
                    // ),
                    DropdownOption(
                      icon: Icons.tune,
                      text: t.boardProjectSettings,
                      onTap: () {
                        uiStateProvider.leftPanelSection =
                            LeftPanelSection.projectSettings;
                      },
                    ),
                    // DropdownOption(
                    //   icon: Icons.settings,
                    //   text: t.boardPreferences,
                    // ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: theme.dPanelPadding,
          ),
          Expanded(
            child: Selector<UiStateProvider, LeftPanelSection>(
              selector: (context, uiStateProvider) =>
                  uiStateProvider.leftPanelSection,
              builder: (context, leftPanelSection, child) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: leftPanelSection == LeftPanelSection.videos
                      ? ImportedVideosBoard()
                      : ProjectSettingsBoard(),
                );
              },
            ),
          ),
          // ImportedVideosBoard(),
        ],
      ),
    );
  }
}
