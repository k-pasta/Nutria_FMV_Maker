// Inline dropdown that expands downwards inside its parent (not an overlay).
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';
import 'package:nutria_fmv_maker/ui/theme/ui_constants.dart';

/// One choice of a [NutriaDropdown].
class NutriaDropdownOption {
  const NutriaDropdownOption({required this.icon, required this.text});

  final IconData icon;
  final String text;
}

/// Shows the option at [selectedIndex]; clicking it reveals the others.
/// Picking one calls [onSelected]; the caller updates [selectedIndex].
class NutriaDropdown extends StatefulWidget {
  const NutriaDropdown({
    super.key,
    required this.options,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<NutriaDropdownOption> options;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  State<NutriaDropdown> createState() => _NutriaDropdownState();
}

class _NutriaDropdownState extends State<NutriaDropdown>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: kShortAnimation,
  );
  late final Animation<double> _expansion = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOut,
  );
  bool _expanded = false;

  void _setExpanded(bool expanded) {
    setState(() => _expanded = expanded);
    expanded ? _controller.forward() : _controller.reverse();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: theme.cCard,
        borderRadius: BorderRadius.circular(theme.dPanelBorderRadius),
        boxShadow: theme.cardShadow(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _HoverItem(
            option: widget.options[widget.selectedIndex],
            header: true,
            expanded: _expanded,
            onTap: () => _setExpanded(!_expanded),
          ),
          SizeTransition(
            sizeFactor: _expansion,
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < widget.options.length; i++)
                  if (i != widget.selectedIndex)
                    _HoverItem(
                      option: widget.options[i],
                      onTap: () {
                        _setExpanded(false);
                        widget.onSelected(i);
                      },
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HoverItem extends StatefulWidget {
  const _HoverItem({
    required this.option,
    required this.onTap,
    this.header = false,
    this.expanded = false,
  });

  final NutriaDropdownOption option;
  final VoidCallback onTap;

  /// The always-visible top row, with the arrow.
  final bool header;
  final bool expanded;

  @override
  State<_HoverItem> createState() => _HoverItemState();
}

class _HoverItemState extends State<_HoverItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final highlighted = _hovered || widget.expanded;
    final foreground = widget.header || highlighted
        ? theme.cTextActive
        : theme.cText;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          color: highlighted ? theme.cCardHovered : theme.cCard,
          padding: EdgeInsets.symmetric(
            horizontal: theme.dSectionPadding,
            vertical: theme.dPanelPadding,
          ),
          child: Row(
            children: [
              Icon(widget.option.icon, color: foreground),
              SizedBox(width: theme.dPanelPadding),
              Expanded(
                child: Text(
                  widget.option.text,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: foreground),
                ),
              ),
              if (widget.header)
                Icon(
                  widget.expanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: theme.cTextActive,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
