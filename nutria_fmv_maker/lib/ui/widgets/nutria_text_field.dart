// Theme text field that stays in sync with external changes (e.g. undo).
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/ui/text/expression_text.dart';
import 'package:nutria_fmv_maker/ui/text/markdown_edit.dart';
import 'package:nutria_fmv_maker/ui/text/markdown_text.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';
import 'package:nutria_fmv_maker/ui/theme/ui_constants.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_context_menu.dart';
import 'package:nutria_fmv_maker/ui/widgets/raised_edge.dart';
import 'package:nutria_fmv_protocol/nutria_fmv_protocol.dart';

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
    this.isAccented = false,
    this.inputFormatters,
    this.horizontalPadding,
    this.bareStyle,
    this.autofocus = false,
    this.onSubmitted,
    this.onEscape,
    this.markdown = false,
    this.expressionTypes,
  });

  final String text;
  final String? hint;
  final ValueChanged<String>? onChanged;
  final ValueChanged<bool>? onFocusChanged;

  /// `null`: grows with the text, and Enter starts a new line.
  final int? maxLines;
  final TextAlign textAlign;

  /// Shows the text in the accent color, e.g. for a name that's taken.
  final bool isError;

  /// Shows the text in the accent color, e.g. for an overridden setting.
  final bool isAccented;

  /// Limits what can be typed, e.g. to digits.
  final List<TextInputFormatter>? inputFormatters;

  /// Space left and right of the text (default: the theme's), e.g. to make
  /// room for buttons drawn over the field's ends.
  final double? horizontalPadding;

  /// Draws only the text, in this style: no fill, no padding, no raised
  /// edge. For editing text in place, e.g. a node's name in its strip.
  final TextStyle? bareStyle;

  /// Focuses the field (and selects its text) as soon as it appears.
  final bool autofocus;

  /// Enter was pressed.
  final ValueChanged<String>? onSubmitted;

  /// Escape was pressed (e.g. to cancel an edit).
  final VoidCallback? onEscape;

  /// Story text: shows `**bold**` and `*italic*` as they look, and Ctrl+B /
  /// Ctrl+I make the selection bold or italic.
  final bool markdown;

  /// A logic expression over these variables (by name): coloured as it's
  /// typed, and Tab completes variable names.
  final Map<String, FmvValueType>? expressionTypes;

  @override
  State<NutriaTextField> createState() => _NutriaTextFieldState();
}

