// One playback setting (name + value buttons), for project settings and for
// per-node overrides.
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/core/document/video_setting_steps.dart';
import 'package:nutria_fmv_maker/core/document/video_settings.dart';
import 'package:nutria_fmv_maker/l10n/generated/app_localizations.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_context_menu.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_number_field.dart';
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
  AppLocalizations t,
  VideoSettingType type,
  VideoSettings settings,
) => switch (type) {
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
    DefaultSelectionMethod.specified => t.overrideDefaultSelection_Specified,
  },
};

/// Selection time as shown in its field: seconds with two decimals.
String _seconds(int ms) => (ms / 1000).toStringAsFixed(2);

/// One setting as a [NutriaSettingRow]. On nodes, an overridden setting is
/// accented and gets a reset (x) button.
///
/// The selection time is a number field (type seconds, or step a second with
/// its arrows); every other setting steps through its values by clicking,
/// and right-clicking it lists them all.
class VideoSettingRow extends StatefulWidget {
  const VideoSettingRow({
    super.key,
    required this.type,
    required this.settings,
    required this.onStep,
    required this.onChanged,
    this.isOverridden = false,
    this.onReset,
    this.onMenuOpenChanged,
  });

  final VideoSettingType type;

  /// The values shown (for a node: project settings with its overrides).
  final VideoSettings settings;

  /// The user clicked previous (-1) or next (1); toggles always send 1.
  final ValueChanged<int> onStep;

  /// The user picked or typed a value: [settings] with [type] changed. All
  /// keystrokes of one typing session share [mergeKey] (one undo step).
  final void Function(VideoSettings next, {Object? mergeKey}) onChanged;
  final bool isOverridden;

  /// Removes the override. Shown only when [isOverridden].
  final VoidCallback? onReset;
  final ValueChanged<bool>? onMenuOpenChanged;

  @override
  State<VideoSettingRow> createState() => _VideoSettingRowState();
}

class _VideoSettingRowState extends State<VideoSettingRow> {
  Object _typing = Object();

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final type = widget.type;
    final settings = widget.settings;
    final toggle = isToggleSetting(type);
    final options = settings.optionsFor(type);
    return NutriaSettingRow(
      label: videoSettingName(t, type),
      value: videoSettingValue(t, type, settings),
      isAccented: widget.isOverridden,
      onReset: widget.isOverridden ? widget.onReset : null,
      resetTooltip: t.tooltipResetOverride,
      field: type == VideoSettingType.selectionTime
          ? NutriaNumberField(
              text: _seconds(settings.selectionTimeMs),
              decimals: true,
              isAccented: widget.isOverridden,
              onStep: widget.onStep,
              onFocusChanged: (focused) {
                if (focused) _typing = Object();
              },
              onChanged: (text) {
                final seconds = NutriaNumberField.parse(text);
                if (seconds == null || seconds < 0) return;
                widget.onChanged(
                  settings.copyWith(selectionTimeMs: (seconds * 1000).round()),
                  mergeKey: _typing,
                );
              },
            )
          : null,
      onTap: toggle ? () => widget.onStep(1) : null,
      onPrevious: toggle ? null : () => widget.onStep(-1),
      onNext: toggle ? null : () => widget.onStep(1),
      options: options.isEmpty
          ? null
          : [
              for (final option in options)
                NutriaContextMenuItem(
                  icon: settings.sameValue(option, type)
                      ? Icons.check
                      : Icons.circle_outlined,
                  label: videoSettingValue(t, type, option),
                  onSelected: () => widget.onChanged(option),
                ),
            ],
      onOptionsOpenChanged: widget.onMenuOpenChanged,
    );
  }
}
