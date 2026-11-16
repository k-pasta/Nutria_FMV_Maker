// Square theme button: plain, icon, or left/right stepper.
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';

/// A square button of the theme's button height with hover and press states.
///
/// - [NutriaButton.new]: shows [child].
/// - [NutriaButton.icon]: shows [icon].
/// - [NutriaButton.leftRight]: a stepper; clicking the left or right half
///   calls [onTapLeft] or [onTapRight].
///
/// When [isActive] is false the button is transparent and ignores clicks.
class NutriaButton extends StatefulWidget {
  const NutriaButton({
    super.key,
    required VoidCallback this.onTap,
    this.child,
    this.isAccented = false,
    this.isActive = true,
  })  : icon = null,
        iconScale = 0.65,
        onTapLeft = null,
        onTapRight = null;

  const NutriaButton.icon({
    super.key,
    required VoidCallback this.onTap,
    required IconData this.icon,
    this.isAccented = false,
    this.isActive = true,
    this.iconScale = 0.65,
  })  : child = null,
        onTapLeft = null,
        onTapRight = null;

  const NutriaButton.leftRight({
    super.key,
    required VoidCallback this.onTapLeft,
    required VoidCallback this.onTapRight,
    this.child,
    this.isAccented = false,
    this.isActive = true,
  })  : onTap = null,
        icon = null,
        iconScale = 0.65;

  final VoidCallback? onTap;
  final VoidCallback? onTapLeft;
  final VoidCallback? onTapRight;
  final Widget? child;
  final IconData? icon;

  /// Icon size relative to the button height.
  final double iconScale;
  final bool isAccented;
  final bool isActive;

  bool get _isStepper => onTapLeft != null;

  @override
  State<NutriaButton> createState() => _NutriaButtonState();
}

enum _Side { none, left, right }

class _NutriaButtonState extends State<NutriaButton> {
  bool _hovered = false;
  bool _pressed = false;
  _Side _hoverSide = _Side.none;

  _Side _sideOf(Offset local) {
    final width = context.size?.width ?? 0;
    return local.dx < width / 2 ? _Side.left : _Side.right;
  }

  Color _background(AppTheme theme) {
    if (!widget.isActive) return Colors.transparent;
    if (_pressed) {
      return widget.isAccented ? theme.cAccentButtonPressed : theme.cButtonPressed;
    }
    if (_hovered) {
      return widget.isAccented ? theme.cAccentButtonHovered : theme.cButtonHovered;
    }
    return widget.isAccented ? theme.cAccentButton : theme.cButton;
  }

  Color _arrowColor(AppTheme theme, _Side side) {
    if (_hoverSide == side) return theme.cText;
    if (_hoverSide != _Side.none) return theme.cTextInactive;
    return theme.cButtonContentUnhovered;
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final active = widget.isActive;
    return MouseRegion(
      // Only the rounded box takes hits, not the corners outside it.
      hitTestBehavior: HitTestBehavior.deferToChild,
      cursor: active ? SystemMouseCursors.click : MouseCursor.defer,
      onEnter: (_) => setState(() => _hovered = active),
      onHover: (e) {
        final side = _sideOf(e.localPosition);
        if (side != _hoverSide) setState(() => _hoverSide = side);
      },
      onExit: (_) => setState(() {
        _hovered = false;
        _pressed = false;
        _hoverSide = _Side.none;
      }),
      child: GestureDetector(
        behavior: HitTestBehavior.deferToChild,
        onTapDown: active ? (_) => setState(() => _pressed = true) : null,
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: active
            ? (details) {
                setState(() => _pressed = false);
                if (widget._isStepper) {
                  _sideOf(details.localPosition) == _Side.left
                      ? widget.onTapLeft!()
                      : widget.onTapRight!();
                } else {
                  widget.onTap!();
                }
              }
            : null,
        child: Container(
          height: theme.dButtonHeight,
          constraints: BoxConstraints(
              minWidth: theme.dButtonHeight, minHeight: theme.dButtonHeight),
          decoration: BoxDecoration(
            color: _background(theme),
            borderRadius: BorderRadius.circular(theme.dButtonBorderRadius),
          ),
          child: IgnorePointer(
            // Centered, and only as wide as the content needs: a Center
            // would stretch icon buttons to the full width they're offered.
            child: Stack(alignment: Alignment.center, children: [
              if (widget._isStepper) ...[
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: -theme.dButtonHeight / 5,
                  child: Icon(Icons.arrow_left,
                      size: theme.dButtonHeight,
                      color: _arrowColor(theme, _Side.left)),
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  right: -theme.dButtonHeight / 5,
                  child: Icon(Icons.arrow_right,
                      size: theme.dButtonHeight,
                      color: _arrowColor(theme, _Side.right)),
                ),
              ],
              ?widget.child,
              if (widget.icon != null)
                Icon(
                  widget.icon,
                  size: theme.dButtonHeight * widget.iconScale,
                  color: !active
                      ? theme.cTextInactive
                      : widget.isAccented
                          ? theme.cOnAccent
                          : _hovered
                              ? theme.cText
                              : theme.cButtonContentUnhovered,
                ),
            ]),
          ),
        ),
      ),
    );
  }
}
