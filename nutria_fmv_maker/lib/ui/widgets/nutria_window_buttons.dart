// Minimize, maximize/restore and close, at the right end of the menu bar
// when the app draws its own title bar.
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_tooltip.dart';

/// What each window button says on hover.
typedef NutriaWindowLabels = ({
  String minimize,
  String maximize,
  String restore,
  String close,
});

/// The three window buttons, as tall as the menu bar. [isMaximized] picks
/// between maximize and restore.
class NutriaWindowButtons extends StatelessWidget {
  const NutriaWindowButtons({
    super.key,
    required this.isMaximized,
    required this.labels,
    required this.onMinimize,
    required this.onToggleMaximize,
    required this.onClose,
  });

  final bool isMaximized;
  final NutriaWindowLabels labels;
  final VoidCallback onMinimize;
  final VoidCallback onToggleMaximize;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      _WindowButton(
        icon: Icons.remove,
        tooltip: labels.minimize,
        onTap: onMinimize,
      ),
      _WindowButton(
        icon: isMaximized ? Icons.filter_none : Icons.crop_square,
        tooltip: isMaximized ? labels.restore : labels.maximize,
        onTap: onToggleMaximize,
        // The "restore" icon is drawn larger than the others.
        iconScale: isMaximized ? 0.8 : 1,
      ),
      _WindowButton(
        icon: Icons.close,
        tooltip: labels.close,
        onTap: onClose,
        isClose: true,
      ),
    ],
  );
}

class _WindowButton extends StatefulWidget {
  const _WindowButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.isClose = false,
    this.iconScale = 1,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final bool isClose;
  final double iconScale;

  @override
  State<_WindowButton> createState() => _WindowButtonState();
}

class _WindowButtonState extends State<_WindowButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final background = !_hovered
        ? Colors.transparent
        : (widget.isClose ? theme.cWindowClose : theme.cButtonHovered);
    final color = _hovered && widget.isClose
        ? theme.cOnWindowClose
        : theme.cMenuBarText;
    return NutriaTooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          child: Container(
            // The width of the system's buttons, relative to the bar.
            width: theme.dMenuBarHeight * 1.5,
            height: theme.dMenuBarHeight,
            color: background,
            child: Icon(
              widget.icon,
              size: theme.dTextHeight * widget.iconScale,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
