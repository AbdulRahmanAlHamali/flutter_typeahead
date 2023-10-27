import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter_typeahead/src/common/field/typeahead_field.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_list_config.dart';
import 'package:flutter_typeahead/src/cupertino/field/cupertino_text_field_configuration.dart';
import 'package:flutter_typeahead/src/cupertino/suggestions_box/cupertino_suggestions_box_decoration.dart';
import 'package:flutter_typeahead/src/cupertino/suggestions_box/cupertino_suggestions_list.dart';

/// A [CupertinoTextField](https://docs.flutter.io/flutter/cupertino/CupertinoTextField-class.html)
/// that displays a list of suggestions as the user types
///
/// See also:
///
/// * [TypeAheadFormField], a [FormField](https://docs.flutter.io/flutter/widgets/FormField-class.html)
/// implementation of [TypeAheadField] that allows the value to be saved,
/// validated, etc.
class CupertinoTypeAheadField<T> extends BaseTypeAheadField<T> {
  const CupertinoTypeAheadField({
    Key? key,
    required super.suggestionsCallback,
    required super.itemBuilder,
    super.itemSeparatorBuilder,
    required super.onSuggestionSelected,
    CupertinoTextFieldConfiguration super.textFieldConfiguration =
        const CupertinoTextFieldConfiguration(),
    this.suggestionsBoxDecoration = const CupertinoSuggestionsBoxDecoration(),
    super.debounceDuration = const Duration(milliseconds: 300),
    super.suggestionsBox,
    super.loadingBuilder,
    super.noItemsFoundBuilder,
    super.errorBuilder,
    super.transitionBuilder,
    super.animationStart = 0.25,
    super.animationDuration = const Duration(milliseconds: 500),
    super.suggestionsBoxVerticalOffset = 5.0,
    super.direction = AxisDirection.down,
    super.hideOnLoading = false,
    super.hideOnEmpty = false,
    super.hideOnError = false,
    super.hideSuggestionsOnKeyboardHide = true,
    super.keepSuggestionsOnLoading = true,
    super.keepSuggestionsOnSuggestionSelected = false,
    super.autoFlipDirection = false,
    super.autoFlipListDirection = true,
    super.autoFlipMinHeight = 64.0,
    super.minCharsForSuggestions = 0,
    super.hideKeyboardOnDrag = true,
  })  : assert(animationStart >= 0.0 && animationStart <= 1.0),
        assert(
            direction == AxisDirection.down || direction == AxisDirection.up),
        assert(minCharsForSuggestions >= 0),
        assert(!hideKeyboardOnDrag ||
            hideKeyboardOnDrag && !hideSuggestionsOnKeyboardHide),
        super(key: key);

  @override
  final CupertinoSuggestionsBoxDecoration? suggestionsBoxDecoration;

  @override
  Widget buildSuggestionsList(
      BuildContext context, SuggestionsListConfig<T> config) {
    return CupertinoSuggestionsList<T>(
      animationDuration: config.animationDuration,
      animationStart: config.animationStart,
      controller: config.controller,
      debounceDuration: config.debounceDuration,
      decoration: suggestionsBoxDecoration,
      errorBuilder: config.errorBuilder,
      giveTextFieldFocus: config.giveTextFieldFocus,
      hideKeyboardOnDrag: config.hideKeyboardOnDrag,
      hideOnEmpty: config.hideOnEmpty,
      hideOnError: config.hideOnError,
      hideOnLoading: config.hideOnLoading,
      intercepting: config.intercepting,
      itemBuilder: config.itemBuilder,
      itemSeparatorBuilder: config.itemSeparatorBuilder,
      keepSuggestionsOnLoading: config.keepSuggestionsOnLoading,
      layoutArchitecture: config.layoutArchitecture,
      loadingBuilder: config.loadingBuilder,
      minCharsForSuggestions: config.minCharsForSuggestions,
      noItemsFoundBuilder: config.noItemsFoundBuilder,
      onSuggestionFocus: config.onSuggestionFocus,
      onSuggestionSelected: config.onSuggestionSelected,
      scrollController: config.scrollController,
      shouldRefreshSuggestionFocusIndexNotifier:
          config.shouldRefreshSuggestionFocusIndexNotifier,
      suggestionsBox: config.suggestionsBox,
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
