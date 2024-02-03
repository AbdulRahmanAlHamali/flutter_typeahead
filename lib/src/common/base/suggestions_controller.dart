import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// A controller of a SuggestionsField and its SuggestionsBox.
///
/// This allows access to the state of suggestions (items, loading, error),
/// the state of the suggestions box (open, direction, focus) and
/// the ability to open and close the suggestions box.
class SuggestionsController<T> extends ChangeNotifier {
  /// A controller of a SuggestionsBox.
  /// This is used to open, close, toggle and resize the suggestions box.
  SuggestionsController();

  /// Returns the SuggestionsController of the closest ancestor SuggestionsBox or null if none exists.
  static SuggestionsController<T>? maybeOf<T>(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<SuggestionsControllerProvider<T>>()
        ?.notifier;
  }

  /// Returns the SuggestionsController of the closest ancestor SuggestionsBox.
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

  /// A stream of events that occur when the suggestions list should be refreshed.
  ///
  /// For internal use only.
  Stream<void> get $refreshes => _refreshesController.stream;
  final StreamController<void> _refreshesController =
      StreamController<void>.broadcast();

  /// Resets the suggestions so that they are requested again.
  void refresh() {
    ChangeNotifier.debugAssertNotDisposed(this);
    _suggestions = null;
    _refreshesController.add(null);
  }

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

  /// The current state of focus of the suggestions box and field.
  SuggestionsFocusState get focusState => _focusState;
  SuggestionsFocusState _focusState = SuggestionsFocusState.blur;

  /// Whether the suggestions field should retain the focus when its box is closed.
  bool get retainFocus => _retainFocus;
  bool _retainFocus = false;

  /// Whether the suggestions box should gain the focus when it is opened.
  bool get gainFocus => _gainFocus;
  bool _gainFocus = true;

  /// The desired direction of the suggestions box.
  ///
  /// The suggestions box will try to open in this direction.
  /// If there is insufficient space, it may open in the opposite direction,
  /// depending on its configuration.
  ///
  /// See [effectiveDirection] for the actual direction of the suggestions box.
  VerticalDirection get direction => _direction;
  set direction(VerticalDirection value) {
    if (_direction == value) return;
    _direction = value;
    notifyListeners();
  }

  VerticalDirection _direction = VerticalDirection.down;

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
  VerticalDirection get effectiveDirection => _effectiveDirection;
  set effectiveDirection(VerticalDirection value) {
    if (_effectiveDirection == value) return;
    _effectiveDirection = value;
    notifyListeners();
  }

  VerticalDirection _effectiveDirection = VerticalDirection.down;

  /// A stream of events that occur when the suggestions box should be resized.
  ///
  /// For internal use only.
  Stream<void> get $resizes => _resizesController.stream;
  final StreamController<void> _resizesController =
      StreamController<void>.broadcast();

  /// Resizes the suggestions box.
  ///
  /// You usually don't need to call this method manually.
  void resize() {
    ChangeNotifier.debugAssertNotDisposed(this);
    _resizesController.add(null);
  }

  /// A stream of selected suggestions.
  Stream<T> get selections => _selectionsController.stream;
  final StreamController<T> _selectionsController =
      StreamController<T>.broadcast();

  /// Should be called when a suggestion is selected.
  ///
  /// This notifies potential listeners of the selection.
  void select(T suggestion) => _selectionsController.add(suggestion);

  /// Focuses the suggestions box.
  void focusBox() {
    if (_focusState == SuggestionsFocusState.box) return;
    _focusState = SuggestionsFocusState.box;
    notifyListeners();
  }

  /// Focuses the suggestions field.
  void focusField() {
    if (_focusState == SuggestionsFocusState.field) return;
    _focusState = SuggestionsFocusState.field;
    notifyListeners();
  }

  /// Unfocuses the suggestions box and its field.
  void unfocus() {
    if (_focusState == SuggestionsFocusState.blur) return;
    _focusState = SuggestionsFocusState.blur;
    notifyListeners();
  }

  /// Opens the suggestions box.
  void open({bool gainFocus = true}) {
    if (isOpen) return;
    _isOpen = true;
    _gainFocus = gainFocus;
    notifyListeners();
    resize();
  }

  /// Closes the suggestions box.
  void close({bool retainFocus = false}) {
    if (!isOpen) return;
    _isOpen = false;
    _retainFocus = retainFocus;
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
    _refreshesController.close();
    _resizesController.close();
    _selectionsController.close();
    super.dispose();
  }
}

/// Injects a SuggestionsController into the widget tree.
class SuggestionsControllerProvider<T>
    extends InheritedNotifier<SuggestionsController<T>> {
  const SuggestionsControllerProvider({
    super.key,
    required SuggestionsController<T> controller,
    required Widget child,
  }) : super(notifier: controller, child: child);
}

/// The state of focus of the suggestions box and field.
enum SuggestionsFocusState {
  /// Neither the suggestions box nor field are focused.
  blur,

  /// The suggestions box is focused.
  box,

  /// The suggestions field is focused.
  field;

  /// Whether the suggestions box or field is focused.
  bool get hasFocus => this != SuggestionsFocusState.blur;
}
