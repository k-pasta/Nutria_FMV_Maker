// Theme text field that stays in sync with external changes (e.g. undo).
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';
import 'package:nutria_fmv_maker/ui/theme/ui_constants.dart';

/// A single- or multi-line text field.
///
/// [text] is the source of truth: when it changes from outside (undo, loading
/// a project) the field updates, except while the user is typing in it.
/// [onFocusChanged] lets callers start a new undo step per editing session.
class NutriaTextField extends StatefulWidget {
  const NutriaTextField({
    super.key,
    required this.text,
    this.hint,
    this.onChanged,
    this.onFocusChanged,
    this.maxLines = 1,
    this.textAlign = TextAlign.left,
  });

  final String text;
  final String? hint;
  final ValueChanged<String>? onChanged;
  final ValueChanged<bool>? onFocusChanged;
  final int maxLines;
  final TextAlign textAlign;

  @override
  State<NutriaTextField> createState() => _NutriaTextFieldState();
}

class _NutriaTextFieldState extends State<NutriaTextField> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.text);
  final FocusNode _focus = FocusNode();

  /// Single-key app shortcuts (toggle panels, zoom) must not fire while
  /// typing, so the field swallows them before they reach the app.
  static const _blockedShortcuts = <ShortcutActivator, Intent>{
    SingleActivator(LogicalKeyboardKey.keyT): DoNothingAndStopPropagationIntent(),
    SingleActivator(LogicalKeyboardKey.keyN): DoNothingAndStopPropagationIntent(),
    SingleActivator(LogicalKeyboardKey.add): DoNothingAndStopPropagationIntent(),
    SingleActivator(LogicalKeyboardKey.numpadAdd):
        DoNothingAndStopPropagationIntent(),
    SingleActivator(LogicalKeyboardKey.equal): DoNothingAndStopPropagationIntent(),
    SingleActivator(LogicalKeyboardKey.minus): DoNothingAndStopPropagationIntent(),
    SingleActivator(LogicalKeyboardKey.numpadSubtract):
        DoNothingAndStopPropagationIntent(),
  };

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocus);
  }

  @override
  void didUpdateWidget(NutriaTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_focus.hasFocus && widget.text != _controller.text) {
      _controller.text = widget.text;
    }
  }

  void _onFocus() {
    setState(() {});
    widget.onFocusChanged?.call(_focus.hasFocus);
    // Typing may have been normalized by the model; show the stored value.
    if (!_focus.hasFocus && widget.text != _controller.text) {
      _controller.text = widget.text;
    }
  }

  @override
  void dispose() {
    _focus.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final focused = _focus.hasFocus;
    final radius = BorderRadius.circular(theme.dButtonBorderRadius);
    const hidden = BorderSide(color: Colors.transparent);
    return Shortcuts(
      shortcuts: _blockedShortcuts,
      child: TextField(
        controller: _controller,
        focusNode: _focus,
        onChanged: widget.onChanged,
        textInputAction: TextInputAction.next,
        cursorColor: theme.cText,
        style: TextStyle(
          color: focused ? theme.cTextActive : theme.cText,
          fontSize: theme.dTextHeight,
        ),
        maxLines: widget.maxLines,
        maxLength: kTextFieldMaxLength,
        textAlign: widget.textAlign,
        decoration: InputDecoration(
          // Allows heights below Material's 48px minimum.
          isDense: true,
          // Vertically centers one line in a button-high field (+0.5 by eye).
          contentPadding: EdgeInsets.symmetric(
            vertical: (theme.dButtonHeight - theme.dTextHeight) / 2 + 0.5,
            horizontal: theme.dTextfieldPadding,
          ),
          counterText: '',
          hintText: widget.hint,
          hintStyle:
              TextStyle(color: theme.cTextInactive, fontWeight: FontWeight.w900),
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: theme.cOutlines, width: theme.dOutlinesWidth),
            borderRadius: radius,
          ),
          focusedBorder: OutlineInputBorder(borderRadius: radius, borderSide: hidden),
          disabledBorder:
              OutlineInputBorder(borderRadius: radius, borderSide: hidden),
          filled: true,
          fillColor: focused ? theme.cTextFieldActive : theme.cTextField,
        ),
      ),
    );
  }
}
