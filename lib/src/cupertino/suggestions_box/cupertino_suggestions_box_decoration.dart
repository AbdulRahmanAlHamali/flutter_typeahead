import 'package:flutter/cupertino.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_box_decoration.dart';

/// Supply an instance of this class to the [TypeAhead.suggestionsBoxDecoration]
/// property to configure the suggestions box decoration
class CupertinoSuggestionsBoxDecoration extends BaseSuggestionsBoxDecoration {
  /// Creates a [CupertinoSuggestionsBoxDecoration]
  const CupertinoSuggestionsBoxDecoration({
    super.hasScrollbar,
    super.constraints,
    super.color,
    this.border,
    this.borderRadius,
    super.offsetX,
    super.scrollbarThumbAlwaysVisible,
  });

  final BoxBorder? border;
  final BorderRadiusGeometry? borderRadius;
}
