// Right-click menu over any area, with items supplied by the caller.
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
  });

  final List<NutriaContextMenuItem> Function(Offset localPosition) itemsAt;
  final Widget child;

  /// Plain (left) click on the area.
  final VoidCallback? onTap;
  final ValueChanged<bool>? onOpenChanged;

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
    if (x + kContextMenuWidth > window.width && kContextMenuWidth < window.width) {
      x = window.width - kContextMenuWidth;
    }
    if (y + kContextMenuHeight > window.height &&
        kContextMenuHeight < window.height) {
      y = window.height - kContextMenuHeight;
    }
    return Offset(x, y);
  }

  void _open(TapUpDetails details) {
    _close();
    final items = widget.itemsAt(details.localPosition);
    if (items.isEmpty) return;
    final position = _fit(details.globalPosition);
    final theme = context.appTheme;
    final itemStyle = NutriaMenuStyles(theme).item;

    _entry = OverlayEntry(
      builder: (_) => Stack(children: [
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
                color: theme.cPanel,
                border:
                    Border.all(color: theme.cOutlines, width: theme.dOutlinesWidth),
                borderRadius: BorderRadius.circular(theme.dPanelBorderRadius),
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
                            text: item.label, state: NutriaTextState.accented),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
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

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: widget.onTap,
        onSecondaryTapUp: _open,
        child: widget.child,
      );
}
