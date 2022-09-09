import 'package:flutter/material.dart';

class ShouldRefreshSuggestionFocusIndexNotifier extends ValueNotifier<void> {
  ShouldRefreshSuggestionFocusIndexNotifier(
      {required FocusNode? textFieldFocusNode})
      : super(null) {
    textFieldFocusNode?.addListener(() {
      if (textFieldFocusNode.hasFocus) {
        notifyListeners();
      }
    });
  }
}
