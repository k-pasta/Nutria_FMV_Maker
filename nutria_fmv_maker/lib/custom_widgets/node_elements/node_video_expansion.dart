import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nutria_fmv_maker/custom_widgets/nutria_button.dart';
import 'package:nutria_fmv_maker/models/node_data/video_node_overrides.dart';
import 'package:nutria_fmv_maker/providers/app_settings_provider.dart';
import 'package:nutria_fmv_maker/providers/nodes_provider.dart';
import 'package:nutria_fmv_maker/static_data/data_static_properties.dart';
import 'package:nutria_fmv_maker/static_data/ui_static_properties.dart';
import 'package:provider/provider.dart';

import '../../models/app_theme.dart';
import '../../models/enums_data.dart';
import '../../models/node_data/branched_video_node_data.dart';
import '../../models/node_data/video_node_data.dart';
import '../../providers/theme_provider.dart';
import '../nutria_text.dart';
import 'node_debug_info.dart';
import 'node_swatches_picker.dart';
import 'node_video_override.dart';
import 'dart:math';

class NodeVideoExpansion extends StatelessWidget {
  const NodeVideoExpansion.branched({
    super.key,
    required this.videoNodeData,
  }) : isBranched = true;

  const NodeVideoExpansion.simple({
    super.key,
    required this.videoNodeData,
  }) : isBranched = false;

  final VideoNodeData videoNodeData;
  final bool isBranched;

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().currentAppTheme;
    final settings = context.read<AppSettingsProvider>().currentVideoSettings;
    final nodesProvider = context.read<NodesProvider>();
    final t = AppLocalizations.of(context)!;

    final addOverride = nodesProvider.addOverride;
    final convert = nodesProvider.convertNode;

    final overrideTypes = isBranched
        ? [
            VideoOverrideType.selectionTime,
            VideoOverrideType.pauseOnEnd,
            VideoOverrideType.showTimer,
            VideoOverrideType.videoFit,
            VideoOverrideType.defaultSelection,
          ]
        : [
            VideoOverrideType.videoFit,
          ];

    final widgets = <Widget>[
      if (isBranched) _buildConvertButton(convert, t),
      ...overrideTypes.map((type) {
        final override = _getOverrideOrDefault(type, settings);

        return _buildOverrideTile(
          override: override,
          onChanged: (newOverride) =>
              addOverride(videoNodeData.id, newOverride),
          t: t,
        );
      }),
      _buildSwatchesPicker(),
      _buildDebugInfo(),
    ].expand((w) => [w, _buildSpacing(theme)]).toList()
      ..removeLast();

    return Column(children: widgets);
  }

  // --------------------------
  // 🧠 GENERIC OVERRIDE BUILDER
  // --------------------------

  Widget _buildOverrideTile({
    required VideoNodeOverride override,
    required void Function(VideoNodeOverride) onChanged,
    required AppLocalizations t,
  }) {
    return VideoOverride(
      videoNodeData: videoNodeData,
      nodeOverride: override,
    );
  }

  // --------------------------
  // 🔍 OVERRIDE RESOLUTION
  // --------------------------

  VideoNodeOverride _getOverrideOrDefault(
    VideoOverrideType type,
    List<VideoNodeOverride> defaults,
  ) {
    return videoNodeData.overrides.firstWhere(
      (o) => o.videoOverrideType == type,
      orElse: () => defaults.firstWhere((o) => o.videoOverrideType == type),
    );
  }

  // --------------------------
  // 🧩 UI HELPERS
  // --------------------------

  Widget _buildConvertButton(
    Function(String nodeId) convert,
    AppLocalizations t,
  ) {
    return SizedBox(
      width: double.infinity,
      child: NutriaButton(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: NutriaText(text: t.nodeConvertToSimple),
        ),
        onTap: () => convert(videoNodeData.id),
      ),
    );
  }

  Widget _buildSwatchesPicker() {
    return NodeSwatchesPicker(nodeData: videoNodeData);
  }

  Widget _buildDebugInfo() {
    return NodeDebugInfo(videoNodeData: videoNodeData);
  }

  Widget _buildSpacing(AppTheme theme) {
    return SizedBox(height: theme.dPanelPadding);
  }
}
