import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/src/common/field/typeahead_field.dart';

class SuggestionsBox {
  SuggestionsBox(
    this.context,
    this.direction,
    this.autoFlipDirection,
    this.autoFlipListDirection,
    this.autoFlipMinHeight,
  )   : desiredDirection = direction,
        assert(
          direction == AxisDirection.down || direction == AxisDirection.up,
          'SuggestionsBox direction must be either AxisDirection.down or AxisDirection.up',
        );

  static const int _waitMetricsTimeoutMillis = 1000;

  final BuildContext context;
  final AxisDirection desiredDirection;
  final bool autoFlipDirection;
  final bool autoFlipListDirection;
  final double autoFlipMinHeight;

  OverlayEntry? overlayEntry;
  AxisDirection direction;

  bool _isOpened = false;
  bool get isOpened => _isOpened;

  double maxHeight = 200;
  double textBoxWidth = 100;
  double textBoxHeight = 100;

  final StreamController<LogicalKeyboardKey> _keyEventController =
      StreamController<LogicalKeyboardKey>.broadcast();

  Stream<LogicalKeyboardKey> get keyEvents => _keyEventController.stream;

  KeyEventResult onKeyEvent(FocusNode node, RawKeyEvent key) {
    _keyEventController.add(key.logicalKey);
    return KeyEventResult.ignored;
  }

  void _assertInitialized() {
    if (overlayEntry == null) {
      throw StateError(
        'SuggestionsBox must be initialized '
        'before calling this method',
      );
    }
  }

  void open() {
    _assertInitialized();
    if (isOpened) return;
    resize();
    Overlay.of(context).insert(overlayEntry!);
    _isOpened = true;
  }

  void close() {
    _assertInitialized();
    if (!isOpened) return;
    overlayEntry!.remove();
    _isOpened = false;
  }

  void toggle() {
    if (isOpened) {
      close();
    } else {
      open();
    }
  }

  void resize() {
    // check to see if widget is still mounted
    // user may have closed the widget with the keyboard still open
    if (context.mounted) {
      _adjustMaxHeightAndOrientation();
      overlayEntry!.markNeedsBuild();
    }
  }

  // See if there's enough room in the desired direction for the overlay to display
  // correctly. If not, try the opposite direction if things look more roomy there
  void _adjustMaxHeightAndOrientation() {
    BaseTypeAheadField widget = context.widget as BaseTypeAheadField;

    RenderBox? box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;

    textBoxWidth = box.size.width;
    textBoxHeight = box.size.height;

    // top of text box
    double textBoxAbsY = box.localToGlobal(Offset.zero).dy;

    // height of window
    double windowHeight = MediaQuery.of(context).size.height;

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
      direction = desiredDirection;
      // Sometimes textBoxAbsY is NaN, so we need to check for that
      if (!maxHDesired.isNaN) {
        maxHeight = maxHDesired;
      }
    } else {
      // There's not enough room in the desired direction so see how much room is in the opposite direction
      AxisDirection flipped = flipAxisDirection(desiredDirection);
      double maxHFlipped = _calculateMaxHeight(flipped, box, widget,
          windowHeight, rootMediaQuery, keyboardHeight, textBoxAbsY);

      // if there's more room in this opposite direction, update the direction and maxHeight
      if (maxHFlipped > maxHDesired) {
        direction = flipped;

        // Not sure if this is needed, but it's here just in case
        if (!maxHFlipped.isNaN) {
          maxHeight = maxHFlipped;
        }
      }
    }

    if (maxHeight < 0) maxHeight = 0;
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
        textBoxHeight -
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

  Future<void> updateDimensions() async {
    if (await _updateDimensions()) {
      resize();
    }
  }

  /// Delays until the keyboard has toggled or the orientation has fully changed
  Future<bool> _updateDimensions() async {
    if (context.mounted) {
      // initial viewInsets which are before the keyboard is toggled
      EdgeInsets initial = MediaQuery.of(context).viewInsets;
      // initial MediaQuery for orientation change
      MediaQuery? initialRootMediaQuery = _findRootMediaQuery();

      int timer = 0;
      // viewInsets or MediaQuery have changed once keyboard has toggled or orientation has changed
      while (context.mounted && timer < _waitMetricsTimeoutMillis) {
        // TODO: reduce delay if showDialog ever exposes detection of animation end
        await Future<void>.delayed(const Duration(milliseconds: 170));
        timer += 170;

        if (context.mounted &&
            (MediaQuery.of(context).viewInsets != initial ||
                _findRootMediaQuery() != initialRootMediaQuery)) {
          return true;
        }
      }
    }

    return false;
  }

  MediaQuery? _findRootMediaQuery() {
    MediaQuery? rootMediaQuery;
    context.visitAncestorElements((element) {
      if (element.widget is MediaQuery) {
        rootMediaQuery = element.widget as MediaQuery;
      }
      return true;
    });

    return rootMediaQuery;
  }

  void dispose() {
    close();
    _keyEventController.close();
  }
}
