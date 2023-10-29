import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// A controller of a SuggestionsBox.
/// This is used to open, close, toggle and resize the suggestions box.
class SuggestionsBoxController extends ChangeNotifier {
  /// A controller of a SuggestionsBox.
  /// This is used to open, close, toggle and resize the suggestions box.
  SuggestionsBoxController();

  /// Whether the suggestions box is open.
  bool get isOpen => _isOpen;
  bool _isOpen = false;

  /// Whether the child of suggestions box should retain the focus when it is closed.
  bool get retainFocus => _retainFocus;
  bool _retainFocus = false;

  /// A stream of up and down arrow key occuring on any focus node of the suggestions box.
  Stream<LogicalKeyboardKey> get keyEvents => _keyEventController.stream;
  final StreamController<LogicalKeyboardKey> _keyEventController =
      StreamController<LogicalKeyboardKey>.broadcast();

  /// Should be called when a key is pressed on any focus node of the suggestions box.
  KeyEventResult onKeyEvent(FocusNode node, KeyEvent key) {
    if (key is! KeyDownEvent) return KeyEventResult.ignored;
    if ([
      LogicalKeyboardKey.arrowDown,
      LogicalKeyboardKey.arrowUp,
    ].contains(key.logicalKey)) {
      _keyEventController.add(key.logicalKey);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  /// A stream of resize events sent by this controller.
  Stream<void> get resizeEvents => _resizeEventController.stream;
  final StreamController<void> _resizeEventController =
      StreamController<void>.broadcast();

  /// Whether the suggestions list is focused.
  bool get suggestionsFocused => _suggestionsFocused;
  bool _suggestionsFocused = false;

  /// Focuses the suggestions list.
  void focusSuggestions() {
    if (suggestionsFocused) return;
    _suggestionsFocused = true;
    notifyListeners();
  }

  /// Unfocuses the suggestions list and returns the focus to the suggestions box.
  void unfocusSuggestions() {
    if (!suggestionsFocused) return;
    _suggestionsFocused = false;
    notifyListeners();
  }

  /// Focuses the suggestions box.
  // This is implemented by focusing the suggestions list and then unfocusing it,
  // which is somewhat hacky but works.
  void focusBox() {
    focusSuggestions();
    unfocusSuggestions();
  }

  /// Resizes the suggestions box.
  void resize() {
    ChangeNotifier.debugAssertNotDisposed(this);
    _resizeEventController.add(null);
  }

  /// Opens the suggestions box.
  void open() {
    if (isOpen) return;
    _isOpen = true;
    _retainFocus = false;
    notifyListeners();
    resize();
  }

  /// Closes the suggestions box.
  void close({bool retainFocus = false}) {
    if (!isOpen) return;
    _isOpen = false;
    _retainFocus = retainFocus;
    _suggestionsFocused = false;
    notifyListeners();
  }

  /// Opens the suggestions box if closed and vice-versa.
  void toggle() {
    if (isOpen) {
      close();
    } else {
      open();
    }
  }

  @override
  void dispose() {
    close();
    _keyEventController.close();
    _resizeEventController.close();
    super.dispose();
  }
}
