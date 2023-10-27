import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/src/common/field/typeahead_field.dart';

class SuggestionsBox extends ChangeNotifier {
  /// A controller of a SuggestionsBox.
  /// This is used to open, close, toggle and resize the suggestions box.
  SuggestionsBox({
    AxisDirection direction = AxisDirection.down,
    bool autoFlipDirection = false,
    bool autoFlipListDirection = true,
    double autoFlipMinHeight = 64.0,
  })  : _direction = direction,
        _desiredDirection = direction,
        _autoFlipDirection = autoFlipDirection,
        _autoFlipListDirection = autoFlipListDirection,
        _autoFlipMinHeight = autoFlipMinHeight;

  /// The direction in which the suggestions box opens.
  /// Depending on the available space,
  /// this might not be the same as the [desiredDirection].
  AxisDirection get direction => _direction;
  AxisDirection _direction;

  /// The desired direction of the suggestions box.
  /// This is the direction that the suggestions box will open in if there is
  /// enough room. If there is not enough room, the suggestions box will open
  /// in the opposite direction.
  AxisDirection get desiredDirection => _desiredDirection;
  set desiredDirection(AxisDirection value) {
    if (_desiredDirection == value) return;
    if (value != AxisDirection.down && value != AxisDirection.up) {
      throw ArgumentError(
        'SuggestionsBox desiredDirection must be either AxisDirection.down or AxisDirection.up',
      );
    }
    _desiredDirection = value;
    notifyListeners();
    _maybeResize();
  }

  AxisDirection _desiredDirection;

  /// Whether the suggestions box should automatically flip direction.
  bool get autoFlipDirection => _autoFlipDirection;
  set autoFlipDirection(bool value) {
    if (_autoFlipDirection == value) return;
    _autoFlipDirection = value;
    notifyListeners();
    _maybeResize();
  }

  bool _autoFlipDirection;

  /// Whether the suggestions list should automatically flip direction.
  bool get autoFlipListDirection => _autoFlipListDirection;
  set autoFlipListDirection(bool value) {
    if (_autoFlipListDirection == value) return;
    _autoFlipListDirection = value;
    notifyListeners();
    _maybeResize();
  }

  bool _autoFlipListDirection;

  /// The minimum height at which the suggestions box should automatically flip direction.
  double get autoFlipMinHeight => _autoFlipMinHeight;
  set autoFlipMinHeight(double value) {
    if (_autoFlipMinHeight == value) return;
    _autoFlipMinHeight = value;
    notifyListeners();
    _maybeResize();
  }

  double _autoFlipMinHeight;

  /// The [BuildContext] of the [TypeAheadField] that this SuggestionsBox is attached to.
  BuildContext get _context {
    if (__context == null) {
      throw StateError('SuggestionsBox must be attached before using it.');
    }
    return __context!;
  }

  BuildContext? __context;

  /// The [OverlayEntry] which represents the content of this SuggestionsBox.
  OverlayEntry get _overlayEntry {
    if (__overlayEntry == null) {
      throw StateError('SuggestionsBox must be attached before using it.');
    }
    return __overlayEntry!;
  }

  OverlayEntry? __overlayEntry;

  /// Attach this SuggestionsBox to a [TypeAheadField].
  /// This is called by the [TypeAheadField] itself.
  void attach({
    required BuildContext context,
    required OverlayEntry overlayEntry,
  }) {
    __context = context;
    __overlayEntry = overlayEntry;
    resize();
  }

  /// Whether this SuggestionsBox is attached to a [TypeAheadField].
  bool get isAttached => __overlayEntry != null;

  /// The maximum height of the suggestions box.
  double get maxHeight => _maxHeight;
  double _maxHeight = 200;

  /// The width of the suggestions box.
  double get width => _boxWidth;
  double _boxWidth = 100;

  /// The height of the suggestions box.
  double get height => _boxHeight;
  double _boxHeight = 100;

  /// Whether the suggestions box is open.
  bool get isOpen => _isOpen;
  bool _isOpen = false;

  /// A stream of key events that occur on the [TypeAheadField].
  Stream<LogicalKeyboardKey> get keyEvents => _keyEventController.stream;
  final StreamController<LogicalKeyboardKey> _keyEventController =
      StreamController<LogicalKeyboardKey>.broadcast();

  /// Should be called when a key is pressed on the [TypeAheadField].
  /// This is used internally. Do not call this method directly.
  KeyEventResult onKeyEvent(FocusNode node, RawKeyEvent key) {
    if (key is RawKeyUpEvent) return KeyEventResult.ignored;
    _keyEventController.add(key.logicalKey);
    return KeyEventResult.ignored;
  }

  /// Opens the suggestions box.
  void open() {
    if (isOpen) return;
    resize();
    Overlay.of(_context).insert(_overlayEntry);
    _isOpen = true;
    notifyListeners();
  }

