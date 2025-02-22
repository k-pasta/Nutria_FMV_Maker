import 'package:flutter/material.dart';
import 'package:nutria_fmv_maker/models/app_theme.dart';
import 'package:provider/provider.dart';

import 'custom_widgets/menu_bar_elements/menu_styles.dart';
import 'providers/theme_provider.dart';
import 'providers/ui_state_provider.dart';

class RightClickMenuExample extends StatefulWidget {
  @override
  _RightClickMenuExampleState createState() => _RightClickMenuExampleState();
}

class _RightClickMenuExampleState extends State<RightClickMenuExample> {
  OverlayEntry? _overlayEntry;

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;
    final MenuStyles menuStyles = MenuStyles(theme: theme);

    return Scaffold(
      appBar: AppBar(
          title: ElevatedButton(
              onPressed: () {
                print('button pressed');
              },
              child: Text('Right Click Context Menu'))),
      body: Center(
        child: GestureDetector(
          onSecondaryTapUp: (details) => _showContextMenu(
              context, details.globalPosition, menuStyles.buttonStyleMenu),
          child: Container(
            padding: EdgeInsets.all(20),
            color: Colors.blueAccent,
            child: Text(
              'Right-click on me',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }

  void _showContextMenu(
      BuildContext context, Offset position, ButtonStyle buttonstyle) {
    final uiState = context.read<UiStateProvider>();

    final AppTheme theme = context.read<ThemeProvider>().currentAppTheme;

    _removeContextMenu(); // Ensure any previous menu is removed
    uiState.setContextMenuOpen(true);

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Background tap detector
          ContextMenuDimmer(
            removeContextMenu: _removeContextMenu,
          ),
          // Context menu
          Positioned(
            left: position.dx,
            top: position.dy,
            child: Container(
              width: 150,
              decoration: BoxDecoration(
                  color: theme.cPanel,
                  border: Border.all(
                      color: theme.cOutlines, width: theme.dOutlinesWidth),
                  borderRadius:
                      BorderRadius.circular(theme.dPanelBorderRadius)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(theme.dPanelBorderRadius),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    MenuItemButton(
                      leadingIcon: Icon(Icons.videocam),
                      style: buttonstyle,
                      onPressed: () => _onMenuItemPressed(context, 'Option 1'),
                      child: Text('Option 1'),
                    ),
                    MenuItemButton(
                      leadingIcon: Icon(Icons.video_call),
                      style: buttonstyle,
                      onPressed: () => _onMenuItemPressed(context, 'Option 2'),
                      child: Text('Option 2'),
                    ),
                    MenuItemButton(
                      leadingIcon: Icon(Icons.multiple_stop),
                      style: buttonstyle,
                      onPressed: () => _onMenuItemPressed(context, 'Option 3'),
                      child: Text('Option 3'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _onMenuItemPressed(BuildContext context, String option) {
    _removeContextMenu();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Selected: $option')));
  }

  void _removeContextMenu() {
    final uiState = context.read<UiStateProvider>();
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
      uiState.setContextMenuOpen(false);
    }
  }
}

///Dimmer for left click
class ContextMenuDimmer extends StatelessWidget {
  final VoidCallback removeContextMenu;

  const ContextMenuDimmer({
    super.key,
    required this.removeContextMenu,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Listener(
        behavior: HitTestBehavior
            .translucent, // Ensure events reach underlying widgets
        onPointerDown: (event) {
          removeContextMenu();
        },
        // child: Container(color: Colors.black12,),
      ),
    );
  }
}
