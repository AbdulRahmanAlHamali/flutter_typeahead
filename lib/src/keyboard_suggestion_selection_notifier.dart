import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KeyboardSuggestionSelectionNotifier
    extends ValueNotifier<LogicalKeyboardKey?> {
  KeyboardSuggestionSelectionNotifier() : super(null);

  void onKeyboardEvent(RawKeyEvent event) {
    // we only respond to key down events
    if (event is RawKeyUpEvent) return;

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
