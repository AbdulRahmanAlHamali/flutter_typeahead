import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/src/common/field/suggestions_field.dart';
import 'package:flutter_typeahead/src/common/search/suggestions_search.dart';
import 'package:flutter_typeahead/src/common/base/suggestions_controller.dart';
import 'package:flutter_typeahead/src/common/box/suggestions_list.dart';

import 'package:flutter_typeahead/src/common/base/types.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

/// {@template flutter_typeahead.RawTypeAheadField}
/// A widget that shows suggestions above a text field while the user is typing.
///
/// This is the base class for the Material and Cupertino versions of the widget.
/// You may use this class if you want to create your own version of the widget.
/// {@endtemplate}
abstract class RawTypeAheadField<T> extends StatefulWidget {
  const RawTypeAheadField({
    super.key,
    this.animationDuration = const Duration(milliseconds: 200),
    this.autoFlipDirection = false,
    this.autoFlipMinHeight = 144,
    required this.builder,
    this.controller,
    this.debounceDuration = const Duration(milliseconds: 300),
    this.direction = VerticalDirection.down,
    required this.errorBuilder,
    this.focusNode,
    this.hideKeyboardOnDrag = false,
    this.hideOnEmpty = false,
    this.hideOnError = false,
    this.hideOnLoading = false,
    this.showOnFocus = true,
    this.hideOnUnfocus = true,
    this.hideWithKeyboard = true,
    this.hideOnSelect = true,
    required this.itemBuilder,
    this.itemSeparatorBuilder,
    this.retainOnLoading = true,
    required this.loadingBuilder,
    required this.emptyBuilder,
    required this.onSelected,
    this.scrollController,
    this.suggestionsController,
    required this.suggestionsCallback,
    this.transitionBuilder,
    this.decorationBuilder,
    this.listBuilder,
    this.constraints,
    this.offset,
  });

  /// Builds the text field that will be used to search for the suggestions.
  final TextFieldBuilder builder;

  /// {@macro flutter_typeahead.SuggestionsSearch.textEditingController}
  final TextEditingController? controller;

  /// {@macro flutter_typeahead.SuggestionsField.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter_typeahead.SuggestionsBox.controller}
  final SuggestionsController<T>? suggestionsController;

  /// {@macro flutter_typeahead.SuggestionsField.onSelected}
  final ValueSetter<T>? onSelected;

  /// {@macro flutter_typeahead.SuggestionsField.direction}
  final VerticalDirection? direction;

  /// {@macro flutter_typeahead.SuggestionsField.constraints}
  final BoxConstraints? constraints;

  /// {@macro flutter_typeahead.SuggestionsField.offset}
  final Offset? offset;

  /// {@macro flutter_typeahead.SuggestionsField.autoFlipDirection}
  final bool autoFlipDirection;

  /// {@macro flutter_typeahead.SuggestionsField.autoFlipMinHeight}
  final double autoFlipMinHeight;

  /// {@macro flutter_typeahead.SuggestionsField.showOnFocus}
  final bool showOnFocus;

  /// {@macro flutter_typeahead.SuggestionsField.hideOnUnfocus}
  final bool hideOnUnfocus;

  /// {@macro flutter_typeahead.SuggestionsField.hideOnSelect}
  final bool hideOnSelect;

  /// {@macro flutter_typeahead.SuggestionsField.hideWithKeyboard}
  final bool hideWithKeyboard;

  /// {@macro flutter_typeahead.SuggestionsBox.scrollController}
  final ScrollController? scrollController;

  /// {@macro flutter_typeahead.SuggestionsBox.transitionBuilder}
  final AnimationTransitionBuilder? transitionBuilder;

  /// {@macro flutter_typeahead.SuggestionsBox.animationDuration}
  final Duration? animationDuration;

  /// {@macro flutter_typeahead.SuggestionsSearch.suggestionsCallback}
  final SuggestionsCallback<T> suggestionsCallback;

  /// {@macro flutter_typeahead.SuggestionsList.retainOnLoading}
  final bool? retainOnLoading;

  /// {@macro flutter_typeahead.SuggestionsList.hideKeyboardOnDrag}
  final bool? hideKeyboardOnDrag;

