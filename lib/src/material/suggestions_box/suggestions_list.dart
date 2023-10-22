import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_list.dart';

class SuggestionsList<T> extends RenderSuggestionsList<T> {
  const SuggestionsList({
    super.key,
    required super.suggestionsBox,
    this.decoration,
    super.controller,
    super.intercepting = false,
    super.getImmediateSuggestions = false,
    super.onSuggestionSelected,
    super.suggestionsCallback,
    super.itemBuilder,
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
    SuggestionsListConfigState state,
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
            padding: EdgeInsets.symmetric(vertical: 8.0),
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
    SuggestionsListConfigState state,
  ) {
    Widget child;

    if (errorBuilder != null) {
      child = errorBuilder!(context, state.error);
    } else {
      child = Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Error: ${state.error}',
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      );
    }

    return child;
  }

  @override
  Widget createNoItemsFoundWidget(
    BuildContext context,
    SuggestionsListConfigState state,
  ) {
    Widget child;

    if (noItemsFoundBuilder != null) {
      child = noItemsFoundBuilder!(context);
    } else {
      child = Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          'No Items Found!',
          textAlign: TextAlign.center,
          style:
              TextStyle(color: Theme.of(context).disabledColor, fontSize: 18.0),
        ),
      );
    }

    return child;
  }

  @override
  Widget createSuggestionsWidget(
    BuildContext context,
    SuggestionsListConfigState state,
  ) {
    Widget child;

    if (layoutArchitecture == null) {
      child = defaultSuggestionsWidget(context, state);
    } else {
      child = customSuggestionsWidget(context, state);
    }

    if (decoration!.hasScrollbar) {
      child = MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Scrollbar(
          controller: state.scrollController,
          thumbVisibility: decoration!.scrollbarThumbAlwaysVisible,
          trackVisibility: decoration!.scrollbarTrackAlwaysVisible,
          child: child,
        ),
      );
    }

    return TextFieldTapRegion(child: child);
  }

  Widget defaultSuggestionsWidget(
    BuildContext context,
    SuggestionsListConfigState state,
  ) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      primary: false,
      shrinkWrap: true,
      keyboardDismissBehavior: hideKeyboardOnDrag
          ? ScrollViewKeyboardDismissBehavior.onDrag
          : ScrollViewKeyboardDismissBehavior.manual,
      controller: state.scrollController,
      reverse: suggestionsBox!.direction == AxisDirection.down
          ? false
          : suggestionsBox!.autoFlipListDirection,
      itemCount: state.suggestions!.length,
      itemBuilder: (context, index) {
        final suggestion = state.suggestions!.elementAt(index);
        final focusNode = state.focusNodes[index];
        return TextFieldTapRegion(
          child: InkWell(
            focusColor: Theme.of(context).hoverColor,
            focusNode: focusNode,
            child: itemBuilder!(context, suggestion),
            onTap: () {
              // we give the focus back to the text field
              giveTextFieldFocus();
              onSuggestionSelected!(suggestion);
            },
          ),
        );
      },
      separatorBuilder: (context, index) =>
          itemSeparatorBuilder?.call(context, index) ?? const SizedBox.shrink(),
    );
  }

  Widget customSuggestionsWidget(
    BuildContext context,
    SuggestionsListConfigState state,
  ) {
    return layoutArchitecture!(
      List.generate(state.suggestions!.length, (index) {
        final suggestion = state.suggestions!.elementAt(index);
        final focusNode = state.focusNodes[index];

        return TextFieldTapRegion(
          child: InkWell(
            focusColor: Theme.of(context).hoverColor,
            focusNode: focusNode,
            child: itemBuilder!(context, suggestion),
            onTap: () {
              // * we give the focus back to the text field
              giveTextFieldFocus();
              onSuggestionSelected!(suggestion);
            },
          ),
        );
      }),
      state.scrollController,
    );
  }

  @override
  Widget createWidgetWrapper(
    BuildContext context,
    SuggestionsListConfigState state,
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
