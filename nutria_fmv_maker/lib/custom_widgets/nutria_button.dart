import 'package:flutter/material.dart';
import 'package:nutria_fmv_maker/models/app_theme.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class NutriaButton extends StatefulWidget {
  final Widget? child;
  final bool isAccented;
  final bool isActive;
  const NutriaButton({
    super.key,
    this.child,
    this.isAccented = true,
    this.isActive = true,
  });
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

  @override
void didUpdateWidget(covariant NutriaButton oldWidget) {
  super.didUpdateWidget(oldWidget);
  
  // Update button state if widget properties change
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
    AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;
    print('build');
    return GestureDetector(
      onTapDown: (_) {
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
              context.read<ThemeProvider>().toggleThemeMode();
            }
          : () {},
      child: MouseRegion(
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
        cursor:
            buttonState.isActive ? SystemMouseCursors.click : MouseCursor.defer,
        child: Container(
          constraints: BoxConstraints(minWidth: theme.dButtonHeight),
          height: theme.dButtonHeight,
          decoration: BoxDecoration(
              color: getColor(buttonState, theme),
              border: Border.all(
                color: buttonState.isAccented ? theme.cAccent : theme.cOutlines,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(theme.dButtonBorderRadius)),
          child: widget.child,
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
