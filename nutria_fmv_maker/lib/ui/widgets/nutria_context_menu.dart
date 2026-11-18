// Right-click menu over any area, with items supplied by the caller.
import 'package:flutter/gestures.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';
import 'package:nutria_fmv_maker/ui/theme/ui_constants.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_menu_styles.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_text.dart';

/// One entry of a [NutriaContextMenuArea].
class NutriaContextMenuItem {
  const NutriaContextMenuItem({
    required this.icon,
    required this.label,
    required this.onSelected,
  });

  final IconData icon;
  final String label;
  final VoidCallback onSelected;
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

  /// Keeps the menu inside the window when opened near its edge.
  Offset _fit(Offset position) {
    final window = MediaQuery.sizeOf(context);
    var x = position.dx;
    var y = position.dy;
    if (x + kContextMenuWidth > window.width &&
        kContextMenuWidth < window.width) {
      x = window.width - kContextMenuWidth;
    }
    if (y + kContextMenuHeight > window.height &&
        kContextMenuHeight < window.height) {
      y = window.height - kContextMenuHeight;
    }
    return Offset(x, y);
  }

  void _open(Offset localPosition, Offset globalPosition) {
    _close();
    final items = widget.itemsAt(localPosition);
    if (items.isEmpty) return;
    final position = _fit(globalPosition);
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
          Positioned(
            left: position.dx,
            top: position.dy,
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
                        MenuItemButton(
                          leadingIcon: Icon(item.icon),
                          style: itemStyle,
                          onPressed: () {
                            _close();
                            item.onSelected();
                          },
                          child: NutriaText(
                            text: item.label,
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
