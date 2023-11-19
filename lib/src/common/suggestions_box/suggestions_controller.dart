import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// A controller of a SuggestionsBox.
/// This is used to open, close, toggle and resize the suggestions box.
class SuggestionsController<T> extends ChangeNotifier {
  /// A controller of a SuggestionsBox.
  /// This is used to open, close, toggle and resize the suggestions box.
  SuggestionsController();

  static SuggestionsController<T>? maybeOf<T>(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<SuggestionsControllerProvider<T>>()
        ?.notifier;
  }

  static SuggestionsController<T> of<T>(BuildContext context) {
    SuggestionsController<T>? controller = maybeOf<T>(context);
    if (controller == null) {
      throw FlutterError.fromParts(
        [
          ErrorSummary('No SuggestionsController found in the context. '),
          ErrorDescription(
            'SuggestionsControllers are only available inside SuggestionsBox widgets.',
          ),
          ErrorHint('Are you inside a SuggestionsBox?'),
          context.describeElement('The context used was')
        ],
      );
    }
    return controller;
  }

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

  /// Whether the suggestions box is focused.
  bool get focused => _focused;
  bool _focused = false;

  /// Whether the child of suggestions box should retain the focus when it is closed.
  bool get retainFocus => _retainFocus;
  bool _retainFocus = false;

  /// The desired direction of the suggestions box.
  ///
  /// The suggestions box will try to open in this direction.
  /// If there is insufficient space, it may open in the opposite direction,
  /// depending on its configuration.
  AxisDirection get direction => _direction;
  set direction(AxisDirection value) {
    if (_direction == value) return;
    _direction = value;
    notifyListeners();
  }

  AxisDirection _direction = AxisDirection.down;

  /// The effective direction of the suggestions box.
  /// This may or may not be the same as [direction].
  ///
  /// If you wish to change the direction of the suggestions box, use [direction].
  ///
  /// This value is typically set by the [SuggestionsField] widget.
  /// You should not need to set it manually.
  ///
  /// This value can be used to determine e.g. the direction of the ScrollView
  /// inside the suggestions box.
  AxisDirection get effectiveDirection => _effectiveDirection;
  set effectiveDirection(AxisDirection value) {
    if (_effectiveDirection == value) return;
    _effectiveDirection = value;
    notifyListeners();
  }

  AxisDirection _effectiveDirection = AxisDirection.down;

  /// A stream of events that occur when the suggestions box should be resized.
  Stream<void> get resizes => _resizesController.stream;
  final StreamController<void> _resizesController =
      StreamController<void>.broadcast();

  /// A stream of up and down arrow key occuring on any focus node of the suggestions box.
  Stream<VerticalDirection> get keys => _keyEventController.stream;
  final StreamController<VerticalDirection> _keyEventController =
      StreamController<VerticalDirection>.broadcast();

  /// Should be called when a key is pressed on any focus node of the suggestions box.
  void sendKey(VerticalDirection key) => _keyEventController.add(key);

  /// A stream of selected suggestions.
  Stream<T> get selections => _selectionsController.stream;
  final StreamController<T> _selectionsController =
      StreamController<T>.broadcast();

  /// Should be called when a suggestion is selected.
  ///
  /// This notifies potential listeners of the selection.
  void select(T suggestion) => _selectionsController.add(suggestion);

  /// Resizes the suggestions box.
  ///
  /// You usually don't need to call this method manually.
  void resize() {
    ChangeNotifier.debugAssertNotDisposed(this);
    _resizesController.add(null);
  }

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

class SuggestionsControllerProvider<T>
    extends InheritedNotifier<SuggestionsController<T>> {
  const SuggestionsControllerProvider({
    super.key,
    required SuggestionsController<T> controller,
    required Widget child,
  }) : super(notifier: controller, child: child);
}
