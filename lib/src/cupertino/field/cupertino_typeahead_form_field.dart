import 'dart:core';

import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/src/common/field/typeahead_form_field.dart';
import 'package:flutter_typeahead/src/cupertino/field/cupertino_text_field_configuration.dart';
import 'package:flutter_typeahead/src/cupertino/field/cupertino_typeahead_field.dart';
import 'package:flutter_typeahead/src/cupertino/suggestions_box/cupertino_suggestions_decoration.dart';

/// A [FormField](https://docs.flutter.io/flutter/widgets/FormField-class.html)
/// implementation of [TypeAheadField], that allows the value to be saved,
/// validated, etc.
///
/// See also:
///
/// * [TypeAheadField], A [CupertinoTextField](https://docs.flutter.io/flutter/cupertino/CupertinoTextField-class.html)
/// that displays a list of suggestions as the user types
class CupertinoTypeAheadFormField<T> extends BaseTypeAheadFormField<T> {
  /// Creates a [CupertinoTypeAheadFormField]
  CupertinoTypeAheadFormField({
    super.key,
    super.animationDuration,
    super.animationStart,
    super.autoFlipDirection,
    super.autoFlipListDirection,
    super.autoFlipMinHeight,
    super.autovalidateMode,
    super.debounceDuration,
    super.direction,
    super.enabled,
    super.errorBuilder,
    super.hideKeyboardOnDrag,
    super.hideOnEmpty,
    super.hideOnError,
    super.hideOnLoading,
    super.hideOnUnfocus,
    super.hideWithKeyboard,
    super.hideOnSelect,
    super.initialValue,
    super.intercepting,
    required super.itemBuilder,
    super.itemSeparatorBuilder,
    super.keepSuggestionsOnLoading,
    super.layoutArchitecture,
    super.loadingBuilder,
    super.minCharsForSuggestions,
    super.noItemsFoundBuilder,
    super.onReset,
    super.onSaved,
    required super.onSuggestionSelected,
    super.suggestionsController,
    this.suggestionsDecoration = const CupertinoSuggestionsDecoration(),
    required super.suggestionsCallback,
    CupertinoTextFieldConfiguration super.textFieldConfiguration =
        const CupertinoTextFieldConfiguration(),
    super.transitionBuilder,
    super.validator,
  });

  @override
  final CupertinoSuggestionsDecoration suggestionsDecoration;

  @override
  Widget buildTextField(BaseTypeAheadFormFieldState<T> field,
      covariant CupertinoTextFieldConfiguration config) {
    return CupertinoTypeAheadField(
      animationDuration: animationDuration,
      animationStart: animationStart,
      autoFlipDirection: autoFlipDirection,
      autoFlipListDirection: autoFlipListDirection,
      autoFlipMinHeight: autoFlipMinHeight,
      debounceDuration: debounceDuration,
      direction: direction,
      errorBuilder: errorBuilder,
      hideKeyboardOnDrag: hideKeyboardOnDrag,
      hideOnEmpty: hideOnEmpty,
      hideOnError: hideOnError,
      hideOnLoading: hideOnLoading,
      hideOnUnfocus: hideOnUnfocus,
      hideOnSelect: hideOnSelect,
      itemBuilder: itemBuilder,
      itemSeparatorBuilder: itemSeparatorBuilder,
      keepSuggestionsOnLoading: keepSuggestionsOnLoading,
      layoutArchitecture: layoutArchitecture,
      loadingBuilder: loadingBuilder,
      minCharsForSuggestions: minCharsForSuggestions,
      noItemsFoundBuilder: noItemsFoundBuilder,
      onSuggestionSelected: onSuggestionSelected,
      suggestionsController: suggestionsController,
      suggestionsDecoration: suggestionsDecoration,
      suggestionsCallback: suggestionsCallback,
      textFieldConfiguration: config,
      transitionBuilder: transitionBuilder,
    );
  }
}
