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
    super.suggestionsBoxController,
    super.loadingBuilder,
    super.noItemsFoundBuilder,
    super.errorBuilder,
    super.transitionBuilder,
    super.animationStart = 0.25,
    super.animationDuration = const Duration(milliseconds: 500),
    super.getImmediateSuggestions = false,
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
      suggestionsBox: config.suggestionsBox,
      decoration: suggestionsBoxDecoration,
      controller: config.controller,
      intercepting: config.intercepting,
      getImmediateSuggestions: config.getImmediateSuggestions,
      onSuggestionSelected: config.onSuggestionSelected,
      suggestionsCallback: config.suggestionsCallback,
      itemBuilder: config.itemBuilder,
      itemSeparatorBuilder: config.itemSeparatorBuilder,
      layoutArchitecture: config.layoutArchitecture,
      scrollController: config.scrollController,
      debounceDuration: config.debounceDuration,
      loadingBuilder: config.loadingBuilder,
      noItemsFoundBuilder: config.noItemsFoundBuilder,
      errorBuilder: config.errorBuilder,
      transitionBuilder: config.transitionBuilder,
      animationDuration: config.animationDuration,
      animationStart: config.animationStart,
      direction: config.direction,
      hideOnLoading: config.hideOnLoading,
      hideOnEmpty: config.hideOnEmpty,
      hideOnError: config.hideOnError,
      keepSuggestionsOnLoading: config.keepSuggestionsOnLoading,
      minCharsForSuggestions: config.minCharsForSuggestions,
      shouldRefreshSuggestionFocusIndexNotifier:
          config.shouldRefreshSuggestionFocusIndexNotifier,
      giveTextFieldFocus: config.giveTextFieldFocus,
      onSuggestionFocus: config.onSuggestionFocus,
      onKeyEvent: config.onKeyEvent,
      hideKeyboardOnDrag: config.hideKeyboardOnDrag,
    );
  }

  @override
  Widget buildTextField(
    BuildContext context,
    covariant CupertinoTextFieldConfiguration config,
  ) {
    return CupertinoTextField(
      controller: config.controller,
      focusNode: config.focusNode,
      decoration: config.decoration,
      padding: config.padding,
      placeholder: config.placeholder,
      placeholderStyle: config.placeholderStyle,
      prefix: config.prefix,
      prefixMode: config.prefixMode,
      suffix: config.suffix,
      suffixMode: config.suffixMode,
      clearButtonMode: config.clearButtonMode,
      keyboardType: config.keyboardType,
      textInputAction: config.textInputAction,
      textCapitalization: config.textCapitalization,
      style: config.style,
      textAlign: config.textAlign,
      autofocus: config.autofocus,
      obscureText: config.obscureText,
      autocorrect: config.autocorrect,
      maxLines: config.maxLines,
      minLines: config.minLines,
      maxLength: config.maxLength,
      maxLengthEnforcement: config.maxLengthEnforcement,
      onChanged: config.onChanged,
      onEditingComplete: config.onEditingComplete,
      onTap: config.onTap,
      onSubmitted: config.onSubmitted,
      inputFormatters: config.inputFormatters,
      enabled: config.enabled,
      readOnly: config.readOnly,
      cursorWidth: config.cursorWidth,
      cursorRadius: config.cursorRadius ?? const Radius.circular(2),
      cursorColor: config.cursorColor,
      keyboardAppearance: config.keyboardAppearance,
      scrollPadding: config.scrollPadding,
      enableInteractiveSelection: config.enableInteractiveSelection,
    );
  }
}
