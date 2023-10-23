import 'dart:core';

import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/src/common/field/typeahead_form_field.dart';
import 'package:flutter_typeahead/src/cupertino/field/cupertino_text_field_configuration.dart';
import 'package:flutter_typeahead/src/cupertino/field/cupertino_typeahead_field.dart';
import 'package:flutter_typeahead/src/cupertino/suggestions_box/cupertino_suggestions_box_decoration.dart';

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
    super.initialValue,
    super.enabled,
    super.autovalidateMode,
    super.onSaved,
    super.onReset,
    super.validator,
    super.errorBuilder,
    super.noItemsFoundBuilder,
    super.loadingBuilder,
    super.onSuggestionsBoxToggle,
    super.debounceDuration,
    this.suggestionsBoxDecoration = const CupertinoSuggestionsBoxDecoration(),
    super.suggestionsBoxController,
    required super.onSuggestionSelected,
    required super.itemBuilder,
    super.itemSeparatorBuilder,
    super.layoutArchitecture,
    required super.suggestionsCallback,
    super.suggestionsBoxVerticalOffset,
    required super.textFieldConfiguration,
    super.transitionBuilder,
    super.animationDuration,
    super.animationStart,
    super.direction,
    super.hideOnLoading,
    super.hideOnEmpty,
    super.hideOnError,
    super.hideSuggestionsOnKeyboardHide,
    super.intercepting,
    super.keepSuggestionsOnLoading,
    super.keepSuggestionsOnSuggestionSelected,
    super.autoFlipDirection,
    super.autoFlipListDirection,
    super.autoFlipMinHeight,
    super.hideKeyboard,
    super.minCharsForSuggestions,
    super.hideKeyboardOnDrag,
    super.ignoreAccessibleNavigation,
  });

  @override
  final CupertinoSuggestionsBoxDecoration? suggestionsBoxDecoration;

  @override
  Widget buildTextField(BaseTypeAheadFormFieldState<T> field,
      covariant CupertinoTextFieldConfiguration config) {
    return CupertinoTypeAheadField(
      transitionBuilder: transitionBuilder,
      errorBuilder: errorBuilder,
      noItemsFoundBuilder: noItemsFoundBuilder,
      loadingBuilder: loadingBuilder,
      debounceDuration: debounceDuration,
      suggestionsBoxDecoration: suggestionsBoxDecoration,
      suggestionsBoxController: suggestionsBoxController,
      textFieldConfiguration: config,
      suggestionsBoxVerticalOffset: suggestionsBoxVerticalOffset,
      onSuggestionSelected: onSuggestionSelected,
      itemBuilder: itemBuilder,
      itemSeparatorBuilder: itemSeparatorBuilder,
      suggestionsCallback: suggestionsCallback,
      animationStart: animationStart,
      animationDuration: animationDuration,
      direction: direction,
      hideOnLoading: hideOnLoading,
      hideOnEmpty: hideOnEmpty,
      hideOnError: hideOnError,
      hideSuggestionsOnKeyboardHide: hideSuggestionsOnKeyboardHide,
      keepSuggestionsOnLoading: keepSuggestionsOnLoading,
      keepSuggestionsOnSuggestionSelected: keepSuggestionsOnSuggestionSelected,
      autoFlipDirection: autoFlipDirection,
      autoFlipListDirection: autoFlipListDirection,
      autoFlipMinHeight: autoFlipMinHeight,
      minCharsForSuggestions: minCharsForSuggestions,
      hideKeyboardOnDrag: hideKeyboardOnDrag,
    );
  }
}
