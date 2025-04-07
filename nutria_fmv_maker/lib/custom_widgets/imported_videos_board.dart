import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_theme.dart';
import '../providers/nodes_provider.dart';
import '../providers/theme_provider.dart';
import '../utilities/select_video.dart';
import 'nutria_button.dart';
import 'video_collection_elements/video_collection_entry.dart';

class ImportedVideosBoard extends StatelessWidget {
  ImportedVideosBoard({
    super.key,
  });
  final scrollController = ScrollController(); //TODO move to UIprovider

  @override
  Widget build(BuildContext context) {
    final NodesProvider nodesProvider = context.read<NodesProvider>();
    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;

    return Stack(children: [
      SizedBox(
        width: double.infinity,
        height: double.infinity,
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
              behavior:
                  ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: theme.dSectionPadding),
                child: SingleChildScrollView(
                  clipBehavior: Clip.hardEdge,
                  controller: scrollController,
                  child: Selector<NodesProvider, List<String>>(
                    selector: (context, provider) => provider.videoDataIds,
                    builder: (BuildContext context, value, Widget? child) {
                      return Wrap(
                          children: nodesProvider.videos
                              .map((video) =>
                                  VideoCollectionEntry(videoDataId: video.id))
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
    ]);
  }
}
