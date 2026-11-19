// Material menu styles derived from the AppTheme.
import 'package:material_ui/material_ui.dart';
import 'package:nutria_fmv_maker/ui/theme/app_theme.dart';

/// Styles for [MenuBar], submenus and menu items.
class NutriaMenuStyles {
  NutriaMenuStyles(AppTheme theme)
    : bar = MenuStyle(
        backgroundColor: WidgetStatePropertyAll(theme.cMenuBar),
        // Material's bar is raised; its shadow ended where the menus end and
        // made the bar look split in two.
        elevation: const WidgetStatePropertyAll(0),
        shadowColor: const WidgetStatePropertyAll(Colors.transparent),
        surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
        shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(side: BorderSide.none),
        ),
      ),
      submenu = MenuStyle(
        backgroundColor: WidgetStatePropertyAll(theme.cCard),
        surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
        shadowColor: WidgetStatePropertyAll(theme.cShadow),
        elevation: const WidgetStatePropertyAll(8),
        shape: WidgetStatePropertyAll<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(theme.dPanelBorderRadius),
          ),
        ),
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(vertical: theme.dSectionPadding * 1.6),
        ),
      ),
      barButton = ButtonStyle(
        overlayColor: WidgetStatePropertyAll(theme.cButtonHovered),
        foregroundColor: WidgetStatePropertyAll(theme.cMenuBarText),
        fixedSize: WidgetStatePropertyAll(
          Size.fromHeight(theme.dMenuBarHeight),
        ),
      ),
      item = ButtonStyle(
        // Unavailable entries grey out their icon along with their text.
        iconColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.disabled)
              ? theme.cTextInactive
              : theme.cAccent,
        ),
        overlayColor: WidgetStatePropertyAll(theme.cButtonHovered),
        foregroundColor: WidgetStatePropertyAll(theme.cMenuBarText),
        shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(side: BorderSide.none),
        ),
      );

  /// The menu bar itself.
  final MenuStyle bar;

  /// Drop-down menus opened from the bar.
  final MenuStyle submenu;

  /// Top-level buttons on the bar.
  final ButtonStyle barButton;

  /// Entries inside menus (also the context menu).
  final ButtonStyle item;
}
