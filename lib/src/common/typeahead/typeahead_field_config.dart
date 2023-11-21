import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/src/common/base/suggestions_controller.dart';
import 'package:flutter_typeahead/src/common/base/types.dart';

/// Base class to contain all the configuration parameters for the [TypeAheadField].
///
/// This class is used to ensure parameters are consistent between all subclasses.
abstract interface class TypeaheadFieldConfig<T> {
  /// {@macro flutter_typeahead.SuggestionsSearch.textEditingController}
  TextEditingController? get controller;

  /// {@macro flutter_typeahead.SuggestionsField.focusNode}
  FocusNode? get focusNode;

  /// {@macro flutter_typeahead.SuggestionsBox.controller}
  SuggestionsController<T>? get suggestionsController;

  /// {@macro flutter_typeahead.SuggestionsField.onSelected}
  ValueSetter<T>? get onSelected;

  /// {@macro flutter_typeahead.SuggestionsField.direction}
  AxisDirection? get direction;

  /// {@macro flutter_typeahead.SuggestionsField.constraints}
  BoxConstraints? get constraints;

  /// {@macro flutter_typeahead.SuggestionsField.offset}
  Offset? get offset;

  /// {@macro flutter_typeahead.SuggestionsField.autoFlipDirection}
  bool get autoFlipDirection;

  /// {@macro flutter_typeahead.SuggestionsField.autoFlipMinHeight}
  double get autoFlipMinHeight;

  /// {@macro flutter_typeahead.SuggestionsField.hideOnUnfocus}
  bool get hideOnUnfocus;

  /// {@macro flutter_typeahead.SuggestionsField.hideOnSelect}
  bool get hideOnSelect;

  /// {@macro flutter_typeahead.SuggestionsField.hideWithKeyboard}
  bool get hideWithKeyboard;

  /// {@macro flutter_typeahead.SuggestionsBox.scrollController}
  ScrollController? get scrollController;

  /// {@macro flutter_typeahead.SuggestionsBox.transitionBuilder}
  AnimationTransitionBuilder? get transitionBuilder;

  /// {@macro flutter_typeahead.SuggestionsBox.animationDuration}
  Duration? get animationDuration;

  /// {@macro flutter_typeahead.SuggestionsSearch.suggestionsCallback}
  SuggestionsCallback<T> get suggestionsCallback;

  /// {@macro flutter_typeahead.SuggestionsList.keepSuggestionsOnLoading}
  bool? get keepSuggestionsOnLoading;

  /// {@macro flutter_typeahead.SuggestionsList.hideKeyboardOnDrag}
  bool? get hideKeyboardOnDrag;

  /// {@macro flutter_typeahead.SuggestionsList.hideOnLoading}
  bool? get hideOnLoading;

  /// {@macro flutter_typeahead.SuggestionsList.hideOnError}
  bool? get hideOnError;

  /// {@macro flutter_typeahead.SuggestionsList.hideOnEmpty}
  bool? get hideOnEmpty;

  /// {@macro flutter_typeahead.SuggestionsList.loadingBuilder}
  WidgetBuilder? get loadingBuilder;

  //// {@macro flutter_typeahead.SuggestionsList.errorBuilder}
  ErrorBuilder? get errorBuilder;

  /// {@macro flutter_typeahead.SuggestionsList.emptyBuilder}
  WidgetBuilder? get emptyBuilder;

  /// {@macro flutter_typeahead.SuggestionsListConfig.itemBuilder}
  ItemBuilder<T> get itemBuilder;

  /// {@macro flutter_typeahead.SuggestionsList.itemSeparatorBuilder}
  ItemBuilder<int>? get itemSeparatorBuilder;

  /// {@macro flutter_typeahead.SuggestionsBox.decorationBuilder}
  DecorationBuilder? get decorationBuilder;

  /// {@template flutter_typeahead.SuggestionsList.listBuilder}
  ListBuilder? get listBuilder;

  /// {@macro flutter_typeahead.SuggestionsList.autoFlipListDirection}
  bool? get autoFlipListDirection;

  /// {@macro flutter_typeahead.SuggestionsSearch.debounce}
  Duration? get debounceDuration;

  /// {@macro flutter_typeahead.SuggestionsSearch.minCharsForSuggestions}
  int? get minCharsForSuggestions;
}
