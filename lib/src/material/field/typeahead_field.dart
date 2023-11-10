import 'package:flutter/material.dart';
import 'package:flutter_typeahead/src/common/field/typeahead_field.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_list_config.dart';
import 'package:flutter_typeahead/src/material/field/text_field_configuration.dart';
import 'package:flutter_typeahead/src/material/suggestions_box/suggestions_box_decoration.dart';
import 'package:flutter_typeahead/src/material/suggestions_box/suggestions_list.dart';

/// {@macro flutter_typeahead.BaseTypeAheadField}
class TypeAheadField<T> extends BaseTypeAheadField<T> {
  const TypeAheadField({
    super.key,
    super.animationDuration,
    super.animationStart,
    super.autoFlipDirection,
    super.autoFlipListDirection,
    super.autoFlipMinHeight,
    super.debounceDuration,
    super.direction,
    super.errorBuilder,
    super.hideKeyboardOnDrag,
    super.hideOnEmpty,
    super.hideOnError,
    super.hideOnLoading,
    super.hideOnUnfocus,
    super.intercepting,
    required super.itemBuilder,
    super.itemSeparatorBuilder,
    super.keepSuggestionsOnLoading,
    super.keepSuggestionsOnSelect,
    super.layoutArchitecture,
    super.loadingBuilder,
    super.minCharsForSuggestions,
    super.noItemsFoundBuilder,
    required super.onSuggestionSelected,
    super.scrollController,
    super.suggestionsBoxController,
    this.suggestionsBoxDecoration = const SuggestionsBoxDecoration(),
    required super.suggestionsCallback,
    this.textFieldConfiguration = const TextFieldConfiguration(),
    super.transitionBuilder,
  });

  @override
  final SuggestionsBoxDecoration suggestionsBoxDecoration;

  @override
  final TextFieldConfiguration textFieldConfiguration;

  @override
  Widget buildSuggestionsList(
          BuildContext context, SuggestionsListConfig<T> config) =>
      SuggestionsList<T>(
        animationDuration: config.animationDuration,
        animationStart: config.animationStart,
        controller: config.controller,
        debounceDuration: config.debounceDuration,
        decoration: suggestionsBoxDecoration,
        direction: config.direction,
        errorBuilder: config.errorBuilder,
        hideKeyboardOnDrag: config.hideKeyboardOnDrag,
        hideOnEmpty: config.hideOnEmpty,
        hideOnError: config.hideOnError,
        hideOnLoading: config.hideOnLoading,
        itemBuilder: config.itemBuilder,
        itemSeparatorBuilder: config.itemSeparatorBuilder,
        keepSuggestionsOnLoading: config.keepSuggestionsOnLoading,
        keepSuggestionsOnSelect: config.keepSuggestionsOnSelect,
        layoutArchitecture: config.layoutArchitecture,
        loadingBuilder: config.loadingBuilder,
        minCharsForSuggestions: config.minCharsForSuggestions,
        noItemsFoundBuilder: config.noItemsFoundBuilder,
        onSuggestionSelected: config.onSuggestionSelected,
        scrollController: config.scrollController,
        suggestionsBoxController: config.suggestionsBoxController,
        suggestionsCallback: config.suggestionsCallback,
        transitionBuilder: config.transitionBuilder,
      );

  @override
  Widget buildTextField(
      BuildContext context, covariant TextFieldConfiguration config) {
    return TextField(
      autocorrect: config.autocorrect,
      autofillHints: config.autofillHints,
      autofocus: config.autofocus,
      contentInsertionConfiguration: config.contentInsertionConfiguration,
      contextMenuBuilder: config.contextMenuBuilder,
      controller: config.controller,
      cursorColor: config.cursorColor,
      cursorRadius: config.cursorRadius,
      cursorWidth: config.cursorWidth,
      decoration: config.decoration,
      enableInteractiveSelection: config.enableInteractiveSelection,
      enableSuggestions: config.enableSuggestions,
      enabled: config.enabled,
      expands: config.expands,
      focusNode: config.focusNode,
      inputFormatters: config.inputFormatters,
      keyboardAppearance: config.keyboardAppearance,
      keyboardType: config.keyboardType,
      maxLength: config.maxLength,
      maxLengthEnforcement: config.maxLengthEnforcement,
      maxLines: config.maxLines,
      minLines: config.minLines,
      obscureText: config.obscureText,
      onChanged: config.onChanged,
      onEditingComplete: config.onEditingComplete,
      onSubmitted: config.onSubmitted,
      onTap: config.onTap,
      onTapOutside: config.onTapOutside,
      readOnly: config.readOnly,
      scrollPadding: config.scrollPadding,
      style: config.style,
      textAlign: config.textAlign,
      textAlignVertical: config.textAlignVertical,
      textCapitalization: config.textCapitalization,
      textDirection: config.textDirection,
      textInputAction: config.textInputAction,
    );
  }
}
