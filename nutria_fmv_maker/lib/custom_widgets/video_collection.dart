import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nutria_fmv_maker/custom_widgets/video_collection_elements/video_thumbnail.dart';
import 'package:nutria_fmv_maker/models/app_theme.dart';
import 'package:nutria_fmv_maker/providers/theme_provider.dart';
import 'package:nutria_fmv_maker/providers/video_player_provider.dart';
import 'package:nutria_fmv_maker/static_data/ui_static_properties.dart';
import 'package:provider/provider.dart';

import '../models/node_data.dart';
import '../providers/nodes_provider.dart';
import 'video_collection_elements/nutria_menu_dropdown.dart';
import 'video_collection_elements/video_collection_entry.dart';

class VideoCollection extends StatelessWidget {
  VideoCollection({super.key});
  final scrollController = ScrollController();

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
            child: RawScrollbar(
              controller: scrollController,
              thumbVisibility: true,
              scrollbarOrientation: ScrollbarOrientation.right,
              radius: Radius.circular(theme.dButtonBorderRadius),
              thumbColor: theme.cButtonPressed,
              trackColor: theme.cButton,
              trackVisibility: true,
              child: ScrollConfiguration(
                behavior:
                    ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: theme.dSectionPadding),
                  child: SingleChildScrollView(
                    clipBehavior: Clip.hardEdge,
                    controller: scrollController,
                    child: Wrap(
                        children: nodesProvider.videos
                            .map((video) =>
                                VideoCollectionEntry(videoDataId: video.id))
                            .toList()

                        // children: List.generate(
                        //   25,
                        //   (index) => const VideoCollectionEntry(),
                        // ),
                        ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}




