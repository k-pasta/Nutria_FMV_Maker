import 'package:flutter/material.dart';
import 'package:nutria_fmv_maker/models/enums_data.dart';
import 'package:nutria_fmv_maker/models/node_data/video_node_data.dart';
import 'package:nutria_fmv_maker/models/node_data/video_node_overrides.dart';
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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VideoOverride extends StatelessWidget {
  const VideoOverride({
    super.key,
    required this.videoNodeData,
    required this.nodeOverride,
  });

  final VideoNodeData videoNodeData;
  final VideoNodeOverride nodeOverride;

  bool get isLeftRight => nodeOverride is VideoNodeOverrideDoubleButton;

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().currentAppTheme;
    final nodesProvider = context.read<NodesProvider>();
    final t = AppLocalizations.of(context)!;

    final isOverridden = videoNodeData.overrides
        .any((o) => o.videoOverrideType == nodeOverride.videoOverrideType);

    final displayValue = nodeOverride.getOverrideValueString(t);

    return Row(
      children: [
        // LEFT SIDE (label + remove button)
        Expanded(
          child: SizedBox(
            height: theme.dButtonHeight,
            child: Row(
              children: [
                if (isOverridden)
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        nodesProvider.removeOverride(
                          videoNodeData.id,
                          nodeOverride.videoOverrideType,
                        );
                      },
                      child: SizedBox(
                        width: theme.dTextHeight + theme.dPanelPadding,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            Icons.close,
                            color: theme.cTextActive,
                            size: theme.dTextHeight,
                          ),
                        ),
                      ),
                    ),
                  ),
                Expanded(
                  child: NutriaText(
                    text: nodeOverride.getOverrideNameString(t),
                    state: isOverridden
                        ? NutriaTextState.accented
                        : NutriaTextState.normal,
                  ),
                ),
              ],
            ),
          ),
        ),

        // RIGHT SIDE (button)
        Expanded(
          child: switch (nodeOverride) {
            VideoNodeOverrideDoubleButton o => NutriaButton.leftRight(
                isAccented: isOverridden,
                onTapLeft: () => nodesProvider.addOverride(
                    videoNodeData.id, o.copyIteratedDownwards()),
                onTapRight: () => nodesProvider.addOverride(
                    videoNodeData.id, o.copyIteratedUpwards()),
                child: NutriaText(text: displayValue),
              ),
            VideoNodeOverrideSingleButton o => NutriaButton(
                isAccented: isOverridden,
                onTap: () => nodesProvider.addOverride(
                    videoNodeData.id, o.copySwitched()),
                child: NutriaText(text: displayValue),
              ),
          },
        )
      ],
    );
  }
}
