import 'package:flutter/widgets.dart';

abstract class BaseSuggestionsBoxDecoration {
  const BaseSuggestionsBoxDecoration({
    this.hasScrollbar = true,
    this.scrollbarThumbAlwaysVisible = false,
    this.constraints,
    this.color,
    this.offsetX = 0,
  });

  /// Defines if a scrollbar will be displayed or not.
  final bool hasScrollbar;

  /// If set to true, the scrollbar thumb in the suggestion list will always be visible
  /// evnen when not scrolling.
  ///
  /// Defaults to false
  final bool scrollbarThumbAlwaysVisible;

  /// The constraints to be applied to the suggestions box
  final BoxConstraints? constraints;

  /// The color to paint the suggestions box.
  ///
  /// Same as [Material.color](https://docs.flutter.io/flutter/material/Material/color.html)
  final Color? color;

  /// Adds an offset to the suggestions box
  final double offsetX;
}
