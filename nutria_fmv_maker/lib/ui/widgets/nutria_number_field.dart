// A number you can type, step with the arrows on its sides, or drag.
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_text_field.dart';

/// A text field for a number with ◀ ▶ arrows inside its ends: clicking an
/// arrow calls [onStep] with -1 or 1; typing calls [onChanged] with the text.
/// Dragging its middle sideways steps too, one step every
/// [kNumberDragStep] pixels (left down, right up; with Shift, three times
/// finer), between [onDragStart] and [onDragEnd]. A click without dragging
/// starts typing. Used wherever the app edits a number (variables,
/// settings), so they all work the same way.
class NutriaNumberField extends StatefulWidget {
  const NutriaNumberField({
    super.key,
    required this.text,
    required this.onStep,
    required this.onChanged,
    this.decimals = false,
    this.isAccented = false,
    this.hint,
    this.onFocusChanged,
    this.onDragStart,
    this.onDragEnd,
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

  /// A drag starts and ends: the steps between can be one undo step.
  final VoidCallback? onDragStart;
  final VoidCallback? onDragEnd;

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
  State<NutriaNumberField> createState() => _NutriaNumberFieldState();
}

/// Screen pixels of dragging per step.
const kNumberDragStep = 8.0;

class _NutriaNumberFieldState extends State<NutriaNumberField> {
  bool _focused = false;
  bool _dragging = false;

  /// Screen pixels dragged since the last step.
  double _dragged = 0;

  double? _lastX;

  void _onDragStart(DragStartDetails details) {
    _dragging = true;
    _dragged = 0;
    _lastX = details.globalPosition.dx;
    widget.onDragStart?.call();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    // Global positions, so a step is the same distance at any canvas zoom.
    final x = details.globalPosition.dx;
    _dragged += x - (_lastX ?? x);
    _lastX = x;
    final step = HardwareKeyboard.instance.isShiftPressed
        ? kNumberDragStep * 3
        : kNumberDragStep;
    while (_dragged.abs() >= step) {
      final direction = _dragged.sign.toInt();
      _dragged -= direction * step;
      widget.onStep(direction);
    }
  }

  void _onDragEnd() {
    if (!_dragging) return;
    _dragging = false;
    _lastX = null;
    widget.onDragEnd?.call();
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
              isAccented: widget.isAccented,
              text: widget.text,
              hint: widget.hint,
              textAlign: TextAlign.center,
              horizontalPadding: arrowWidth,
              inputFormatters: [
                NutriaNumberField.filter(decimals: widget.decimals),
              ],
              onFocusChanged: (focused) {
                setState(() => _focused = focused);
                widget.onFocusChanged?.call(focused);
              },
              onChanged: widget.onChanged,
            ),
          ),
          // Sideways drags on the middle change the value. Clicks pass
          // through to the field (translucent); while typing, drags select
          // text instead.
          if (!_focused)
            Positioned(
              left: arrowWidth,
              right: arrowWidth,
              top: 0,
              bottom: 0,
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeLeftRight,
                opaque: false,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  // Counted from the press, not from where the drag won.
                  dragStartBehavior: DragStartBehavior.down,
                  onHorizontalDragStart: _onDragStart,
                  onHorizontalDragUpdate: _onDragUpdate,
                  onHorizontalDragEnd: (_) => _onDragEnd(),
                  onHorizontalDragCancel: _onDragEnd,
                ),
              ),
            ),
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: arrowWidth,
            child: _Arrow(
              icon: Icons.arrow_left,
              onTap: () => widget.onStep(-1),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: arrowWidth,
            child: _Arrow(
              icon: Icons.arrow_right,
              onTap: () => widget.onStep(1),
            ),
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
