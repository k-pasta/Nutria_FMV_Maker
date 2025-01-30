import 'package:flutter/material.dart';

class MenuExample extends StatefulWidget {
  const MenuExample({super.key});

  @override
  State<MenuExample> createState() => _MenuExampleState();
}

class CustomMenuController extends MenuController with ChangeNotifier {
  
}

class _MenuExampleState extends State<MenuExample> {
  final MenuController _menuController = MenuController();
  bool _isMenuOpen = false;

  @override
  void initState() {
    super.initState();
  }
  //   // Listen for menu state changes
  //   _menuController.addListener(() {
  //     setState(() {
  //       _isMenuOpen = _menuController.isOpen;
  //     });
  //   });
  // }

  // @override
  // void dispose() {
  //   _menuController.removeListener(() {});
  //   _menuController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Menu Controller Example")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MenuAnchor(
              
              controller: _menuController,
              builder: (BuildContext context, MenuController controller,
                  Widget? child) {
                return ElevatedButton(
                  onPressed: () {
                    if (controller.isOpen) {
                      setState(() {
                        controller.close();
                      });
                    } else {
                      setState(() {
                        controller.open();
                      });
                    }
                  },
                  child: const Text("Open Menu"),
                );
              },
              menuChildren: [
                MenuItemButton(
                  onPressed: () => print("Item 1 clicked"),
                  child: const Text("Item 1"),
                ),
                MenuItemButton(
                  onPressed: () => print("Item 2 clicked"),
                  child: const Text("Item 2"),
                ),
                MenuItemButton(
                  onPressed: () => print("Item 3 clicked"),
                  child: const Text("Item 3"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              _menuController.isOpen ? "Menu is Open" : "Menu is Closed",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
