import 'package:flutter/widgets.dart';

abstract class BaseSuggestionsBoxDecoration {
  const BaseSuggestionsBoxDecoration({
    this.hasScrollbar = true,
    this.scrollbarThumbAlwaysVisible = false,
    this.constraints,
    this.color,
    this.offsetX = 0,
    this.offsetY = 5,
  });

  /// Defines if a scrollbar will be displayed or not.
  ///
  /// Defaults to true.
  final bool hasScrollbar;

  /// Whether the scrollbar thumb in the suggestion list should always be visible
  /// even when the user is not scrolling.
  ///
  /// Defaults to false.
  final bool scrollbarThumbAlwaysVisible;

  /// The constraints to be applied to the suggestions box
  final BoxConstraints? constraints;

  /// The color to paint the suggestions box.
  ///
  /// Same as [Material.color](https://docs.flutter.io/flutter/material/Material/color.html)
  final Color? color;

  /// The horizontal offset of the suggestions box.
  ///
  /// Defaults to 0.
  final double offsetX;

  /// The vertical offset of the suggestions box.
  ///
  /// Defaults to 5.
  final double offsetY;
}
