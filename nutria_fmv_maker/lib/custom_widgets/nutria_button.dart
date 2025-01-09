import 'package:flutter/material.dart';
import 'package:nutria_fmv_maker/models/app_theme.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class NutriaButton extends StatefulWidget {
  final Widget? child;
  final bool isAccented;
  final bool isActive;
  final VoidCallback onTap;
  final VoidCallback onTapRight;
  final VoidCallback onTapLeft;

  final bool _isLeftRight;
  static void _defaultOnTap() {
    print('default');
  }

  const NutriaButton({
    super.key,
    required this.onTap,
    this.child,
    this.isAccented = false,
    this.isActive = true,
  })  : onTapLeft = _defaultOnTap,
        onTapRight = _defaultOnTap,
        _isLeftRight = false;

  const NutriaButton.leftRight({
    super.key,
    required this.onTapLeft,
    required this.onTapRight,
    this.child,
    this.isAccented = false,
    this.isActive = true,
  })  : onTap = _defaultOnTap,
        _isLeftRight = true;

  @override
  State<NutriaButton> createState() => _NutriaButtonState();
}

class _NutriaButtonState extends State<NutriaButton> {
  late ButtonState buttonState;

  @override
  void initState() {
    super.initState();
    // Initialize buttonColor based on the current widget state
    buttonState = ButtonState(
        isAccented: widget.isAccented,
        isActive: widget.isActive,
        buttonStateType: ButtonStateType.normal);
  }

  Color getColor(ButtonState buttonState, AppTheme theme) {
    switch (buttonState.buttonStateType) {
      case ButtonStateType.hovered:
        return buttonState.isAccented
            ? theme.cAccentButtonHovered
            : theme.cButtonHovered;
      case ButtonStateType.pressed:
        return buttonState.isAccented
            ? theme.cAccentButtonPressed
            : theme.cButtonPressed;
      case ButtonStateType.normal:
        return buttonState.isAccented ? theme.cAccentButton : theme.cButton;
      // default: theme.cButton;
      // return theme.cButton;
    }
  }

  // Update button state if widget properties change
  @override
  void didUpdateWidget(covariant NutriaButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isAccented != widget.isAccented ||
        oldWidget.isActive != widget.isActive) {
      setState(() {
        buttonState.isAccented = widget.isAccented;
        buttonState.isActive = widget.isActive;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('build');
    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;
    double positionX;
    double widgetWidth;
    return MouseRegion(
      onHover: (details) {
        final RenderBox box = context.findRenderObject() as RenderBox;
        widgetWidth = box.size.width;
        positionX = details.localPosition.dx;
        if (positionX < widgetWidth / 2) {
          // Hover is on the left half
          // widget.onTapLeft();
        } else {
          // Hover is on the right half
          // widget.onTapRight();
        }
      },
      hitTestBehavior: HitTestBehavior
          .deferToChild, // accepting hits only where the child is, to prevent a rounded corners bug where hits are accepted outside the corners
      onEnter: (_) {
        setState(() {
          buttonState.buttonStateType = ButtonStateType.hovered;
        });
      },
      onExit: (_) {
        setState(() {
          buttonState.buttonStateType = ButtonStateType.normal;
        });
      },
      cursor: buttonState.isActive
          ? SystemMouseCursors.click
          : MouseCursor.defer, //hand cursor if active, normal cursor if not
      child: GestureDetector(
        behavior: HitTestBehavior.deferToChild, // for rounded corners bug
        onTapDown: (details) {
          final RenderBox box = context.findRenderObject() as RenderBox;
          widgetWidth = box.size.width;
          positionX = details.localPosition.dx;
          if (positionX < widgetWidth / 2) {
            // Tap is on the left half
            widget.onTapLeft();
          } else {
            // Tap is on the right half
            widget.onTapRight();
          }
          setState(() {
            buttonState.buttonStateType = ButtonStateType.pressed;
          });
        },
        onTapUp: (_) {
          setState(() {
            buttonState.buttonStateType = ButtonStateType.hovered;
          });
        },
        onTapCancel: () {
          setState(() {
            buttonState.buttonStateType = ButtonStateType.normal;
          });
        },
        onTap: widget.isActive
            ? () {
                context.read<ThemeProvider>().toggleThemeMode(); //Todo remove
                widget.onTap();
              }
            : () {},
        child: Container(
          constraints: BoxConstraints(minWidth: theme.dButtonHeight, minHeight: theme.dButtonHeight),
          height: theme.dButtonHeight,
          width: theme.dButtonHeight,
          decoration: BoxDecoration(
              color: getColor(buttonState, theme),
              border: Border.all(
                color: buttonState.isAccented ? theme.cAccent : theme.cOutlines,
                width: 1, //TODO de-hardcode
              ),
              borderRadius: BorderRadius.circular(theme.dButtonBorderRadius)),
          child: IgnorePointer(
            //only allow for the button to receive events. nested buttons etc won't work for simplicity.
            // child: Center(child: widget.child)
            child: Stack(children: [
             widget._isLeftRight? Positioned(
                top: 0,
                bottom: 0,
                left: -theme.dButtonHeight / 5,
                child: Icon(Icons.arrow_left,
                    size: theme.dButtonHeight,
                    color: buttonState.buttonStateType == ButtonStateType.normal
                        ? theme.cPanel
                        : theme.cText),
              ) : Container(),
             widget._isLeftRight? Positioned(
                top: 0,
                bottom: 0,
                right: -theme.dButtonHeight / 5,
                child: Icon(Icons.arrow_right,
                    size: theme.dButtonHeight,
                    color: buttonState.buttonStateType == ButtonStateType.normal
                        ? theme.cPanel
                        : theme.cText),
              ) : Container(),
              // Center(child: widget.child), //TODO figure why this is not centered
              Center(child: Icon(Icons.arrow_drop_down,
                    size: theme.dButtonHeight,
                    color: buttonState.buttonStateType == ButtonStateType.normal
                        ? theme.cPanel
                        : theme.cText)), //TODO figure why this is not centered
            ]),
          ),
        ),
      ),
    );
  }
}

class ButtonState {
  bool isAccented;
  bool isActive;
  ButtonStateType buttonStateType;
  ButtonState({
    required this.isAccented,
    required this.isActive,
    required this.buttonStateType,
  });
}

enum ButtonStateType { hovered, pressed, normal }

// Stack(
//               children: [
//                 widget._isLeftRight
//                     ? Row(
//                         children: [
//                           Expanded(
//                             child: GestureDetector(
//                               behavior: HitTestBehavior.translucent,
//                               onTap: widget.onTapLeft,
//                             ),
//                           ),
//                           Expanded(
//                             child: GestureDetector(
//                               behavior: HitTestBehavior.translucent,
//                               onTap: widget.onTapRight,
//                             ),
//                           )
//                         ],
//                       )
//                     : GestureDetector(),
//                 widget.child ??
//                     GestureDetector(
//                       behavior: HitTestBehavior.translucent,
//                     ),
//               ],
//             ),