import 'package:flutter/material.dart';
import 'package:flutter_typeahead/src/common/field/typeahead_form_field.dart';
import 'package:flutter_typeahead/src/material/field/text_field_configuration.dart';
import 'package:flutter_typeahead/src/material/field/typeahead_field.dart';
import 'package:flutter_typeahead/src/material/suggestions_box/suggestions_decoration.dart';

/// A [FormField](https://docs.flutter.io/flutter/widgets/FormField-class.html)
/// implementation of [TypeAheadField], that allows the value to be saved,
/// validated, etc.
///
/// See also:
///
/// * [TypeAheadField], A [TextField](https://docs.flutter.io/flutter/material/TextField-class.html)
/// that displays a list of suggestions as the user types
class TypeAheadFormField<T> extends BaseTypeAheadFormField<T> {
  /// Creates a [TypeAheadFormField].
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
    super.hideOnUnfocus,
    super.hideWithKeyboard,
    super.hideOnSelect,
    super.initialValue,
    super.intercepting,
    required super.itemBuilder,
    super.itemSeparatorBuilder,
    super.keepSuggestionsOnLoading,
    super.key,
    super.layoutArchitecture,
    super.loadingBuilder,
    super.minCharsForSuggestions,
    super.noItemsFoundBuilder,
    super.onReset,
    super.onSaved,
    required super.onSuggestionSelected,
    super.suggestionsController,
    this.suggestionsDecoration = const SuggestionsDecoration(),
    required super.suggestionsCallback,
    TextFieldConfiguration super.textFieldConfiguration =
        const TextFieldConfiguration(),
    super.transitionBuilder,
    super.validator,
  });

  @override
  final SuggestionsDecoration suggestionsDecoration;

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
      hideOnUnfocus: hideOnUnfocus,
      hideOnSelect: hideOnSelect,
      intercepting: intercepting,
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
      textFieldConfiguration: config.copyWith(
        decoration: config.decoration.copyWith(errorText: field.errorText),
      ),
      transitionBuilder: transitionBuilder,
    );
  }
}
