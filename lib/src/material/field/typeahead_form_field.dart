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
    this.suggestionsBoxDecoration = const SuggestionsBoxDecoration(),
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
  final SuggestionsBoxDecoration? suggestionsBoxDecoration;

  @override
  Widget buildTextField(
    BaseTypeAheadFormFieldState<T> field,
    covariant TextFieldConfiguration config,
  ) {
    return TypeAheadField(
      transitionBuilder: transitionBuilder,
      errorBuilder: errorBuilder,
      noItemsFoundBuilder: noItemsFoundBuilder,
      loadingBuilder: loadingBuilder,
      debounceDuration: debounceDuration,
      suggestionsBoxDecoration: suggestionsBoxDecoration,
      suggestionsBoxController: suggestionsBoxController,
      textFieldConfiguration: config.copyWith(
        decoration: config.decoration.copyWith(errorText: field.errorText),
      ),
      suggestionsBoxVerticalOffset: suggestionsBoxVerticalOffset,
      onSuggestionSelected: onSuggestionSelected,
      onSuggestionsBoxToggle: onSuggestionsBoxToggle,
      itemBuilder: itemBuilder,
      itemSeparatorBuilder: itemSeparatorBuilder,
      layoutArchitecture: layoutArchitecture,
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
      intercepting: intercepting,
      autoFlipDirection: autoFlipDirection,
      autoFlipListDirection: autoFlipListDirection,
      autoFlipMinHeight: autoFlipMinHeight,
      hideKeyboard: hideKeyboard,
      minCharsForSuggestions: minCharsForSuggestions,
      hideKeyboardOnDrag: hideKeyboardOnDrag,
      ignoreAccessibleNavigation: ignoreAccessibleNavigation,
    );
  }
}
