import 'package:flutter/material.dart';
import 'package:nutria_fmv_maker/custom_widgets/menu_bar_elements/menu_data.dart';
import 'package:nutria_fmv_maker/custom_widgets/nutria_button.dart';
import 'package:nutria_fmv_maker/providers/ui_state_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:path/path.dart';

import 'menu_bar_elements/menu_styles.dart';
import 'menu_bar_elements/nutria_menu_button.dart';
import '../../static_data/ui_static_properties.dart';
import '../../models/app_theme.dart';

import 'package:provider/provider.dart';
import '../../../providers/theme_provider.dart';

class NutriaMenuBar extends StatelessWidget {
  final Widget child;
  const NutriaMenuBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;
    final UiStateProvider uiStateProvider = context.read<UiStateProvider>();
    final MenuStyles menuStyles = MenuStyles(theme: theme);
    final List<NutriaMenuButton> menuData = MenuData.menuData(context);
    // Create a map for the shortcut actions
    final Map<ShortcutActivator, VoidCallback> shortcutActions = {
      for (var menu in menuData)
        for (var submenu in menu.submenuButtons)
          if (submenu.shortcut != null) submenu.shortcut!: submenu.function,
    };
    
    return CallbackShortcuts(
      bindings: shortcutActions,
      child: Theme(
        data: Theme.of(context).copyWith(
          menuTheme: MenuThemeData(
            style: menuStyles.submenuStyle, // Apply _submenuStyle locally
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Focus(
              autofocus: true,
              child: MenuBar(
                style: menuStyles.menuStyle, // Apply menu bar style
                children: menuData.map((menu) {
                  return _buildMenuButton(menu, uiStateProvider, menuStyles);
                }).toList(),
              ),
            ),
            Expanded(
              child: ClipRRect(
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build menu buttons recursively
  Widget _buildMenuButton(
    NutriaMenuButton menu,
    UiStateProvider uiStateProvider,
    MenuStyles menuStyles,
  ) {
    return SubmenuButton(
      onOpen: () {
        uiStateProvider.setModalOrMenuOpen(true);
      },
      onClose: () {
        uiStateProvider.setModalOrMenuOpen(false);
      },
      onFocusChange: (_) {
        uiStateProvider.setModalOrMenuOpen(false);
      },
      style: menuStyles.buttonStyleBar, // Apply submenu button style
      child: Text(menu.title),
      menuChildren: menu.submenuButtons.map((submenu) {
        return _buildSubmenuButton(submenu, uiStateProvider, menuStyles);
      }).toList(),
    );
  }

  // Helper method to build submenu buttons recursively
  Widget _buildSubmenuButton(
    NutriaSubmenuButton submenu,
    UiStateProvider uiStateProvider,
    MenuStyles menuStyles,
  ) {
    if (submenu.submenuButtons != null && submenu.submenuButtons!.isNotEmpty) {
      // If there are nested submenu buttons, render another SubmenuButton
      return SubmenuButton(
        // onOpen: () {
        //   uiStateProvider.setModalOrMenuOpen(true);
        // },
        // onClose: () {
        //   uiStateProvider.setModalOrMenuOpen(false);
        // },
        onFocusChange: (_) {
          uiStateProvider.setModalOrMenuOpen(false);
        },
        style: menuStyles.buttonStyleMenu, // Apply submenu button style
        child: Row(
          children: [
            if (submenu.icon != null) Icon(submenu.icon, size: 16),
            const SizedBox(width: 8),
            Text(submenu.text),
          ],
        ),
        menuChildren: submenu.submenuButtons!.map((nestedSubmenu) {
          return _buildSubmenuButton(nestedSubmenu, uiStateProvider, menuStyles);
        }).toList(),
      );
    } else {
      // If there are no nested submenu buttons, render a MenuItemButton
      return MenuItemButton(
        style: menuStyles.buttonStyleMenu, // Apply menu item button style
        onPressed: submenu.function,
        shortcut: submenu.shortcut,
        child: Row(
          children: [
            if (submenu.icon != null) Icon(submenu.icon, size: 16),
            const SizedBox(width: 8),
            Text(submenu.text),
          ],
        ),
      );
    }
  }
}