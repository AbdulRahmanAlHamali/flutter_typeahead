import 'package:flutter/cupertino.dart';

/// Supply an instance of this class to the [TypeAhead.suggestionsBoxDecoration]
/// property to configure the suggestions box decoration
class CupertinoSuggestionsBoxDecoration {
  /// Defines if a scrollbar will be displayed or not.
  final bool hasScrollbar;

  /// If set to true, the scrollbar thumb in the suggestion list will always be visible
  /// evnen when not scrolling.
  ///
  /// Defaults to false
  final bool scrollbarThumbAlwaysVisible;

  /// The constraints to be applied to the suggestions box
  final BoxConstraints? constraints;
  final Color? color;
  final BoxBorder? border;
  final BorderRadiusGeometry? borderRadius;

  /// Adds an offset to the suggestions box
  final double offsetX;

  /// Creates a [CupertinoSuggestionsBoxDecoration]
  const CupertinoSuggestionsBoxDecoration({
    this.hasScrollbar = true,
    this.constraints,
    this.color,
    this.border,
    this.borderRadius,
    this.offsetX = 0.0,
    this.scrollbarThumbAlwaysVisible = false,
  });
}
