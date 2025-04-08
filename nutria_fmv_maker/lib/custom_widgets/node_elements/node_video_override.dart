import 'package:flutter/material.dart';
import 'package:nutria_fmv_maker/models/enums_data.dart';
import 'package:nutria_fmv_maker/models/node_data/video_node_data.dart';
import '../../models/enums_ui.dart';
import '../../models/node_data/branched_video_node_data.dart';
import '../../models/node_data/node_data.dart';
import '../../models/app_theme.dart';

import '../../providers/app_settings_provider.dart';
import '../../providers/nodes_provider.dart';
import 'package:provider/provider.dart';
import '../../../providers/theme_provider.dart';
import '../nutria_button.dart';
import '../nutria_text.dart';

class VideoOverride extends StatelessWidget {
  const VideoOverride.leftRight({
    super.key,
    required this.videoNodeData,
    required this.videoOverride,
    required this.onTapLeft,
    required this.onTapRight,
    required this.labelText,
  })  : isLeftRight = true,
        onTap = _defaultOnTap;
  // isParent = false;

  const VideoOverride({
    super.key,
    required this.videoNodeData,
    required this.videoOverride,
    required this.onTap,
    required this.labelText,
  })  : isLeftRight = false,
        onTapLeft = _defaultOnTap,
        onTapRight = _defaultOnTap;
  // isParent = false;

  // const VideoOverride.parent({
  //   super.key,
  //   required this.videoNodeData,
  //   required this.labelText,
  // })  : isLeftRight = false,
  //       videoOverride = VideoOverrides.selectionTime, //todo make more readable
  //       onTap = _defaultOnTap,
  //       onTapLeft = _defaultOnTap,
  //       onTapRight = _defaultOnTap,
  //       isParent = true;

  static void _defaultOnTap() {}

  final String labelText;
  final bool isLeftRight;
  final VoidCallback onTapLeft;
  final VoidCallback onTapRight;
  final VoidCallback onTap;
  final VideoNodeData videoNodeData;
  final VideoOverrides videoOverride;
  // final bool isParent;

  @override
  Widget build(BuildContext context) {
    final AppSettingsProvider appSettingsProvider =
        context.read<AppSettingsProvider>();

    final NodesProvider nodesProvider = context.read<NodesProvider>();

    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;

    final String key = videoOverride.name;
    final bool isOverriden = videoNodeData.overrides.containsKey(key);

    return Selector<AppSettingsProvider, Map<VideoOverrides, dynamic>>(
      selector: (context, provider) => provider.currentVideoSettings,
      builder: (context, settings, child) {
        
        final String data = isOverriden
            ? getOverrideString(key, videoNodeData.overrides[key])
            : getOverrideString(
                key, appSettingsProvider.currentVideoSettings[videoOverride]);

        return Row(
          children: [
            Expanded(
              child: SizedBox(
                height: theme.dButtonHeight,
                child: Row(children: [
                  if (isOverriden)
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          nodesProvider.removeOverride(videoNodeData.id, key);
                        },
                        child: Container(
                          color: Colors.transparent,
                          child: SizedBox(
                            width: theme.dTextHeight + theme.dPanelPadding,
                            child: Align(
                              alignment: Alignment
                                  .centerLeft, // Align the icon to the left
                              child: Icon(
                                Icons.close,
                                color: theme.cTextActive,
                                size: theme.dTextHeight,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  Expanded(
                    child: NutriaText(
                      text: labelText,
                      state: isOverriden
                          ? NutriaTextState.accented
                          : NutriaTextState.normal,
                    ),
                  ),
                ]),
              ),
            ),
            Expanded(
              child: isLeftRight
                  ? NutriaButton.leftRight(
                      isAccented: isOverriden,
                      onTapLeft: onTapLeft,
                      onTapRight: onTapRight,
                      child: NutriaText(text: data),
                    )
                  : NutriaButton(
                      isAccented: isOverriden,
                      onTap: onTap,
                      child: NutriaText(text: data),
                    ),
            ),
          ],
        );
      },
    );
  }
}
