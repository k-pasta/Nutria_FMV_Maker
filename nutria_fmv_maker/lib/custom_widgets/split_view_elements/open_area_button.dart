
import 'package:flutter/material.dart';
import 'package:nutria_fmv_maker/static_data/data_static_properties.dart';
import 'package:provider/provider.dart';

import '../../models/app_theme.dart';
import '../../models/enums_ui.dart';
import '../../providers/ui_state_provider.dart';
import '../../providers/theme_provider.dart';

class OpenAreaButton extends StatefulWidget {
  final AreaSide area;
  final double totalWidth;
  const OpenAreaButton(
      {super.key, required this.area, required this.totalWidth});

  @override
  State<OpenAreaButton> createState() => _OpenAreaButtonState();
}


class _OpenAreaButtonState extends State<OpenAreaButton> {
  bool _isHovered = false;
  bool _isClicked = false;
  bool _isActive = false;
  @override
  Widget build(BuildContext context) {
    final UiStateProvider uiProvider =
        Provider.of<UiStateProvider>(context, listen: false);
    final bool _isleftSide = widget.area == AreaSide.left;
    _isActive =
        _isleftSide ? uiProvider.isLeftClosed : uiProvider.isRightClosed;
    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;
    return Positioned(
      left: _isleftSide ? 0 : null,
      right: !_isleftSide ? 0 : null,
      top: 0,
      bottom: 0,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: DataStaticProperties.baseAnimationTimeInMs),
        curve: Curves.easeInOut,
        opacity: (_isHovered) ? 1.0 : 0.0,
        child: IgnorePointer(
          ignoring: !_isActive,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) {
              setState(() {
                _isHovered = true;
              });
            },
            onExit: (_) {
              setState(() {
                _isHovered = false;
              });
            },
            child: GestureDetector(
              onTapDown: (_) {
                setState(() {
                  _isClicked = true;
                });
              },
              onTapUp: (_) {
                setState(() {
                  _isClicked = false;
                });
              },
              onTap: () {
                _isleftSide
                    ? uiProvider.openLeft(totalWidth: widget.totalWidth)
                    : uiProvider.openRight(totalWidth: widget.totalWidth);
                uiProvider.updateIntended(widget.area);
              },
              child: Container(
                height: theme.dButtonHeight,
                width: theme.dButtonHeight / 2,
                decoration: BoxDecoration(
                    color: _isClicked
                        ? theme.cButtonPressed
                        : (_isHovered ? theme.cButtonHovered : theme.cButton),
                    borderRadius: BorderRadius.only(
                      topRight: _isleftSide
                          ? Radius.circular(theme.dButtonBorderRadius)
                          : Radius.zero,
                      bottomRight: _isleftSide
                          ? Radius.circular(theme.dButtonBorderRadius)
                          : Radius.zero,
                      topLeft: !_isleftSide
                          ? Radius.circular(theme.dButtonBorderRadius)
                          : Radius.zero,
                      bottomLeft: !_isleftSide
                          ? Radius.circular(theme.dButtonBorderRadius)
                          : Radius.zero,
                    ),
                    border: Border(
                      top: BorderSide(
                          color: theme.cOutlines, width: theme.dOutlinesWidth),
                      bottom: BorderSide(
                          color: theme.cOutlines, width: theme.dOutlinesWidth),
                      right: _isleftSide
                          ? BorderSide(
                              color: theme.cOutlines,
                              width: theme.dOutlinesWidth)
                          : BorderSide.none,
                      left: !_isleftSide
                          ? BorderSide(
                              color: theme.cOutlines,
                              width: theme.dOutlinesWidth)
                          : BorderSide.none,
                    )),
                child: Icon(
                  _isleftSide ? Icons.arrow_right : Icons.arrow_left,
                  color: theme.cText,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}