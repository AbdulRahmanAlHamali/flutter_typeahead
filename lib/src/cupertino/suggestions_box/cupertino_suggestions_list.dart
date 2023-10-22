import 'package:flutter/cupertino.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_list.dart';

class CupertinoSuggestionsList<T> extends RenderSuggestionsList<T> {
  const CupertinoSuggestionsList({
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
  final CupertinoSuggestionsBoxDecoration? decoration;

  @override
  Widget createLoadingWidget(
    BuildContext context,
    SuggestionsListConfigState<T> state,
  ) {
    Widget child;

    bool keepSuggestionsOnLoading = this.keepSuggestionsOnLoading ?? true;
    Iterable<T>? suggestions = state.suggestions;

    if (keepSuggestionsOnLoading && suggestions != null) {
      if (suggestions.isEmpty) {
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
            child: CupertinoActivityIndicator(),
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
        padding: const EdgeInsets.all(4.0),
        child: Text(
          message,
          textAlign: TextAlign.start,
          style: const TextStyle(
            color: CupertinoColors.destructiveRed,
            fontSize: 18.0,
          ),
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
      child = const Padding(
        padding: EdgeInsets.all(4.0),
        child: Text(
          'No Items Found!',
          textAlign: TextAlign.start,
          style: TextStyle(
            color: CupertinoColors.inactiveGray,
            fontSize: 18.0,
          ),
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

    if (layoutArchitecture != null) {
      child = customSuggestionsWidget(context, state);
    } else {
      child = defaultSuggestionsWidget(context, state);
    }

    CupertinoSuggestionsBoxDecoration? decoration = this.decoration;
    if (decoration != null && decoration.hasScrollbar) {
      child = MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: CupertinoScrollbar(
          controller: state.scrollController,
          thumbVisibility: decoration.scrollbarThumbAlwaysVisible,
          child: child,
        ),
      );
    }

    return child;
  }

  Widget defaultSuggestionsWidget(
    BuildContext context,
    SuggestionsListConfigState<T> state,
  ) {
    Iterable<T>? suggestions = state.suggestions;
    if (suggestions == null) {
      throw StateError(
        'suggestions can not be null when building '
        'suggestions widget',
      );
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      primary: false,
      shrinkWrap: true,
      controller: state.scrollController,
      keyboardDismissBehavior: hideKeyboardOnDrag
          ? ScrollViewKeyboardDismissBehavior.onDrag
          : ScrollViewKeyboardDismissBehavior.manual,
      reverse: suggestionsBox.direction == AxisDirection.down
          ? false
          : suggestionsBox.autoFlipListDirection,
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions.elementAt(index);
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          child: itemBuilder(
            context,
            suggestion,
          ),
          onTap: () => onSuggestionSelected?.call(suggestion),
        );
      },
      separatorBuilder: (context, index) =>
          itemSeparatorBuilder?.call(context, index) ?? const SizedBox.shrink(),
    );
  }

  Widget customSuggestionsWidget(
    BuildContext context,
    SuggestionsListConfigState<T> state,
  ) {
    Iterable<T>? suggestions = state.suggestions;
    if (suggestions == null) {
      throw StateError(
        'suggestions can not be null when building '
        'suggestions widget',
      );
    }

    return layoutArchitecture!(
      List.generate(suggestions.length, (index) {
        final suggestion = suggestions.elementAt(index);
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          child: itemBuilder(context, suggestion),
          onTap: () => onSuggestionSelected?.call(suggestion),
        );
      }),
      state.scrollController,
    );
  }

  @override
  Widget createWidgetWrapper(
      BuildContext context, SuggestionsListConfigState<T> state, Widget child) {
    Color? color = decoration?.color;
    color ??= CupertinoTheme.of(context).barBackgroundColor;

    BoxBorder? border = decoration?.border;
    border ??= Border.all(
      color: const CupertinoDynamicColor.withBrightness(
        color: Color(0x33000000),
        darkColor: Color(0x33FFFFFF),
      ),
      width: 0.0,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        border: border,
        borderRadius: decoration?.borderRadius,
      ),
      child: child,
    );
  }
}
