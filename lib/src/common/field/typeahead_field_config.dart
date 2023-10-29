import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_box_controller.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_box_decoration.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/text_field_configuration.dart';
import 'package:flutter_typeahead/src/typedef.dart';

/// Base class to contain all the configuration parameters for the [TypeAheadField].
///
/// This class is used to ensure parameters are consistent between all subclasses.
abstract class TypeaheadFieldConfig<T> {
  /// {@macro flutter_typeahead.SuggestionsListConfig.suggestionsCallback}
  SuggestionsCallback<T> get suggestionsCallback;

  /// {@macro flutter_typeahead.SuggestionsListConfig.onSuggestionSelected}
  SuggestionSelectionCallback<T> get onSuggestionSelected;

  /// {@macro flutter_typeahead.SuggestionsListConfig.itemBuilder}
  ItemBuilder<T> get itemBuilder;

  /// {@macro flutter_typeahead.SuggestionsListConfig.itemSeparatorBuilder}
  IndexedWidgetBuilder? get itemSeparatorBuilder;

  /// {@macro flutter_typeahead.SuggestionsListConfig.layoutArchitecture}
  LayoutArchitecture? get layoutArchitecture;

  /// {@macro flutter_typeahead.SuggestionsListConfig.scrollController}
  ScrollController? get scrollController;

  /// {@macro flutter_typeahead.SuggestionsListConfig.suggestionsBox}
  SuggestionsBoxController? get suggestionsBoxController;

  /// The decoration of the sheet that contains the suggestions.
  BaseSuggestionsBoxDecoration get suggestionsBoxDecoration;

  /// {@macro flutter_typeahead.SuggestionsListConfig.debounce}
  Duration get debounceDuration;

  /// {@macro flutter_typeahead.SuggestionsListConfig.loadingBuilder}
  WidgetBuilder? get loadingBuilder;

  /// {@macro flutter_typeahead.SuggestionsListConfig.noItemsFoundBuilder}
  WidgetBuilder? get noItemsFoundBuilder;

  /// {@macro flutter_typeahead.SuggestionsListConfig.errorBuilder}
  ErrorBuilder? get errorBuilder;

  /// {@macro flutter_typeahead.SuggestionsListConfig.intercepting}
  bool get intercepting;

  /// The configuration of the [TextField](https://docs.flutter.io/flutter/material/TextField-class.html)
  /// that the TypeAhead widget displays.
  BaseTextFieldConfiguration get textFieldConfiguration;

  /// {@macro flutter_typeahead.SuggestionsListConfig.transitionBuilder}
  AnimationTransitionBuilder? get transitionBuilder;

  /// {@macro flutter_typeahead.SuggestionsListConfig.animationDuration}
  Duration get animationDuration;

  /// {@macro flutter_typeahead.SuggestionsBox.direction}
  AxisDirection get direction;

  /// {@macro flutter_typeahead.SuggestionsListConfig.animationStart}
  double get animationStart;

  /// {@macro flutter_typeahead.SuggestionsBox.verticalOffset}
  double get suggestionsBoxVerticalOffset;

  /// {@macro flutter_typeahead.SuggestionsListConfig.hideOnLoading}
  bool get hideOnLoading;

  /// {@macro flutter_typeahead.SuggestionsListConfig.hideOnEmpty}
  bool get hideOnEmpty;

  /// {@macro flutter_typeahead.SuggestionsListConfig.hideOnError}
  bool get hideOnError;

  /// {@macro flutter_typeahead.SuggestionsBox.hideOnUnfocus}
  bool get hideOnUnfocus;

  /// {@macro flutter_typeahead.SuggestionsListConfig.keepSuggestionsOnLoading}
  bool get keepSuggestionsOnLoading;

  /// {@macro flutter_typeahead.SuggestionsListConfig.keepSuggestionsOnSelect}
  bool get keepSuggestionsOnSelect;

  /// {@macro flutter_typeahead.SuggestionsBox.autoFlipDirection}
  bool get autoFlipDirection;

  /// {@macro flutter_typeahead.SuggestionsBox.autoFlipListDirection}
  bool get autoFlipListDirection;

  /// {@macro flutter_typeahead.SuggestionsBox.autoFlipMinHeight}
  double get autoFlipMinHeight;

  /// {@macro flutter_typeahead.SuggestionsListConfig.minCharsForSuggestions}
  int get minCharsForSuggestions;

  /// {@macro flutter_typeahead.SuggestionsListConfig.hideKeyboardOnDrag}
  bool get hideKeyboardOnDrag;

  /// Workaround for an Android OS issue with Flutter 3.7+ that causes the suggestions list
  /// to switch to accessibility mode incorrectly and therefore become unresponsive to gestures.
  ///
  /// This is device manifacturer specific. Note that enabling this will
  /// make the suggestions list non-accessible for users with accessibility needs.
  ///
  /// Defaults to false.
  bool get ignoreAccessibleNavigation;
}
