import 'package:flutter/cupertino.dart';
import 'package:flutter_typeahead/src/cupertino/suggestions_box/cupertino_suggestions_box.dart';

/// Supply an instance of this class to the [TypeAhead.suggestionsBoxController]
/// property to manually control the suggestions box
class CupertinoSuggestionsBoxController {
  CupertinoSuggestionsBox? suggestionsBox;
  FocusNode? effectiveFocusNode;

  /// Opens the suggestions box
  void open() {
    effectiveFocusNode!.requestFocus();
  }

  /// Closes the suggestions box
  void close() {
    effectiveFocusNode!.unfocus();
  }

  /// Opens the suggestions box if closed and vice-versa
  void toggle() {
    if (suggestionsBox!.isOpened) {
      close();
    } else {
      open();
    }
  }

  /// Recalculates the height of the suggestions box
  void resize() {
    suggestionsBox!.resize();
  }
}