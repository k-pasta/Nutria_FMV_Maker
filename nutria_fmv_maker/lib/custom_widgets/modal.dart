import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_theme.dart';
import '../providers/theme_provider.dart';
import '../providers/ui_state_provider.dart';

class Modal extends StatelessWidget {
  const Modal({
    super.key,
    this.child,
  });
 final Widget? child;

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 450,
          // maxHeight: 350,
        ),
        child: IntrinsicHeight(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: theme.cPanel,
                      borderRadius: BorderRadius.circular(
                          theme.dPanelBorderRadius),
                      border: Border.all(
                        color: theme.cOutlines,
                        width: theme.dSectionOutlineWidth,
                      )),
                  padding:
                      EdgeInsets.all(theme.dSectionPadding * 3),
                  child: child,
                ),
                //close button
                Positioned(
                    right: theme.dSectionPadding * 2,
                    top: theme.dSectionPadding * 2,
                    child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            context.read<UiStateProvider>().isModalInfoOpen = false;
                          },
                          child: Icon(
                            Icons.close,
                            color: theme.cTextInactive,
                            size: 25,
                          ),
                        )))
              ],
            ),
          ),
        ),
      ),
    );
  }
}