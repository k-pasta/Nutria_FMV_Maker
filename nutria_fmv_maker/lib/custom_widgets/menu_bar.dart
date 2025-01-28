import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/app_theme.dart';
import '../providers/theme_provider.dart';
import 'package:menu_bar/menu_bar.dart';

///returns material app!

class MyMenuBar extends StatefulWidget {
  final Widget child;
  const MyMenuBar({super.key, required this.child});

  @override
  State<MyMenuBar> createState() => _MyMenuBarState();
}

class _MyMenuBarState extends State<MyMenuBar> {
  Color _menuBarButtonColor = Color.fromRGBO(25, 25, 25, 0);
  List<BarButton> _menuBarButtons() {
    return [
      BarButton(
        text: const Text(
          'File',
          // style: TextStyle(color: Colors.white),
        ),
        submenu: SubMenu(
          menuItems: [
            MenuButton(
              onTap: () => print('Save'),
              text: const Text('Save'),
              shortcutText: 'Ctrl+S',
              shortcut:
                  const SingleActivator(LogicalKeyboardKey.keyS, control: true),
            ),
            MenuButton(
              onTap: () {},
              text: const Text('Save as'),
              shortcutText: 'Ctrl+Shift+S',
            ),
            const MenuDivider(),
            MenuButton(
              onTap: () {},
              text: const Text('Open File'),
            ),
            MenuButton(
              onTap: () {},
              text: const Text('Open Folder'),
            ),
            const MenuDivider(),
            MenuButton(
              text: const Text('Preferences'),
              icon: const Icon(Icons.settings),
              submenu: SubMenu(
                menuItems: [
                  MenuButton(
                    onTap: () {},
                    icon: const Icon(Icons.keyboard),
                    text: const Text('Shortcuts'),
                  ),
                  const MenuDivider(),
                  MenuButton(
                    onTap: () {},
                    icon: const Icon(Icons.extension),
                    text: const Text('Extensions'),
                  ),
                  const MenuDivider(),
                  MenuButton(
                    icon: const Icon(Icons.looks),
                    text: const Text('Change theme'),
                    submenu: SubMenu(
                      menuItems: [
                        MenuButton(
                          onTap: () {},
                          icon: const Icon(Icons.light_mode),
                          text: const Text('Light theme'),
                        ),
                        const MenuDivider(),
                        MenuButton(
                          onTap: () {},
                          icon: const Icon(Icons.dark_mode),
                          text: const Text('Dark theme'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const MenuDivider(),
            MenuButton(
              onTap: () {},
              shortcutText: 'Ctrl+Q',
              text: const Text('Exit'),
              icon: const Icon(Icons.exit_to_app),
            ),
          ],
        ),
      ),
      BarButton(
        text: const Text(
          'Edit',
          style: TextStyle(color: Colors.white),
        ),
        submenu: SubMenu(
          menuItems: [
            MenuButton(
              onTap: () {},
              text: const Text('Undo'),
              shortcutText: 'Ctrl+Z',
            ),
            MenuButton(
              onTap: () {},
              text: const Text('Redo'),
              shortcutText: 'Ctrl+Y',
            ),
            const MenuDivider(),
            MenuButton(
              onTap: () {},
              text: const Text('Cut'),
              shortcutText: 'Ctrl+X',
            ),
            MenuButton(
              onTap: () {},
              text: const Text('Copy'),
              shortcutText: 'Ctrl+C',
            ),
            MenuButton(
              onTap: () {},
              text: const Text('Paste'),
              shortcutText: 'Ctrl+V',
            ),
            const MenuDivider(),
            MenuButton(
              onTap: () {},
              text: const Text('Find'),
              shortcutText: 'Ctrl+F',
            ),
          ],
        ),
      ),
      BarButton(
        text: const Text(
          'Help',
          style: TextStyle(color: Colors.white),
        ),
        submenu: SubMenu(
          menuItems: [
            MenuButton(
              onTap: () {},
              text: const Text('Check for updates'),
            ),
            const MenuDivider(),
            MenuButton(
              onTap: () {},
              text: const Text('View License'),
            ),
            const MenuDivider(),
            MenuButton(
              onTap: () {},
              icon: const Icon(Icons.info),
              text: const Text('About'),
            ),
          ],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;

    // return MenuBar(children: [
    //   MenuItemButton(
    //     child: Text('hi'),
    //   )
    // ],);

    return MenuBarWidget(

        // Add a list of [BarButton]. The buttons in this List are
        // displayed as the buttons on the bar itself
        barButtons: _menuBarButtons(),

        // Style the menu bar itself. Hover over [MenuStyle] for all the options
        barStyle: MenuStyle(
          // surfaceTintColor: WidgetStatePropertyAll(Colors.amber),

          padding: WidgetStatePropertyAll(EdgeInsets.zero),
          backgroundColor: WidgetStatePropertyAll(theme.cMenuBar),
          // backgroundColor: WidgetStatePropertyAll(Colors.white),
          maximumSize: WidgetStatePropertyAll(
              Size(double.infinity, theme.dMenuBarHeight)),
          shape: WidgetStatePropertyAll<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.zero, // Removes circular borders
            ),
          ),
        ),

        // Style the menu bar buttons. Hover over [ButtonStyle] for all the options
        barButtonStyle: ButtonStyle(
          minimumSize: WidgetStatePropertyAll(Size(0, theme.dMenuBarHeight)),
          textStyle:
              WidgetStatePropertyAll(TextStyle(color: theme.cMenuBarText)),
          foregroundColor: WidgetStatePropertyAll(theme.cMenuBarText),
          // backgroundColor: WidgetStatePropertyAll(Colors.amberAccent),
          overlayColor: WidgetStatePropertyAll(theme.cPanel),

          padding:
              MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 20.0)),
          // minimumSize: MaterialStatePropertyAll(Size(0.0, 0.0)),
          // backgroundBuilder: (_,__,___){return Placeholder();}
        ),

        // Style the menu and submenu buttons. Hover over [ButtonStyle] for all the options
        menuButtonStyle: ButtonStyle(
          shape: WidgetStatePropertyAll<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.zero, // Removes circular borders
            ),
          ),
          // textStyle: WidgetStatePropertyAll(TextStyle(color: theme.cMenuBarText)),
          foregroundColor: WidgetStatePropertyAll(theme.cMenuBarText),
          iconColor: WidgetStatePropertyAll(theme.cMenuBarText),
          overlayColor: WidgetStatePropertyAll(theme.cAccentButtonHovered),
          minimumSize: MaterialStatePropertyAll(Size.fromHeight(36.0)),
          padding: WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0)),
        ),

        // Enable or disable the bar
        enabled: true,

        // Set the child, i.e. the application under the menu bar
        child: widget.child);
  }
}
