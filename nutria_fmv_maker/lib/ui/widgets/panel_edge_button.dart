// Tab on the window edge that appears on hover to reopen a closed panel.
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';
import 'package:nutria_fmv_maker/ui/theme/ui_constants.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_tooltip.dart';

/// The window edge a [PanelEdgeButton] sits on.
enum PanelEdge { left, right }

/// Positioned at the vertical center of the [side] edge of a [Stack].
/// Invisible until hovered; ignores input unless [enabled].
class PanelEdgeButton extends StatefulWidget {
  const PanelEdgeButton({
    super.key,
    required this.side,
    required this.enabled,
    required this.onTap,
    this.tooltip,
  });

  final PanelEdge side;
  final bool enabled;
  final VoidCallback onTap;
  final String? tooltip;

  @override
  State<PanelEdgeButton> createState() => _PanelEdgeButtonState();
}

class _PanelEdgeButtonState extends State<PanelEdgeButton> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final left = widget.side == PanelEdge.left;
    final round = Radius.circular(theme.dButtonBorderRadius);
    return Positioned(
      left: left ? 0 : null,
      right: left ? null : 0,
      top: 0,
      bottom: 0,
      child: AnimatedOpacity(
        duration: kBaseAnimation,
        curve: Curves.easeInOut,
        opacity: _hovered ? 1 : 0,
        child: IgnorePointer(
          ignoring: !widget.enabled,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => setState(() => _hovered = true),
            onExit: (_) => setState(() => _hovered = false),
            child: GestureDetector(
              onTapDown: (_) => setState(() => _pressed = true),
              onTapUp: (_) => setState(() => _pressed = false),
              onTapCancel: () => setState(() => _pressed = false),
              onTap: widget.onTap,
              child: Center(
                child: NutriaTooltip(
                  message: widget.tooltip,
                  child: Container(
                    height: theme.dButtonHeight,
                    width: theme.dButtonHeight / 2,
                    decoration: BoxDecoration(
                      color: _pressed
                          ? theme.cButtonPressed
                          : (_hovered ? theme.cButtonHovered : theme.cButton),
                      borderRadius: left
                          ? BorderRadius.horizontal(right: round)
                          : BorderRadius.horizontal(left: round),
                      boxShadow: theme.cardShadow(),
                    ),
                    child: Icon(
                      left ? Icons.arrow_right : Icons.arrow_left,
                      color: theme.cText,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
