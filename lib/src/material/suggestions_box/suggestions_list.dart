import 'package:flutter/material.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_list.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/typedef.dart';
import 'package:flutter_typeahead/src/material/suggestions_box/suggestions_decoration.dart';

class SuggestionsList<T> extends BaseSuggestionsList<T> {
  const SuggestionsList({
    super.key,
    super.animationDuration,
    super.animationStart,
    super.autoFlipListDirection,
    required super.controller,
    super.debounceDuration,
    this.decoration,
    super.direction,
    super.errorBuilder,
    required super.hideKeyboardOnDrag,
    super.hideOnEmpty,
    super.hideOnError,
    super.hideOnLoading,
    super.hideOnSelect,
    required super.itemBuilder,
    super.itemSeparatorBuilder,
    super.keepSuggestionsOnLoading,
    super.layoutArchitecture,
    super.loadingBuilder,
    super.minCharsForSuggestions,
    super.noItemsFoundBuilder,
    super.onSuggestionSelected,
    super.scrollController,
    required super.suggestionsController,
    super.suggestionsCallback,
    super.transitionBuilder,
  });

  @override
  final SuggestionsDecoration? decoration;

  @override
  @protected
  Widget createLoadingWidget(
    BuildContext context,
    SuggestionsListState<T> state,
  ) {
    Widget child;

    if (loadingBuilder != null) {
      child = loadingBuilder!(context);
    } else {
      child = const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [CircularProgressIndicator()],
        ),
      );
    }

    return child;
  }

  @override
  @protected
  Widget createErrorWidget(
    BuildContext context,
    SuggestionsListState<T> state,
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
  @protected
  Widget createNoItemsFoundWidget(
    BuildContext context,
    SuggestionsListState<T> state,
  ) {
    Widget child;

    if (noItemsFoundBuilder != null) {
      child = noItemsFoundBuilder!(context);
    } else {
      child = Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          'No items found!',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      );
    }

    return child;
  }

  @override
  @protected
  Widget createSuggestionsWidget(
    BuildContext context,
    SuggestionsListState<T> state,
  ) {
    Widget child;

    LayoutArchitecture? layoutArchitecture = this.layoutArchitecture;
    layoutArchitecture ??= createDefaultLayout;

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
        ),
      ),
      state.scrollController,
    );

    SuggestionsDecoration? decoration = this.decoration;
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

  Widget _itemBuilder(BuildContext context, T suggestion) {
    return TextFieldTapRegion(
      child: InkWell(
        focusColor: Theme.of(context).hoverColor,
        child: itemBuilder(context, suggestion),
        onTap: () => onSelected(suggestion),
      ),
    );
  }

  @override
  @protected
  Widget createWidgetWrapper(
    BuildContext context,
    SuggestionsListState<T> state,
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
