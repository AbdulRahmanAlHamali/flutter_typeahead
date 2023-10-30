import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter_typeahead/src/common/field/typeahead_field.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_list_config.dart';
import 'package:flutter_typeahead/src/cupertino/field/cupertino_text_field_configuration.dart';
import 'package:flutter_typeahead/src/cupertino/suggestions_box/cupertino_suggestions_box_decoration.dart';
import 'package:flutter_typeahead/src/cupertino/suggestions_box/cupertino_suggestions_list.dart';

/// {@macro flutter_typeahead.BaseTypeAheadField}
class CupertinoTypeAheadField<T> extends BaseTypeAheadField<T> {
  const CupertinoTypeAheadField({
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
    super.ignoreAccessibleNavigation,
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
    this.suggestionsBoxDecoration = const CupertinoSuggestionsBoxDecoration(),
    required super.suggestionsCallback,
    this.textFieldConfiguration = const CupertinoTextFieldConfiguration(),
    super.transitionBuilder,
  });

  @override
  final CupertinoSuggestionsBoxDecoration suggestionsBoxDecoration;

  @override
  final CupertinoTextFieldConfiguration textFieldConfiguration;

  @override
  Widget buildSuggestionsList(
      BuildContext context, SuggestionsListConfig<T> config) {
    return CupertinoSuggestionsList<T>(
      animationDuration: config.animationDuration,
      animationStart: config.animationStart,
      autoFlipListDirection: config.autoFlipListDirection,
      controller: config.controller,
      debounceDuration: config.debounceDuration,
      decoration: suggestionsBoxDecoration,
      direction: config.direction,
      errorBuilder: config.errorBuilder,
      hideKeyboardOnDrag: config.hideKeyboardOnDrag,
      hideOnEmpty: config.hideOnEmpty,
      hideOnError: config.hideOnError,
      hideOnLoading: config.hideOnLoading,
      intercepting: config.intercepting,
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
  }

  @override
  Widget buildTextField(
    BuildContext context,
    covariant CupertinoTextFieldConfiguration config,
  ) {
    return CupertinoTextField(
      autocorrect: config.autocorrect,
      autofocus: config.autofocus,
      contentInsertionConfiguration: config.contentInsertionConfiguration,
      contextMenuBuilder: config.contextMenuBuilder,
      controller: config.controller,
      clearButtonMode: config.clearButtonMode,
      cursorColor: config.cursorColor,
      cursorRadius: config.cursorRadius ?? const Radius.circular(2),
      cursorWidth: config.cursorWidth,
      decoration: config.decoration,
      enableInteractiveSelection: config.enableInteractiveSelection,
      enabled: config.enabled,
      enableSuggestions: config.enableSuggestions,
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
      padding: config.padding,
      placeholder: config.placeholder,
      placeholderStyle: config.placeholderStyle,
      prefix: config.prefix,
      prefixMode: config.prefixMode,
      readOnly: config.readOnly,
      scrollPadding: config.scrollPadding,
      style: config.style,
      suffix: config.suffix,
      suffixMode: config.suffixMode,
      textAlign: config.textAlign,
      textCapitalization: config.textCapitalization,
      textInputAction: config.textInputAction,
    );
  }
}
