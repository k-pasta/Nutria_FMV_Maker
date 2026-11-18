// A number you can type, or step with the arrows on its sides.
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_text_field.dart';

/// A text field for a number with ◀ ▶ arrows inside its ends: clicking an
/// arrow calls [onStep] with -1 or 1; typing calls [onChanged] with the text.
/// Used wherever the app edits a number (variables, settings), so they all
/// work the same way.
class NutriaNumberField extends StatelessWidget {
  const NutriaNumberField({
    super.key,
    required this.text,
    required this.onStep,
    required this.onChanged,
    this.decimals = false,
    this.isAccented = false,
    this.hint,
    this.onFocusChanged,
  });

  final String text;
  final ValueChanged<int> onStep;
  final ValueChanged<String> onChanged;

  /// Allows a decimal point (or comma); otherwise only whole numbers.
  final bool decimals;

  /// Shows the number in the accent color, e.g. for an overridden setting.
  final bool isAccented;
  final String? hint;
  final ValueChanged<bool>? onFocusChanged;

  /// Lets through text on the way to a number: digits, a leading minus and,
  /// with [decimals], one decimal point or comma.
  static TextInputFormatter filter({required bool decimals}) {
    final valid = decimals ? RegExp(r'^-?\d*[.,]?\d*$') : RegExp(r'^-?\d*$');
    return TextInputFormatter.withFunction(
      (old, next) => valid.hasMatch(next.text) ? next : old,
    );
  }

  /// Reads a typed number, with a comma also accepted as the decimal point.
  static double? parse(String text) {
    final value = double.tryParse(text.trim().replaceAll(',', '.'));
    return value != null && value.isFinite ? value : null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final arrowWidth = theme.dButtonHeight * 0.7;
    return SizedBox(
      height: theme.dButtonHeight,
      child: Stack(
        children: [
          Positioned.fill(
            child: NutriaTextField(
              isAccented: isAccented,
              text: text,
              hint: hint,
              textAlign: TextAlign.center,
              horizontalPadding: arrowWidth,
              inputFormatters: [filter(decimals: decimals)],
              onFocusChanged: onFocusChanged,
              onChanged: onChanged,
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: arrowWidth,
            child: _Arrow(icon: Icons.arrow_left, onTap: () => onStep(-1)),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: arrowWidth,
            child: _Arrow(icon: Icons.arrow_right, onTap: () => onStep(1)),
          ),
        ],
      ),
    );
  }
}

class _Arrow extends StatefulWidget {
  const _Arrow({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  State<_Arrow> createState() => _ArrowState();
}

class _ArrowState extends State<_Arrow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: Center(
          child: Icon(
            widget.icon,
            size: theme.dButtonHeight * 0.8,
            color: _hovered ? theme.cTextActive : theme.cButtonContentUnhovered,
          ),
        ),
      ),
    );
  }
}
