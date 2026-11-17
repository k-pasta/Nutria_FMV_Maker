// Theme text field that stays in sync with external changes (e.g. undo).
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';
import 'package:nutria_fmv_maker/ui/theme/ui_constants.dart';
import 'package:nutria_fmv_maker/ui/widgets/raised_edge.dart';

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
    this.isError = false,
    this.inputFormatters,
    this.horizontalPadding,
  });

  final String text;
  final String? hint;
  final ValueChanged<String>? onChanged;
  final ValueChanged<bool>? onFocusChanged;
  final int maxLines;
  final TextAlign textAlign;

  /// Shows the text in the accent color, e.g. for a name that's taken.
  final bool isError;

  /// Limits what can be typed, e.g. to digits.
  final List<TextInputFormatter>? inputFormatters;

  /// Space left and right of the text (default: the theme's), e.g. to make
  /// room for buttons drawn over the field's ends.
  final double? horizontalPadding;

  @override
  State<NutriaTextField> createState() => _NutriaTextFieldState();
}

class _NutriaTextFieldState extends State<NutriaTextField> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.text,
  );
  final FocusNode _focus = FocusNode();

  /// Single-key app shortcuts (panels, zoom, framing, play) must not fire
  /// while typing, so the field swallows every key that types a character
  /// before it reaches the app. Keys with Ctrl or Alt still get through.
  ///
  /// Clipboard keys act on the text, not on the app (which would copy or
  /// paste nodes), and Ctrl+D (duplicate nodes) does nothing.
  static final Map<ShortcutActivator, Intent> _blockedShortcuts = {
    for (final key in _typingKeys)
      SingleActivator(key): const DoNothingAndStopPropagationIntent(),
    const SingleActivator(LogicalKeyboardKey.keyC, control: true):
        CopySelectionTextIntent.copy,
    const SingleActivator(LogicalKeyboardKey.keyX, control: true):
        const CopySelectionTextIntent.cut(SelectionChangedCause.keyboard),
    const SingleActivator(LogicalKeyboardKey.keyV, control: true):
        const PasteTextIntent(SelectionChangedCause.keyboard),
    const SingleActivator(LogicalKeyboardKey.keyA, control: true):
        const SelectAllTextIntent(SelectionChangedCause.keyboard),
    const SingleActivator(LogicalKeyboardKey.keyD, control: true):
        const DoNothingAndStopPropagationIntent(),
  };

  static final List<LogicalKeyboardKey> _typingKeys = [
    for (final (first, count) in [
      (LogicalKeyboardKey.keyA, 26),
      (LogicalKeyboardKey.digit0, 10),
      (LogicalKeyboardKey.numpad0, 10),
    ])
      for (var i = 0; i < count; i++)
        ?LogicalKeyboardKey.findKeyByKeyId(first.keyId + i),
    LogicalKeyboardKey.space,
    LogicalKeyboardKey.minus,
    LogicalKeyboardKey.equal,
    LogicalKeyboardKey.add,
    LogicalKeyboardKey.comma,
    LogicalKeyboardKey.period,
    LogicalKeyboardKey.slash,
    LogicalKeyboardKey.backslash,
    LogicalKeyboardKey.semicolon,
    LogicalKeyboardKey.quote,
    LogicalKeyboardKey.bracketLeft,
    LogicalKeyboardKey.bracketRight,
    LogicalKeyboardKey.backquote,
    LogicalKeyboardKey.numpadAdd,
    LogicalKeyboardKey.numpadSubtract,
    LogicalKeyboardKey.numpadMultiply,
    LogicalKeyboardKey.numpadDivide,
    LogicalKeyboardKey.numpadDecimal,
  ];

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
    // Raised a little in themes with elevation, like buttons.
    return RaisedEdge(
      radius: theme.dButtonBorderRadius,
      child: Shortcuts(
        shortcuts: _blockedShortcuts,
        child: TextField(
          controller: _controller,
          focusNode: _focus,
          onChanged: widget.onChanged,
          inputFormatters: widget.inputFormatters,
          // Clicking elsewhere ends editing, so the app's keyboard shortcuts
          // work again (desktop fields keep focus by default).
          onTapOutside: (_) => _focus.unfocus(),
          textInputAction: TextInputAction.next,
          cursorColor: theme.cText,
          style: TextStyle(
            color: widget.isError
                ? theme.cAccent
                : (focused ? theme.cTextActive : theme.cText),
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
              horizontal: widget.horizontalPadding ?? theme.dTextfieldPadding,
            ),
            counterText: '',
            hintText: widget.hint,
            hintStyle: TextStyle(color: theme.cTextInactive),
            // Flat: the fill shows the field, a darker fill shows focus.
            border: OutlineInputBorder(
              borderRadius: radius,
              borderSide: hidden,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: radius,
              borderSide: hidden,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: radius,
              borderSide: hidden,
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: radius,
              borderSide: hidden,
            ),
            filled: true,
            fillColor: focused ? theme.cTextFieldActive : theme.cTextField,
          ),
        ),
      ),
    );
  }
}
