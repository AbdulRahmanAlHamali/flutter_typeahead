import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KeyboardSuggestionSelectionNotifier
    extends ValueNotifier<LogicalKeyboardKey?> {
  KeyboardSuggestionSelectionNotifier() : super(null);

  void onKeyboardEvent(RawKeyEvent event) {
    // * we only handle key down event
    if (event.runtimeType == RawKeyUpEvent) return;

    if (event.logicalKey == LogicalKeyboardKey.arrowDown ||
        event.logicalKey == LogicalKeyboardKey.arrowUp) {
      if (value == event.logicalKey) {
        notifyListeners();
      } else {
        value = event.logicalKey;
      }
    }
  }
}
