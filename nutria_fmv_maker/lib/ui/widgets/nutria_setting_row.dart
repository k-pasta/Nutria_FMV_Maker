// A labeled setting: name on the left, a value button on the right.
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_button.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_context_menu.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_text.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_tooltip.dart';

/// Shows [label] and [value]. With [onTap], clicking the value toggles it;
/// with [onPrevious]/[onNext], its left and right halves step through the
/// choices. [onReset] adds an (x) before the label, e.g. to remove a node's
/// override; [isAccented] highlights a changed value: its text turns the
/// accent color, the same as an accented [field] (one look for every
/// override).
class NutriaSettingRow extends StatelessWidget {
  const NutriaSettingRow({
    super.key,
    required this.label,
    required this.value,
    this.onTap,
    this.onPrevious,
    this.onNext,
    this.onReset,
    this.resetTooltip,
    this.isAccented = false,
    this.field,
    this.options,
    this.onOptionsOpenChanged,
  }) : assert(
         field != null ||
             onTap != null ||
             (onPrevious != null && onNext != null),
       );

  final String label;
  final String value;
  final VoidCallback? onTap;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final VoidCallback? onReset;

  /// Hint on the reset (x) button.
  final String? resetTooltip;
  final bool isAccented;

  /// Shown instead of the value button, e.g. a `NutriaNumberField`.
  final Widget? field;

  /// Every possible value, offered when the value is right-clicked.
  final List<NutriaContextMenuItem>? options;
  final ValueChanged<bool>? onOptionsOpenChanged;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final valueText = NutriaText(
      text: value,
      state: isAccented ? NutriaTextState.highlighted : NutriaTextState.normal,
    );
    final onReset = this.onReset;
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: theme.dButtonHeight,
            child: Row(
              children: [
                if (onReset != null)
                  NutriaTooltip(
                    message: resetTooltip,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: onReset,
                        child: SizedBox(
                          width: theme.dTextHeight + theme.dPanelPadding,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Icon(
                              Icons.close,
                              color: theme.cTextActive,
                              size: theme.dTextHeight,
                            ),
                          ),
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
              ],
            ),
          ),
        ),
        Expanded(child: _withOptions(_value(valueText))),
      ],
    );
  }

  Widget _value(Widget valueText) {
    final field = this.field;
    if (field != null) return field;
    final onTap = this.onTap;
    return onTap != null
        ? NutriaButton(onTap: onTap, child: valueText)
        : NutriaButton.leftRight(
            onTapLeft: onPrevious!,
            onTapRight: onNext!,
            child: valueText,
          );
  }

  Widget _withOptions(Widget value) {
    final options = this.options;
    if (options == null) return value;
    return NutriaContextMenuArea(
      itemsAt: (_) => options,
      onOpenChanged: onOptionsOpenChanged,
      child: value,
    );
  }
}
