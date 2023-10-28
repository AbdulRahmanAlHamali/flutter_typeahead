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
    super.hideSuggestionsOnKeyboardHide,
    super.ignoreAccessibleNavigation,
    super.initialValue,
    super.intercepting,
    required super.itemBuilder,
    super.itemSeparatorBuilder,
    super.keepSuggestionsOnLoading,
    super.keepSuggestionsOnSuggestionSelected,
    super.layoutArchitecture,
    super.loadingBuilder,
    super.minCharsForSuggestions,
    super.noItemsFoundBuilder,
    super.onReset,
    super.onSaved,
    required super.onSuggestionSelected,
    super.suggestionsBoxController,
    this.suggestionsBoxDecoration = const CupertinoSuggestionsBoxDecoration(),
    super.suggestionsBoxVerticalOffset,
    required super.suggestionsCallback,
    required super.textFieldConfiguration,
    super.transitionBuilder,
    super.validator,
  });

  @override
  final CupertinoSuggestionsBoxDecoration? suggestionsBoxDecoration;

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
      hideSuggestionsOnKeyboardHide: hideSuggestionsOnKeyboardHide,
      itemBuilder: itemBuilder,
      itemSeparatorBuilder: itemSeparatorBuilder,
      keepSuggestionsOnLoading: keepSuggestionsOnLoading,
      keepSuggestionsOnSuggestionSelected: keepSuggestionsOnSuggestionSelected,
      loadingBuilder: loadingBuilder,
      minCharsForSuggestions: minCharsForSuggestions,
      noItemsFoundBuilder: noItemsFoundBuilder,
      onSuggestionSelected: onSuggestionSelected,
      suggestionsBoxController: suggestionsBoxController,
      suggestionsBoxDecoration: suggestionsBoxDecoration,
      suggestionsBoxVerticalOffset: suggestionsBoxVerticalOffset,
      suggestionsCallback: suggestionsCallback,
      textFieldConfiguration: config,
      transitionBuilder: transitionBuilder,
    );
  }
}
