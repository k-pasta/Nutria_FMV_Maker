import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nutria_fmv_maker/custom_widgets/nutria_button.dart';
import 'package:nutria_fmv_maker/providers/ui_state_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'menu_bar_elements/nutria_menu_button.dart';
import '../../static_data/ui_static_properties.dart';
import '../../models/app_theme.dart';

import 'package:provider/provider.dart';
import '../../../providers/theme_provider.dart';

class NutriaMenuBar extends StatelessWidget {
  final Widget child;

  NutriaMenuBar({super.key, required this.child});

  List<NutriaMenuButton> menuData(BuildContext context) {
    return [
      NutriaMenuButton(
        title: "File",
        submenuButtons: [
          NutriaSubmenuButton(
            text: "${AppLocalizations.of(context)!.videoNodeChoice}",
            function: () {},
            icon: Icons.create_new_folder,
          ),
          NutriaSubmenuButton(
            text: "Open File",
            function: () => debugPrint("Open File selected"),
            shortcut: SingleActivator(LogicalKeyboardKey.keyO, control: true),
            icon: Icons.folder_open,
          ),
          NutriaSubmenuButton(
            text: "Save File",
            function: () => debugPrint("Save File selected"),
            shortcut: SingleActivator(LogicalKeyboardKey.keyS, control: true),
            icon: Icons.save,
          ),
        ],
      ),
      NutriaMenuButton(
        title: "Edit",
        submenuButtons: [
          NutriaSubmenuButton(
            text: "Cut",
            function: () => debugPrint("Cut selected"),
            icon: Icons.cut,
          ),
          NutriaSubmenuButton(
            text: "Copy",
            function: () => debugPrint("Copy selected"),
            icon: Icons.copy,
          ),
          NutriaSubmenuButton(
            text: "Paste",
            function: () => debugPrint("Paste selected"),
            icon: Icons.paste,
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;
    final UiStateProvider uiStateProvider = context.read<UiStateProvider>();
    final MenuStyles menuStyles = MenuStyles(theme: theme);
    // Create a map for the shortcut actions
    final Map<ShortcutActivator, VoidCallback> shortcutActions = {
      for (var menu in menuData(context))
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
                children: menuData(context).map((menu) {
                  return SubmenuButton(
                    onOpen: () {
                      uiStateProvider.isModalOrMenuOpen = true;
                    },
                    onClose: () {
                      uiStateProvider.isModalOrMenuOpen = false;
                    },
                    onFocusChange: (_) {
                      print('focus change');
                    },
                    style:
                        menuStyles.buttonStyleBar, // Apply submenu button style
                    child: Text(menu.title),
                    menuChildren: menu.submenuButtons.map((submenu) {
                      return MenuItemButton(
                        style: menuStyles
                            .buttonStyleMenu, // Apply menu item button style
                        onPressed: submenu.function,
                        shortcut: submenu.shortcut,
                        child: Row(
                          children: [
                            if (submenu.icon != null)
                              Icon(submenu.icon, size: 16),
                            const SizedBox(width: 8),
                            Text(submenu.text),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                }).toList(),
              ),
            ),
            Expanded(
              child: ClipRRect(
                // clipBehavior: Clip.hardEdge,
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuStyles {
  final AppTheme theme;

  late final MenuStyle menuStyle;
  late final MenuStyle submenuStyle;
  late final ButtonStyle buttonStyleBar;
  late final ButtonStyle buttonStyleMenu;

  MenuStyles({required this.theme}) {
    menuStyle = MenuStyle(
      backgroundColor: WidgetStatePropertyAll(theme.cMenuBar),
      shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(side: BorderSide.none)),
    );
    submenuStyle = MenuStyle(
      backgroundColor: WidgetStatePropertyAll(theme.cPanel),
      shape: const WidgetStatePropertyAll<OutlinedBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 0, vertical: 16),
      ),
    );
    buttonStyleBar = ButtonStyle(
      overlayColor: WidgetStatePropertyAll(theme.cPanel),
      foregroundColor: WidgetStatePropertyAll(theme.cMenuBarText),
    );
    buttonStyleMenu = ButtonStyle(
      iconColor: WidgetStatePropertyAll(theme.cAccent),
      overlayColor: WidgetStatePropertyAll(theme.cAccentButtonHovered),
      foregroundColor: WidgetStatePropertyAll(theme.cMenuBarText),
      shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(side: BorderSide.none)),
    );
  }
}
