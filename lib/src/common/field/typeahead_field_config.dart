import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_box_controller.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_box_decoration.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/text_field_configuration.dart';
import 'package:flutter_typeahead/src/typedef.dart';

/// Base class to contain all the configuration parameters for the [TypeAheadField].
///
/// This class is used to ensure parameters are consistent between all subclasses.
abstract class TypeaheadFieldConfig<T> {
  /// Called with the search pattern to get the search suggestions.
  ///
  /// This callback must not be null. It is be called by the TypeAhead widget
  /// and provided with the search pattern. It should return a [List](https://api.dartlang.org/stable/2.0.0/dart-core/List-class.html)
  /// of suggestions either synchronously, or asynchronously (as the result of a
  /// [Future](https://api.dartlang.org/stable/dart-async/Future-class.html)).
  /// Typically, the list of suggestions should not contain more than 4 or 5
  /// entries. These entries will then be provided to [itemBuilder] to display
  /// the suggestions.
  ///
  /// Example:
  /// ```dart
  /// suggestionsCallback: (pattern) async {
  ///   return await _getSuggestions(pattern);
  /// }
  /// ```
  SuggestionsCallback<T> get suggestionsCallback;

  /// Called when a suggestion is tapped.
  ///
  /// This callback must not be null. It is called by the TypeAhead widget and
  /// provided with the value of the tapped suggestion.
  ///
  /// For example, you might want to navigate to a specific view when the user
  /// tabs a suggestion:
  /// ```dart
  /// onSuggestionSelected: (suggestion) {
  ///   Navigator.of(context).push(MaterialPageRoute(
  ///     builder: (context) => SearchResult(
  ///       searchItem: suggestion
  ///     )
  ///   ));
  /// }
  /// ```
  ///
  /// Or to set the value of the text field:
  /// ```dart
  /// onSuggestionSelected: (suggestion) {
  ///   _controller.text = suggestion['name'];
  /// }
  /// ```
  SuggestionSelectionCallback<T> get onSuggestionSelected;

  /// Called for each suggestion returned by [suggestionsCallback] to build the
  /// corresponding widget.
  ///
  /// This callback must not be null. It is called by the TypeAhead widget for
  /// each suggestion, and expected to build a widget to display this
  /// suggestion's info. For example:
  ///
  /// ```dart
  /// itemBuilder: (context, suggestion) {
  ///   return ListTile(
  ///     title: Text(suggestion['name']),
  ///     subtitle: Text('USD' + suggestion['price'].toString())
  ///   );
  /// }
  /// ```
  ItemBuilder<T> get itemBuilder;

  /// Item separator builder
  /// same as [ListView.separated.separatorBuilder]
  IndexedWidgetBuilder? get itemSeparatorBuilder;

  /// By default, we render the suggestions in a ListView, using
  /// the `itemBuilder` to construct each element of the list.  Specify
  /// your own `layoutArchitecture` if you want to be responsible
  /// for layinng out the widgets using some other system (like a grid).
  LayoutArchitecture? get layoutArchitecture;

  /// Used to control the scroll behavior of item-builder list
  ScrollController? get scrollController;

  /// Allows directly controlling the [SuggestionsBox],
  /// like opening and closing it programmatically.
  SuggestionsBoxController? get suggestionsBoxController;

  /// The decoration of the sheet that contains the suggestions.
  BaseSuggestionsBoxDecoration? get suggestionsBoxDecoration;

  /// The duration to wait after the user stops typing before calling
  /// [suggestionsCallback].
  ///
  /// This prevents making unnecessary calls to [suggestionsCallback] while the
  /// user is still typing.
  ///
  /// This is 300 milliseconds by default.
  /// If you wish to immediately get suggestions, use `Duration.zero`.
  Duration get debounceDuration;

  /// Called when waiting for [suggestionsCallback] to return.
  ///
  /// It is expected to return a widget to display while waiting.
  /// For example:
  /// ```dart
  /// (BuildContext context) {
  ///   return Text('Loading...');
  /// }
  /// ```
  ///
  /// If not specified, a [CircularProgressIndicator](https://docs.flutter.io/flutter/material/CircularProgressIndicator-class.html) is shown
  WidgetBuilder? get loadingBuilder;

  /// Called when [suggestionsCallback] returns an empty array.
  ///
  /// It is expected to return a widget to display when no suggestions are
  /// avaiable.
  /// For example:
  /// ```dart
  /// (BuildContext context) {
  ///   return Text('No Items Found!');
  /// }
  /// ```
  ///
  /// If not specified, a simple text is shown
  WidgetBuilder? get noItemsFoundBuilder;

  /// Called when [suggestionsCallback] throws an exception.
  ///
  /// It is called with the error object, and expected to return a widget to
  /// display when an exception is thrown
  /// For example:
  /// ```dart
  /// (BuildContext context, error) {
  ///   return Text('$error');
  /// }
  /// ```
  ///
  /// If not specified, the error is shown in [ThemeData.errorColor](https://docs.flutter.io/flutter/material/ThemeData/errorColor.html)
  ErrorBuilder? get errorBuilder;

  /// Used to overcome [Flutter issue 98507](https://github.com/flutter/flutter/issues/98507)
  /// Most commonly experienced when placing the [TypeAheadFormField] on a google map in Flutter Web.
  // TODO: this issue was marked fixed, test if this is still needed
  bool get intercepting;

