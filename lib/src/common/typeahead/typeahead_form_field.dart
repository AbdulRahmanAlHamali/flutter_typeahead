import 'package:flutter/material.dart';
import 'package:flutter_typeahead/src/common/typeahead/typeahead_field_config.dart';
import 'package:flutter_typeahead/src/common/base/connector_widget.dart';
import 'package:flutter_typeahead/src/common/base/suggestions_controller.dart';
import 'package:flutter_typeahead/src/common/base/types.dart';

/// {@template typeahead_field.TypeAheadFormField}
/// A [FormField](https://docs.flutter.io/flutter/widgets/FormField-class.html)
/// implementation of [TypeAheadField], that allows the value to be saved,
/// validated, etc.
///
/// See also:
///
/// * [TypeAheadField], A [TextField](https://docs.flutter.io/flutter/material/TextField-class.html)
/// that displays a list of suggestions as the user types
/// {@endtemplate}
abstract class RawTypeAheadFormField<T> extends FormField<String>
    implements TypeaheadFieldConfig<T> {
  RawTypeAheadFormField({
    super.key,
    this.animationDuration = const Duration(milliseconds: 200),
    this.autoFlipDirection = false,
    this.autoFlipListDirection = true,
    this.autoFlipMinHeight = 64,
    TextFieldBuilder? builder,
    required this.fieldBuilder,
    this.controller,
    this.debounceDuration = const Duration(milliseconds: 300),
    this.direction = AxisDirection.down,
    this.errorBuilder,
    this.focusNode,
    this.hideKeyboardOnDrag = false,
    this.hideOnEmpty = false,
    this.hideOnError = false,
    this.hideOnLoading = false,
    this.hideOnUnfocus = true,
    this.hideWithKeyboard = true,
    this.hideOnSelect = true,
    required this.itemBuilder,
    this.itemSeparatorBuilder,
    this.keepSuggestionsOnLoading = true,
    this.loadingBuilder,
    this.minCharsForSuggestions = 0,
    this.emptyBuilder,
    this.onSelected,
    this.scrollController,
    this.suggestionsController,
    required this.suggestionsCallback,
    this.transitionBuilder,
    this.decorationBuilder,
    this.listBuilder,
    this.constraints,
    this.offset,
    String? initialValue,
    this.onReset,
    super.onSaved,
    super.validator,
    super.autovalidateMode,
    super.enabled = true,
  })  : assert(
          initialValue == null || controller == null,
          'Cannot provide both a controller and an initial value.',
        ),
        textFieldBuilder = builder,
        super(
          initialValue: controller?.text ?? initialValue ?? '',
          // This is a Stub. The builder is overridden below.
          builder: (_) => throw UnimplementedError(
            'RawTypeAheadFormField.builder must be overridden',
          ),
        );

  // Adds a callback for resetting the form field
  final VoidCallback? onReset;

  /// A builder for the inner field. This is typically a [TypeAheadField].
  final Widget Function(BaseTypeAheadFormFieldState<T> field) fieldBuilder;

  /// A builder for the inner text field. This is typically a [TextField].
  final TextFieldBuilder? textFieldBuilder;

  @override
  final TextEditingController? controller;
  @override
  final FocusNode? focusNode;

  @override
  final SuggestionsController<T>? suggestionsController;
  @override
  final ValueSetter<T>? onSelected;
  @override
  final AxisDirection? direction;
  @override
  final BoxConstraints? constraints;
  @override
  final Offset? offset;
  @override
  final bool autoFlipDirection;
  @override
  final double autoFlipMinHeight;
  @override
  final bool hideOnUnfocus;
  @override
  final bool hideOnSelect;
  @override
  final bool hideWithKeyboard;
  @override
  final ScrollController? scrollController;
  @override
  final AnimationTransitionBuilder? transitionBuilder;
  @override
  final Duration? animationDuration;
  @override
  final SuggestionsCallback<T> suggestionsCallback;
  @override
  final bool? keepSuggestionsOnLoading;
  @override
  final bool? hideKeyboardOnDrag;
  @override
  final bool? hideOnLoading;
  @override
  final bool? hideOnError;
  @override
  final bool? hideOnEmpty;
  @override
  final WidgetBuilder? loadingBuilder;
  @override
  final ErrorBuilder? errorBuilder;
  @override
  final WidgetBuilder? emptyBuilder;
  @override
  final ItemBuilder<T> itemBuilder;
  @override
  final ItemBuilder<int>? itemSeparatorBuilder;
  @override
  final DecorationBuilder? decorationBuilder;
  @override
  final ListBuilder? listBuilder;
  @override
  final bool? autoFlipListDirection;
  @override
  final Duration? debounceDuration;
  @override
  final int? minCharsForSuggestions;

  @override
  FormFieldBuilder<String> get builder => (field) {
        final state = field as BaseTypeAheadFormFieldState<T>;
        return ConnectorWidget(
          value: state.controller,
          connect: (controller) => controller.addListener(state.onTextChanged),
          disconnect: (controller, key) =>
              controller.removeListener(state.onTextChanged),
          child: fieldBuilder(state),
        );
      };

  @override
  FormFieldState<String> createState() => BaseTypeAheadFormFieldState<T>();
}

class BaseTypeAheadFormFieldState<T> extends FormFieldState<String> {
  @override
  RawTypeAheadFormField get widget => super.widget as RawTypeAheadFormField<T>;

  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
    controller.addListener(onTextChanged);
  }

  @override
  void didUpdateWidget(covariant RawTypeAheadFormField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      if (oldWidget.controller == null) {
        controller.dispose();
      }
      controller = widget.controller ?? TextEditingController();
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  void reset() {
    super.reset();
    setState(() {
      controller.text = widget.initialValue ?? '';
      if (widget.onReset != null) {
        widget.onReset!();
      }
    });
  }

  void onTextChanged() {
    // Suppress changes that originated from within this class.
    //
    // In the case where a controller has been passed in to this widget, we
    // register this change listener. In these cases, we'll also receive change
    // notifications for changes originating from within this class -- for
    // example, the reset() method. In such cases, the FormField value will
    // already have been set.
    if (controller.text != value) {
      didChange(controller.text);
    }
  }
}
