// Right-click menu over any area, with items supplied by the caller.
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_menu_styles.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_text.dart';

/// One entry of a [NutriaContextMenuArea].
class NutriaContextMenuItem {
  const NutriaContextMenuItem({
    required IconData this.icon,
    required String this.label,
    required VoidCallback this.onSelected,
  });

  /// A thin line between groups of items.
  const NutriaContextMenuItem.divider()
    : icon = null,
      label = null,
      onSelected = null;

  final IconData? icon;
  final String? label;
  final VoidCallback? onSelected;

  bool get isDivider => onSelected == null;
}

/// Wraps [child]; right-clicking it opens a menu of the items [itemsAt]
/// returns for the click position (local to [child]). The menu closes on any
/// click elsewhere or when the window changes size.
class NutriaContextMenuArea extends StatefulWidget {
  const NutriaContextMenuArea({
    super.key,
    required this.itemsAt,
    required this.child,
    this.onTap,
    this.onOpenChanged,
    this.behavior = HitTestBehavior.deferToChild,
    this.fromPointerEvents = false,
  });

  final List<NutriaContextMenuItem> Function(Offset localPosition) itemsAt;
  final Widget child;

  /// Plain (left) click on the area.
  final VoidCallback? onTap;
  final ValueChanged<bool>? onOpenChanged;

  /// Use [HitTestBehavior.opaque] when [child] paints nothing itself.
  final HitTestBehavior behavior;

  /// Opens on raw pointer events instead of a gesture, for children that
  /// claim right-clicks themselves (text fields select text on them).
  final bool fromPointerEvents;

  @override
  State<NutriaContextMenuArea> createState() => _NutriaContextMenuAreaState();
}

class _NutriaContextMenuAreaState extends State<NutriaContextMenuArea>
    with WidgetsBindingObserver {
  OverlayEntry? _entry;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() => _close();

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _entry?.remove();
    super.dispose();
  }

  void _open(Offset localPosition, Offset globalPosition) {
    _close();
    final items = widget.itemsAt(localPosition);
    if (items.isEmpty) return;
    final position = globalPosition;
    final theme = context.appTheme;
    final itemStyle = NutriaMenuStyles(theme).item;

    _entry = OverlayEntry(
      builder: (_) => Stack(
        children: [
          // Any click outside the menu closes it and still reaches the app.
          Positioned.fill(
            child: Listener(
              behavior: HitTestBehavior.translucent,
              onPointerDown: (_) => _close(),
            ),
          ),
          // Opens at the click, moved in as needed to stay in the window.
          CustomSingleChildLayout(
            delegate: _InsideWindow(position),
            child: IntrinsicWidth(
              child: Container(
                decoration: BoxDecoration(
                  color: theme.cCard,
                  borderRadius: BorderRadius.circular(theme.dPanelBorderRadius),
                  boxShadow: theme.cardShadow(lifted: true),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(theme.dPanelBorderRadius),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final item in items)
                        if (item.isDivider)
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: theme.dPanelPadding / 2,
                            ),
                            child: Container(
                              height: theme.dDividerWidth,
                              color: theme.cDivider,
                            ),
                          )
                        else
                          MenuItemButton(
                            leadingIcon: Icon(item.icon),
                            style: itemStyle,
                            onPressed: () {
                              _close();
                              item.onSelected!();
                            },
                            child: NutriaText(
                              text: item.label!,
                              state: NutriaTextState.accented,
                            ),
                          ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    Overlay.of(context).insert(_entry!);
    widget.onOpenChanged?.call(true);
  }

  void _close() {
    final entry = _entry;
    if (entry == null) return;
    entry.remove();
    _entry = null;
    widget.onOpenChanged?.call(false);
  }

  /// Whether the pointer went down with the right button ([fromPointerEvents]).
  bool _secondaryDown = false;

  @override
  Widget build(BuildContext context) {
    if (widget.fromPointerEvents) {
      return Listener(
        behavior: widget.behavior,
        onPointerDown: (event) =>
            _secondaryDown = event.buttons & kSecondaryMouseButton != 0,
        onPointerUp: (event) {
          if (!_secondaryDown) return;
          _secondaryDown = false;
          _open(event.localPosition, event.position);
        },
        child: widget.child,
      );
    }
    return GestureDetector(
      behavior: widget.behavior,
      onTap: widget.onTap,
      onSecondaryTapUp: (details) =>
          _open(details.localPosition, details.globalPosition),
      child: widget.child,
    );
  }
}

/// Places the menu's top-left corner at [position], moved left or up just
/// enough for the whole menu to fit in the window.
class _InsideWindow extends SingleChildLayoutDelegate {
  const _InsideWindow(this.position);

  final Offset position;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      constraints.loosen();

  @override
  Offset getPositionForChild(Size size, Size childSize) => Offset(
    position.dx.clamp(0, math.max(0, size.width - childSize.width)),
    position.dy.clamp(0, math.max(0, size.height - childSize.height)),
  );

  @override
  bool shouldRelayout(_InsideWindow oldDelegate) =>
      oldDelegate.position != position;
}
