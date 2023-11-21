import 'package:flutter/cupertino.dart';
import 'package:flutter_typeahead/src/common/base/suggestions_decoration.dart';

/// Supply an instance of this class to the [TypeAhead.suggestionsDecoration]
/// property to configure the suggestions box decoration
class CupertinoSuggestionsDecoration extends BaseSuggestionsDecoration {
  /// Creates a [CupertinoSuggestionsDecoration]
  const CupertinoSuggestionsDecoration({
    super.hasScrollbar,
    super.constraints,
    super.color,
    this.border,
    this.borderRadius,
    super.scrollbarThumbAlwaysVisible,
    super.offset,
  });

  final BoxBorder? border;
  final BorderRadiusGeometry? borderRadius;
}
