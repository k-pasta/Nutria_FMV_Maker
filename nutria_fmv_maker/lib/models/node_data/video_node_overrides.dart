import 'package:nutria_fmv_maker/models/enums_data.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:json_annotation/json_annotation.dart';

// part 'video_node_overrides.g.dart';

sealed class VideoNodeOverride {
  final VideoOverrideType videoOverrideType;
  Object get value;
  Object get jsonValue;
  const VideoNodeOverride({required this.videoOverrideType});

  String getOverrideValueString(AppLocalizations t);

  String getOverrideNameString(AppLocalizations t) {
    switch (videoOverrideType) {
      case VideoOverrideType.selectionTime:
        return t.overrideSelectionTime;
      case VideoOverrideType.pauseOnEnd:
        return t.overridePauseOnEnd;
      case VideoOverrideType.showTimer:
        return t.overrideShowTimer;
      case VideoOverrideType.videoFit:
        return t.overrideVideoFit;
      case VideoOverrideType.defaultSelection:
        return t.overrideDefaultSelection;
      // case VideoOverrides.pauseMusicPath:
      //   return t.pauseMusicPath;
      default:
        return t.overrideUnknown;
    }
  }
}

sealed class VideoNodeOverrideSingleButton extends VideoNodeOverride {
  const VideoNodeOverrideSingleButton({required super.videoOverrideType});

  VideoNodeOverrideSingleButton copySwitched();
}

sealed class VideoNodeOverrideDoubleButton extends VideoNodeOverride {
  const VideoNodeOverrideDoubleButton({required super.videoOverrideType});

  VideoNodeOverrideDoubleButton copyIteratedUpwards();
  VideoNodeOverrideDoubleButton copyIteratedDownwards();
}

class VideoNodeOverrideSelectionTime extends VideoNodeOverrideDoubleButton {
  final Duration selectionTime;

  const VideoNodeOverrideSelectionTime({
    required this.selectionTime,
  }) : super(videoOverrideType: VideoOverrideType.selectionTime);

  @override
  Duration get value => selectionTime;

  @override
  int get jsonValue => selectionTime.inMilliseconds;

  @override
  String getOverrideValueString(t) =>
      '${(selectionTime.inMilliseconds / 1000).toStringAsFixed(2)} s';

  @override
  VideoNodeOverrideDoubleButton copyIteratedDownwards() {
    final newDuration = selectionTime.inMilliseconds > 1000
        ? Duration(milliseconds: selectionTime.inMilliseconds - 1000)
        : Duration.zero;
    return VideoNodeOverrideSelectionTime(selectionTime: newDuration);
  }

  @override
  VideoNodeOverrideDoubleButton copyIteratedUpwards() {
    final newDuration =
        Duration(milliseconds: selectionTime.inMilliseconds + 1000);
    return VideoNodeOverrideSelectionTime(selectionTime: newDuration);
  }
}

class VideoNodeOverridePauseOnEnd extends VideoNodeOverrideSingleButton {
  final bool pauseOnEnd;

  VideoNodeOverridePauseOnEnd({
    required this.pauseOnEnd,
  }) : super(videoOverrideType: VideoOverrideType.pauseOnEnd);

  @override
  bool get value => pauseOnEnd;

  @override
  bool get jsonValue => pauseOnEnd;

  @override
  String getOverrideValueString(AppLocalizations t) =>
      pauseOnEnd ? t.essentialsYes : t.essentialsNo;

  @override
  VideoNodeOverrideSingleButton copySwitched() {
    return VideoNodeOverridePauseOnEnd(pauseOnEnd: !pauseOnEnd);
  }
}

class VideoNodeOverrideShowTimer extends VideoNodeOverrideSingleButton {
  final bool showTimer;

  const VideoNodeOverrideShowTimer({
    required this.showTimer,
  }) : super(videoOverrideType: VideoOverrideType.showTimer);

  @override
  bool get value => showTimer;

  @override
  bool get jsonValue => showTimer;

  @override
  String getOverrideValueString(AppLocalizations t) =>
      showTimer ? t.essentialsYes : t.essentialsNo;

  @override
  VideoNodeOverrideSingleButton copySwitched() {
    return VideoNodeOverrideShowTimer(showTimer: !showTimer);
  }
}

class VideoNodeOverrideVideoFit extends VideoNodeOverrideDoubleButton {
  final VideoFit videoFit;

