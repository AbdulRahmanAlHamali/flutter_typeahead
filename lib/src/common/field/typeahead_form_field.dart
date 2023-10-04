import 'package:flutter/material.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_box_decoration.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/text_field_configuration.dart';
import 'package:flutter_typeahead/src/material/field/typeahead_field.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_box_controller.dart';
import 'package:flutter_typeahead/src/typedef.dart';

/// A [FormField](https://docs.flutter.io/flutter/widgets/FormField-class.html)
/// implementation of [TypeAheadField], that allows the value to be saved,
/// validated, etc.
///
/// See also:
///
/// * [TypeAheadField], A [TextField](https://docs.flutter.io/flutter/material/TextField-class.html)
/// that displays a list of suggestions as the user types
abstract class BaseTypeAheadFormField<T> extends FormField<String> {
  /// Creates a [TypeAheadFormField]
  BaseTypeAheadFormField({
    super.key,
    String? initialValue,
    this.getImmediateSuggestions = false,
    super.enabled = true,
    super.autovalidateMode,
    super.onSaved,
    this.onReset,
    super.validator,
    this.errorBuilder,
    this.noItemsFoundBuilder,
    this.loadingBuilder,
    this.onSuggestionsBoxToggle,
    this.debounceDuration = const Duration(milliseconds: 300),
    this.suggestionsBoxController,
    required this.onSuggestionSelected,
    required this.itemBuilder,
    this.itemSeparatorBuilder,
    this.layoutArchitecture,
    required this.suggestionsCallback,
    this.suggestionsBoxVerticalOffset = 5.0,
    required this.textFieldConfiguration,
    this.transitionBuilder,
    this.animationDuration = const Duration(milliseconds: 500),
    this.animationStart = 0.25,
    this.direction = AxisDirection.down,
    this.hideOnLoading = false,
    this.hideOnEmpty = false,
    this.hideOnError = false,
    this.hideSuggestionsOnKeyboardHide = true,
    this.intercepting = false,
    this.keepSuggestionsOnLoading = true,
    this.keepSuggestionsOnSuggestionSelected = false,
    this.autoFlipDirection = false,
    this.autoFlipListDirection = true,
    this.autoFlipMinHeight = 64.0,
    this.hideKeyboard = false,
    this.minCharsForSuggestions = 0,
    this.hideKeyboardOnDrag = false,
    this.ignoreAccessibleNavigation = false,
  })  : assert(
            initialValue == null || textFieldConfiguration.controller == null),
        assert(minCharsForSuggestions >= 0),
        super(
          initialValue: textFieldConfiguration.controller != null
              ? textFieldConfiguration.controller!.text
              : (initialValue ?? ''),
          // This is a Stub. The builder is overridden below.
          builder: (_) => throw UnimplementedError(
            'BaseTypeAheadFormField.builder must be overridden',
          ),
        );

  /// The configuration of the [TextField](https://docs.flutter.io/flutter/material/TextField-class.html)
  /// that the TypeAhead widget displays
  final BaseTextFieldConfiguration textFieldConfiguration;

  // Adds a callback for resetting the form field
  final VoidCallback? onReset;

  /// The decoration of the sheet that contains the suggestions.
  BaseSuggestionsBoxDecoration? get suggestionsBoxDecoration;

  final bool getImmediateSuggestions;
  final ErrorBuilder? errorBuilder;
  final WidgetBuilder? noItemsFoundBuilder;
  final WidgetBuilder? loadingBuilder;
  final void Function(bool)? onSuggestionsBoxToggle;
  final Duration debounceDuration;
  final SuggestionsBoxController? suggestionsBoxController;
  final SuggestionSelectionCallback<T> onSuggestionSelected;
  final ItemBuilder<T> itemBuilder;
  final IndexedWidgetBuilder? itemSeparatorBuilder;
  final LayoutArchitecture? layoutArchitecture;
  final SuggestionsCallback<T> suggestionsCallback;
  final double suggestionsBoxVerticalOffset;
  final AnimationTransitionBuilder? transitionBuilder;
  final Duration animationDuration;
  final double animationStart;
  final AxisDirection direction;
  final bool hideOnLoading;
  final bool hideOnEmpty;
  final bool hideOnError;
  final bool hideSuggestionsOnKeyboardHide;
  final bool intercepting;
  final bool keepSuggestionsOnLoading;
  final bool keepSuggestionsOnSuggestionSelected;
  final bool autoFlipDirection;
  final bool autoFlipListDirection;
  final double autoFlipMinHeight;
  final bool hideKeyboard;
  final int minCharsForSuggestions;
  final bool hideKeyboardOnDrag;
  final bool ignoreAccessibleNavigation;

  Widget buildTextField(
    BaseTypeAheadFormFieldState<T> field,
    BaseTextFieldConfiguration config,
  );

  @override
  FormFieldBuilder<String> get builder => (field) {
        final BaseTypeAheadFormFieldState<T> state =
            field as BaseTypeAheadFormFieldState<T>;
        return buildTextField(
          state,
          textFieldConfiguration.copyWith(
            onChanged: (text) {
              state.didChange(text);
              textFieldConfiguration.onChanged?.call(text);
            },
            controller: state._effectiveController,
          ),
        );
      };

  @override
  FormFieldState<String> createState() => BaseTypeAheadFormFieldState<T>();
}

class BaseTypeAheadFormFieldState<T> extends FormFieldState<String> {
  TextEditingController? _controller;

  TextEditingController? get _effectiveController =>
      widget.textFieldConfiguration.controller ?? _controller;

  @override
  BaseTypeAheadFormField get widget =>
      super.widget as BaseTypeAheadFormField<dynamic>;

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
  void didUpdateWidget(BaseTypeAheadFormField oldWidget) {
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
      if (widget.onReset != null) {
        widget.onReset!();
      }
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
