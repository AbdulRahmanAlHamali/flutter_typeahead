import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter_typeahead/src/cupertino/field/cupertino_text_field_configuration.dart';
import 'package:flutter_typeahead/src/cupertino/field/cupertino_typeahead_field.dart';
import 'package:flutter_typeahead/src/cupertino/suggestions_box/cupertino_suggestions_box_controller.dart';
import 'package:flutter_typeahead/src/cupertino/suggestions_box/cupertino_suggestions_box_decoration.dart';
import 'package:flutter_typeahead/src/typedef.dart';

/// A [FormField](https://docs.flutter.io/flutter/widgets/FormField-class.html)
/// implementation of [TypeAheadField], that allows the value to be saved,
/// validated, etc.
///
/// See also:
///
/// * [TypeAheadField], A [CupertinoTextField](https://docs.flutter.io/flutter/cupertino/CupertinoTextField-class.html)
/// that displays a list of suggestions as the user types
class CupertinoTypeAheadFormField<T> extends FormField<String> {
  /// The configuration of the [CupertinoTextField](https://docs.flutter.io/flutter/cupertino/CupertinoTextField-class.html)
  /// that the TypeAhead widget displays
  final CupertinoTextFieldConfiguration textFieldConfiguration;

  CupertinoTypeAheadFormField.paged({
    Key? key,
    String? initialValue,
    bool getImmediateSuggestions = false,
    @Deprecated('Use autoValidateMode parameter which provides more specific '
        'behavior related to auto validation. '
        'This feature was deprecated after Flutter v1.19.0.')
    bool autovalidate = false,
    bool enabled = true,
    AutovalidateMode? autovalidateMode,
    FormFieldSetter<String>? onSaved,
    FormFieldValidator<String>? validator,
    ErrorBuilder? errorBuilder,
    WidgetBuilder? noItemsFoundBuilder,
    WidgetBuilder? loadingBuilder,
    Duration debounceDuration = const Duration(milliseconds: 300),
    CupertinoSuggestionsBoxDecoration suggestionsBoxDecoration =
        const CupertinoSuggestionsBoxDecoration(),
    CupertinoSuggestionsBoxController? suggestionsBoxController,
    required SuggestionSelectionCallback<T> onSuggestionSelected,
    required ItemBuilder<T> itemBuilder,
    IndexedWidgetBuilder? itemSeparatorBuilder,
    required SuggestionsLoadMoreCallback<T> suggestionsLoadMoreCallback,
    double suggestionsBoxVerticalOffset = 5.0,
    this.textFieldConfiguration = const CupertinoTextFieldConfiguration(),
    AnimationTransitionBuilder? transitionBuilder,
    Duration animationDuration = const Duration(milliseconds: 500),
    double animationStart = 0.25,
    AxisDirection direction = AxisDirection.down,
    bool hideOnLoading = false,
    bool hideOnEmpty = false,
    bool hideOnError = false,
    bool hideSuggestionsOnKeyboardHide = true,
    bool keepSuggestionsOnLoading = true,
    bool keepSuggestionsOnSuggestionSelected = false,
    bool autoFlipDirection = false,
    bool autoFlipListDirection = true,
    double autoFlipMinHeight = 64.0,
    int minCharsForSuggestions = 0,
    bool hideKeyboardOnDrag = false,
  })  : assert(
            initialValue == null || textFieldConfiguration.controller == null),
        assert(minCharsForSuggestions >= 0),
        super(
            key: key,
            onSaved: onSaved,
            validator: validator,
            initialValue: textFieldConfiguration.controller != null
                ? textFieldConfiguration.controller!.text
                : (initialValue ?? ''),
            enabled: enabled,
            autovalidateMode: autovalidateMode,
            builder: (FormFieldState<String> field) {
              final CupertinoTypeAheadFormFieldState state =
                  field as CupertinoTypeAheadFormFieldState<dynamic>;

              return CupertinoTypeAheadField.paged(
                getImmediateSuggestions: getImmediateSuggestions,
                transitionBuilder: transitionBuilder,
                errorBuilder: errorBuilder,
                noItemsFoundBuilder: noItemsFoundBuilder,
                loadingBuilder: loadingBuilder,
                debounceDuration: debounceDuration,
                suggestionsBoxDecoration: suggestionsBoxDecoration,
                suggestionsBoxController: suggestionsBoxController,
                textFieldConfiguration: textFieldConfiguration.copyWith(
                  onChanged: (text) {
                    state.didChange(text);
                    textFieldConfiguration.onChanged?.call(text);
                  },
                  controller: state._effectiveController,
                ),
                suggestionsBoxVerticalOffset: suggestionsBoxVerticalOffset,
                onSuggestionSelected: onSuggestionSelected,
                itemBuilder: itemBuilder,
                itemSeparatorBuilder: itemSeparatorBuilder,
                suggestionsLoadMoreCallback: suggestionsLoadMoreCallback,
                animationStart: animationStart,
                animationDuration: animationDuration,
                direction: direction,
                hideOnLoading: hideOnLoading,
                hideOnEmpty: hideOnEmpty,
                hideOnError: hideOnError,
                hideSuggestionsOnKeyboardHide: hideSuggestionsOnKeyboardHide,
                keepSuggestionsOnLoading: keepSuggestionsOnLoading,
                keepSuggestionsOnSuggestionSelected:
                    keepSuggestionsOnSuggestionSelected,
                autoFlipDirection: autoFlipDirection,
                autoFlipListDirection: autoFlipListDirection,
                autoFlipMinHeight: autoFlipMinHeight,
                minCharsForSuggestions: minCharsForSuggestions,
                hideKeyboardOnDrag: hideKeyboardOnDrag,
              );
            });