  /// The configuration of the [TextField](https://docs.flutter.io/flutter/material/TextField-class.html)
  /// that the TypeAhead widget displays
  BaseTextFieldConfiguration get textFieldConfiguration;

  /// Called to display animations when [suggestionsCallback] returns suggestions
  ///
  /// It is provided with the suggestions box instance and the animation
  /// controller, and expected to return some animation that uses the controller
  /// to display the suggestion box.
  ///
  /// For example:
  /// ```dart
  /// transitionBuilder: (context, suggestionsBox, animationController) {
  ///   return FadeTransition(
  ///     child: suggestionsBox,
  ///     opacity: CurvedAnimation(
  ///       parent: animationController,
  ///       curve: Curves.fastOutSlowIn
  ///     ),
  ///   );
  /// }
  /// ```
  /// This argument is best used with [animationDuration] and [animationStart]
  /// to fully control the animation.
  ///
  /// To fully remove the animation, just return `suggestionsBox`
  ///
  /// If not specified, a [SizeTransition](https://docs.flutter.io/flutter/widgets/SizeTransition-class.html) is shown.
  AnimationTransitionBuilder? get transitionBuilder;

  /// The duration that [transitionBuilder] animation takes.
  ///
  /// This argument is best used with [transitionBuilder] and [animationStart]
  /// to fully control the animation.
  ///
  /// Defaults to 500 milliseconds.
  Duration get animationDuration;

  /// Determine the [SuggestionsBoxController]'s direction.
  ///
  /// If [AxisDirection.down], the [SuggestionsBoxController] will be below the [TextField]
  /// and the [_SuggestionsList] will grow **down**.
  ///
  /// If [AxisDirection.up], the [SuggestionsBoxController] will be above the [TextField]
  /// and the [_SuggestionsList] will grow **up**.
  ///
  /// [AxisDirection.left] and [AxisDirection.right] are not allowed.
  AxisDirection get direction;

  /// The value at which the [transitionBuilder] animation starts.
  ///
  /// This argument is best used with [transitionBuilder] and [animationDuration]
  /// to fully control the animation.
  ///
  /// Defaults to 0.25.
  double get animationStart;

  /// How far below the text field should the suggestions box be
  ///
  /// Defaults to 5.
  double get suggestionsBoxVerticalOffset;

  /// If set to true, no loading box will be shown while suggestions are
  /// being fetched. [loadingBuilder] will also be ignored.
  ///
  /// Defaults to false.
  bool get hideOnLoading;

  /// If set to true, nothing will be shown if there are no results.
  /// [noItemsFoundBuilder] will also be ignored.
  ///
  /// Defaults to false.
  bool get hideOnEmpty;

  /// If set to true, nothing will be shown if there is an error.
  /// [errorBuilder] will also be ignored.
  ///
  /// Defaults to false.
  bool get hideOnError;

  /// If set to false, the suggestions box will stay opened after
  /// the keyboard is closed.
  ///
  /// Defaults to true.
  bool get hideSuggestionsOnKeyboardHide;

  /// If set to false, the suggestions box will show a circular
  /// progress indicator when retrieving suggestions.
  ///
  /// Defaults to true.
  bool get keepSuggestionsOnLoading;

  /// If set to true, the suggestions box will remain opened even after
  /// selecting a suggestion.
  ///
  /// Note that if this is enabled, the only way
  /// to close the suggestions box is either manually via the
  /// `SuggestionsBoxController` or when the user closes the software
  /// keyboard if `hideSuggestionsOnKeyboardHide` is set to true. Users
  /// with a physical keyboard will be unable to close the
  /// box without a manual way via `SuggestionsBoxController`.
  ///
  /// Defaults to false.
  bool get keepSuggestionsOnSuggestionSelected;

  /// If set to true, in the case where the suggestions box has less than
  /// _SuggestionsBoxController.minOverlaySpace to grow in the desired [direction], the direction axis
  /// will be temporarily flipped if there's more room available in the opposite
  /// direction.
  ///
  /// Defaults to false.
  bool get autoFlipDirection;

  /// If set to false, suggestion list will not be reversed according to the
  /// [autoFlipDirection] property.
  ///
  /// Defaults to true.
  bool get autoFlipListDirection;

  /// Minimum height below [autoFlipDirection] is triggered
  ///
  /// Defaults to 64.
  double get autoFlipMinHeight;

  /// The minimum number of characters which must be entered before
  /// [suggestionsCallback] is triggered.
  ///
  /// Defaults to 0.
  int get minCharsForSuggestions;

  /// If set to true and if the user scrolls through the suggestion list, hide the keyboard automatically.
  /// If set to false, the keyboard remains visible.
  /// Throws an exception, if hideKeyboardOnDrag and hideSuggestionsOnKeyboardHide are both set to true as
  /// they are mutual exclusive.
  ///
  /// Defaults to false.
  bool get hideKeyboardOnDrag;

  /// Allows a bypass of a problem on Flutter 3.7+ with the accessibility through Overlay
  /// that prevents flutter_typeahead to register a click on the list of suggestions properly.
  ///
  /// Defaults to false.
  bool get ignoreAccessibleNavigation;
}
