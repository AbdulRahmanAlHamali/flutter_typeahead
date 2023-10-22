import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_list.dart';

class SuggestionsList<T> extends RenderSuggestionsList<T> {
  const SuggestionsList({
    super.key,
    required super.suggestionsBox,
    required super.itemBuilder,
    this.decoration,
    super.controller,
    super.intercepting = false,
    super.getImmediateSuggestions = false,
    super.onSuggestionSelected,
    super.suggestionsCallback,
    super.itemSeparatorBuilder,
    super.layoutArchitecture,
    super.scrollController,
    super.debounceDuration,
    super.loadingBuilder,
    super.noItemsFoundBuilder,
    super.errorBuilder,
    super.transitionBuilder,
    super.animationDuration,
    super.animationStart,
    super.direction,
    super.hideOnLoading,
    super.hideOnEmpty,
    super.hideOnError,
    super.keepSuggestionsOnLoading,
    super.minCharsForSuggestions,
    required super.keyboardSuggestionSelectionNotifier,
    required super.shouldRefreshSuggestionFocusIndexNotifier,
    required super.giveTextFieldFocus,
    required super.onSuggestionFocus,
    required super.onKeyEvent,
    required super.hideKeyboardOnDrag,
  });

  @override
  final SuggestionsBoxDecoration? decoration;

  @override
  Widget createLoadingWidget(
    BuildContext context,
    SuggestionsListConfigState<T> state,
  ) {
    Widget child;

    if (keepSuggestionsOnLoading! && state.suggestions != null) {
      if (state.suggestions!.isEmpty) {
        child = createNoItemsFoundWidget(context, state);
      } else {
        child = createSuggestionsWidget(context, state);
      }
    } else {
      if (loadingBuilder != null) {
        child = loadingBuilder!(context);
      } else {
        child = const Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: CircularProgressIndicator(),
          ),
        );
      }
    }

    return child;
  }

  @override
  Widget createErrorWidget(
    BuildContext context,
    SuggestionsListConfigState<T> state,
  ) {
    Widget child;

    if (errorBuilder != null) {
      child = errorBuilder!(context, state.error);
    } else {
      String message = 'An error has occured';
      if (state.error != null) {
        message = 'Error: ${state.error}';
      }
      child = Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          message,
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      );
    }

    return child;
  }

  @override
  Widget createNoItemsFoundWidget(
    BuildContext context,
    SuggestionsListConfigState<T> state,
  ) {
    Widget child;

    if (noItemsFoundBuilder != null) {
      child = noItemsFoundBuilder!(context);
    } else {
      child = Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          'No Items Found!',
          textAlign: TextAlign.center,
          style:
              TextStyle(color: Theme.of(context).disabledColor, fontSize: 18),
        ),
      );
    }

    return child;
  }

  @override
  Widget createSuggestionsWidget(
    BuildContext context,
    SuggestionsListConfigState<T> state,
  ) {
    Widget child;

    LayoutArchitecture? layoutArchitecture = this.layoutArchitecture;
    layoutArchitecture ??= _defaultLayout;

    Iterable<T>? suggestions = state.suggestions;
    if (suggestions == null) {
      throw StateError(
        'suggestions can not be null when building '
        'suggestions widget',
      );
    }

    child = layoutArchitecture(
      List.generate(
        suggestions.length,
        (index) => _itemBuilder(
          context,
          suggestions.elementAt(index),
          state.focusNodes[index],
        ),
      ),
      state.scrollController,
    );

    SuggestionsBoxDecoration? decoration = this.decoration;
    if (decoration != null && decoration.hasScrollbar) {
      child = MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Scrollbar(
          controller: state.scrollController,
          thumbVisibility: decoration.scrollbarThumbAlwaysVisible,
          trackVisibility: decoration.scrollbarTrackAlwaysVisible,
          child: child,
        ),
      );
    }

    return TextFieldTapRegion(child: child);
  }

  Widget _defaultLayout(Iterable<Widget> items, ScrollController controller) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      primary: false,
      shrinkWrap: true,
      keyboardDismissBehavior: hideKeyboardOnDrag
          ? ScrollViewKeyboardDismissBehavior.onDrag
          : ScrollViewKeyboardDismissBehavior.manual,
      controller: scrollController,
      reverse: suggestionsBox.direction == AxisDirection.down
          ? false
          : suggestionsBox.autoFlipListDirection,
      itemCount: items.length,
      itemBuilder: (context, index) => items.elementAt(index),
      separatorBuilder: (context, index) =>
          itemSeparatorBuilder?.call(context, index) ?? const SizedBox.shrink(),
    );
  }

  Widget _itemBuilder(BuildContext context, T suggestion, FocusNode focusNode) {
    return TextFieldTapRegion(
      child: InkWell(
        focusColor: Theme.of(context).hoverColor,
        focusNode: focusNode,
        child: itemBuilder(context, suggestion),
        onTap: () {
          giveTextFieldFocus();
          onSuggestionSelected?.call(suggestion);
        },
      ),
    );
  }

  @override
  Widget createWidgetWrapper(
    BuildContext context,
    SuggestionsListConfigState<T> state,
    Widget child,
  ) {
    return Material(
      elevation: decoration?.elevation ?? 0,
      color: decoration?.color,
      shape: decoration?.shape,
      borderRadius: decoration?.borderRadius,
      shadowColor: decoration?.shadowColor,
      clipBehavior: decoration?.clipBehavior ?? Clip.none,
      child: child,
    );
  }
}
