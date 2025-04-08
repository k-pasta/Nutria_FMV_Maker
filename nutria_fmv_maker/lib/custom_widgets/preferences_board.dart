import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nutria_fmv_maker/custom_widgets/board_video_override.dart';
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
            behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: theme.dSectionPadding),
              child: SingleChildScrollView(
                clipBehavior: Clip.hardEdge,
                controller: scrollController,
                child: Selector<AppSettingsProvider, Map<VideoOverrides, dynamic>>(
                  selector: (context, provider) => provider.currentVideoSettings,
                  builder:
                      (BuildContext context, currentVideoSettings, Widget? child) {
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

    final Map<VideoOverrides, dynamic> settings =
        appSettingsProvider.currentVideoSettings;
    final void Function(VideoOverrides key, dynamic value) editSetting =
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
      Map<VideoOverrides, dynamic> settings,
      Function(VideoOverrides key, dynamic value) editSetting,
      AppLocalizations t) {
    final currentSetting = settings[VideoOverrides.selectionTime];
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
      videoSetting: VideoOverrides.selectionTime,
      onTapLeft: () {
        editSetting(VideoOverrides.selectionTime, durationDown);
      },
      onTapRight: () {
        editSetting(VideoOverrides.selectionTime, durationUp);
      },
      labelText: t.overrideSelectionTime,
    );
  }

  Widget _buildPauseOnEndSetting(
      Map<VideoOverrides, dynamic> settings,
      Function(VideoOverrides key, dynamic value) editSetting,
      AppLocalizations t) {
    final currentSetting =
        settings[VideoOverrides.pauseOnEnd] as bool? ?? false;

    return BoardVideoSetting(
      videoSetting: VideoOverrides.pauseOnEnd,
      onTap: () {
        editSetting(VideoOverrides.pauseOnEnd, !currentSetting);
      },
      labelText: t.overridePauseOnEnd,
    );
  }

  Widget _buildShowTimerSetting(
      Map<VideoOverrides, dynamic> settings,
      Function(VideoOverrides key, dynamic value) editSetting,
      AppLocalizations t) {
    final currentSetting = settings[VideoOverrides.showTimer] as bool? ?? false;

    return BoardVideoSetting(
      videoSetting: VideoOverrides.showTimer,
      onTap: () {
        editSetting(VideoOverrides.showTimer, !currentSetting);
      },
      labelText: t.overrideShowTimer,
    );
  }

  Widget _buildVideoFitSetting(
      Map<VideoOverrides, dynamic> settings,
      Function(VideoOverrides key, dynamic value) editSetting,
      AppLocalizations t) {
    final currentFit = settings[VideoOverrides.videoFit] as VideoFit;
    final int currentIndex = VideoFit.values.indexOf(currentFit);

    final int nextIndex = (currentIndex + 1) % VideoFit.values.length;
    final int previousIndex =
        (currentIndex - 1) < 0 ? VideoFit.values.length - 1 : currentIndex - 1;

    final VideoFit nextFit = VideoFit.values[nextIndex];
    final VideoFit previousFit = VideoFit.values[previousIndex];

    return BoardVideoSetting.leftRight(
      videoSetting: VideoOverrides.videoFit,
      onTapLeft: () {
        editSetting(VideoOverrides.videoFit, previousFit);
      },
      onTapRight: () {
        editSetting(VideoOverrides.videoFit, nextFit);
      },
      labelText: t.overrideVideoFit,
    );
  }

  Widget _buildDefaultSelectionSetting(
      Map<VideoOverrides, dynamic> settings,
      Function(VideoOverrides key, dynamic value) editSetting,
      AppLocalizations t) {
    final currentMethod =
        settings[VideoOverrides.defaultSelection] as DefaultSelectionMethod;
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
      videoSetting: VideoOverrides.defaultSelection,
      onTapLeft: () {
        editSetting(VideoOverrides.defaultSelection, previousMethod);
      },
      onTapRight: () {
        editSetting(VideoOverrides.defaultSelection, nextMethod);
      },
      labelText: t.overrideDefaultSelection,
    );
  }
}
