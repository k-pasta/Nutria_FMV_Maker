// A themed hover hint.
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';

/// Shows [message] after the pointer rests on [child] for a moment. With a
/// `null` message it's just [child].
class NutriaTooltip extends StatelessWidget {
  const NutriaTooltip({super.key, required this.message, required this.child});

  final String? message;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final message = this.message;
    if (message == null) return child;
    final theme = context.appTheme;
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
