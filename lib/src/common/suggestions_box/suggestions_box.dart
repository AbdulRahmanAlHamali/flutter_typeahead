import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/root_media_query.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_box_controller.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_box_decoration.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_box_dimension_connector.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_box_focus_connector.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_box_keyboard_connector.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_box_overlay_entry.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_box_scroll_connector.dart';

/// A widget that displays a list of suggestions above or below another widget.
class SuggestionsBox<T> extends StatefulWidget {
  const SuggestionsBox({
    super.key,
    this.direction = AxisDirection.down,
    required this.controller,
    required this.suggestionsListBuilder,
    required this.focusNode,
    required this.child,
    required this.decoration,
    this.autoFlipDirection = false,
    this.autoFlipListDirection = true,
    this.autoFlipMinHeight = 64,
    this.hideOnUnfocus = true,
    this.ignoreAccessibleNavigation = false,
  });

  /// The controller of the suggestions box.
  final SuggestionsBoxController controller;

  /// The builder for the suggestions list.
  final WidgetBuilder suggestionsListBuilder;

  /// The focus node of the child of the suggestions box.
  final FocusNode focusNode;

  /// The child of the suggestions box.
  final Widget child;

  /// {@template flutter_typeahead.SuggestionsBox.direction}
  /// The direction in which the suggestions box opens.
  ///
  /// Must be either [AxisDirection.down] or [AxisDirection.up].
  ///
  /// Defaults to [AxisDirection.down].
  /// {@endtemplate}
  final AxisDirection direction;

  /// {@template flutter_typeahead.SuggestionsBox.autoFlipDirection}
  /// Whether the suggestions box should automatically flip direction if there's not enough space
  /// in the desired direction, but there is enough space in the opposite direction.
  ///
  /// Defaults to false.
  ///
  /// See also:
  /// * [autoFlipListDirection], which controls whether the suggestions list should be reversed if the suggestions box is flipped.
  /// * [autoFlipMinHeight], which controls the minimum height the suggesttions box can have before attempting to flip.
  /// {@endtemplate}
  final bool autoFlipDirection;

  /// {@template flutter_typeahead.SuggestionsBox.autoFlipListDirection}
  /// Whether the suggestions list should be reversed if the suggestions box is flipped.
  ///
  /// Defaults to true.
  /// {@endtemplate}
  final bool autoFlipListDirection;

  /// {@template flutter_typeahead.SuggestionsBox.autoFlipMinHeight}
  /// The minimum height the suggesttions box can have before attempting to flip.
  ///
  /// Defaults to 64.
  /// {@endtemplate}
  final double autoFlipMinHeight;

  /// The decoration of the suggestions box.
  final BaseSuggestionsBoxDecoration decoration;

  /// {@template flutter_typeahead.SuggestionsBox.hideOnUnfocus}
  /// Whether the suggestions box should be hidden when the child of the suggestions box loses focus.
  ///
  /// If disabled, the suggestions box will remain open when the user e.g. closes the keyboard.
  ///
  /// Defaults to true.
  /// {@endtemplate}
  final bool hideOnUnfocus;

  /// Whether the suggestions box should ignore the [MediaQueryData.accessibleNavigation] setting.
  final bool ignoreAccessibleNavigation;

  @override
  State<SuggestionsBox<T>> createState() => _SuggestionsBoxState<T>();
}

class _SuggestionsBoxState<T> extends State<SuggestionsBox<T>> {
  final LayerLink _layerLink = LayerLink();

  double maxHeight = 200;
  double width = 100;
  double height = 100;

  late AxisDirection direction;
  AxisDirection get desiredDirection => widget.direction;

  late OverlayState overlay;
  late OverlayEntry overlayEntry;

  late StreamSubscription<void> resizeSubscription;

  @override
  void initState() {
    super.initState();

    overlay = Overlay.of(context);
    overlayEntry = _createOverlay();
    direction = desiredDirection;

    widget.controller.addListener(onOpenedChanged);
    resizeSubscription = widget.controller.resizeEvents.listen((_) => resize());
  }

