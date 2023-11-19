import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter_typeahead/src/common/field/typeahead_field.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/typedef.dart';
import 'package:flutter_typeahead/src/cupertino/field/cupertino_text_field_configuration.dart';
import 'package:flutter_typeahead/src/cupertino/suggestions_box/cupertino_suggestions_decoration.dart';
import 'package:flutter_typeahead/src/cupertino/suggestions_box/cupertino_suggestions_list.dart';

/// {@macro flutter_typeahead.BaseTypeAheadField}
class CupertinoTypeAheadField<T> extends RawTypeAheadField<T> {
  CupertinoTypeAheadField({
    super.key,
    super.animationDuration,
    super.autoFlipDirection,
    super.autoFlipListDirection,
    super.autoFlipMinHeight,
    super.debounceDuration,
    super.direction,
    ErrorBuilder? errorBuilder,
    super.hideKeyboardOnDrag,
    super.hideOnEmpty,
    super.hideOnError,
    super.hideOnLoading,
    super.hideOnUnfocus,
    super.hideWithKeyboard,
    super.hideOnSelect,
    required ItemBuilder<T> itemBuilder,
    super.itemSeparatorBuilder,
    super.keepSuggestionsOnLoading,
    WidgetBuilder? loadingBuilder,
    super.minCharsForSuggestions,
    WidgetBuilder? emptyBuilder,
    required super.onSelected,
    super.scrollController,
    super.suggestionsController,
    required super.suggestionsCallback,
    super.transitionBuilder,
    super.constraints,
    super.offset,
    this.suggestionsDecoration = const CupertinoSuggestionsDecoration(),
    this.textFieldConfiguration = const CupertinoTextFieldConfiguration(),
  }) : super(
          controller: textFieldConfiguration.controller,
          focusNode: textFieldConfiguration.focusNode,
          errorBuilder: errorBuilder ?? TypeAheadCupertinoDefaults.errorBuilder,
          loadingBuilder:
              loadingBuilder ?? TypeAheadCupertinoDefaults.loadingBuilder,
          emptyBuilder: emptyBuilder ?? TypeAheadCupertinoDefaults.emptyBuilder,
          itemBuilder: TypeAheadCupertinoDefaults.itemBuilder(itemBuilder),
          wrapperBuilder:
              TypeAheadCupertinoDefaults.wrapperBuilder(suggestionsDecoration),
          builder: (context, controller, focusNode) {
            CupertinoTextFieldConfiguration config = textFieldConfiguration;
            return CupertinoTextField(
              autocorrect: config.autocorrect,
              autofillHints: config.autofillHints,
              autofocus: config.autofocus,
              contentInsertionConfiguration:
                  config.contentInsertionConfiguration,
              contextMenuBuilder: config.contextMenuBuilder,
              controller: controller,
              clearButtonMode: config.clearButtonMode,
              cursorColor: config.cursorColor,
              cursorRadius: config.cursorRadius ?? const Radius.circular(2),
              cursorWidth: config.cursorWidth,
              decoration: config.decoration,
              enableInteractiveSelection: config.enableInteractiveSelection,
              enableSuggestions: config.enableSuggestions,
              enabled: config.enabled,
              expands: config.expands,
              focusNode: focusNode,
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
              padding: config.padding,
              placeholder: config.placeholder,
              placeholderStyle: config.placeholderStyle,
              prefix: config.prefix,
              prefixMode: config.prefixMode,
              suffix: config.suffix,
              suffixMode: config.suffixMode,
              style: config.style,
              textAlign: config.textAlign,
              textAlignVertical: config.textAlignVertical,
              textCapitalization: config.textCapitalization,
              textDirection: config.textDirection,
              textInputAction: config.textInputAction,
            );
          },
        );

  /// {@macro flutter_typeahead.TypeAheadField.suggestionsDecoration}
  final CupertinoSuggestionsDecoration suggestionsDecoration;

  /// {@macro flutter_typeahead.TypeAheadField.textFieldConfiguration}
  final CupertinoTextFieldConfiguration textFieldConfiguration;
}
