import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// A controller of a SuggestionsBox.
/// This is used to open, close, toggle and resize the suggestions box.
class SuggestionsController<T> extends ChangeNotifier {
  /// A controller of a SuggestionsBox.
  /// This is used to open, close, toggle and resize the suggestions box.
  SuggestionsController();

  /// The current suggestions of the suggestions box.
  List<T>? get suggestions =>
      _suggestions == null ? null : List.of(_suggestions!);
  set suggestions(List<T>? value) {
    if (listEquals(_suggestions, value)) return;
    if (value != null) {
      value = List.of(value);
    }
    _suggestions = value;
    notifyListeners();
  }

  List<T>? _suggestions;

  /// Whether the suggestions box is loading.
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    if (_isLoading == value) return;
    _isLoading = value;
    notifyListeners();
  }

  bool _isLoading = false;

  /// Whether the suggestions box has encountered an error while loading.
  bool get hasError => _error != null;

  /// The error encountered by the suggestions box while loading, if any.
  Object? get error => _error;
  set error(Object? value) {
    if (_error == value) return;
    _error = value;
    notifyListeners();
  }

  Object? _error;

  /// Whether the suggestions box is open.
  bool get isOpen => _isOpen;
  bool _isOpen = false;

  /// Whether the child of suggestions box should retain the focus when it is closed.
  bool get retainFocus => _retainFocus;
  bool _retainFocus = false;

  /// A stream of up and down arrow key occuring on any focus node of the suggestions box.
  Stream<LogicalKeyboardKey> get keys => _keyEventController.stream;
  final StreamController<LogicalKeyboardKey> _keyEventController =
      StreamController<LogicalKeyboardKey>.broadcast();

  /// Should be called when a key is pressed on any focus node of the suggestions box.
  KeyEventResult sendKey(FocusNode node, KeyEvent key) {
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

  /// A stream of events that occur when the suggestions box should be resized.
  Stream<void> get resizes => _resizesController.stream;
  final StreamController<void> _resizesController =
      StreamController<void>.broadcast();

  /// Resizes the suggestions box.
  ///
  /// You usually don't need to call this method manually.
  void resize() {
    ChangeNotifier.debugAssertNotDisposed(this);
    _resizesController.add(null);
  }

  /// Whether the suggestions box is focused.
  bool get focused => _focused;
  bool _focused = false;

  /// Focuses the suggestions box.
  void focus() {
    if (focused) return;
    _focused = true;
    notifyListeners();
  }

  /// Unfocuses the suggestions box and returns the focus to the suggestions box.
  void unfocus() {
    if (!focused) return;
    _focused = false;
    notifyListeners();
  }

  /// Focuses the child of the suggestions box.
  // This is implemented by focusing the suggestions box and then unfocusing it,
  // which is kind of jank, but the easiest way to do it with our current setup.
  void focusChild() {
    focus();
    unfocus();
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
    _focused = false;
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
    _resizesController.close();
    super.dispose();
  }
}
