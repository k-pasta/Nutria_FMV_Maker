import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class KeyboardProvider extends ChangeNotifier {
  // Track the state of modifier keys
  bool _isShiftPressed = false;
  bool _isCtrlPressed = false;
  bool _isAltPressed = false;

  KeyboardProvider() {
    // Add a key event handler to update modifier key states
    HardwareKeyboard.instance.addHandler(_handleKeyEvent);
  }

  @override
  void dispose() {
    // Remove the key event handler when the provider is disposed
    HardwareKeyboard.instance.removeHandler(_handleKeyEvent);
    super.dispose();
  }

  // Key event handler to update modifier key states
  bool _handleKeyEvent(KeyEvent event) {
    // Update the state of modifier keys
    _isShiftPressed = HardwareKeyboard.instance.logicalKeysPressed
        .contains(LogicalKeyboardKey.shiftLeft) ||
        HardwareKeyboard.instance.logicalKeysPressed
            .contains(LogicalKeyboardKey.shiftRight);
    _isCtrlPressed = HardwareKeyboard.instance.logicalKeysPressed
        .contains(LogicalKeyboardKey.controlLeft) ||
        HardwareKeyboard.instance.logicalKeysPressed
            .contains(LogicalKeyboardKey.controlRight);
    _isAltPressed = HardwareKeyboard.instance.logicalKeysPressed
        .contains(LogicalKeyboardKey.altLeft) ||
        HardwareKeyboard.instance.logicalKeysPressed
            .contains(LogicalKeyboardKey.altRight);

    // Notify listeners about the state change
    notifyListeners();

    // Return false to allow other handlers to process the event
    return false;
  }

  // Getters to access the state of modifier keys
  bool get isShiftPressed => _isShiftPressed;
  bool get isCtrlPressed => _isCtrlPressed;
  bool get isAltPressed => _isAltPressed;
}