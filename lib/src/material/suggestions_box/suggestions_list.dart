import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_list.dart';

class SuggestionsList<T> extends RenderSuggestionsList<T> {
  const SuggestionsList({
    super.key,
    required super.suggestionsBoxController,
    required super.itemBuilder,
    required super.controller,
    this.decoration,
    super.intercepting = false,
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
    super.hideOnLoading,
    super.hideOnEmpty,
    super.hideOnError,
    super.keepSuggestionsOnLoading,
    super.keepSuggestionsOnSelect,
    super.minCharsForSuggestions,
    required super.hideKeyboardOnDrag,
  });

  @override
  final SuggestionsBoxDecoration? decoration;

  @override
  @protected
  Widget createLoadingWidget(
    BuildContext context,
    SuggestionsListState<T> state,
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
          // state.focusNodes[index],
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
