import 'package:flutter/material.dart';
import 'package:flutter_typeahead/src/common/base/suggestions_decoration.dart';

/// Supply an instance of this class to the [TypeAheadField.suggestionsBoxDecoration]
/// property to configure the suggestions box decoration
class SuggestionsDecoration extends BaseSuggestionsDecoration {
  /// Creates a SuggestionsBoxDecoration
  const SuggestionsDecoration({
    this.elevation = 4,
    super.color,
    this.shape,
    super.hasScrollbar,
    this.borderRadius,
    this.shadowColor = Colors.black,
    super.constraints,
    this.clipBehavior = Clip.none,
    super.scrollbarThumbAlwaysVisible,
    this.scrollbarTrackAlwaysVisible = false,
    super.offset,
  });

  /// The z-coordinate at which to place the suggestions box. This controls the size
  /// of the shadow below the box.
  ///
  /// Same as [Material.elevation](https://docs.flutter.io/flutter/material/Material/elevation.html)
  final double elevation;

  /// Defines the material's shape as well its shadow.
  ///
  /// Same as [Material.shape](https://docs.flutter.io/flutter/material/Material/shape.html)
  final ShapeBorder? shape;

  /// If set to true, the scrollbar track in the suggestion list will always be visible
  /// evnen when not scrolling.
  ///
  /// Defaults to false
  final bool scrollbarTrackAlwaysVisible;

  /// If non-null, the corners of this box are rounded by this [BorderRadius](https://docs.flutter.io/flutter/painting/BorderRadius-class.html).
  ///
  /// Same as [Material.borderRadius](https://docs.flutter.io/flutter/material/Material/borderRadius.html)
  final BorderRadius? borderRadius;

  /// The color to paint the shadow below the material.
  ///
  /// Same as [Material.shadowColor](https://docs.flutter.io/flutter/material/Material/shadowColor.html)
  final Color shadowColor;

  /// The content will be clipped (or not) according to this option.
  ///
  /// Same as [Material.clipBehavior](https://api.flutter.dev/flutter/material/Material/clipBehavior.html)
  final Clip clipBehavior;
}
