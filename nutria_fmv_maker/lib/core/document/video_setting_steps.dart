// How each playback setting changes when the user clicks it in the editor.
import 'package:nutria_fmv_maker/core/document/video_settings.dart';

/// Selection time changes by this much per click.
const kSelectionTimeStepMs = 1000;

/// Which settings a node of each kind can override. Simple video nodes have
/// no choices, so only the picture settings apply.
const kBranchedNodeSettings = VideoSettingType.values;
const kSimpleNodeSettings = [VideoSettingType.videoFit];

/// Whether [type] is changed with one toggle button (on/off) rather than
/// previous/next buttons.
bool isToggleSetting(VideoSettingType type) =>
    type == VideoSettingType.pauseOnEnd || type == VideoSettingType.showTimer;

T _cycle<T>(List<T> values, T current, int direction) =>
    values[(values.indexOf(current) + direction) % values.length];

extension VideoSettingSteps on VideoSettings {
  /// Steps [type] forward ([direction] 1) or back (-1). Toggles flip either
  /// way; lists wrap around; the selection time doesn't go below zero.
  VideoSettings step(VideoSettingType type, int direction) => switch (type) {
        VideoSettingType.selectionTime => copyWith(
            selectionTimeMs: (selectionTimeMs + direction * kSelectionTimeStepMs)
                .clamp(0, 1 << 31)),
        VideoSettingType.pauseOnEnd => copyWith(pauseOnEnd: !pauseOnEnd),
        VideoSettingType.showTimer => copyWith(showTimer: !showTimer),
        VideoSettingType.videoFit =>
          copyWith(videoFit: _cycle(VideoFit.values, videoFit, direction)),
        VideoSettingType.defaultSelection => copyWith(
            defaultSelection: _cycle(
                DefaultSelectionMethod.values, defaultSelection, direction)),
      };
}
