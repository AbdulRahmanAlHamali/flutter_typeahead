import 'package:flutter/material.dart';
import 'package:flutter_typeahead/src/common/field/typeahead_field.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/typedef.dart';
import 'package:flutter_typeahead/src/material/field/text_field_configuration.dart';
import 'package:flutter_typeahead/src/material/suggestions_box/suggestions_decoration.dart';
import 'package:flutter_typeahead/src/material/suggestions_box/suggestions_list.dart';

/// {@macro flutter_typeahead.RawTypeAheadField}
class TypeAheadField<T> extends RawTypeAheadField<T> {
  TypeAheadField({
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
    this.suggestionsDecoration = const SuggestionsDecoration(),
    this.textFieldConfiguration = const TextFieldConfiguration(),
  }) : super(
          controller: textFieldConfiguration.controller,
          focusNode: textFieldConfiguration.focusNode,
          constraints: suggestionsDecoration.constraints,
          offset: suggestionsDecoration.offset,
          errorBuilder: errorBuilder ?? TypeAheadMaterialDefaults.errorBuilder,
          loadingBuilder:
              loadingBuilder ?? TypeAheadMaterialDefaults.loadingBuilder,
          emptyBuilder: emptyBuilder ?? TypeAheadMaterialDefaults.emptyBuilder,
          itemBuilder: TypeAheadMaterialDefaults.itemBuilder(itemBuilder),
          wrapperBuilder:
              TypeAheadMaterialDefaults.wrapperBuilder(suggestionsDecoration),
          builder: (context, controller, focusNode) {
            TextFieldConfiguration config = textFieldConfiguration;
            return TextField(
              autocorrect: config.autocorrect,
              autofillHints: config.autofillHints,
              autofocus: config.autofocus,
              contentInsertionConfiguration:
                  config.contentInsertionConfiguration,
              contextMenuBuilder: config.contextMenuBuilder,
              controller: controller,
              cursorColor: config.cursorColor,
              cursorRadius: config.cursorRadius,
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
              style: config.style,
              textAlign: config.textAlign,
              textAlignVertical: config.textAlignVertical,
              textCapitalization: config.textCapitalization,
              textDirection: config.textDirection,
              textInputAction: config.textInputAction,
            );
          },
        );

  /// {@template flutter_typeahead.TypeAheadField.suggestionsDecoration}
  /// The decoration of the suggestions box.
  /// {@endtemplate}
  final SuggestionsDecoration suggestionsDecoration;

  /// {@template flutter_typeahead.TypeAheadField.textFieldConfiguration}
  /// The configuration of the text field.
  ///
  /// Mirrors the parameters of [TextField].
  /// {@endtemplate}
  final TextFieldConfiguration textFieldConfiguration;
}
