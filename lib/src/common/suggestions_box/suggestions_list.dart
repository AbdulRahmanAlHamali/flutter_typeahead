import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_controller.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_decoration.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_list_animation.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_list_config.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_list_keyboard_connector.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_list_scroll_injector.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_list_text_debouncer.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_list_typing_connector.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/typedef.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

/// Renders all the suggestions using a ListView as default.
/// If `layoutArchitecture` is specified, uses that instead.
abstract class BaseSuggestionsList<T> extends StatefulWidget
    implements SuggestionsListConfig<T> {
  const BaseSuggestionsList({
    super.key,
    this.animationDuration,
    this.animationStart,
    this.autoFlipListDirection = true,
    required this.controller,
    this.debounceDuration,
    this.direction = AxisDirection.down,
    this.errorBuilder,
    this.hideKeyboardOnDrag = false,
    this.hideOnEmpty,
    this.hideOnError,
    this.hideOnLoading,
    this.hideOnSelect,
    required this.itemBuilder,
    this.itemSeparatorBuilder,
    this.keepSuggestionsOnLoading,
    this.layoutArchitecture,
    this.loadingBuilder,
    this.minCharsForSuggestions,
    this.noItemsFoundBuilder,
    this.onSuggestionSelected,
    this.scrollController,
    required this.suggestionsController,
    required this.suggestionsCallback,
    this.transitionBuilder,
  });

  @override
  final Duration? animationDuration;
  @override
  final double? animationStart;
  @override
  final bool autoFlipListDirection;
  @override
  final TextEditingController controller;
  @override
  final Duration? debounceDuration;
  @override
  final AxisDirection direction;
  @override
  final ErrorBuilder? errorBuilder;
  @override
  final bool hideKeyboardOnDrag;
  @override
  final bool? hideOnEmpty;
  @override
  final bool? hideOnError;
  @override
  final bool? hideOnSelect;
  @override
  final bool? hideOnLoading;
  @override
  final ItemBuilder<T> itemBuilder;
  @override
  final IndexedWidgetBuilder? itemSeparatorBuilder;
  @override
  final bool? keepSuggestionsOnLoading;
  @override
  final LayoutArchitecture? layoutArchitecture;
  @override
  final WidgetBuilder? loadingBuilder;
  @override
  final int? minCharsForSuggestions;
  @override
  final WidgetBuilder? noItemsFoundBuilder;
  @override
  final SuggestionSelectionCallback<T>? onSuggestionSelected;
  @override
  final ScrollController? scrollController;
  @override
  final SuggestionsController<T> suggestionsController;
  @override
  final SuggestionsCallback<T> suggestionsCallback;
  @override
  final AnimationTransitionBuilder? transitionBuilder;

  BaseSuggestionsDecoration? get decoration;

  /// Creates a widget to display while suggestions are loading.
  @protected
  Widget createLoadingWidget(
    BuildContext context,
  );

  /// Creates a widget to display when an error has occurred.
  @protected
  Widget createErrorWidget(
    BuildContext context,
    Object error,
  );

  /// Creates a widget to display when no suggestions are available.
  @protected
  Widget createNoItemsFoundWidget(BuildContext context);

  /// Creates a widget to display the suggestions.
  @protected
  Widget createSuggestionsWidget(
    BuildContext context,
    List<T> suggestions,
  );

  /// Creates a widget to wrap all the other widgets.
  @protected
  Widget createWidgetWrapper(
    BuildContext context,
    Widget child,
  ) =>
      child;

  /// Call to select a suggestion.
  ///
  /// Handles closing the suggestions box if [hideOnSelect] is false.
  @protected
  void onSelected(T suggestion) {
    // We call this before closing the suggestions list
    // so that the text field can be updated without reopening the suggestions list.
    onSuggestionSelected?.call(suggestion);
    if (hideOnSelect ?? true) {
      suggestionsController.close(retainFocus: true);
    } else {
      suggestionsController.focusChild();
    }
  }

  @protected
  Widget createDefaultLayout(
    BuildContext context,
    Iterable<Widget> items,
  ) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      keyboardDismissBehavior: hideKeyboardOnDrag
          ? ScrollViewKeyboardDismissBehavior.onDrag
          : ScrollViewKeyboardDismissBehavior.manual,
      reverse: direction == AxisDirection.up ? autoFlipListDirection : false,
      itemCount: items.length,
      itemBuilder: (context, index) => items.elementAt(index),
      separatorBuilder: (context, index) =>
          itemSeparatorBuilder?.call(context, index) ?? const SizedBox.shrink(),
    );
  }

  @override
  State<BaseSuggestionsList<T>> createState() => _BaseSuggestionsListState<T>();
}

