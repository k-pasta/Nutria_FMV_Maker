// One playback setting (name + value buttons), for project settings and for
// per-node overrides.
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/core/document/video_setting_steps.dart';
import 'package:nutria_fmv_maker/core/document/video_settings.dart';
import 'package:nutria_fmv_maker/l10n/generated/app_localizations.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_setting_row.dart';

/// The localized name of a setting.
String videoSettingName(AppLocalizations t, VideoSettingType type) =>
    switch (type) {
      VideoSettingType.selectionTime => t.overrideSelectionTime,
      VideoSettingType.pauseOnEnd => t.overridePauseOnEnd,
      VideoSettingType.showTimer => t.overrideShowTimer,
      VideoSettingType.videoFit => t.overrideVideoFit,
      VideoSettingType.defaultSelection => t.overrideDefaultSelection,
    };

/// The localized value of setting [type] in [settings].
String videoSettingValue(
        AppLocalizations t, VideoSettingType type, VideoSettings settings) =>
    switch (type) {
      VideoSettingType.selectionTime =>
        '${(settings.selectionTimeMs / 1000).toStringAsFixed(2)} s',
      VideoSettingType.pauseOnEnd =>
        settings.pauseOnEnd ? t.essentialsYes : t.essentialsNo,
      VideoSettingType.showTimer =>
        settings.showTimer ? t.essentialsYes : t.essentialsNo,
      VideoSettingType.videoFit => switch (settings.videoFit) {
          VideoFit.fit => t.overrideVideoFit_Fit,
          VideoFit.fill => t.overrideVideoFit_Fill,
          VideoFit.fillWidth => t.overrideVideoFit_FillWidth,
          VideoFit.fillHeight => t.overrideVideoFit_FillHeight,
          VideoFit.stretch => t.overrideVideoFit_Stretch,
        },
      VideoSettingType.defaultSelection => switch (settings.defaultSelection) {
          DefaultSelectionMethod.first => t.overrideDefaultSelection_First,
          DefaultSelectionMethod.last => t.overrideDefaultSelection_Last,
          DefaultSelectionMethod.lastSelected =>
            t.overrideDefaultSelection_LastSelected,
          DefaultSelectionMethod.random => t.overrideDefaultSelection_Random,
          DefaultSelectionMethod.specified =>
            t.overrideDefaultSelection_Specified,
        },
    };

/// One setting as a [NutriaSettingRow]. On nodes, an overridden setting is
/// accented and gets a reset (x) button.
class VideoSettingRow extends StatelessWidget {
  const VideoSettingRow({
    super.key,
    required this.type,
    required this.settings,
    required this.onStep,
    this.isOverridden = false,
    this.onReset,
  });

  final VideoSettingType type;

  /// The values shown (for a node: project settings with its overrides).
  final VideoSettings settings;

  /// The user clicked previous (-1) or next (1); toggles always send 1.
  final ValueChanged<int> onStep;
  final bool isOverridden;

  /// Removes the override. Shown only when [isOverridden].
  final VoidCallback? onReset;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final toggle = isToggleSetting(type);
    return NutriaSettingRow(
      label: videoSettingName(t, type),
      value: videoSettingValue(t, type, settings),
      isAccented: isOverridden,
      onReset: isOverridden ? onReset : null,
      onTap: toggle ? () => onStep(1) : null,
      onPrevious: toggle ? null : () => onStep(-1),
      onNext: toggle ? null : () => onStep(1),
    );
  }
}
