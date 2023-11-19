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
class TypeAheadFormField<T> extends RawTypeAheadFormField<T> {
  /// Creates a [TypeAheadFormField].
  TypeAheadFormField({
    super.key,
    super.animationDuration,
    super.autoFlipDirection,
    super.autoFlipListDirection,
    super.autoFlipMinHeight,
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
    super.constraints,
    super.offset,
    super.initialValue,
    super.onReset,
    super.onSaved,
    super.validator,
    super.autovalidateMode,
    super.enabled,
    this.suggestionsDecoration = const SuggestionsDecoration(),
    this.textFieldConfiguration = const TextFieldConfiguration(),
  }) : super(
          fieldBuilder: (field) => TypeAheadField<T>(
            animationDuration: animationDuration,
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
            loadingBuilder: loadingBuilder,
            minCharsForSuggestions: minCharsForSuggestions,
            emptyBuilder: emptyBuilder,
            onSelected: onSelected,
            suggestionsController: suggestionsController,
            suggestionsDecoration: suggestionsDecoration,
            suggestionsCallback: suggestionsCallback,
            textFieldConfiguration: textFieldConfiguration.copyWith(
              controller: field.controller,
              decoration: textFieldConfiguration.decoration.copyWith(
                errorText: field.errorText,
              ),
            ),
            transitionBuilder: transitionBuilder,
          ),
        );

  /// {@macro flutter_typeahead.TypeAheadField.suggestionsDecoration}
  final SuggestionsDecoration suggestionsDecoration;

  /// {@macro flutter_typeahead.TypeAheadField.textFieldConfiguration}
  final TextFieldConfiguration textFieldConfiguration;
}
