import 'package:flutter/material.dart';
import 'package:flutter_typeahead/src/common/field/typeahead_form_field.dart';
import 'package:flutter_typeahead/src/material/field/text_field_configuration.dart';
import 'package:flutter_typeahead/src/material/field/typeahead_field.dart';
import 'package:flutter_typeahead/src/material/suggestions_box/suggestions_box_decoration.dart';

/// A [FormField](https://docs.flutter.io/flutter/widgets/FormField-class.html)
/// implementation of [TypeAheadField], that allows the value to be saved,
/// validated, etc.
///
/// See also:
///
/// * [TypeAheadField], A [TextField](https://docs.flutter.io/flutter/material/TextField-class.html)
/// that displays a list of suggestions as the user types
class TypeAheadFormField<T> extends BaseTypeAheadFormField<T> {
  /// Creates a [TypeAheadFormField]
  TypeAheadFormField({
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
    super.key,
    super.layoutArchitecture,
    super.loadingBuilder,
    super.minCharsForSuggestions,
    super.noItemsFoundBuilder,
    super.onReset,
    super.onSaved,
    required super.onSuggestionSelected,
    super.suggestionsBoxController,
    this.suggestionsBoxDecoration = const SuggestionsBoxDecoration(),
    super.suggestionsBoxVerticalOffset,
    required super.suggestionsCallback,
    required TextFieldConfiguration super.textFieldConfiguration,
    super.transitionBuilder,
    super.validator,
  });

  @override
  final SuggestionsBoxDecoration? suggestionsBoxDecoration;

  @override
  Widget buildTextField(
    BaseTypeAheadFormFieldState<T> field,
    covariant TextFieldConfiguration config,
  ) {
    return TypeAheadField(
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
      ignoreAccessibleNavigation: ignoreAccessibleNavigation,
      intercepting: intercepting,
      itemBuilder: itemBuilder,
      itemSeparatorBuilder: itemSeparatorBuilder,
      keepSuggestionsOnLoading: keepSuggestionsOnLoading,
      keepSuggestionsOnSuggestionSelected: keepSuggestionsOnSuggestionSelected,
      layoutArchitecture: layoutArchitecture,
      loadingBuilder: loadingBuilder,
      minCharsForSuggestions: minCharsForSuggestions,
      noItemsFoundBuilder: noItemsFoundBuilder,
      onSuggestionSelected: onSuggestionSelected,
      suggestionsBoxController: suggestionsBoxController,
      suggestionsBoxDecoration: suggestionsBoxDecoration,
      suggestionsBoxVerticalOffset: suggestionsBoxVerticalOffset,
      suggestionsCallback: suggestionsCallback,
      textFieldConfiguration: config.copyWith(
        decoration: config.decoration.copyWith(errorText: field.errorText),
      ),
      transitionBuilder: transitionBuilder,
    );
  }
}
