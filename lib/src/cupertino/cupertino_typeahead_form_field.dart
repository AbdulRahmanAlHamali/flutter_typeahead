import 'dart:core';

import 'package:flutter_typeahead/src/common/typeahead/typeahead_form_field.dart';
import 'package:flutter_typeahead/src/cupertino/cupertino_suggestions_decoration.dart';
import 'package:flutter_typeahead/src/cupertino/cupertino_typeahead_field.dart';

/// {@macro typeahead_field.TypeAheadFormField}
class CupertinoTypeAheadFormField<T> extends RawTypeAheadFormField<T> {
  /// Creates a [CupertinoTypeAheadFormField]
  CupertinoTypeAheadFormField({
    super.key,
    super.animationDuration,
    super.autoFlipDirection,
    super.autoFlipListDirection,
    super.autoFlipMinHeight,
    super.builder,
    super.controller,
    super.debounceDuration,
    super.direction,
    super.errorBuilder,
    super.focusNode,
    super.hideKeyboardOnDrag,
    super.hideOnEmpty,
    super.hideOnError,
    super.hideOnLoading,
    super.hideOnUnfocus,
    super.hideWithKeyboard,
    super.hideOnSelect,
    required super.itemBuilder,
    super.itemSeparatorBuilder,
    super.keepSuggestionsOnLoading,
    super.loadingBuilder,
    super.minCharsForSuggestions,
    super.emptyBuilder,
    required super.onSelected,
    super.scrollController,
    super.suggestionsController,
    required super.suggestionsCallback,
    super.transitionBuilder,
    super.wrapperBuilder,
    super.initialValue,
    super.onReset,
    super.onSaved,
    super.validator,
    super.autovalidateMode,
    super.enabled,
    this.suggestionsDecoration = const CupertinoSuggestionsDecoration(),
  }) : super(
          constraints: suggestionsDecoration.constraints,
          offset: suggestionsDecoration.offset,
          fieldBuilder: (field) => CupertinoTypeAheadField<T>(
            animationDuration: animationDuration,
            autoFlipDirection: autoFlipDirection,
            autoFlipListDirection: autoFlipListDirection,
            autoFlipMinHeight: autoFlipMinHeight,
            builder: builder,
            debounceDuration: debounceDuration,
            direction: direction,
            errorBuilder: errorBuilder,
            hideKeyboardOnDrag: hideKeyboardOnDrag,
            hideOnEmpty: hideOnEmpty,
            hideOnError: hideOnError,
            hideOnLoading: hideOnLoading,
            hideOnUnfocus: hideOnUnfocus,
            hideWithKeyboard: hideWithKeyboard,
            hideOnSelect: hideOnSelect,
            itemBuilder: itemBuilder,
            itemSeparatorBuilder: itemSeparatorBuilder,
            keepSuggestionsOnLoading: keepSuggestionsOnLoading,
            loadingBuilder: loadingBuilder,
            minCharsForSuggestions: minCharsForSuggestions,
            emptyBuilder: emptyBuilder,
            onSelected: onSelected,
            suggestionsController: suggestionsController,
            suggestionsDecoration: suggestionsDecoration,
            suggestionsCallback: suggestionsCallback,
            transitionBuilder: transitionBuilder,
          ),
        );

  /// {@macro flutter_typeahead.TypeAheadField.suggestionsDecoration}
  final CupertinoSuggestionsDecoration suggestionsDecoration;
}
