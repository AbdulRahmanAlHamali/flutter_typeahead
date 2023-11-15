import 'package:flutter/cupertino.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_list.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/typedef.dart';
import 'package:flutter_typeahead/src/cupertino/suggestions_box/cupertino_suggestions_decoration.dart';

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
    required super.suggestionsCallback,
    super.transitionBuilder,
  });

  @override
  final CupertinoSuggestionsDecoration? decoration;

  @override
  @protected
  Widget createLoadingWidget(BuildContext context) {
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
    Object error,
  ) {
    Widget child;

    if (errorBuilder != null) {
      child = errorBuilder!(context, error);
    } else {
      String message = 'An error has occured';
      message = 'Error: $error';
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
  Widget createNoItemsFoundWidget(BuildContext context) {
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
    List<T> suggestions,
  ) {
    Widget child;

    LayoutArchitecture? layoutArchitecture = this.layoutArchitecture;
    layoutArchitecture ??= createDefaultLayout;

    child = layoutArchitecture(
      context,
      List.generate(
        suggestions.length,
        (index) => _itemBuilder(
          context,
          suggestions.elementAt(index),
        ),
      ),
    );

    CupertinoSuggestionsDecoration? decoration = this.decoration;
    if (decoration != null && decoration.hasScrollbar) {
      child = MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: CupertinoScrollbar(
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
    BuildContext context,
    Widget child,
  ) {
    Color? color = decoration?.color;
    color ??= CupertinoTheme.of(context).barBackgroundColor.withOpacity(1);

    BoxBorder? border = decoration?.border;
    border ??= Border.all(
      color: CupertinoColors.separator.resolveFrom(context),
      width: 1,
    );

    return DefaultTextStyle(
      style: CupertinoTheme.of(context).textTheme.textStyle,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          border: border,
          borderRadius: decoration?.borderRadius,
        ),
        child: child,
      ),
    );
  }
}