  /// Closes the suggestions box.
  void close() {
    if (!isOpen) return;
    _overlayEntry.remove();
    _isOpen = false;
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

  /// Resizes the suggestions box,
  /// if it is attached to a [TypeAheadField].
  void _maybeResize() {
    if (!isAttached) return;
    resize();
  }

  /// Resizes the suggestions box.
  void resize() {
    if (!_context.mounted) return;
    _adjustMaxHeightAndOrientation();
    _overlayEntry.markNeedsBuild();
  }

  // Resize the suggestions box based on the available height.
  // If there's not enough room in the desired direction, flip the direction
  // and see if there's enough room there.
  void _adjustMaxHeightAndOrientation() {
    BaseTypeAheadField widget = _context.widget as BaseTypeAheadField;

    RenderBox? box = _context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;

    _boxWidth = box.size.width;
    _boxHeight = box.size.height;
    notifyListeners();

    // top of text box
    double textBoxAbsY = box.localToGlobal(Offset.zero).dy;

    // height of window
    double windowHeight = MediaQuery.of(_context).size.height;

    // we need to find the root MediaQuery for the unsafe area height
    // we cannot use BuildContext.ancestorWidgetOfExactType because
    // widgets like SafeArea creates a new MediaQuery with the padding removed
    MediaQuery rootMediaQuery = _findRootMediaQuery()!;

    // height of keyboard
    double keyboardHeight = rootMediaQuery.data.viewInsets.bottom;

    double maxHDesired = _calculateMaxHeight(desiredDirection, box, widget,
        windowHeight, rootMediaQuery, keyboardHeight, textBoxAbsY);

    // if there's enough room in the desired direction, update the direction and the max height
    if (maxHDesired >= autoFlipMinHeight || !autoFlipDirection) {
      _direction = desiredDirection;
      notifyListeners();
      // Sometimes textBoxAbsY is NaN, so we need to check for that
      if (!maxHDesired.isNaN) {
        _maxHeight = maxHDesired;
        notifyListeners();
      }
    } else {
      // There's not enough room in the desired direction so see how much room is in the opposite direction
      AxisDirection flipped = flipAxisDirection(desiredDirection);
      double maxHFlipped = _calculateMaxHeight(flipped, box, widget,
          windowHeight, rootMediaQuery, keyboardHeight, textBoxAbsY);

      // if there's more room in this opposite direction, update the direction and maxHeight
      if (maxHFlipped > maxHDesired) {
        _direction = flipped;
        notifyListeners();

        // Not sure if this is needed, but it's here just in case
        if (!maxHFlipped.isNaN) {
          _maxHeight = maxHFlipped;
          notifyListeners();
        }
      }
    }

    if (maxHeight < 0) {
      _maxHeight = 0;
      notifyListeners();
    }
  }

  double _calculateMaxHeight(
    AxisDirection direction,
    RenderBox box,
    BaseTypeAheadField widget,
    double windowHeight,
    MediaQuery rootMediaQuery,
    double keyboardHeight,
    double textBoxAbsY,
  ) {
    return direction == AxisDirection.down
        ? _calculateMaxHeightDown(box, widget, windowHeight, rootMediaQuery,
            keyboardHeight, textBoxAbsY)
        : _calculateMaxHeightUp(box, widget, windowHeight, rootMediaQuery,
            keyboardHeight, textBoxAbsY);
  }

  double _calculateMaxHeightDown(
    RenderBox box,
    BaseTypeAheadField widget,
    double windowHeight,
    MediaQuery rootMediaQuery,
    double keyboardHeight,
    double textBoxAbsY,
  ) {
    // unsafe area, ie: iPhone X 'home button'
    // keyboardHeight includes unsafeAreaHeight, if keyboard is showing, set to 0
    double unsafeAreaHeight =
        keyboardHeight == 0 ? rootMediaQuery.data.padding.bottom : 0;

    return windowHeight -
        keyboardHeight -
        unsafeAreaHeight -
        height -
        textBoxAbsY -
        2 * widget.suggestionsBoxVerticalOffset;
  }

  double _calculateMaxHeightUp(
    RenderBox box,
    BaseTypeAheadField widget,
    double windowHeight,
    MediaQuery rootMediaQuery,
    double keyboardHeight,
    double textBoxAbsY,
  ) {
    // recalculate keyboard absolute y value
    double keyboardAbsY = windowHeight - keyboardHeight;

    // unsafe area, ie: iPhone X notch
    double unsafeAreaHeight = rootMediaQuery.data.padding.top;

    return textBoxAbsY > keyboardAbsY
        ? keyboardAbsY -
            unsafeAreaHeight -
            2 * widget.suggestionsBoxVerticalOffset
        : textBoxAbsY -
            unsafeAreaHeight -
            2 * widget.suggestionsBoxVerticalOffset;
  }

  static const int _waitMetricsTimeoutMillis = 1000;

  // Delays until the keyboard has toggled or the orientation has fully changed
  Future<void> updateDimensions() async {
    if (!_context.mounted) return;
    // initial viewInsets which are before the keyboard is toggled
    EdgeInsets initial = MediaQuery.of(_context).viewInsets;
    // initial MediaQuery for orientation change
    MediaQuery? initialRootMediaQuery = _findRootMediaQuery();

    int timer = 0;
    // viewInsets or MediaQuery have changed once keyboard has toggled or orientation has changed
    while (_context.mounted && timer < _waitMetricsTimeoutMillis) {
      // TODO: reduce delay if showDialog ever exposes detection of animation end
      await Future<void>.delayed(const Duration(milliseconds: 170));
      timer += 170;

      if (!_context.mounted) return;
      if (MediaQuery.of(_context).viewInsets != initial ||
          _findRootMediaQuery() != initialRootMediaQuery) {
        resize();
      }
    }
  }

  MediaQuery? _findRootMediaQuery() {
    MediaQuery? rootMediaQuery;
    _context.visitAncestorElements((element) {
      if (element.widget is MediaQuery) {
        rootMediaQuery = element.widget as MediaQuery;
      }
      return true;
    });

    return rootMediaQuery;
  }

  @override
  void dispose() {
    close();
    _keyEventController.close();
    super.dispose();
  }
}