  @override
  void didUpdateWidget(covariant SuggestionsBox<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(onOpenedChanged);
      widget.controller.addListener(onOpenedChanged);
      resizeSubscription.cancel();
      resizeSubscription =
          widget.controller.resizeEvents.listen((_) => resize());
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    OverlayState newOverlay = Overlay.of(context);
    if (newOverlay != overlay) {
      overlay = newOverlay;
      overlayEntry.remove();
      overlay.insert(overlayEntry);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(onOpenedChanged);
    resizeSubscription.cancel();
    super.dispose();
  }

  /// Handles when the suggestions box is opened or closed via the controller.
  void onOpenedChanged() {
    if (widget.controller.isOpen) {
      if (overlayEntry.mounted) return;
      overlay.insert(overlayEntry);
    } else {
      if (!overlayEntry.mounted) return;
      overlayEntry.remove();
    }
  }

  void rebuildOverlay() {
    // TODO: make this less jank
    overlayEntry.markNeedsBuild();
  }

  // Resize the suggestions box based on the available height.
  // If there's not enough room in the desired direction, flip the direction
  // and see if there's enough room there.
  void resize() {
    RenderBox? box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;

    width = box.size.width;
    height = box.size.height;
    rebuildOverlay();

    // top of text box
    double textBoxAbsY = box.localToGlobal(Offset.zero).dy;

    // height of window
    double windowHeight = MediaQuery.of(context).size.height;

    // TODO: find some better way to do this
    // we need to find the root MediaQuery for the unsafe area height
    // we cannot use BuildContext.ancestorWidgetOfExactType because
    // widgets like SafeArea creates a new MediaQuery with the padding removed
    MediaQuery? rootMediaQuery = rootMediaQueryOf(context);
    if (rootMediaQuery == null) {
      throw StateError(
        'Unable to find a MediaQuery ancestor in the current context.',
      );
    }

    // height of keyboard
    double keyboardHeight = rootMediaQuery.data.viewInsets.bottom;

    double maxHeightDesired = calculateMaxHeight(desiredDirection, box,
        windowHeight, rootMediaQuery, keyboardHeight, textBoxAbsY);

    // if there's enough room in the desired direction, update the direction and the max height
    if (!widget.autoFlipDirection ||
        maxHeightDesired >= widget.autoFlipMinHeight) {
      direction = desiredDirection;
      rebuildOverlay();
      // Sometimes textBoxAbsY is NaN, so we need to check for that
      if (!maxHeightDesired.isNaN) {
        maxHeight = maxHeightDesired;
        rebuildOverlay();
      }
    } else {
      // There's not enough room in the desired direction so see how much room is in the opposite direction
      AxisDirection flipped = flipAxisDirection(desiredDirection);
      double maxHeightFlipped = calculateMaxHeight(flipped, box, windowHeight,
          rootMediaQuery, keyboardHeight, textBoxAbsY);

      // if there's more room in this opposite direction, update the direction and maxHeight
      if (maxHeightFlipped > maxHeightDesired) {
        direction = flipped;
        rebuildOverlay();

        // Not sure if this is needed, but it's here just in case
        if (!maxHeightFlipped.isNaN) {
          maxHeight = maxHeightFlipped;
          rebuildOverlay();
        }
      }
    }

    if (maxHeight < 0) {
      maxHeight = 0;
      rebuildOverlay();
    }
  }

  double calculateMaxHeight(
    AxisDirection direction,
    RenderBox box,
    double windowHeight,
    MediaQuery rootMediaQuery,
    double keyboardHeight,
    double textBoxAbsY,
  ) {
    return direction == AxisDirection.down
        ? calculateMaxHeightDown(
            box, windowHeight, rootMediaQuery, keyboardHeight, textBoxAbsY)
        : calculateMaxHeightUp(
            box, windowHeight, rootMediaQuery, keyboardHeight, textBoxAbsY);
  }

  double calculateMaxHeightDown(
    RenderBox box,
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
        2 * widget.decoration.offsetY;
  }

  double calculateMaxHeightUp(
    RenderBox box,
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
        ? keyboardAbsY - unsafeAreaHeight - 2 * widget.decoration.offsetY
        : textBoxAbsY - unsafeAreaHeight - 2 * widget.decoration.offsetY;
  }

  OverlayEntry _createOverlay() {
    return OverlayEntry(
      builder: (context) => SuggestionsBoxOverlayEntry(
        layerLink: _layerLink,
        suggestionsListBuilder: widget.suggestionsListBuilder,
        direction: direction,
        width: width,
        height: height,
        maxHeight: maxHeight,
        decoration: widget.decoration,
        ignoreAccessibleNavigation: widget.ignoreAccessibleNavigation,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SuggestionsBoxFocusConnector(
      controller: widget.controller,
      focusNode: widget.focusNode,
      hideOnUnfocus: widget.hideOnUnfocus,
      child: SuggestionsBoxScrollConnector(
        controller: widget.controller,
        child: SuggestionsBoxDimensionConnector(
          controller: widget.controller,
          child: SuggestionsBoxKeyboardConnector(
            controller: widget.controller,
            hideOnUnfocus: widget.hideOnUnfocus,
            child: CompositedTransformTarget(
              link: _layerLink,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
