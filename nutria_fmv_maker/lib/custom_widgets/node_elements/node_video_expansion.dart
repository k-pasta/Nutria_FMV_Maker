import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nutria_fmv_maker/custom_widgets/nutria_button.dart';
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
  const NodeVideoExpansion.branched({super.key, required this.videoNodeData}) : isBranched = true;
  const NodeVideoExpansion.simple({super.key, required this.videoNodeData}) : isBranched = false;
  final VideoNodeData videoNodeData;
  final bool isBranched;

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;
    final AppSettingsProvider appSettingsProvider =
        context.read<AppSettingsProvider>(); //TODO check if updates
    final Map<VideoOverrides, dynamic> settings =
        appSettingsProvider.currentVideoSettings;
    final NodesProvider nodesProvider = context.read<NodesProvider>();
    final void Function(String nodeId, String key, dynamic value) addOverride =
        nodesProvider.addOverride;
    final void Function(String nodeId) convert = nodesProvider.convertNode;
        final AppLocalizations t = AppLocalizations.of(context)!;

if (isBranched){
final List<Widget> branchedWidgets = [
      _buildConvertButton(convert, t),
      _buildSelectionTimeOverride(settings, addOverride, t),
      _buildPauseOnEndOverride(settings, addOverride, t),
      _buildShowTimerOverride(settings, addOverride, t),
      _buildVideoFitOverride(settings, addOverride, t),
      _buildDefaultSelectionOverride(settings, addOverride, t),
      // _buildPauseMusicOverride(settings, addOverride),
      _buildSwatchesPicker(),
      _buildDebugInfo(),
    ].expand((widget) => [widget, _buildSpacing(theme)]).toList();
    branchedWidgets.removeLast(); // Remove trailing spacing
    return Column(children: branchedWidgets);
} else {
  final List<Widget> simpleWidgets = [
      _buildVideoFitOverride(settings, addOverride, t),
      _buildSwatchesPicker(),
      _buildDebugInfo(),
    ].expand((widget) => [widget, _buildSpacing(theme)]).toList();
     simpleWidgets.removeLast(); // Remove trailing spacing
    return Column(children: simpleWidgets);
}

    

  


  }

// class NodeSimpleVideoExpansion extends StatelessWidget {
//   const NodeSimpleVideoExpansion({super.key, required this.videoNodeData});

//   final BranchedVideoNodeData videoNodeData;

//   @override
//   Widget build(BuildContext context) {
//     final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;
//     final AppSettingsProvider appSettingsProvider =
//         context.read<AppSettingsProvider>(); //TODO check if updates
//     final Map<VideoOverrides, dynamic> settings =
//         appSettingsProvider.currentVideoSettings;
//     final NodesProvider nodesProvider = context.read<NodesProvider>();
//     final void Function(String nodeId, String key, dynamic value) addOverride =
//         nodesProvider.addOverride;
//     final void Function(String nodeId) convert = nodesProvider.convertNode;

//     final List<Widget> widgets = [
//       _buildConvertButton(convert),
//       _buildSelectionTimeOverride(settings, addOverride),
//       _buildPauseOnEndOverride(settings, addOverride),
//       _buildShowTimerOverride(settings, addOverride),
//       _buildVideoFitOverride(settings, addOverride),
//       _buildDefaultSelectionOverride(settings, addOverride),
//       _buildPauseMusicOverride(settings, addOverride),
//       _buildSwatchesPicker(),
//       _buildDebugInfo(),
//     ].expand((widget) => [widget, _buildSpacing(theme)]).toList();

//     widgets.removeLast(); // Remove trailing spacing

