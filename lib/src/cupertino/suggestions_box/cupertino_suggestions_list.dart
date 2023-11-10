import 'package:flutter/cupertino.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_list.dart';

class CupertinoSuggestionsList<T> extends BaseSuggestionsList<T> {
  const CupertinoSuggestionsList({
    super.key,
    super.animationDuration,
    super.animationStart,
    super.autoFlipListDirection,
    required super.controller,
    super.debounceDuration,
    this.decoration,
    super.direction,
    super.errorBuilder,
    super.hideKeyboardOnDrag,
    super.hideOnEmpty,
    super.hideOnError,
    super.hideOnLoading,
    required super.itemBuilder,
    super.itemSeparatorBuilder,
    super.keepSuggestionsOnLoading,
    super.keepSuggestionsOnSelect,
    super.layoutArchitecture,
    super.loadingBuilder,
    super.minCharsForSuggestions,
    super.noItemsFoundBuilder,
    super.onSuggestionSelected,
    super.scrollController,
    required super.suggestionsBoxController,
    super.suggestionsCallback,
    super.transitionBuilder,
  });

  @override
  final CupertinoSuggestionsBoxDecoration? decoration;

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
          children: [CupertinoActivityIndicator()],
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
        padding: const EdgeInsets.all(4),
        child: Text(
          message,
          textAlign: TextAlign.start,
          style: const TextStyle(
            color: CupertinoColors.destructiveRed,
            fontSize: 18,
          ),
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
      child = const Padding(
        padding: EdgeInsets.all(4),
        child: Text(
          'No Items Found!',
          textAlign: TextAlign.start,
          style: TextStyle(
            color: CupertinoColors.inactiveGray,
            fontSize: 18,
          ),
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

  Widget _itemBuilder(BuildContext context, T suggestion) {
    return TextFieldTapRegion(
      child: FocusableActionDetector(
        mouseCursor: SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: itemBuilder(
            context,
            suggestion,
          ),
          onTap: () => onSelected(suggestion),
        ),
      ),
    );
  }

  @override
  @protected
  Widget createWidgetWrapper(
      BuildContext context, SuggestionsListState<T> state, Widget child) {
    Color? color = decoration?.color;
    color ??= CupertinoTheme.of(context).barBackgroundColor;

    BoxBorder? border = decoration?.border;
    border ??= Border.all(
      color: const CupertinoDynamicColor.withBrightness(
        color: Color(0x33000000),
        darkColor: Color(0x33FFFFFF),
      ),
      width: 0,
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
