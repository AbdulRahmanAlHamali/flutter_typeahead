import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/src/common/base/suggestions_controller.dart';
import 'package:flutter_typeahead/src/common/base/types.dart';

/// A widget that shows a list of suggestions based on user input.
class SuggestionsList<T> extends StatefulWidget {
  const SuggestionsList({
    super.key,
    required this.controller,
    this.hideKeyboardOnDrag,
    this.hideOnLoading,
    this.hideOnError,
    this.hideOnEmpty,
    required this.loadingBuilder,
    required this.errorBuilder,
    required this.emptyBuilder,
    required this.itemBuilder,
    this.retainOnLoading,
    this.listBuilder,
    this.itemSeparatorBuilder,
  });

  /// {@macro flutter_typeahead.SuggestionsBox.controller}
  final SuggestionsController<T> controller;

  /// {@template flutter_typeahead.SuggestionsList.retainOnLoading}
  /// Whether to retain the previous suggestions while loading new suggestions.
  ///
  /// If enabled, [loadingBuilder] will be ignored.
  ///
  /// Defaults to `true`.
  /// {@endtemplate}
  final bool? retainOnLoading;

  /// {@template flutter_typeahead.SuggestionsList.hideKeyboardOnDrag}
  /// Whether the keyboard should be hidden when the user scrolls the suggestions list.
  ///
  /// Cannot be used together with [hideWithKeyboard].
  ///
  /// Defaults to `false`.
  /// {@endtemplate}
  final bool? hideKeyboardOnDrag;

  /// {@template flutter_typeahead.SuggestionsList.hideOnLoading}
  /// Whether the suggestions box should be hidden during loading.
  ///
  /// If enabled, [loadingBuilder] will be ignored.
  ///
  /// Defaults to `false`.
  /// {@endtemplate}
  final bool? hideOnLoading;

  /// {@template flutter_typeahead.SuggestionsList.hideOnError}
  /// Whether the suggestions box should be hidden on error.
  ///
  /// If enabled, [errorBuilder] will be ignored.
  ///
  /// Defaults to `false`.
  /// {@endtemplate}
  final bool? hideOnError;

  /// {@template flutter_typeahead.SuggestionsList.hideOnEmpty}
  /// Whether the suggestions box should be hidden when no suggestions are available.
  ///
  /// If enabled, [noItemsFoundBuilder] will be ignored.
  ///
  /// Defaults to `false`.
  /// {@endtemplate}
  final bool? hideOnEmpty;

  /// {@template flutter_typeahead.SuggestionsList.loadingBuilder}
  /// Builder function to display a loading indicator.
  ///
  /// Called when waiting for [suggestionsCallback] to return.
  ///
  /// Example usage:
  /// ```dart
  /// loadingBuilder: (context) => Text('Loading suggestions...'),
  /// ```
  ///
  /// See also:
  /// * [hideOnLoading], which is whether the suggestions box should be hidden during loading.
  /// {@endtemplate}
  final WidgetBuilder loadingBuilder;

  /// {@template flutter_typeahead.SuggestionsList.errorBuilder}
  /// Builds the widget for when the controller has an error.
  ///
  /// Example usage:
  /// ```dart
  /// errorBuilder: (context, error) => Text(
  ///   '$error',
  ///   style: TextStyle(color: Theme.of(context).errorColor),
  /// ),
  /// ```
  ///
  /// See also:
  /// * [hideOnError], which is whether the suggestions box should be hidden on error.
  /// {@endtemplate}
  final SuggestionsErrorBuilder errorBuilder;

  /// {@template flutter_typeahead.SuggestionsList.emptyBuilder}
  /// Builds the widget for when the suggestions list is empty.
  ///
  /// Example usage:
  /// ```dart
  /// emptyBuilder: (context) => Text('No Items Found!'),
  /// ```
  /// {@endtemplate}
  final WidgetBuilder emptyBuilder;

  /// {@template flutter_typeahead.SuggestionsListConfig.itemBuilder}
  /// Called for each suggestion to build the corresponding widget.
  ///
  /// Example usage:
  /// ```dart
  /// itemBuilder: (context, city) {
  ///   return ListTile(
  ///     title: Text(city.name),
  ///     subtitle: Text(city.country),
  ///   );
  /// },
  /// ```
  /// {@endtemplate}
  final SuggestionsItemBuilder<T> itemBuilder;

  /// {@template flutter_typeahead.SuggestionsList.itemSeparatorBuilder}
  /// Optional builder function to add separators between suggestions.
  ///
  /// Example usage:
  /// ```dart
  /// itemSeparatorBuilder: (context, index) => Divider(),
  /// ```
  ///
  /// Equivalent to [ListView.separated.separatorBuilder].
  /// This is only used when [listBuilder] is not specified.
  /// {@endtemplate}
  final IndexedWidgetBuilder? itemSeparatorBuilder;

  /// {@template flutter_typeahead.SuggestionsList.listBuilder}
  /// Optional builder function to customize the suggestions list.
  ///
  /// Example usage:
  /// ```dart
  /// listBuilder: (context, children) => GridView.count(
  ///   controller: scrollContoller,
  ///   crossAxisCount: 2,
  ///   crossAxisSpacing: 8,
  ///   mainAxisSpacing: 8,
  ///   shrinkWrap: true,
  ///   reverse: SuggestionsController.of<City>(context).effectiveDirection ==
  ///       AxisDirection.up,
  ///   children: children,
  /// ),
  /// ```
  /// {@endtemplate}
  final ListBuilder? listBuilder;

  @override
  State<SuggestionsList<T>> createState() => _SuggestionsListState<T>();
}

class _SuggestionsListState<T> extends State<SuggestionsList<T>> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        List<T>? suggestions = widget.controller.suggestions;
        bool retainOnLoading = widget.retainOnLoading ?? true;

        bool isError = widget.controller.hasError;
        bool isEmpty = suggestions?.isEmpty ?? false;
        bool isLoading = widget.controller.isLoading &&
            (suggestions == null || isEmpty || !retainOnLoading);

        if (isLoading) {
          if (widget.hideOnLoading ?? false) return const SizedBox();
          return widget.loadingBuilder(context);
        } else if (isError) {
          if (widget.hideOnError ?? false) return const SizedBox();
          return widget.errorBuilder(context, widget.controller.error!);
        } else if (isEmpty) {
          if (widget.hideOnEmpty ?? false) return const SizedBox();
          return widget.emptyBuilder(context);
        } else if (suggestions == null) {
          return const SizedBox();
        }

        if (widget.listBuilder != null) {
          return widget.listBuilder!(
            context,
            suggestions
                .map((suggestion) => widget.itemBuilder(context, suggestion))
                .toList(),
          );
        }

        return ListView.separated(
          // We cannot pass a controller, as we want to inherit it from
          // the PrimaryScrollController of the SuggestionsBox.
          // This happens automatically as long as we
          // dont pass a controller and pass either null or true for primary.
          controller: null,
          primary: null,
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          keyboardDismissBehavior: (widget.hideKeyboardOnDrag ?? false)
              ? ScrollViewKeyboardDismissBehavior.onDrag
              : ScrollViewKeyboardDismissBehavior.manual,
          reverse: widget.controller.effectiveDirection == VerticalDirection.up,
          itemCount: suggestions.length,
          itemBuilder: (context, index) =>
              widget.itemBuilder(context, suggestions[index]),
          separatorBuilder: (context, index) =>
              widget.itemSeparatorBuilder?.call(context, index) ??
              const SizedBox.shrink(),
        );
      },
    );
  }
}