class _NutriaTextFieldState extends State<NutriaTextField> {
  late final TextEditingController _controller = widget.expressionTypes != null
      ? ExpressionTextEditingController(
          text: widget.text,
          types: widget.expressionTypes!,
        )
      : widget.markdown
      ? MarkdownTextEditingController(text: widget.text)
      : TextEditingController(text: widget.text);
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
    if (widget.autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _focus.requestFocus();
        _controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _controller.text.length,
        );
      });
    }
  }

  @override
  void didUpdateWidget(NutriaTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    final controller = _controller;
    final types = widget.expressionTypes;
    if (controller is ExpressionTextEditingController && types != null) {
      controller.types = types;
    }
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
    final bare = widget.bareStyle;
    final field = _field(theme);
    // Our own right-click menu: the built-in one is drawn in the field's
    // coordinates, so on a zoomed-out canvas it shrinks with the node.
    final withMenu = NutriaContextMenuArea(
      fromPointerEvents: true,
      itemsAt: (_) => _menu(context),
      child: field,
    );
    // Raised a little in themes with elevation, like buttons.
    return bare != null
        ? withMenu
        : RaisedEdge(radius: theme.dButtonBorderRadius, child: withMenu);
  }

  Widget _field(AppTheme theme) {
    final focused = _focus.hasFocus;
    final radius = BorderRadius.circular(theme.dButtonBorderRadius);
    const hidden = BorderSide(color: Colors.transparent);
    final bare = widget.bareStyle;
    final onEscape = widget.onEscape;
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): ?onEscape,
        if (_controller is ExpressionTextEditingController)
          const SingleActivator(LogicalKeyboardKey.tab): _complete,
        if (widget.markdown) ...{
          const SingleActivator(LogicalKeyboardKey.keyB, control: true): () =>
              _toggleStyle(bold: true),
          const SingleActivator(LogicalKeyboardKey.keyI, control: true): () =>
              _toggleStyle(bold: false),
        },
      },
      child: Shortcuts(
        shortcuts: _blockedShortcuts,
        child: TextField(
          controller: _controller,
          focusNode: _focus,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
          inputFormatters: widget.inputFormatters,
          // Clicking elsewhere ends editing, so the app's keyboard shortcuts
          // work again (desktop fields keep focus by default).
          onTapOutside: (_) => _focus.unfocus(),
          textInputAction: widget.maxLines == null
              ? TextInputAction.newline
              : TextInputAction.next,
          keyboardType: widget.maxLines == null
              ? TextInputType.multiline
              : TextInputType.text,
          cursorColor: theme.cText,
          style:
              bare ??
              TextStyle(
                color: widget.isError || widget.isAccented
                    ? theme.cAccent
                    : (focused ? theme.cTextActive : theme.cText),
                fontSize: theme.dTextHeight,
              ),
          contextMenuBuilder: null,
          maxLines: widget.maxLines,
          maxLength: kTextFieldMaxLength,
          // The limit is a safety net, not something to show.
          buildCounter:
              (_, {required currentLength, required isFocused, maxLength}) =>
                  null,
          textAlign: widget.textAlign,
          decoration: bare != null
              ? InputDecoration.collapsed(
                  hintText: widget.hint,
                  hintStyle: bare.copyWith(color: theme.cTextInactive),
                )
              : InputDecoration(
                  // Allows heights below Material's 48px minimum.
                  isDense: true,
                  // Vertically centers one line in a button-high field (+0.5 by eye).
                  contentPadding: EdgeInsets.symmetric(
                    vertical:
                        (theme.dButtonHeight - theme.dTextHeight) / 2 + 0.5,
                    horizontal:
                        widget.horizontalPadding ?? theme.dTextfieldPadding,
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
                  fillColor: focused
                      ? theme.cTextFieldActive
                      : theme.cTextField,
                ),
        ),
      ),
    );
  }

  /// Cut, Copy, Paste and Select all, as the platform labels them.
  List<NutriaContextMenuItem> _menu(BuildContext context) {
    final labels = MaterialLocalizations.of(context);
    final selection = _controller.selection;
    final hasSelection = selection.isValid && !selection.isCollapsed;
    if (!_focus.hasFocus) _focus.requestFocus();
    return [
      if (hasSelection) ...[
        NutriaContextMenuItem(
          icon: Icons.content_cut,
          label: labels.cutButtonLabel,
          onSelected: () {
            Clipboard.setData(
              ClipboardData(text: selection.textInside(_controller.text)),
            );
            _replaceSelection('');
          },
        ),
        NutriaContextMenuItem(
          icon: Icons.content_copy,
          label: labels.copyButtonLabel,
          onSelected: () => Clipboard.setData(
            ClipboardData(text: selection.textInside(_controller.text)),
          ),
        ),
      ],
      NutriaContextMenuItem(
        icon: Icons.content_paste,
        label: labels.pasteButtonLabel,
        onSelected: () async {
          final text = (await Clipboard.getData(Clipboard.kTextPlain))?.text;
          if (text != null && mounted) _replaceSelection(text);
        },
      ),
      NutriaContextMenuItem(
        icon: Icons.select_all,
        label: labels.selectAllButtonLabel,
        onSelected: () => _controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _controller.text.length,
        ),
      ),
    ];
  }

  /// Tab in an expression: completes the variable name being typed.
  void _complete() {
    final controller = _controller as ExpressionTextEditingController;
    final before = controller.text;
    if (controller.complete() && controller.text != before) {
      widget.onChanged?.call(controller.text);
    }
  }

  /// Makes the selection bold or italic, or plain again (see
  /// [toggleMarkdown]), and reports the change like typing would.
  void _toggleStyle({required bool bold}) {
    final value = _controller.value;
    final selection = value.selection.isValid
        ? value.selection
        : TextSelection.collapsed(offset: value.text.length);
    final edit = toggleMarkdown(
      value.text,
      selection.start,
      selection.end,
      bold: bold,
    );
    if (edit.text.length > kTextFieldMaxLength) return;
    _controller.value = TextEditingValue(
      text: edit.text,
      selection: TextSelection(baseOffset: edit.start, extentOffset: edit.end),
    );
    if (edit.text != value.text) widget.onChanged?.call(edit.text);
  }

  /// Puts [text] in place of the selection (or at the cursor), through the
  /// field's input filters, and reports the change like typing would.
  void _replaceSelection(String text) {
    final value = _controller.value;
    final selection = value.selection.isValid
        ? value.selection
        : TextSelection.collapsed(offset: value.text.length);
    var next = value.replaced(selection, text);
    for (final formatter in widget.inputFormatters ?? const []) {
      next = formatter.formatEditUpdate(value, next);
    }
    if (next.text.length > kTextFieldMaxLength) return;
    _controller.value = next;
    if (next.text != value.text) widget.onChanged?.call(next.text);
  }
}
