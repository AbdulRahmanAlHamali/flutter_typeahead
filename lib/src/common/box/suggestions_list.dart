import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/src/common/base/suggestions_controller.dart';
import 'package:flutter_typeahead/src/common/base/typedef.dart';

/// A widget that shows a list of suggestions based on user input.
class SuggestionsList<T> extends StatefulWidget {
  const SuggestionsList({
    super.key,
    required this.controller,
    this.keepSuggestionsOnLoading,
    this.hideKeyboardOnDrag,
    this.hideOnLoading,
    this.hideOnError,
    this.hideOnEmpty,
    required this.loadingBuilder,
    required this.errorBuilder,
    required this.emptyBuilder,
    required this.itemBuilder,
    this.wrapperBuilder,
    this.itemSeparatorBuilder,
    this.autoFlipListDirection,
  });

  /// {@macro flutter_typeahead.SuggestionsBox.controller}
  final SuggestionsController<T> controller;

  /// {@template flutter_typeahead.SuggestionsList.keepSuggestionsOnLoading}
  /// Whether to keep the previous suggestions visible even during loading.
  ///
  /// If enabled, [loadingBuilder] will be ignored.
  ///
  /// Defaults to `true`.
  /// {@endtemplate}
  final bool? keepSuggestionsOnLoading;

  /// {@template flutter_typeahead.SuggestionsList.hideKeyboardOnDrag}
  /// Whether the keyboard should be hidden when the user scrolls the suggestions list.
  ///
  /// Cannot be used together with [hideSuggestionsOnKeyboardHide].
  ///
  /// Defaults to false.
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

  //// {@template flutter_typeahead.SuggestionsList.errorBuilder}
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
  final Widget Function(BuildContext context, Object? error) errorBuilder;

  /// {@template flutter_typeahead.SuggestionsList.emptyBuilder}
  /// Builds the widget for when the suggestions list is empty.
  ///
  /// Example usage:
  /// ```dart
  /// noItemsFoundBuilder: (context) => Text('No Items Found!'),
  /// ```
  /// {@endtemplate}
  final WidgetBuilder emptyBuilder;

  /// {@template flutter_typeahead.SuggestionsListConfig.itemBuilder}
  /// Called for each suggestion to build the corresponding widget.
  ///
  /// Example usage:
  /// ```dart
  /// itemBuilder: (context, suggestion) {
  ///   return ListTile(
  ///     title: Text(suggestion.name),
  ///     subtitle: Text('\$${suggestion.price}')
  ///   );
  /// }
  /// ```
  /// {@endtemplate}
  final ItemBuilder<T> itemBuilder;

  /// {@template flutter_typeahead.SuggestionsList.itemSeparatorBuilder}
  /// Optional builder function to add separators between suggestions.
  ///
  /// Example usage:
  /// ```dart
  /// itemSeparatorBuilder: (context, index) => Divider(),
  /// ```
  ///
  /// Equivalent to [ListView.separated.separatorBuilder].
  /// {@endtemplate}
  final ItemBuilder<int>? itemSeparatorBuilder;

  /// {@template flutter_typeahead.SuggestionsList.wrapperBuilder}
  /// Optional builder function to wrap the suggestions list.
  ///
  /// Example usage:
  /// ```dart
  /// wrapperBuilder: (context, child) {
  ///   return Container(
  ///     color: Colors.red,
  ///     child: child,
  ///   );
  /// }
  /// ```
  /// {@endtemplate}
  final Widget Function(BuildContext context, Widget child)? wrapperBuilder;

  /// {@template flutter_typeahead.SuggestionsList.autoFlipListDirection}
  /// Whether the suggestions list should be reversed if the suggestions box is flipped.
  ///
  /// Defaults to true.
  /// {@endtemplate}
  final bool? autoFlipListDirection;

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

        bool isLoading = widget.controller.isLoading &&
            (widget.keepSuggestionsOnLoading ?? true);
        bool isError = widget.controller.hasError;
        bool isEmpty = suggestions == null || suggestions.isEmpty;

        if (isLoading) {
          if (widget.hideOnLoading ?? false) return const SizedBox();
          return widget.loadingBuilder(context);
        } else if (isError) {
          if (widget.hideOnError ?? false) return const SizedBox();
          return widget.errorBuilder(context, widget.controller.error!);
        } else if (isEmpty) {
          if (widget.hideOnEmpty ?? false) return const SizedBox();
          return widget.emptyBuilder(context);
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
          reverse: widget.controller.effectiveDirection == AxisDirection.up
              ? (widget.autoFlipListDirection ?? true)
              : false,
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
