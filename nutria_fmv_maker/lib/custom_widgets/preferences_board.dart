import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nutria_fmv_maker/custom_widgets/board_video_override.dart';
import 'package:nutria_fmv_maker/models/node_data/video_node_overrides.dart';
import 'package:nutria_fmv_maker/providers/app_settings_provider.dart';
import 'package:nutria_fmv_maker/static_data/data_static_properties.dart';
import 'package:provider/provider.dart';

import '../models/app_theme.dart';
import '../models/enums_data.dart';
import '../models/enums_ui.dart';
import '../providers/nodes_provider.dart';
import '../providers/theme_provider.dart';
import 'nutria_text.dart';

class PreferencesBoard extends StatelessWidget {
  PreferencesBoard({super.key});
  final scrollController = ScrollController(); //TODO move to UIprovider
  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Padding(
        padding: EdgeInsets.only(left: theme.dTextfieldPadding),
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
              padding: EdgeInsets.symmetric(horizontal: theme.dSectionPadding),
              child: SingleChildScrollView(
                clipBehavior: Clip.hardEdge,
                controller: scrollController, 
                //TODO verify if updates
                child: Selector<AppSettingsProvider, List<Object>>(
                  selector: (context, provider) => provider.currentVideoSettings
                      .map((o) => o.jsonValue)
                      .toList(),
                  builder: (BuildContext context, currentVideoSettings,
                      Widget? child) {
                    return ProjectSettingsBoardList();
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProjectSettingsBoardList extends StatelessWidget {
  const ProjectSettingsBoardList({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations t = AppLocalizations.of(context)!;
    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;
    final AppSettingsProvider appSettingsProvider =
        context.read<AppSettingsProvider>();

    final Map<VideoOverrideType, dynamic> settings =
        appSettingsProvider.currentVideoSettings;
    final void Function(VideoOverrideType key, dynamic value) editSetting =
        appSettingsProvider.updateVideoSetting;

    final List<Widget> branchedWidgets = [
      _buildSnappingToggleSetting(settings, editSetting, t),
      _buildPauseOnEndSetting(settings, editSetting, t),
      _buildShowTimerSetting(settings, editSetting, t),
      _buildVideoFitSetting(settings, editSetting, t),
      _buildDefaultSelectionSetting(settings, editSetting, t),
    ].expand((widget) => [widget, _buildSpacing(theme)]).toList();
    branchedWidgets.removeLast(); // Remove trailing spacing
    return Column(children: branchedWidgets);
  }

  Widget _buildSpacing(AppTheme theme) {
    return SizedBox(height: theme.dPanelPadding);
  }

  Widget _buildSnappingToggleSetting(
      Map<VideoOverrideType, dynamic> settings,
      Function(VideoOverrideType key, dynamic value) editSetting,
      AppLocalizations t) {
    final currentSetting = settings[VideoOverrideType.selectionTime];
    print(currentSetting);
    final Duration durationUp = Duration(
        milliseconds: ((currentSetting as Duration).inMilliseconds +
                DataStaticProperties.intervalInMs)
            .clamp(0, DataStaticProperties.maxSelectionTimeInMs)
            .toInt());
    final Duration durationDown = Duration(
        milliseconds: ((currentSetting as Duration).inMilliseconds -
                DataStaticProperties.intervalInMs)
            .clamp(0, DataStaticProperties.maxSelectionTimeInMs)
            .toInt());

    return BoardVideoSetting.leftRight(
      videoSetting: VideoOverrideType.selectionTime,
      onTapLeft: () {
        editSetting(VideoOverrideType.selectionTime, durationDown);
      },
      onTapRight: () {
        editSetting(VideoOverrideType.selectionTime, durationUp);
      },
      labelText: t.overrideSelectionTime,
    );
  }

  Widget _buildPauseOnEndSetting(
      Map<VideoOverrideType, dynamic> settings,
      Function(VideoOverrideType key, dynamic value) editSetting,
      AppLocalizations t) {
    final currentSetting =
        settings[VideoOverrideType.pauseOnEnd] as bool? ?? false;

    return BoardVideoSetting(
      videoSetting: VideoOverrideType.pauseOnEnd,
      onTap: () {
        editSetting(VideoOverrideType.pauseOnEnd, !currentSetting);
      },
      labelText: t.overridePauseOnEnd,
    );
  }

  Widget _buildShowTimerSetting(
      Map<VideoOverrideType, dynamic> settings,
      Function(VideoOverrideType key, dynamic value) editSetting,
      AppLocalizations t) {
    final currentSetting =
        settings[VideoOverrideType.showTimer] as bool? ?? false;

    return BoardVideoSetting(
      videoSetting: VideoOverrideType.showTimer,
      onTap: () {
        editSetting(VideoOverrideType.showTimer, !currentSetting);
      },
      labelText: t.overrideShowTimer,
    );
  }

  Widget _buildVideoFitSetting(
      Map<VideoOverrideType, dynamic> settings,
      Function(VideoOverrideType key, dynamic value) editSetting,
      AppLocalizations t) {
    final currentFit = settings[VideoOverrideType.videoFit] as VideoFit;
    final int currentIndex = VideoFit.values.indexOf(currentFit);

    final int nextIndex = (currentIndex + 1) % VideoFit.values.length;
    final int previousIndex =
        (currentIndex - 1) < 0 ? VideoFit.values.length - 1 : currentIndex - 1;

    final VideoFit nextFit = VideoFit.values[nextIndex];
    final VideoFit previousFit = VideoFit.values[previousIndex];

    return BoardVideoSetting.leftRight(
      videoSetting: VideoOverrideType.videoFit,
      onTapLeft: () {
        editSetting(VideoOverrideType.videoFit, previousFit);
      },
      onTapRight: () {
        editSetting(VideoOverrideType.videoFit, nextFit);
      },
      labelText: t.overrideVideoFit,
    );
  }

  Widget _buildDefaultSelectionSetting(
      Map<VideoOverrideType, dynamic> settings,
      Function(VideoOverrideType key, dynamic value) editSetting,
      AppLocalizations t) {
    final currentMethod =
        settings[VideoOverrideType.defaultSelection] as DefaultSelectionMethod;
    final int currentIndex =
        DefaultSelectionMethod.values.indexOf(currentMethod);

    final int nextIndex =
        (currentIndex + 1) % DefaultSelectionMethod.values.length;
    final int previousIndex = currentIndex - 1 < 0
        ? DefaultSelectionMethod.values.length - 1
        : currentIndex - 1;

    final DefaultSelectionMethod nextMethod =
        DefaultSelectionMethod.values[nextIndex];
    final DefaultSelectionMethod previousMethod =
        DefaultSelectionMethod.values[previousIndex];

    return BoardVideoSetting.leftRight(
      videoSetting: VideoOverrideType.defaultSelection,
      onTapLeft: () {
        editSetting(VideoOverrideType.defaultSelection, previousMethod);
      },
      onTapRight: () {
        editSetting(VideoOverrideType.defaultSelection, nextMethod);
      },
      labelText: t.overrideDefaultSelection,
    );
  }
}
