import 'package:flutter/material.dart';
import 'package:flutter_typeahead/src/common/field/typeahead_field.dart';
import 'package:flutter_typeahead/src/common/base/types.dart';
import 'package:flutter_typeahead/src/material/material_defaults.dart';

/// {@template flutter_typeahead.TypeAheadField}
/// A widget that shows suggestions above a text field while the user is typing.
///
/// This is the Material Design version of the widget.
/// builder, itemBuilder, loadingBuilder, emptyBuilder, errorBuilder and decorationBuilder will default to Material Design.
/// {@endtemplate}
class TypeAheadField<T> extends RawTypeAheadField<T> {
  TypeAheadField({
    super.key,
    super.animationDuration,
    super.autoFlipDirection,
    super.autoFlipMinHeight,
    TextFieldBuilder? builder,
    super.controller,
    super.debounceDuration,
    super.direction,
    SuggestionsErrorBuilder? errorBuilder,
    super.focusNode,
    super.hideKeyboardOnDrag,
    super.hideOnEmpty,
    super.hideOnError,
    super.hideOnLoading,
    super.showOnFocus,
    super.hideOnUnfocus,
    super.hideWithKeyboard,
    super.hideOnSelect,
    BorderRadius itemBorderRadius = BorderRadius.zero,
    required SuggestionsItemBuilder<T> itemBuilder,
    super.itemSeparatorBuilder,
    super.retainOnLoading,
    WidgetBuilder? loadingBuilder,
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
          itemBuilder: TypeAheadMaterialDefaults.itemBuilder(
              itemBuilder, itemBorderRadius),
          decorationBuilder:
              TypeAheadMaterialDefaults.wrapperBuilder(decorationBuilder),
        );
}
