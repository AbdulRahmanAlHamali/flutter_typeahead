import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_box_controller.dart';
import 'package:flutter_typeahead/src/typedef.dart';

/// Configuration for the suggestions list.
class SuggestionsListConfig<T> {
  SuggestionsListConfig({
    this.animationDuration,
    this.animationStart,
    required this.controller,
    this.debounceDuration,
    this.errorBuilder,
    this.hideKeyboardOnDrag = false,
    this.hideOnEmpty,
    this.hideOnError,
    this.hideOnLoading,
    required this.itemBuilder,
    this.itemSeparatorBuilder,
    this.intercepting = false,
    this.keepSuggestionsOnLoading,
    this.keepSuggestionsOnSelect,
    this.layoutArchitecture,
    this.loadingBuilder,
    this.minCharsForSuggestions,
    this.noItemsFoundBuilder,
    this.onSuggestionSelected,
    this.scrollController,
    required this.suggestionsBoxController,
    this.suggestionsCallback,
    this.transitionBuilder,
  });

  /// Duration of the animation for showing and hiding the suggestions box.
  final Duration? animationDuration;

  /// The starting point of the animation as a double between 0 and 1.
  final double? animationStart;

  /// Controller for the text field used for input.
  final TextEditingController controller;

  /// Duration to wait for changes in the text field before updating suggestions.
  final Duration? debounceDuration;

  /// Builder function for displaying errors.
  final ErrorBuilder? errorBuilder;

  /// Whether the keyboard should be hidden when the user drags the suggestions box.
  final bool hideKeyboardOnDrag;

  /// Whether the suggestions box should be hidden when no suggestions are available.
  final bool? hideOnEmpty;

  /// Whether the suggestions box should be hidden on error.
  final bool? hideOnError;

  /// Whether the suggestions box should be hidden during loading.
  final bool? hideOnLoading;

  /// Builder function to customize each item in the suggestions box.
  final ItemBuilder<T> itemBuilder;

  /// Optional builder function to add separators between suggestions.
  final IndexedWidgetBuilder? itemSeparatorBuilder;

  /// Whether touch interactions should be intercepted or not.
  final bool intercepting;

  /// Whether to keep the suggestions visible even during loading.
  final bool? keepSuggestionsOnLoading;

  /// Whether to keep the suggestions visible even after a suggestion has been selected.
  final bool? keepSuggestionsOnSelect;

  /// Enum to define the layout architecture for the widget.
  final LayoutArchitecture? layoutArchitecture;

  /// Builder function to display a loading indicator.
  final WidgetBuilder? loadingBuilder;

  /// Minimum number of characters required for showing suggestions.
  final int? minCharsForSuggestions;

  /// Builder function to display when no items are found.
  final WidgetBuilder? noItemsFoundBuilder;

  /// Callback for when a suggestion is selected.
  final SuggestionSelectionCallback<T>? onSuggestionSelected;

  /// Controller for the scroll view containing the suggestions.
  final ScrollController? scrollController;

  /// Controller to manage the state of the suggestions box.
  final SuggestionsBoxController suggestionsBoxController;

  /// Callback function to fetch suggestions.
  final SuggestionsCallback<T>? suggestionsCallback;

  /// Builder function for custom animation transitions.
  final AnimationTransitionBuilder? transitionBuilder;
}