  /// Creates a [CupertinoTypeAheadFormField]
  CupertinoTypeAheadFormField({
    Key? key,
    String? initialValue,
    bool getImmediateSuggestions = false,
    @Deprecated('Use autoValidateMode parameter which provides more specific '
        'behavior related to auto validation. '
        'This feature was deprecated after Flutter v1.19.0.')
    bool autovalidate = false,
    bool enabled = true,
    AutovalidateMode? autovalidateMode,
    FormFieldSetter<String>? onSaved,
    FormFieldValidator<String>? validator,
    ErrorBuilder? errorBuilder,
    WidgetBuilder? noItemsFoundBuilder,
    WidgetBuilder? loadingBuilder,
    Duration debounceDuration = const Duration(milliseconds: 300),
    CupertinoSuggestionsBoxDecoration suggestionsBoxDecoration =
        const CupertinoSuggestionsBoxDecoration(),
    CupertinoSuggestionsBoxController? suggestionsBoxController,
    required SuggestionSelectionCallback<T> onSuggestionSelected,
    required ItemBuilder<T> itemBuilder,
    IndexedWidgetBuilder? itemSeparatorBuilder,
    required SuggestionsCallback<T> suggestionsCallback,
    double suggestionsBoxVerticalOffset = 5.0,
    this.textFieldConfiguration = const CupertinoTextFieldConfiguration(),
    AnimationTransitionBuilder? transitionBuilder,
    Duration animationDuration = const Duration(milliseconds: 500),
    double animationStart = 0.25,
    AxisDirection direction = AxisDirection.down,
    bool hideOnLoading = false,
    bool hideOnEmpty = false,
    bool hideOnError = false,
    bool hideSuggestionsOnKeyboardHide = true,
    bool keepSuggestionsOnLoading = true,
    bool keepSuggestionsOnSuggestionSelected = false,
    bool autoFlipDirection = false,
    bool autoFlipListDirection = true,
    double autoFlipMinHeight = 64.0,
    int minCharsForSuggestions = 0,
    bool hideKeyboardOnDrag = false,
  })  : assert(
            initialValue == null || textFieldConfiguration.controller == null),
        assert(minCharsForSuggestions >= 0),
        super(
            key: key,
            onSaved: onSaved,
            validator: validator,
            initialValue: textFieldConfiguration.controller != null
                ? textFieldConfiguration.controller!.text
                : (initialValue ?? ''),
            enabled: enabled,
            autovalidateMode: autovalidateMode,
            builder: (FormFieldState<String> field) {
              final CupertinoTypeAheadFormFieldState state =
                  field as CupertinoTypeAheadFormFieldState<dynamic>;

              return CupertinoTypeAheadField(
                getImmediateSuggestions: getImmediateSuggestions,
                transitionBuilder: transitionBuilder,
                errorBuilder: errorBuilder,
                noItemsFoundBuilder: noItemsFoundBuilder,
                loadingBuilder: loadingBuilder,
                debounceDuration: debounceDuration,
                suggestionsBoxDecoration: suggestionsBoxDecoration,
                suggestionsBoxController: suggestionsBoxController,
                textFieldConfiguration: textFieldConfiguration.copyWith(
                  onChanged: (text) {
                    state.didChange(text);
                    textFieldConfiguration.onChanged?.call(text);
                  },
                  controller: state._effectiveController,
                ),
                suggestionsBoxVerticalOffset: suggestionsBoxVerticalOffset,
                onSuggestionSelected: onSuggestionSelected,
                itemBuilder: itemBuilder,
                itemSeparatorBuilder: itemSeparatorBuilder,
                suggestionsCallback: suggestionsCallback,
                animationStart: animationStart,
                animationDuration: animationDuration,
                direction: direction,
                hideOnLoading: hideOnLoading,
                hideOnEmpty: hideOnEmpty,
                hideOnError: hideOnError,
                hideSuggestionsOnKeyboardHide: hideSuggestionsOnKeyboardHide,
                keepSuggestionsOnLoading: keepSuggestionsOnLoading,
                keepSuggestionsOnSuggestionSelected:
                    keepSuggestionsOnSuggestionSelected,
                autoFlipDirection: autoFlipDirection,
                autoFlipListDirection: autoFlipListDirection,
                autoFlipMinHeight: autoFlipMinHeight,
                minCharsForSuggestions: minCharsForSuggestions,
                hideKeyboardOnDrag: hideKeyboardOnDrag,
              );
            });

