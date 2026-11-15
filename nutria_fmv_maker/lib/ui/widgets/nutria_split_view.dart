// Three-column layout with draggable dividers and collapsible side panels.
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';
import 'package:nutria_fmv_maker/ui/widgets/panel_edge_button.dart';

/// Which side panel a callback refers to.
enum SplitSide { left, right }

/// Left panel | center | right panel. Widths and open state come from the
/// caller, which also decides what dragging a divider does.
class NutriaSplitView extends StatefulWidget {
  const NutriaSplitView({
    super.key,
    required this.leftWidth,
    required this.rightWidth,
    required this.leftOpen,
    required this.rightOpen,
    required this.onDividerDrag,
    required this.onDividerDragEnd,
    required this.onOpenRequested,
    required this.onWindowResized,
    this.handleWidth = 10,
    this.left,
    this.center,
    this.right,
  });

  final double leftWidth;
  final double rightWidth;
  final bool leftOpen;
  final bool rightOpen;
  final double handleWidth;
  final Widget? left;
  final Widget? center;
  final Widget? right;

  /// A divider was dragged by `dx` pixels in a view `totalWidth` wide.
  final void Function(SplitSide side, double dx, double totalWidth) onDividerDrag;

  /// The user let go of the divider next to `side`.
  final void Function(SplitSide side) onDividerDragEnd;

  /// The edge button of a closed panel was clicked.
  final void Function(SplitSide side, double totalWidth) onOpenRequested;

  /// The window got `dx` pixels narrower and is now `totalWidth` wide.
  final void Function(double dx, double totalWidth) onWindowResized;

  @override
  State<NutriaSplitView> createState() => _NutriaSplitViewState();
}

class _NutriaSplitViewState extends State<NutriaSplitView> {
  double? _lastWidth;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    return LayoutBuilder(builder: (context, constraints) {
      final total = constraints.maxWidth;
      final last = _lastWidth;
      if (last != null && last != total) {
        // Report after the frame: providers can't change during build.
        WidgetsBinding.instance.addPostFrameCallback(
            (_) => widget.onWindowResized(last - total, total));
      }
      _lastWidth = total;

      Widget divider(SplitSide side, bool open) => GestureDetector(
            onHorizontalDragUpdate: (d) =>
                widget.onDividerDrag(side, d.delta.dx, total),
            onHorizontalDragEnd: (_) => widget.onDividerDragEnd(side),
            child: MouseRegion(
              cursor: SystemMouseCursors.resizeLeftRight,
              child: Container(
                width: open ? widget.handleWidth : 0,
                decoration: BoxDecoration(
                  color: theme.cPanel,
                  border: Border(
                    left: side == SplitSide.right
                        ? BorderSide(
                            color: theme.cOutlines,
                            width: theme.dSectionOutlineWidth)
                        : BorderSide.none,
                    right: side == SplitSide.left
                        ? BorderSide(
                            color: theme.cOutlines,
                            width: theme.dSectionOutlineWidth)
                        : BorderSide.none,
                  ),
                ),
              ),
            ),
          );

      Widget panel(double width, bool open, Widget? child) => Offstage(
            offstage: !open,
            child: Container(
                width: width,
                height: double.infinity,
                color: theme.cPanel,
                child: child),
          );

      return Stack(children: [
        Row(children: [
          panel(widget.leftWidth, widget.leftOpen, widget.left),
          divider(SplitSide.left, widget.leftOpen),
          Expanded(child: widget.center ?? const SizedBox.expand()),
          divider(SplitSide.right, widget.rightOpen),
          panel(widget.rightWidth, widget.rightOpen, widget.right),
        ]),
        PanelEdgeButton(
          side: PanelEdge.left,
          enabled: !widget.leftOpen,
          onTap: () => widget.onOpenRequested(SplitSide.left, total),
        ),
        PanelEdgeButton(
          side: PanelEdge.right,
          enabled: !widget.rightOpen,
          onTap: () => widget.onOpenRequested(SplitSide.right, total),
        ),
      ]);
    });
  }
}
