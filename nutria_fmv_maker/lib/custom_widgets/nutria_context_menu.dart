import 'package:flutter/material.dart';
import 'package:nutria_fmv_maker/models/app_theme.dart';
import 'package:nutria_fmv_maker/models/node_data.dart';
import 'package:nutria_fmv_maker/static_data/ui_static_properties.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';

import '../providers/nodes_provider.dart';
import 'menu_bar_elements/menu_styles.dart';
import '../providers/theme_provider.dart';
import '../providers/ui_state_provider.dart';

class NutriaContextMenu extends StatefulWidget {
  final Widget? child;
  const NutriaContextMenu({super.key, this.child});

  @override
  State<NutriaContextMenu> createState() => _NutriaContextMenuState();
}

class _NutriaContextMenuState extends State<NutriaContextMenu>
    with WidgetsBindingObserver {
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    _removeContextMenu();
  }

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;
    final MenuStyles menuStyles = MenuStyles(theme: theme);

    return GestureDetector(
      onSecondaryTapUp: (details) {
        _showContextMenu(
          context,
          getAdjustedPosition(
              details.globalPosition, UiStaticProperties.contextMenuWidth, 150),
          details.localPosition,
          menuStyles.buttonStyleMenu,
        );
      },
      child: widget.child,
    );
  }

  Offset getAdjustedPosition(
      Offset position, double menuWidth, double menuHeight) {
    final Size windowSize = WidgetsBinding
            .instance.platformDispatcher.views.first.physicalSize /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

    double adjustedX = position.dx;
    double adjustedY = position.dy;

    // Adjust X position only if menu overflows and window is smaller than menu width
    if (adjustedX + menuWidth > windowSize.width &&
        menuWidth < windowSize.width) {
      adjustedX = windowSize.width - menuWidth;
    }

    // Adjust Y position only if menu overflows and window is smaller than menu height
    if (adjustedY + menuHeight > windowSize.height &&
        menuHeight < windowSize.height) {
      adjustedY = windowSize.height - menuHeight;
    }

    return Offset(adjustedX, adjustedY);
  }

  Uuid uuid = Uuid();

  void _showContextMenu(BuildContext context, Offset globalPosition,
      Offset localPosition, ButtonStyle buttonstyle) {
    final uiState = context.read<UiStateProvider>();

    var t = AppLocalizations.of(context)!;
    final AppTheme theme = context.read<ThemeProvider>().currentAppTheme;
    final nodesProvider = context.read<NodesProvider>();

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
            left: globalPosition.dx,
            top: globalPosition.dy,
            child: Container(
              width: UiStaticProperties.contextMenuWidth,
              decoration: BoxDecoration(
                color: theme.cPanel,
                border: Border.all(
                    color: theme.cOutlines, width: theme.dOutlinesWidth),
                borderRadius: BorderRadius.circular(theme.dPanelBorderRadius),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(theme.dPanelBorderRadius),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    MenuItemButton(
                      leadingIcon: Icon(Icons.videocam),
                      style: buttonstyle,
                      onPressed: () {
                        _removeContextMenu();
                        nodesProvider.addNode(VideoNodeData(
                            position: localPosition -
                                UiStaticProperties.topLeftToMiddle -
                                Offset(UiStaticProperties.nodePadding,
                                    UiStaticProperties.nodePadding),
                            id: uuid.v1(),
                            videoDataId: 'a'));
                      },
                      child: Text(t.contextSimpleVideoNode),
                    ),
                    MenuItemButton(
                      leadingIcon: Icon(Icons.video_call),
                      style: buttonstyle,
                      onPressed: () {},
                      child: Text(t.contextBranchingVideoNode),
                    ),
                    MenuItemButton(
                      leadingIcon: Icon(Icons.equalizer),
                      style: buttonstyle,
                      onPressed: () {},
                      child: Text(t.contextCompareNode),
                    ),
                    MenuItemButton(
                      leadingIcon: Icon(Icons.calculate),
                      style: buttonstyle,
                      onPressed: () {},
                      child: Text(t.contextMathNode),
                    ),
                    MenuItemButton(
                      leadingIcon: Icon(Icons.check_box_rounded),
                      style: buttonstyle,
                      onPressed: () {},
                      child: Text(t.contextSetNode),
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
        child: IgnorePointer(
            child: Container(
          color: Colors.transparent,
        )),
      ),
    );
  }
}