//     return Column(children: widgets);
//   }

  Widget _buildConvertButton(Function(String nodeId) convert, AppLocalizations t) {
    return SizedBox(
      width: double.infinity,
      child: NutriaButton(
        child: Padding(padding: EdgeInsets.symmetric(horizontal: 8) ,child: NutriaText(text: t.nodeConvertToSimple )), //TODO get theme
        onTap: () {
          convert(videoNodeData.id);
        },
      ),
    );
  }

  Widget _buildSelectionTimeOverride(Map<VideoOverrides, dynamic> settings,
      void Function(String nodeId, String key, dynamic value) addOverride, AppLocalizations t) {
    final String key = getVideoOverrideKey(VideoOverrides.selectionTime);

    void _updateSelectionTime(
        Map<VideoOverrides, dynamic> settings,
        void Function(String nodeId, String key, dynamic value) addOverride,
        int interval) {
      final String key = getVideoOverrideKey(VideoOverrides.selectionTime);
      final currentOverride = videoNodeData.overrides[key];
      final int newDurationInMilliseconds = (currentOverride != null
              ? (currentOverride as Duration).inMilliseconds + interval
              : (settings[VideoOverrides.selectionTime] as Duration)
                      .inMilliseconds +
                  interval)
          .clamp(0, DataStaticProperties.maxSelectionTimeInMs)
          .toInt();
      final newDuration = Duration(milliseconds: newDurationInMilliseconds);
      addOverride(videoNodeData.id, key, newDuration);
    }

    return VideoOverride.leftRight(
      videoNodeData: videoNodeData,
      labelText: t.overrideSelectionTime,
      onTapLeft: () => _updateSelectionTime(
          settings, addOverride, -DataStaticProperties.intervalInMs),
      onTapRight: () => _updateSelectionTime(
          settings, addOverride, DataStaticProperties.intervalInMs),
      videoOverride: VideoOverrides.selectionTime,
    );
  }

  Widget _buildPauseOnEndOverride(Map<VideoOverrides, dynamic> settings,
      void Function(String nodeId, String key, dynamic value) addOverride, AppLocalizations t) {
    return VideoOverride(
      videoNodeData: videoNodeData,
      labelText: t.overridePauseOnEnd,
      onTap: () {
        final String key = getVideoOverrideKey(VideoOverrides.pauseOnEnd);
        final currentOverride = videoNodeData.overrides[key];
        final newValue =
            !(currentOverride ?? settings[VideoOverrides.pauseOnEnd] as bool);
        addOverride(videoNodeData.id, key, newValue);
      },
      videoOverride: VideoOverrides.pauseOnEnd,
    );
  }

  Widget _buildShowTimerOverride(Map<VideoOverrides, dynamic> settings,
      void Function(String nodeId, String key, dynamic value) addOverride, AppLocalizations t) {
    return VideoOverride(
      videoNodeData: videoNodeData,
      labelText: t.overrideShowTimer,
      onTap: () {
        final String key = getVideoOverrideKey(VideoOverrides.showTimer);
        final currentOverride = videoNodeData.overrides[key];
        final newValue =
            !(currentOverride ?? settings[VideoOverrides.showTimer] as bool);
        addOverride(videoNodeData.id, key, newValue);
      },
      videoOverride: VideoOverrides.showTimer,
    );
  }

  Widget _buildVideoFitOverride(Map<VideoOverrides, dynamic> settings,
      void Function(String nodeId, String key, dynamic value) addOverride, AppLocalizations t) {
    final String key = getVideoOverrideKey(VideoOverrides.videoFit);

    void _updateVideoFit(
        Map<VideoOverrides, dynamic> settings,
        void Function(String nodeId, String key, dynamic value) addOverride,
        bool isNext) {
      final currentOverride = videoNodeData.overrides[key];

      final VideoFit currentFit = currentOverride != null
          ? VideoFit.values.byName((currentOverride as VideoFit).name)
          : settings[VideoOverrides.videoFit] as VideoFit;

      final int currentIndex = VideoFit.values.indexOf(currentFit);
      final int newIndex =
          (currentIndex + (isNext ? 1 : -1)) % VideoFit.values.length;

      // negative index handling
      final VideoFit newFit = VideoFit
          .values[newIndex < 0 ? VideoFit.values.length + newIndex : newIndex];

      // Pass the actual enum, not the name
      addOverride(videoNodeData.id, key, newFit);
    }

    return VideoOverride.leftRight(
      videoNodeData: videoNodeData,
      labelText: t.overrideVideoFit,
      onTapLeft: () => _updateVideoFit(settings, addOverride, false),
      onTapRight: () => _updateVideoFit(settings, addOverride, true),
      videoOverride: VideoOverrides.videoFit,
    );
  }

  Widget _buildDefaultSelectionOverride(Map<VideoOverrides, dynamic> settings,
      void Function(String nodeId, String key, dynamic value) addOverride, AppLocalizations t) {
    final String key = getVideoOverrideKey(VideoOverrides.defaultSelection);

    void _updateDefaultSelection(
        Map<VideoOverrides, dynamic> settings,
        void Function(String nodeId, String key, dynamic value) addOverride,
        bool isNext) {
      final currentOverride = videoNodeData.overrides[key];

      final DefaultSelectionMethod currentMethod = currentOverride != null
          ? DefaultSelectionMethod.values
              .byName((currentOverride as DefaultSelectionMethod).name)
          : settings[VideoOverrides.defaultSelection] as DefaultSelectionMethod;

      final int currentIndex =
          DefaultSelectionMethod.values.indexOf(currentMethod);
      final int newIndex = (currentIndex + (isNext ? 1 : -1)) %
          DefaultSelectionMethod.values.length;

      // negative index handling
      final DefaultSelectionMethod newMethod = DefaultSelectionMethod.values[
          newIndex < 0
              ? DefaultSelectionMethod.values.length + newIndex
              : newIndex];

      // Pass the actual enum, not the name
      addOverride(videoNodeData.id, key, newMethod);
    }

    return VideoOverride.leftRight(
      videoNodeData: videoNodeData,
      labelText: t.overrideDefaultSelection,
      onTapLeft: () => _updateDefaultSelection(settings, addOverride, false),
      onTapRight: () => _updateDefaultSelection(settings, addOverride, true),
      videoOverride: VideoOverrides.defaultSelection,
    );
  }

  Widget _buildPauseMusicOverride(Map<VideoOverrides, dynamic> settings,
      void Function(String nodeId, String key, dynamic value) addOverride, AppLocalizations t) {
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
