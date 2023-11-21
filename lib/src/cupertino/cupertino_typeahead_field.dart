import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter_typeahead/src/common/typeahead/typeahead_field.dart';
import 'package:flutter_typeahead/src/common/base/typedef.dart';
import 'package:flutter_typeahead/src/cupertino/cupertino_defaults.dart';
import 'package:flutter_typeahead/src/cupertino/cupertino_suggestions_decoration.dart';

/// {@macro flutter_typeahead.BaseTypeAheadField}
class CupertinoTypeAheadField<T> extends RawTypeAheadField<T> {
  CupertinoTypeAheadField({
    super.key,
    super.animationDuration,
    super.autoFlipDirection,
    super.autoFlipListDirection,
    super.autoFlipMinHeight,
    TextFieldBuilder? builder,
    super.controller,
    super.debounceDuration,
    super.direction,
    ErrorBuilder? errorBuilder,
    super.focusNode,
    super.hideKeyboardOnDrag,
    super.hideOnEmpty,
    super.hideOnError,
    super.hideOnLoading,
    super.hideOnUnfocus,
    super.hideWithKeyboard,
    super.hideOnSelect,
    required ItemBuilder<T> itemBuilder,
    super.itemSeparatorBuilder,
    super.keepSuggestionsOnLoading,
    WidgetBuilder? loadingBuilder,
    super.minCharsForSuggestions,
    WidgetBuilder? emptyBuilder,
    required super.onSelected,
    super.scrollController,
    super.suggestionsController,
    required super.suggestionsCallback,
    super.transitionBuilder,
    this.suggestionsDecoration = const CupertinoSuggestionsDecoration(),
  }) : super(
          constraints: suggestionsDecoration.constraints,
          offset: suggestionsDecoration.offset,
          builder: builder ?? TypeAheadCupertinoDefaults.builder,
          errorBuilder: errorBuilder ?? TypeAheadCupertinoDefaults.errorBuilder,
          loadingBuilder:
              loadingBuilder ?? TypeAheadCupertinoDefaults.loadingBuilder,
          emptyBuilder: emptyBuilder ?? TypeAheadCupertinoDefaults.emptyBuilder,
          itemBuilder: TypeAheadCupertinoDefaults.itemBuilder(itemBuilder),
          wrapperBuilder:
              TypeAheadCupertinoDefaults.wrapperBuilder(suggestionsDecoration),
        );

  /// {@macro flutter_typeahead.TypeAheadField.suggestionsDecoration}
  final CupertinoSuggestionsDecoration suggestionsDecoration;
}
