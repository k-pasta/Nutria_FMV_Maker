// A flat slider without a thumb, for timelines and volume.
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';

class NutriaSlider extends StatelessWidget {
  const NutriaSlider({
    super.key,
    required this.value,
    required this.max,
    required this.onChanged,
    this.onChangeEnd,
    this.isAccented = false,
  });

  /// Clamped to 0..[max]. A [max] of 0 (nothing loaded) shows an empty bar.
  final double value;
  final double max;
  final ValueChanged<double> onChanged;
  final ValueChanged<double>? onChangeEnd;

  /// Accent color for the filled part (timelines); otherwise button colors.
  final bool isAccented;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final safeMax = max > 0 ? max : 1.0;
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        // Rounded outer ends, flat where the filled part stops.
        trackShape: const RoundedRectSliderTrackShape(),
        thumbShape: SliderComponentShape.noThumb,
        overlayShape: SliderComponentShape.noOverlay,
        trackHeight: theme.dPanelPadding + 1,
      ),
      child: Slider(
        value: value.clamp(0, safeMax),
        max: safeMax,
        onChanged: max > 0 ? onChanged : null,
        onChangeEnd: onChangeEnd,
        activeColor: isAccented ? theme.cAccent : theme.cButtonPressed,
        inactiveColor: theme.cButton,
      ),
    );
  }
}
