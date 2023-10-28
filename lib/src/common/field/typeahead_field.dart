import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_typeahead/src/common/field/typeahead_field_config.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_box.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_list_config.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/text_field_configuration.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

abstract class BaseTypeAheadField<T> extends StatefulWidget
    implements TypeaheadFieldConfig<T> {
  const BaseTypeAheadField({
    required this.suggestionsCallback,
    required this.itemBuilder,
    this.itemSeparatorBuilder,
    this.layoutArchitecture,
    this.intercepting = false,
    required this.onSuggestionSelected,
    this.debounceDuration = const Duration(milliseconds: 300),
    this.scrollController,
    this.suggestionsBoxController,
    this.loadingBuilder,
    this.noItemsFoundBuilder,
    this.errorBuilder,
    this.transitionBuilder,
    this.animationStart = 0.25,
    this.animationDuration = const Duration(milliseconds: 500),
    this.suggestionsBoxVerticalOffset = 5,
    this.direction = AxisDirection.down,
    this.hideOnLoading = false,
    this.hideOnEmpty = false,
    this.hideOnError = false,
    this.hideSuggestionsOnKeyboardHide = true,
    this.keepSuggestionsOnLoading = true,
    this.keepSuggestionsOnSuggestionSelected = false,
    this.autoFlipDirection = false,
    this.autoFlipListDirection = true,
    this.autoFlipMinHeight = 64,
    this.minCharsForSuggestions = 0,
    this.hideKeyboardOnDrag = false,
    this.ignoreAccessibleNavigation = false,
    super.key,
  })  : assert(animationStart >= 0 && animationStart <= 1),
        assert(minCharsForSuggestions >= 0),
        assert(
          !hideKeyboardOnDrag ||
              hideKeyboardOnDrag && !hideSuggestionsOnKeyboardHide,
        );

  @override
  final Duration animationDuration;
  @override
  final double animationStart;
  @override
  final bool autoFlipDirection;
  @override
  final bool autoFlipListDirection;
  @override
  final double autoFlipMinHeight;
  @override
  final Duration debounceDuration;
  @override
  final AxisDirection direction;
  @override
  final ErrorBuilder? errorBuilder;
  @override
  final bool hideKeyboardOnDrag;
  @override
  final bool hideOnEmpty;
  @override
  final bool hideOnError;
  @override
  final bool hideOnLoading;
  @override
  final bool hideSuggestionsOnKeyboardHide;
  @override
  final bool ignoreAccessibleNavigation;
  @override
  final ItemBuilder<T> itemBuilder;
  @override
  final IndexedWidgetBuilder? itemSeparatorBuilder;
  @override
  final bool intercepting;
  @override
  final bool keepSuggestionsOnLoading;
  @override
  final bool keepSuggestionsOnSuggestionSelected;
  @override
  final LayoutArchitecture? layoutArchitecture;
  @override
  final WidgetBuilder? loadingBuilder;
  @override
  final int minCharsForSuggestions;
  @override
  final WidgetBuilder? noItemsFoundBuilder;
  @override
  final SuggestionSelectionCallback<T> onSuggestionSelected;
  @override
  final ScrollController? scrollController;
  @override
  final SuggestionsBoxController? suggestionsBoxController;
  @override
  final SuggestionsCallback<T> suggestionsCallback;
  @override
  final double suggestionsBoxVerticalOffset;
  @override
  final AnimationTransitionBuilder? transitionBuilder;

  Widget buildSuggestionsList(
    BuildContext context,
    SuggestionsListConfig<T> config,
  );

  Widget buildTextField(
    BuildContext context,
    BaseTextFieldConfiguration config,
  );

  @override
  State<BaseTypeAheadField<T>> createState() => _BaseTypeAheadFieldState<T>();
}

class _BaseTypeAheadFieldState<T> extends State<BaseTypeAheadField<T>> {
  late SuggestionsBoxController _suggestionsBoxController;

  late TextEditingController _textEditingController;

  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    _suggestionsBoxController =
        widget.suggestionsBoxController ?? SuggestionsBoxController();

    _textEditingController =
        widget.textFieldConfiguration.controller ?? TextEditingController();

    _focusNode = widget.textFieldConfiguration.focusNode ?? FocusNode();
  }

  @override
  void didUpdateWidget(covariant BaseTypeAheadField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.textFieldConfiguration.controller !=
        widget.textFieldConfiguration.controller) {
      if (oldWidget.textFieldConfiguration.controller == null) {
        _textEditingController.dispose();
      }
      _textEditingController =
          widget.textFieldConfiguration.controller ?? TextEditingController();
    }

    if (oldWidget.textFieldConfiguration.focusNode !=
        widget.textFieldConfiguration.focusNode) {
      if (oldWidget.textFieldConfiguration.focusNode == null) {
        _focusNode.dispose();
      }
      _focusNode = widget.textFieldConfiguration.focusNode ?? FocusNode();
    }
  }

  @override
  void dispose() {
    if (widget.suggestionsBoxController == null) {
      _suggestionsBoxController.dispose();
    }
    if (widget.textFieldConfiguration.controller == null) {
      _textEditingController.dispose();
    }
    if (widget.textFieldConfiguration.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SuggestionsBox(
      controller: _suggestionsBoxController,
      focusNode: _focusNode,
      suggestionsListBuilder: (context) => widget.buildSuggestionsList(
        context,
        SuggestionsListConfig(
          suggestionsBoxController: _suggestionsBoxController,
          debounceDuration: widget.debounceDuration,
          intercepting: widget.intercepting,
          controller: _textEditingController,
          loadingBuilder: widget.loadingBuilder,
          scrollController: widget.scrollController,
          noItemsFoundBuilder: widget.noItemsFoundBuilder,
          errorBuilder: widget.errorBuilder,
          transitionBuilder: widget.transitionBuilder,
          suggestionsCallback: widget.suggestionsCallback,
          animationDuration: widget.animationDuration,
          animationStart: widget.animationStart,
          onSuggestionSelected: widget.onSuggestionSelected,
          itemBuilder: widget.itemBuilder,
          itemSeparatorBuilder: widget.itemSeparatorBuilder,
          layoutArchitecture: widget.layoutArchitecture,
          hideOnLoading: widget.hideOnLoading,
          hideOnEmpty: widget.hideOnEmpty,
          hideOnError: widget.hideOnError,
          keepSuggestionsOnLoading: widget.keepSuggestionsOnLoading,
          minCharsForSuggestions: widget.minCharsForSuggestions,
          hideKeyboardOnDrag: widget.hideKeyboardOnDrag,
        ),
      ),
      child: PointerInterceptor(
        intercepting: widget.intercepting,
        child: widget.buildTextField(
          context,
          widget.textFieldConfiguration.copyWith(
            focusNode: _focusNode,
            controller: _textEditingController,
          ),
        ),
      ),
    );
  }
}