class _BaseSuggestionsListState<T> extends State<BaseSuggestionsList<T>> {
  bool isQueued = false;

  @override
  void initState() {
    super.initState();
    onOpenChange();
    widget.suggestionsController.addListener(onOpenChange);
  }

  void onOpenChange() {
    if (widget.suggestionsController.isOpen) {
      load();
    }
  }

  /// Loads suggestions if not already loaded.
  Future<void> load() async {
    if (widget.suggestionsController.suggestions != null) return;
    return reload();
  }

  /// Loads suggestions. Discards any previously loaded suggestions.
  Future<void> reload() async {
    if (widget.suggestionsController.isLoading) {
      isQueued = true;
      return;
    }

    widget.suggestionsController.suggestions =
        widget.suggestionsController.suggestions;
    widget.suggestionsController.isLoading = true;
    widget.suggestionsController.error = null;

    List<T>? newSuggestions;
    Object? newError;

    bool hasCharacters = widget.minCharsForSuggestions == null ||
        widget.minCharsForSuggestions! <= widget.controller.text.length;

    if (hasCharacters) {
      try {
        newSuggestions =
            (await widget.suggestionsCallback(widget.controller.text)).toList();
      } on Exception catch (e) {
        newError = e;
      }
    }

    if (mounted) {
      widget.suggestionsController.suggestions = newSuggestions;
      widget.suggestionsController.error = newError;
      widget.suggestionsController.isLoading = false;
    }

    if (isQueued) {
      isQueued = false;
      await reload();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.suggestionsController,
      builder: (context, _) {
        bool keepSuggestionsOnLoading = widget.keepSuggestionsOnLoading ?? true;
        List<T>? suggestions = widget.suggestionsController.suggestions;
        bool showLoading = keepSuggestionsOnLoading || suggestions == null;

        Widget child;
        if (widget.suggestionsController.isLoading && showLoading) {
          if (widget.hideOnLoading!) {
            child = const SizedBox();
          } else {
            child = widget.createLoadingWidget(context);
          }
        } else if (widget.suggestionsController.hasError) {
          if (widget.hideOnError!) {
            child = const SizedBox();
          } else {
            child = widget.createErrorWidget(
                context, widget.suggestionsController.error!);
          }
        } else if (suggestions?.isEmpty ?? true) {
          if (widget.hideOnEmpty ?? false) {
            child = const SizedBox();
          } else {
            child = widget.createNoItemsFoundWidget(context);
          }
        } else {
          child = widget.createSuggestionsWidget(context, suggestions!);
        }

        return SuggestionsListTextDebouncer(
          controller: widget.controller,
          debounceDuration: widget.debounceDuration,
          onChanged: (_) => reload(),
          child: SuggestionsListScrollInjector(
            controller: widget.scrollController,
            child: SuggestionsListKeyboardConnector(
              controller: widget.suggestionsController,
              child: SuggestionsListTypingConnector(
                controller: widget.suggestionsController,
                textEditingController: widget.controller,
                child: PointerInterceptor(
                  child: widget.createWidgetWrapper(
                    context,
                    SuggestionsListAnimation(
                      controller: widget.suggestionsController,
                      transitionBuilder: widget.transitionBuilder,
                      direction: widget.direction,
                      animationStart: widget.animationStart,
                      animationDuration: widget.animationDuration,
                      child: child,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
