// The top menu bar with the logo, built from plain menu data.
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_menu_styles.dart';
import 'package:nutria_fmv_maker/ui/widgets/nutria_text.dart';

/// A top-level menu ("File", "Edit"…).
class NutriaMenu {
  const NutriaMenu({required this.title, required this.entries});

  final String title;
  final List<NutriaMenuEntry> entries;
}

/// A menu entry. Either an action ([onPressed]; `null` shows it disabled) or
/// a nested submenu ([children]).
class NutriaMenuEntry {
  const NutriaMenuEntry({
    required this.label,
    this.onPressed,
    this.shortcut,
    this.icon,
    this.children = const [],
  });

  final String label;
  final VoidCallback? onPressed;

  /// Shown next to the label only; the key binding itself lives in the app's
  /// shortcut table.
  final MenuSerializableShortcut? shortcut;
  final IconData? icon;
  final List<NutriaMenuEntry> children;
}

/// The menu bar. Clicking the logo calls [onLogoTap]; [onOpenChanged] reports
/// whether any menu is open, so the app can dim the canvas.
class NutriaMenuBar extends StatelessWidget {
  const NutriaMenuBar({
    super.key,
    required this.menus,
    this.onLogoTap,
    this.onOpenChanged,
  });

  final List<NutriaMenu> menus;
  final VoidCallback? onLogoTap;
  final ValueChanged<bool>? onOpenChanged;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final styles = NutriaMenuStyles(theme);
    return Theme(
      data: Theme.of(
        context,
      ).copyWith(menuTheme: MenuThemeData(style: styles.submenu)),
      child: Stack(
        children: [
          SizedBox(
            height: theme.dMenuBarHeight,
            width: double.infinity,
            child: MenuBar(
              style: styles.bar,
              children: [
                // Click target over the logo, which is drawn on top below.
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    // The box is empty, so it must catch clicks itself.
                    behavior: HitTestBehavior.opaque,
                    onTap: onLogoTap,
                    child: SizedBox(
                      width: theme.dMenuBarHeight * 2 - theme.dLogoPadding,
                      height: theme.dMenuBarHeight,
                    ),
                  ),
                ),
                for (final menu in menus)
                  SubmenuButton(
                    onOpen: () => onOpenChanged?.call(true),
                    onClose: () => onOpenChanged?.call(false),
                    style: styles.barButton,
                    menuChildren: [
                      for (final entry in menu.entries) _entry(entry, styles),
                    ],
                    child: NutriaText(
                      text: menu.title,
                      state: NutriaTextState.accented,
                    ),
                  ),
              ],
            ),
          ),
          Positioned(
            top: theme.dLogoPadding,
            left: theme.dLogoPadding,
            child: IgnorePointer(
              // The art is a silhouette with the face cut out, so the cut-outs
              // show what is behind it: themes whose menu bar is too light for
              // that give the logo a darker backing.
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.cLogoBadge,
                  borderRadius: BorderRadius.circular(theme.dPanelBorderRadius),
                ),
                child: SvgPicture.asset(
                  theme.logoAsset,
                  width: theme.dMenuBarHeight * 2.2,
                  height: (theme.dMenuBarHeight - theme.dLogoPadding) * 2,
                  colorFilter: ColorFilter.mode(
                    theme.cAccentButton,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _entry(NutriaMenuEntry entry, NutriaMenuStyles styles) {
    final label = Row(
      children: [
        if (entry.icon != null) Icon(entry.icon, size: 16),
        const SizedBox(width: 8),
        NutriaText(
          text: entry.label,
          state: entry.onPressed == null && entry.children.isEmpty
              ? NutriaTextState.inactive
              : NutriaTextState.accented,
        ),
      ],
    );
    if (entry.children.isNotEmpty) {
      return SubmenuButton(
        style: styles.item,
        menuChildren: [for (final c in entry.children) _entry(c, styles)],
        child: label,
      );
    }
    return MenuItemButton(
      style: styles.item,
      onPressed: entry.onPressed,
      shortcut: entry.shortcut,
      child: label,
    );
  }
}