  /// {@macro flutter_typeahead.SuggestionsList.hideOnLoading}
  final bool? hideOnLoading;

  /// {@macro flutter_typeahead.SuggestionsList.hideOnError}
  final bool? hideOnError;

  /// {@macro flutter_typeahead.SuggestionsList.hideOnEmpty}
  final bool? hideOnEmpty;

  /// {@macro flutter_typeahead.SuggestionsList.loadingBuilder}
  final WidgetBuilder loadingBuilder;

  //// {@macro flutter_typeahead.SuggestionsList.errorBuilder}
  final SuggestionsErrorBuilder errorBuilder;

  /// {@macro flutter_typeahead.SuggestionsList.emptyBuilder}
  final WidgetBuilder emptyBuilder;

  /// {@macro flutter_typeahead.SuggestionsListConfig.itemBuilder}
  final SuggestionsItemBuilder<T> itemBuilder;

  /// {@macro flutter_typeahead.SuggestionsList.itemSeparatorBuilder}
  final IndexedWidgetBuilder? itemSeparatorBuilder;

  /// {@macro flutter_typeahead.SuggestionsBox.decorationBuilder}
  final DecorationBuilder? decorationBuilder;

  /// {@macro flutter_typeahead.SuggestionsList.listBuilder}
  final ListBuilder? listBuilder;

  /// {@macro flutter_typeahead.SuggestionsSearch.debounce}
  final Duration? debounceDuration;

  @override
  State<RawTypeAheadField<T>> createState() => _RawTypeAheadFieldState<T>();
}

class _RawTypeAheadFieldState<T> extends State<RawTypeAheadField<T>> {
  late TextEditingController controller;
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? TextEditingController();
    focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void didUpdateWidget(covariant RawTypeAheadField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      if (oldWidget.controller == null) {
        controller.dispose();
      }
      controller = widget.controller ?? TextEditingController();
    }
    if (oldWidget.focusNode != widget.focusNode) {
      if (oldWidget.focusNode == null) {
        focusNode.dispose();
      }
      focusNode = widget.focusNode ?? FocusNode();
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      controller.dispose();
    }
    if (widget.focusNode == null) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SuggestionsField<T>(
      controller: widget.suggestionsController,
      onSelected: widget.onSelected,
      focusNode: focusNode,
      direction: widget.direction,
      autoFlipDirection: widget.autoFlipDirection,
      autoFlipMinHeight: widget.autoFlipMinHeight,
      showOnFocus: widget.showOnFocus,
      hideOnUnfocus: widget.hideOnUnfocus,
      hideOnSelect: widget.hideOnSelect,
      hideWithKeyboard: widget.hideWithKeyboard,
      constraints: widget.constraints,
      offset: widget.offset,
      scrollController: widget.scrollController,
      decorationBuilder: (context, child) => TextFieldTapRegion(
        child: SuggestionsSearch<T>(
          controller: SuggestionsController.of<T>(context),
          textEditingController: controller,
          suggestionsCallback: widget.suggestionsCallback,
          debounceDuration: widget.debounceDuration,
          child: widget.decorationBuilder?.call(context, child) ?? child,
        ),
      ),
      transitionBuilder: widget.transitionBuilder,
      animationDuration: widget.animationDuration,
      builder: (context, suggestionsController) => SuggestionsList<T>(
        controller: suggestionsController,
        loadingBuilder: widget.loadingBuilder,
        errorBuilder: widget.errorBuilder,
        emptyBuilder: widget.emptyBuilder,
        hideOnLoading: widget.hideOnLoading,
        hideOnError: widget.hideOnError,
        hideOnEmpty: widget.hideOnEmpty,
        retainOnLoading: widget.retainOnLoading,
        hideKeyboardOnDrag: widget.hideKeyboardOnDrag,
        itemBuilder: widget.itemBuilder,
        itemSeparatorBuilder: widget.itemSeparatorBuilder,
        listBuilder: widget.listBuilder,
      ),
      child: PointerInterceptor(
        child: widget.builder(
          context,
          controller,
          focusNode,
        ),
      ),
    );
  }
}
