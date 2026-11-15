// A labeled setting: name on the left, a value button on the right.
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_button.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_text.dart';

/// Shows [label] and [value]. With [onTap], clicking the value toggles it;
/// with [onPrevious]/[onNext], its left and right halves step through the
/// choices. [onReset] adds an (x) before the label, e.g. to remove a node's
/// override; [isAccented] highlights a changed value.
class NutriaSettingRow extends StatelessWidget {
  const NutriaSettingRow({
    super.key,
    required this.label,
    required this.value,
    this.onTap,
    this.onPrevious,
    this.onNext,
    this.onReset,
    this.isAccented = false,
  }) : assert(onTap != null || (onPrevious != null && onNext != null));

  final String label;
  final String value;
  final VoidCallback? onTap;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final VoidCallback? onReset;
  final bool isAccented;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final valueText = NutriaText(text: value);
    final onTap = this.onTap;
    final onReset = this.onReset;
    return Row(children: [
      Expanded(
        child: SizedBox(
          height: theme.dButtonHeight,
          child: Row(children: [
            if (onReset != null)
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onReset,
                  child: SizedBox(
                    width: theme.dTextHeight + theme.dPanelPadding,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Icon(Icons.close,
                          color: theme.cTextActive, size: theme.dTextHeight),
                    ),
                  ),
                ),
              ),
            Expanded(
              child: NutriaText(
                text: label,
                state: isAccented
                    ? NutriaTextState.accented
                    : NutriaTextState.normal,
              ),
            ),
          ]),
        ),
      ),
      Expanded(
        child: onTap != null
            ? NutriaButton(isAccented: isAccented, onTap: onTap, child: valueText)
            : NutriaButton.leftRight(
                isAccented: isAccented,
                onTapLeft: onPrevious!,
                onTapRight: onNext!,
                child: valueText,
              ),
      ),
    ]);
  }
}
