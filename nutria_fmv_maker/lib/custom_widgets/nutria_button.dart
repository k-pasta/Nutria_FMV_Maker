import 'package:flutter/material.dart';
import 'package:nutria_fmv_maker/models/app_theme.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class NutriaButton extends StatefulWidget {
  final Widget? child;
  bool isAccented;
  bool isActive;
  NutriaButton({
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
buttonState = ButtonState(isAccented: widget.isAccented, isActive: widget.isActive, buttonStateType: ButtonStateType.normal);

  }

//  Color getColor(ButtonState buttonState){
// switch (buttonStateType) {
//   case ButtonStateType.hovered:
//   case ButtonStateType.pressed:
//   return widget.isAccented ? theme.cAccentButtonPressed : theme.cButtonPressed;
//   case ButtonStateType.normal:

//     break;
//   default:
// }
// return
//  };

  @override
  void didUpdateWidget(covariant NutriaButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update buttonColor if widget properties change
    if (oldWidget.isAccented != widget.isAccented) {
      AppTheme theme = context.read<ThemeProvider>().currentAppTheme;
      setState(() {
        
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
        cursor: widget.isActive ? SystemMouseCursors.click : MouseCursor.defer,
        child: Container(
          constraints: BoxConstraints(minWidth: theme.dButtonHeight),
          height: theme.dButtonHeight,
          decoration: BoxDecoration(
              color: ,
              border: Border.all(
                color: widget.isAccented ? theme.cAccent : theme.cOutlines,
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
