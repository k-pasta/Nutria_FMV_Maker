// A themed hover hint.
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';

/// Shows [message] after the pointer rests on [child] for a moment. With a
/// `null` message it's just [child].
///
/// With [stable], [child] keeps its state when the message comes and goes
/// while it is in use (e.g. an error on a text field being typed in). Without
/// it, adding or removing the tooltip rebuilds [child] from scratch, and a
/// text field loses focus. (A hidden `Tooltip` doesn't help: Flutter's own
/// Tooltip inserts a wrapper only while visible.)
class NutriaTooltip extends StatefulWidget {
  const NutriaTooltip({
    super.key,
    required this.message,
    required this.child,
    this.stable = false,
  });

  final String? message;
  final Widget child;
  final bool stable;

  @override
  State<NutriaTooltip> createState() => _NutriaTooltipState();
}

class _NutriaTooltipState extends State<NutriaTooltip> {
  /// Moves [NutriaTooltip.child] instead of rebuilding it ([stable] only).
  GlobalKey? _childKey;

  @override
  Widget build(BuildContext context) {
    if (widget.stable) _childKey ??= GlobalKey();
    final key = _childKey;
    final child =
        key == null ? widget.child : KeyedSubtree(key: key, child: widget.child);
    final message = widget.message;
    if (message == null) return child;
    return _tooltip(context.appTheme, message, child);
  }

  Widget _tooltip(AppTheme theme, String message, Widget child) {
    return Tooltip(
      message: message,
      waitDuration: const Duration(milliseconds: 600),
      padding: EdgeInsets.symmetric(
        horizontal: theme.dTextfieldPadding,
        vertical: theme.dPanelPadding / 2,
      ),
      decoration: BoxDecoration(
        color: theme.cCard,
        borderRadius: BorderRadius.circular(theme.dPanelBorderRadius),
        boxShadow: theme.cardShadow(),
      ),
      textStyle: TextStyle(
        color: theme.cTextActive,
        fontSize: theme.dTextHeight * 0.9,
        fontWeight: FontWeight.w500,
      ),
      child: child,
    );
  }
}
