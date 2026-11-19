// A button that opens a searchable list: type to filter, Enter or click to
// pick. Drawn in screen space, so it keeps its size on a zoomed canvas.
import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_button.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_text.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_text_field.dart';

/// Shows [label] on a button; clicking it opens a list of [options] with a
/// search field above. [onSelected] gets the index of the picked option.
class NutriaSearchMenu extends StatefulWidget {
  const NutriaSearchMenu({
    super.key,
    required this.label,
    required this.options,
    required this.onSelected,
    this.searchHint,
    this.emptyText,
    this.isError = false,
    this.isPlaceholder = false,
    this.isAccented = false,
    this.onOpenChanged,
  });

  final String label;
  final List<String> options;
  final ValueChanged<int> onSelected;
  final String? searchHint;

  /// Shown in the list when there are no options at all.
  final String? emptyText;

  /// Shows [label] in the accent color.
  final bool isError;

  /// Shows [label] faintly (nothing picked yet).
  final bool isPlaceholder;

  /// Shows [label] in the accent color for a changed value (an override),
  /// like other setting rows.
  final bool isAccented;
  final ValueChanged<bool>? onOpenChanged;

  @override
  State<NutriaSearchMenu> createState() => _NutriaSearchMenuState();
}

class _NutriaSearchMenuState extends State<NutriaSearchMenu> {
  OverlayEntry? _entry;

  @override
  void dispose() {
    _entry?.remove();
    super.dispose();
  }

  void _close() {
    final entry = _entry;
    if (entry == null) return;
    entry.remove();
    _entry = null;
    widget.onOpenChanged?.call(false);
  }

  void _open() {
    final box = context.findRenderObject()! as RenderBox;
    final topLeft = box.localToGlobal(Offset.zero);
    final bottomLeft = box.localToGlobal(Offset(0, box.size.height));
    _entry = OverlayEntry(
      builder: (_) => _SearchPanel(
        at: bottomLeft,
        minWidth: math.max(
          180,
          (box.localToGlobal(Offset(box.size.width, 0)) - topLeft).dx,
        ),
        options: widget.options,
        searchHint: widget.searchHint,
        emptyText: widget.emptyText,
        onPicked: (index) {
          _close();
          widget.onSelected(index);
        },
        onClose: _close,
      ),
    );
    Overlay.of(context).insert(_entry!);
    widget.onOpenChanged?.call(true);
  }

  @override
  Widget build(BuildContext context) => NutriaButton(
    onTap: _open,
    child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.appTheme.dTextfieldPadding,
      ),
      child: NutriaText(
        text: widget.label,
        state: widget.isError
            ? NutriaTextState.error
            : widget.isAccented
            ? NutriaTextState.highlighted
            : (widget.isPlaceholder
                  ? NutriaTextState.inactive
                  : NutriaTextState.normal),
      ),
    ),
  );
}

class _SearchPanel extends StatefulWidget {
  const _SearchPanel({
    required this.at,
    required this.minWidth,
    required this.options,
    required this.onPicked,
    required this.onClose,
    this.searchHint,
    this.emptyText,
  });

  final Offset at;
  final double minWidth;
  final List<String> options;
  final ValueChanged<int> onPicked;
  final VoidCallback onClose;
  final String? searchHint;
  final String? emptyText;

  @override
  State<_SearchPanel> createState() => _SearchPanelState();
}

class _SearchPanelState extends State<_SearchPanel> {
  String _query = '';

  List<int> _matchesOf(String query) => [
    for (final (i, option) in widget.options.indexed)
      if (option.toLowerCase().contains(query.toLowerCase())) i,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final matches = _matchesOf(_query);
    final window = MediaQuery.sizeOf(context);
    return Stack(
      children: [
        Positioned.fill(
          child: Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (_) => widget.onClose(),
          ),
        ),
        Positioned(
          left: math.min(widget.at.dx, window.width - widget.minWidth),
          top: widget.at.dy,
          // Text fields need a Material above them; overlays have none.
          child: Material(
            type: MaterialType.transparency,
            child: CallbackShortcuts(
              bindings: {
                const SingleActivator(LogicalKeyboardKey.escape):
                    widget.onClose,
              },
              child: Container(
                width: widget.minWidth,
                constraints: BoxConstraints(
                  maxHeight: math.max(120, window.height - widget.at.dy - 8),
                ),
                padding: EdgeInsets.all(theme.dPanelPadding),
                decoration: BoxDecoration(
                  color: theme.cCard,
                  borderRadius: BorderRadius.circular(theme.dPanelBorderRadius),
                  boxShadow: theme.cardShadow(lifted: true),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    NutriaTextField(
                      text: '',
                      hint: widget.searchHint,
                      autofocus: true,
                      onChanged: (text) => setState(() => _query = text),
                      onEscape: widget.onClose,
                      onSubmitted: (text) {
                        final found = _matchesOf(text);
                        if (found.isNotEmpty) widget.onPicked(found.first);
                      },
                    ),
                    SizedBox(height: theme.dPanelPadding),
                    if (widget.options.isEmpty && widget.emptyText != null)
                      Padding(
                        padding: EdgeInsets.all(theme.dPanelPadding),
                        child: NutriaText(
                          text: widget.emptyText!,
                          state: NutriaTextState.inactive,
                          maxLines: 3,
                        ),
                      ),
                    Flexible(
                      child: ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        children: [
                          for (final i in matches)
                            _Option(
                              label: widget.options[i],
                              onTap: () => widget.onPicked(i),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Option extends StatefulWidget {
  const _Option({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  State<_Option> createState() => _OptionState();
}

class _OptionState extends State<_Option> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          height: theme.dButtonHeight,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: theme.dTextfieldPadding),
          decoration: BoxDecoration(
            color: _hovered ? theme.cButtonHovered : null,
            borderRadius: BorderRadius.circular(theme.dButtonBorderRadius),
          ),
          child: NutriaText(text: widget.label),
        ),
      ),
    );
  }
}
