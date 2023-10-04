import 'package:flutter/cupertino.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_list.dart';

class CupertinoSuggestionsList<T> extends RenderSuggestionsList<T> {
  const CupertinoSuggestionsList({
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
  final CupertinoSuggestionsBoxDecoration? decoration;

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
      child = loadingBuilder != null
          ? loadingBuilder!(context)
          : Container(
              decoration: BoxDecoration(
                color: CupertinoColors.white,
                border: Border.all(
                  color: CupertinoColors.extraLightBackgroundGray,
                  width: 1.0,
                ),
              ),
              child: const Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: CupertinoActivityIndicator(),
                ),
              ),
            );
    }

    return child;
  }

  @override
  Widget createErrorWidget(
    BuildContext context,
    SuggestionsListConfigState state,
  ) {
    return errorBuilder != null
        ? errorBuilder!(context, state.error)
        : Container(
            decoration: BoxDecoration(
              color: CupertinoColors.white,
              border: Border.all(
                color: CupertinoColors.extraLightBackgroundGray,
                width: 1.0,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                'Error: ${state.error}',
                textAlign: TextAlign.start,
                style: const TextStyle(
                  color: CupertinoColors.destructiveRed,
                  fontSize: 18.0,
                ),
              ),
            ),
          );
  }

  @override
  Widget createNoItemsFoundWidget(
    BuildContext context,
    SuggestionsListConfigState state,
  ) {
    return noItemsFoundBuilder != null
        ? noItemsFoundBuilder!(context)
        : Container(
            decoration: BoxDecoration(
              color: CupertinoColors.white,
              border: Border.all(
                color: CupertinoColors.extraLightBackgroundGray,
                width: 1.0,
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.all(4.0),
              child: Text(
                'No Items Found!',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: CupertinoColors.inactiveGray,
                  fontSize: 18.0,
                ),
              ),
            ),
          );
  }

  @override
  Widget createSuggestionsWidget(
    BuildContext context,
    SuggestionsListConfigState state,
  ) {
    if (layoutArchitecture == null) {
      return defaultSuggestionsWidget(context, state);
    } else {
      return customSuggestionsWidget(context, state);
    }
  }

  @override
  Widget defaultSuggestionsWidget(
    BuildContext context,
    SuggestionsListConfigState state,
  ) {
    Widget child = Container(
      decoration: BoxDecoration(
        color: decoration!.color ?? CupertinoColors.white,
        border: decoration!.border ??
            Border.all(
              color: CupertinoColors.extraLightBackgroundGray,
              width: 1.0,
            ),
        borderRadius: decoration!.borderRadius,
      ),
      child: ListView.separated(
        padding: EdgeInsets.zero,
        primary: false,
        shrinkWrap: true,
        controller: state.scrollController,
        keyboardDismissBehavior: hideKeyboardOnDrag
            ? ScrollViewKeyboardDismissBehavior.onDrag
            : ScrollViewKeyboardDismissBehavior.manual,
        reverse: suggestionsBox!.direction == AxisDirection.down
            ? false
            : suggestionsBox!.autoFlipListDirection,
        itemCount: state.suggestions!.length,
        itemBuilder: (context, index) => GestureDetector(
          behavior: HitTestBehavior.translucent,
          child: itemBuilder!(
            context,
            state.suggestions!.elementAt(index),
          ),
          onTap: () => onSuggestionSelected!(
            state.suggestions!.elementAt(index),
          ),
        ),
        separatorBuilder: (context, index) =>
            itemSeparatorBuilder?.call(context, index) ??
            const SizedBox.shrink(),
      ),
    );

    if (decoration!.hasScrollbar) {
      child = MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: CupertinoScrollbar(
          controller: state.scrollController,
          thumbVisibility: decoration!.scrollbarThumbAlwaysVisible,
          child: child,
        ),
      );
    }

    return child;
  }

  @override
  Widget customSuggestionsWidget(
    BuildContext context,
    SuggestionsListConfigState state,
  ) {
    Widget child = DecoratedBox(
      decoration: BoxDecoration(
        color: decoration!.color ?? CupertinoColors.white,
        border: decoration!.border ??
            Border.all(
              color: CupertinoColors.extraLightBackgroundGray,
              width: 1.0,
            ),
        borderRadius: decoration!.borderRadius,
      ),
      child: layoutArchitecture!(
        List.generate(state.suggestions!.length, (index) {
          final suggestion = state.suggestions!.elementAt(index);

          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: itemBuilder!(context, suggestion),
            onTap: () => onSuggestionSelected!(suggestion),
          );
        }),
        state.scrollController,
      ),
    );

    if (decoration!.hasScrollbar) {
      child = MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: CupertinoScrollbar(
          controller: state.scrollController,
          thumbVisibility: decoration!.scrollbarThumbAlwaysVisible,
          child: child,
        ),
      );
    }

    return child;
  }
}
