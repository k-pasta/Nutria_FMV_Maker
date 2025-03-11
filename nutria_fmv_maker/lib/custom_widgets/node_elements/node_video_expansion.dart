import 'package:flutter/material.dart';
import 'package:nutria_fmv_maker/custom_widgets/nutria_button.dart';
import 'package:nutria_fmv_maker/models/node_data.dart';
import 'package:provider/provider.dart';

import '../../models/app_theme.dart';
import '../../models/enums_data.dart';
import '../../providers/theme_provider.dart';
import '../nutria_text.dart';
import 'node_debug_info.dart';
import 'node_swatches_picker.dart';
import 'node_video_override.dart';

class NodeVideoExpansion extends StatelessWidget {
  const NodeVideoExpansion({super.key, required this.videoNodeData});

  final VideoNodeData videoNodeData;

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;

    final List<Widget> widgets = [
      _buildConvertButton(),
      _buildSelectionTimeOverride(),
      _buildPauseOnEndOverride(),
      _buildShowTimerOverride(),
      _buildVideoFitOverride(),
      _buildDefaultSelectionOverride(),
      _buildPauseMusicOverride(),
      _buildSwatchesPicker(),
      _buildDebugInfo(),
    ].expand((widget) => [widget, _buildSpacing(theme)]).toList();

    widgets.removeLast(); // Remove trailing spacing

    return Column(children: widgets);
  }

  Widget _buildConvertButton() {
    return SizedBox(
      width: double.infinity,
      child: NutriaButton(
        child: NutriaText(text: 'convert to simple video node'),
        onTap: () {},
      ),
    );
  }

  Widget _buildSelectionTimeOverride() {
    return VideoOverride.leftRight(
      videoNodeData: videoNodeData,
      labelText: 'Selection Time',
      onTapLeft: () {},
      onTapRight: () {},
      videoOverride: VideoOverrides.selectionTime,
    );
  }

  Widget _buildPauseOnEndOverride() {
    return VideoOverride(
      videoNodeData: videoNodeData,
      labelText: 'Pause on end',
      onTap: () {},
      videoOverride: VideoOverrides.pauseOnEnd,
    );
  }

  Widget _buildShowTimerOverride() {
    return VideoOverride(
      videoNodeData: videoNodeData,
      labelText: 'Show timer',
      onTap: () {},
      videoOverride: VideoOverrides.showTimer,
    );
  }

  Widget _buildVideoFitOverride() {
    return VideoOverride.leftRight(
      videoNodeData: videoNodeData,
      labelText: 'Video Fit',
      onTapLeft: () {},
      onTapRight: () {},
      videoOverride: VideoOverrides.videoFit,
    );
  }

  Widget _buildDefaultSelectionOverride() {
    return VideoOverride.leftRight(
      videoNodeData: videoNodeData,
      labelText: 'Default selection',
      onTapLeft: () {},
      onTapRight: () {},
      videoOverride: VideoOverrides.defaultSelection,
    );
  }

  Widget _buildPauseMusicOverride() {
    return VideoOverride(
      videoNodeData: videoNodeData,
      labelText: 'Pause music',
      onTap: () {},
      videoOverride: VideoOverrides.pauseMusicPath,
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