  const VideoNodeOverrideVideoFit({
    required this.videoFit,
  }) : super(videoOverrideType: VideoOverrideType.videoFit);

  @override
  VideoFit get value => videoFit;

  @override
  String get jsonValue => videoFit.name;

  @override
  String getOverrideValueString(AppLocalizations t) {
    return switch (videoFit) {
      VideoFit.fit => t.overrideVideoFit_Fit,
      VideoFit.fill => t.overrideVideoFit_Fill,
      VideoFit.fillWidth => t.overrideVideoFit_FillWidth,
      VideoFit.fillHeight => t.overrideVideoFit_FillHeight,
      VideoFit.stretch => t.overrideVideoFit_Stretch,
    };
  }

  @override
  VideoNodeOverrideDoubleButton copyIteratedUpwards() {
    const values = VideoFit.values;
    final currentIndex = values.indexOf(videoFit);
    final nextIndex = (currentIndex + 1) % values.length;
    return VideoNodeOverrideVideoFit(videoFit: values[nextIndex]);
  }

  @override
  VideoNodeOverrideDoubleButton copyIteratedDownwards() {
    const values = VideoFit.values;
    final currentIndex = values.indexOf(videoFit);
    final prevIndex = (currentIndex - 1) % values.length;
    return VideoNodeOverrideVideoFit(videoFit: values[prevIndex]);
  }
}

class VideoNodeOverrideDefaultSelection extends VideoNodeOverrideDoubleButton {
  final DefaultSelectionMethod defaultSelection;

  const VideoNodeOverrideDefaultSelection({
    required this.defaultSelection,
  }) : super(videoOverrideType: VideoOverrideType.defaultSelection);

  @override
  DefaultSelectionMethod get value => defaultSelection;

  @override
  String get jsonValue => defaultSelection.name;

  @override
  String getOverrideValueString(AppLocalizations t) {
    return switch (defaultSelection) {
      DefaultSelectionMethod.first => t.overrideDefaultSelection_First,
      DefaultSelectionMethod.last => t.overrideDefaultSelection_Last,
      DefaultSelectionMethod.lastSelected =>
        t.overrideDefaultSelection_LastSelected,
      DefaultSelectionMethod.random => t.overrideDefaultSelection_Random,
      DefaultSelectionMethod.specified => t.overrideDefaultSelection_Specified,
    };
  }

  @override
  VideoNodeOverrideDoubleButton copyIteratedUpwards() {
    const values = DefaultSelectionMethod.values;
    final currentIndex = values.indexOf(defaultSelection);
    final nextIndex = (currentIndex + 1) % values.length;
    return VideoNodeOverrideDefaultSelection(
        defaultSelection: values[nextIndex]);
  }

  @override
  VideoNodeOverrideDoubleButton copyIteratedDownwards() {
    const values = DefaultSelectionMethod.values;
    final currentIndex = values.indexOf(defaultSelection);
    final prevIndex = (currentIndex - 1) % values.length;
    return VideoNodeOverrideDefaultSelection(
        defaultSelection: values[prevIndex]);
  }
}

class VideoNodeOverrideConverter
    implements JsonConverter<VideoNodeOverride, Map<String, dynamic>> {
  const VideoNodeOverrideConverter();

  @override
  Map<String, dynamic> toJson(VideoNodeOverride object) {
    return {
      'type': object.videoOverrideType.name,
      'value': object.jsonValue,
    };
  }

  @override
  VideoNodeOverride fromJson(Map<String, dynamic> json) {
    final type = VideoOverrideType.values.byName(json['type']);

    switch (type) {
      case VideoOverrideType.selectionTime:
        return VideoNodeOverrideSelectionTime(
          selectionTime: Duration(milliseconds: json['value']),
        );

      case VideoOverrideType.pauseOnEnd:
        return VideoNodeOverridePauseOnEnd(
          pauseOnEnd: json['value'],
        );

      case VideoOverrideType.showTimer:
        return VideoNodeOverrideShowTimer(
          showTimer: json['value'],
        );

      case VideoOverrideType.videoFit:
        return VideoNodeOverrideVideoFit(
          videoFit: VideoFit.values.byName(json['value']),
        );

      case VideoOverrideType.defaultSelection:
        return VideoNodeOverrideDefaultSelection(
          defaultSelection: DefaultSelectionMethod.values.byName(json['value']),
        );

      default:
        throw UnimplementedError(
            'pauseMusicPath override is not yet implemented');
    }
  }
}
