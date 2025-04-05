import 'dart:io';

// import 'package:file_selector/file_selector.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:nutria_fmv_maker/custom_widgets/nutria_button.dart';
import 'package:nutria_fmv_maker/models/app_theme.dart';
import 'package:nutria_fmv_maker/providers/theme_provider.dart';
import 'package:nutria_fmv_maker/static_data/ui_static_properties.dart';
import 'package:nutria_fmv_maker/utilities/select_video.dart';
import 'package:provider/provider.dart';

import '../providers/nodes_provider.dart';
import 'video_collection_elements/nutria_menu_dropdown.dart';
import 'video_collection_elements/video_collection_entry.dart';

class VideoCollection extends StatelessWidget {
  VideoCollection({super.key});
  final scrollController = ScrollController(); //TODO move to UIprovider



  @override
  Widget build(BuildContext context) {
    final NodesProvider nodesProvider = context.read<NodesProvider>();
    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;

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
                        icon: Icons.camera_roll, text: 'Imported Videos'),
                    DropdownOption(icon: Icons.list_alt, text: 'Variables'),
                    DropdownOption(icon: Icons.tune, text: 'Project Settings'),
                    DropdownOption(icon: Icons.settings, text: 'Preferences'),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: theme.dPanelPadding,
          ),
          Expanded(
            child: Stack(children: [
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: theme.dButtonHeight +
                          theme.dSectionPadding +
                          theme.dPanelPadding),
                  child: RawScrollbar(
                    controller: scrollController,
                    thumbVisibility: true,
                    scrollbarOrientation: ScrollbarOrientation.right,
                    radius: Radius.circular(theme.dButtonBorderRadius),
                    thumbColor: theme.cButtonPressed,
                    trackColor: theme.cButton,
                    trackVisibility: true,
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context)
                          .copyWith(scrollbars: false),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: theme.dSectionPadding),
                        child: SingleChildScrollView(
                          clipBehavior: Clip.hardEdge,
                          controller: scrollController,
                          child: Selector<NodesProvider, List<String>>(
                            selector: (context, provider) =>
                                provider.videoDataIds,
                            builder:
                                (BuildContext context, value, Widget? child) {
                              return Wrap(
                                  children: nodesProvider.videos
                                      .map((video) => VideoCollectionEntry(
                                          videoDataId: video.id))
                                      .toList());
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: theme.dSectionPadding,
                child: NutriaButton.Icon(
                  onTap: () {
                    selectVideos().then((paths) {
                      if (paths == null) return;

                      for (var path in paths) {
                        nodesProvider.addVideo(path);
                      }
                    });
                  },
                  icon: Icons.add,
                  isAccented: true,
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