  @override
  CupertinoTypeAheadFormFieldState<T> createState() =>
      CupertinoTypeAheadFormFieldState<T>();
}

class CupertinoTypeAheadFormFieldState<T> extends FormFieldState<String> {
  TextEditingController? _controller;

  TextEditingController? get _effectiveController =>
      widget.textFieldConfiguration.controller ?? _controller;

  @override
  CupertinoTypeAheadFormField get widget =>
      super.widget as CupertinoTypeAheadFormField<dynamic>;

  @override
  void initState() {
    super.initState();
    if (widget.textFieldConfiguration.controller == null) {
      _controller = TextEditingController(text: widget.initialValue);
    } else {
      widget.textFieldConfiguration.controller!
          .addListener(_handleControllerChanged);
    }
  }

  @override
  void didUpdateWidget(CupertinoTypeAheadFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.textFieldConfiguration.controller !=
        oldWidget.textFieldConfiguration.controller) {
      oldWidget.textFieldConfiguration.controller
          ?.removeListener(_handleControllerChanged);
      widget.textFieldConfiguration.controller
          ?.addListener(_handleControllerChanged);

      if (oldWidget.textFieldConfiguration.controller != null &&
          widget.textFieldConfiguration.controller == null) {
        _controller = TextEditingController.fromValue(
            oldWidget.textFieldConfiguration.controller!.value);
      }
      if (widget.textFieldConfiguration.controller != null) {
        setValue(widget.textFieldConfiguration.controller!.text);
        if (oldWidget.textFieldConfiguration.controller == null) {
          _controller = null;
        }
      }
    }
  }

  @override
  void dispose() {
    widget.textFieldConfiguration.controller
        ?.removeListener(_handleControllerChanged);
    super.dispose();
  }

  @override
  void reset() {
    super.reset();
    setState(() {
      _effectiveController!.text = widget.initialValue!;
    });
  }

  void _handleControllerChanged() {
    // Suppress changes that originated from within this class.
    //
    // In the case where a controller has been passed in to this widget, we
    // register this change listener. In these cases, we'll also receive change
    // notifications for changes originating from within this class -- for
    // example, the reset() method. In such cases, the FormField value will
    // already have been set.
    if (_effectiveController!.text != value) {
      didChange(_effectiveController!.text);
    }
  }
}
