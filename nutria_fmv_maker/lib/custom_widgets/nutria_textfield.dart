import 'package:flutter/material.dart';
import 'package:nutria_fmv_maker/models/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import '../providers/theme_provider.dart';
import '../providers/ui_state_provider.dart';

class NutriaTextfield extends StatefulWidget {
  final int index;
  final String? text;
  final ValueChanged<String>? onChanged;

  const NutriaTextfield(
      {super.key,
      this.index = 1,
      this.text,
      this.onChanged}); //TODO de-hardcode

  @override
  State<NutriaTextfield> createState() => _NutriaTextfieldState();
}

class _NutriaTextfieldState extends State<NutriaTextfield> {
  late FocusNode _focusNode;
  static const _doNothingIntent = DoNothingAndStopPropagationIntent();
  final TextEditingController myController = TextEditingController();
  // int numLines = 1;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    myController.text = widget.text ?? '';
    // Listen to focus changes
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange); // Clean up listener
    _focusNode.dispose();
    super.dispose();
  }

  // Called when focus state changes
  void _onFocusChange() {
    setState(() {}); // Rebuild the widget when focus state changes
  }

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = context.watch<ThemeProvider>().currentAppTheme;
    Color backgroundColor =
        _focusNode.hasFocus ? theme.cTextFieldActive : theme.cTextField;
    Color textColor = _focusNode.hasFocus ? theme.cTextActive : theme.cText;

    return Shortcuts(
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.keyT):
            _doNothingIntent, //left panel toggle
        SingleActivator(LogicalKeyboardKey.keyN):
            _doNothingIntent, //right panel toggle
        SingleActivator(LogicalKeyboardKey.add): _doNothingIntent, //zoom in
        SingleActivator(LogicalKeyboardKey.numpadAdd):
            _doNothingIntent, //zoomin
        SingleActivator(LogicalKeyboardKey.minus): _doNothingIntent, //zoom out
        SingleActivator(LogicalKeyboardKey.numpadSubtract):
            _doNothingIntent, //zoom out
        SingleActivator(LogicalKeyboardKey.arrowLeft):
            _doNothingIntent, //navigation
        SingleActivator(LogicalKeyboardKey.arrowRight): _doNothingIntent,
        SingleActivator(LogicalKeyboardKey.arrowUp): _doNothingIntent,
        SingleActivator(LogicalKeyboardKey.arrowDown): _doNothingIntent,
      },
      child: TextField(
        controller: myController,
        onChanged: (String currentText) {
          if (widget.onChanged != null) {
            widget.onChanged!(currentText);
          }
        },
        onTap: () {
          // print('tapped');
        },
        textInputAction: TextInputAction.next,
        focusNode: _focusNode,

        cursorColor: theme.cText,
        style: TextStyle(
          color: textColor,
          fontSize: theme.dTextHeight,
        ),
        // maxLines: null,
        maxLines: 1,
        maxLength: 500, //TODO De-hardcode and document

        decoration: InputDecoration(
          isDense:
              true, //allows custom height and overwrites min height of 48 px (flutter's default for accessibility)

          contentPadding: EdgeInsets.symmetric(
              vertical: (theme.dButtonHeight - theme.dTextHeight) / 2,
              horizontal: 8.0), // TODO de-hardcode
          counterText: '', //disables max character counter
          hintText:
              '${AppLocalizations.of(context)!.videoNodeChoice} ${widget.index} ...',
          hintStyle: TextStyle(
              color: theme.cTextInactive, fontWeight: FontWeight.normal
              ),
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: theme.cOutlines,
                width: theme.dOutlinesWidth), // Visible border when not focused
            borderRadius: BorderRadius.circular(theme.dButtonBorderRadius),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(theme.dButtonBorderRadius),
            borderSide: const  BorderSide(color: Colors.transparent),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(theme.dButtonBorderRadius),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          filled: true,
          fillColor: backgroundColor,
        ),
      ),
    );
  }
}
