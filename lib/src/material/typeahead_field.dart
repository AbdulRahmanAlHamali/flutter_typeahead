import 'package:flutter/material.dart';
import 'package:flutter_typeahead/src/common/field/typeahead_field.dart';
import 'package:flutter_typeahead/src/common/base/types.dart';
import 'package:flutter_typeahead/src/material/material_defaults.dart';

/// {@macro flutter_typeahead.RawTypeAheadField}
class TypeAheadField<T> extends RawTypeAheadField<T> {
  TypeAheadField({
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
    DecorationBuilder? decorationBuilder,
    super.listBuilder,
    super.constraints,
    super.offset,
  }) : super(
          builder: builder ?? TypeAheadMaterialDefaults.builder,
          errorBuilder: errorBuilder ?? TypeAheadMaterialDefaults.errorBuilder,
          loadingBuilder:
              loadingBuilder ?? TypeAheadMaterialDefaults.loadingBuilder,
          emptyBuilder: emptyBuilder ?? TypeAheadMaterialDefaults.emptyBuilder,
          itemBuilder: TypeAheadMaterialDefaults.itemBuilder(itemBuilder),
          decorationBuilder:
              TypeAheadMaterialDefaults.wrapperBuilder(decorationBuilder),
        );
}
