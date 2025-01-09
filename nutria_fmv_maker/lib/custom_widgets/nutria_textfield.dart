import 'package:flutter/material.dart';
import 'package:nutria_fmv_maker/models/app_theme.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class NutriaTextfield extends StatefulWidget {
  final int index;
  const NutriaTextfield({super.key, this.index = 1});

  @override
  State<NutriaTextfield> createState() => _NutriaTextfieldState();
}

class _NutriaTextfieldState extends State<NutriaTextfield> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

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

    return TextField(
      focusNode: _focusNode,
      cursorColor: theme.cText,
      style: TextStyle(color: textColor),
      maxLines: null,
      maxLength: 500, //TODO De-hardcode and document
      decoration: InputDecoration(
        counterText: "", //disables max character counter
        hintText: 'option ${widget.index} ...',
        hintStyle:
            TextStyle(color: theme.cTextInactive, fontWeight: FontWeight.normal
                // color: olors.red,
                ),
        border: InputBorder.none,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: theme.cOutlines,
              width: 1), // Visible border when not focused
          borderRadius: BorderRadius.circular(theme.dButtonBorderRadius),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(theme.dButtonBorderRadius)),
        disabledBorder:OutlineInputBorder(
            borderRadius: BorderRadius.circular(theme.dButtonBorderRadius)),
        contentPadding: EdgeInsets.all(8),
        filled: true,
        fillColor: backgroundColor,
      ),
    );
  }
}
