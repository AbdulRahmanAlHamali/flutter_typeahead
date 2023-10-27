import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_typeahead/src/material/field/text_field_configuration.dart';
import 'package:flutter_typeahead/src/keyboard_suggestion_selection_notifier.dart';
import 'package:flutter_typeahead/src/should_refresh_suggestion_focus_index_notifier.dart';
import 'package:flutter_typeahead/src/material/suggestions_box/suggestions_box.dart';
import 'package:flutter_typeahead/src/material/suggestions_box/suggestions_box_controller.dart';
import 'package:flutter_typeahead/src/material/suggestions_box/suggestions_box_decoration.dart';
import 'package:flutter_typeahead/src/material/suggestions_box/suggestions_list.dart';
import 'package:flutter_typeahead/src/typedef.dart';
import 'package:flutter_typeahead/src/utils.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

/// # Flutter TypeAhead
/// A TypeAhead widget for Flutter, where you can show suggestions to
/// users as they type
///
/// ## Features
/// * Shows suggestions in an overlay that floats on top of other widgets
/// * Allows you to specify what the suggestions will look like through a
/// builder function
/// * Allows you to specify what happens when the user taps a suggestion
/// * Accepts all the parameters that traditional TextFields accept, like
/// decoration, custom TextEditingController, text styling, etc.
/// * Provides two versions, a normal version and a [FormField](https://docs.flutter.io/flutter/widgets/FormField-class.html)
/// version that accepts validation, submitting, etc.
/// * Provides high customizability; you can customize the suggestion box decoration,
/// the loading bar, the animation, the debounce duration, etc.
///
/// ## Installation
/// See the [installation instructions on pub](https://pub.dartlang.org/packages/flutter_typeahead#-installing-tab-).
///
/// ## Usage examples
/// You can import the package with:
/// ```dart
/// import 'package:flutter_typeahead/flutter_typeahead.dart';
/// ```
///
/// and then use it as follows:
///
/// ### Example 1:
/// ```dart
/// TypeAheadField(
///   textFieldConfiguration: TextFieldConfiguration(
///     autofocus: true,
///     style: DefaultTextStyle.of(context).style.copyWith(
///       fontStyle: FontStyle.italic
///     ),
///     decoration: InputDecoration(
///       border: OutlineInputBorder()
///     )
///   ),
///   suggestionsCallback: (pattern) async {
///     return await BackendService.getSuggestions(pattern);
///   },
///   itemBuilder: (context, suggestion) {
///     return ListTile(
///       leading: Icon(Icons.shopping_cart),
///       title: Text(suggestion['name']),
///       subtitle: Text('\$${suggestion['price']}'),
///     );
///   },
///   onSuggestionSelected: (suggestion) {
///     Navigator.of(context).push(MaterialPageRoute(
///       builder: (context) => ProductPage(product: suggestion)
///     ));
///   },
/// )
/// ```
/// In the code above, the `textFieldConfiguration` property allows us to
/// configure the displayed `TextField` as we want. In this example, we are
/// configuring the `autofocus`, `style` and `decoration` properties.
///
/// The `suggestionsCallback` is called with the search string that the user
/// types, and is expected to return a `List` of data either synchronously or
/// asynchronously. In this example, we are calling an asynchronous function
/// called `BackendService.getSuggestions` which fetches the list of
/// suggestions.
///
/// The `itemBuilder` is called to build a widget for each suggestion.
/// In this example, we build a simple `ListTile` that shows the name and the
/// price of the item. Please note that you shouldn't provide an `onTap`
/// callback here. The TypeAhead widget takes care of that.
///
/// The `onSuggestionSelected` is a callback called when the user taps a
/// suggestion. In this example, when the user taps a
/// suggestion, we navigate to a page that shows us the information of the
/// tapped product.
///
/// ### Example 2:
/// Here's another example, where we use the TypeAheadFormField inside a `Form`:
/// ```dart
/// final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
/// final TextEditingController _typeAheadController = TextEditingController();
/// String _selectedCity;
/// ...
/// Form(
///   key: this._formKey,
///   child: Padding(
///     padding: EdgeInsets.all(32.0),
///     child: Column(
///       children: [
///         Text(
///           'What is your favorite city?'
///         ),
///         TypeAheadFormField(
///           textFieldConfiguration: TextFieldConfiguration(
///             controller: this._typeAheadController,
///             decoration: InputDecoration(
///               labelText: 'City'
///             )
///           ),
///           suggestionsCallback: (pattern) {
///             return CitiesService.getSuggestions(pattern);
///           },
///           itemBuilder: (context, suggestion) {
///             return ListTile(
///               title: Text(suggestion),
///             );
///           },
///           transitionBuilder: (context, suggestionsBox, controller) {
///             return suggestionsBox;
///           },
///           onSuggestionSelected: (suggestion) {
///             this._typeAheadController.text = suggestion;
///           },
///           validator: (value) {
///             if (value.isEmpty) {
///               return 'Please select a city';
///             }
///           },
///           onSaved: (value) => this._selectedCity = value,
///         ),
///         SizedBox(height: 10.0,),
///         RaisedButton(
///           child: Text('Submit'),
///           onPressed: () {
///             if (this._formKey.currentState.validate()) {
///               this._formKey.currentState.save();
///               Scaffold.of(context).showSnackBar(SnackBar(
///                 content: Text('Your Favorite City is ${this._selectedCity}')
///               ));
///             }
///           },
///         )
///       ],
///     ),
///   ),
/// )
/// ```
/// Here, we assign to the `controller` property of the `textFieldConfiguration`
/// a `TextEditingController` that we call `_typeAheadController`.
/// We use this controller in the `onSuggestionSelected` callback to set the
/// value of the `TextField` to the selected suggestion.
///
/// The `validator` callback can be used like any `FormField.validator`
/// function. In our example, it checks whether a value has been entered,
/// and displays an error message if not. The `onSaved` callback is used to
/// save the value of the field to the `_selectedCity` member variable.
///
/// The `transitionBuilder` allows us to customize the animation of the
/// suggestion box. In this example, we are returning the suggestionsBox
/// immediately, meaning that we don't want any animation.
///
/// ## Customizations
/// TypeAhead widgets consist of a TextField and a suggestion box that shows
/// as the user types. Both are highly customizable
///
/// ### Customizing the TextField
/// You can customize the text field using the `textFieldConfiguration` property.
/// You provide this property with an instance of `TextFieldConfiguration`,
/// which allows you to configure all the usual properties of `TextField`, like
/// `decoration`, `style`, `controller`, `focusNode`, `autofocus`, `enabled`,
/// etc.
///
/// ### Customizing the Suggestions Box
/// TypeAhead provides default configurations for the suggestions box. You can,
/// however, override most of them.
///
/// #### Customizing the loader, the error and the "no items found" message
/// You can use the [loadingBuilder], [errorBuilder] and [noItemsFoundBuilder] to
/// customize their corresponding widgets. For example, to show a custom error
/// widget:
/// ```dart
/// errorBuilder: (BuildContext context, Object error) =>
///   Text(
///     '$error',
///     style: TextStyle(
///       color: Theme.of(context).errorColor
///     )
///   )
/// ```
/// #### Customizing the animation
/// You can customize the suggestion box animation through 3 parameters: the
/// `animationDuration`, the `animationStart`, and the `transitionBuilder`.
///
/// The `animationDuration` specifies how long the animation should take, while the
/// `animationStart` specified what point (between 0.0 and 1.0) the animation
/// should start from. The `transitionBuilder` accepts the `suggestionsBox` and
/// `animationController` as parameters, and should return a widget that uses
/// the `animationController` to animate the display of the `suggestionsBox`.
/// For example:
/// ```dart
/// transitionBuilder: (context, suggestionsBox, animationController) =>
///   FadeTransition(
///     child: suggestionsBox,
///     opacity: CurvedAnimation(
///       parent: animationController,
///       curve: Curves.fastOutSlowIn
///     ),
///   )
/// ```
/// This uses [FadeTransition](https://docs.flutter.io/flutter/widgets/FadeTransition-class.html)
/// to fade the `suggestionsBox` into the view. Note how the
/// `animationController` was provided as the parent of the animation.
///
/// In order to fully remove the animation, `transitionBuilder` should simply
/// return the `suggestionsBox`. This callback could also be used to wrap the
/// `suggestionsBox` with any desired widgets, not necessarily for animation.
///
/// #### Customizing the debounce duration
/// The suggestions box does not fire for each character the user types. Instead,
/// we wait until the user is idle for a duration of time, and then call the
/// `suggestionsCallback`. The duration defaults to 300 milliseconds, but can be
/// configured using the `debounceDuration` parameter.
///
/// #### Customizing the offset of the suggestions box
/// By default, the suggestions box is displayed 5 pixels below the `TextField`.
/// You can change this by changing the `suggestionsBoxVerticalOffset` property.
///
/// #### Customizing the decoration of the suggestions box
/// You can also customize the decoration of the suggestions box using the
/// `suggestionsBoxDecoration` property. For example, to remove the elevation
/// of the suggestions box, you can write:
/// ```dart
/// suggestionsBoxDecoration: SuggestionsBoxDecoration(
///   elevation: 0.0
/// )
/// ```
/// A [FormField](https://docs.flutter.io/flutter/widgets/FormField-class.html)
/// implementation of [TypeAheadField], that allows the value to be saved,
/// validated, etc.
///
/// See also:
///
/// * [TypeAheadField], A [TextField](https://docs.flutter.io/flutter/material/TextField-class.html)
/// that displays a list of suggestions as the user types
class TypeAheadField<T> extends StatefulWidget {
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
  final SuggestionsCallback<T> suggestionsCallback;

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
  final SuggestionSelectionCallback<T> onSuggestionSelected;

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
  final ItemBuilder<T> itemBuilder;
  final IndexedWidgetBuilder? itemSeparatorBuilder;

  /// By default, we render the suggestions in a ListView, using
  /// the `itemBuilder` to construct each element of the list.  Specify
  /// your own `layoutArchitecture` if you want to be responsible
  /// for layinng out the widgets using some other system (like a grid).
  final LayoutArchitecture? layoutArchitecture;

  /// used to control the scroll behavior of item-builder list
  final ScrollController? scrollController;

  /// The decoration of the material sheet that contains the suggestions.
  ///
  /// If null, default decoration with an elevation of 4.0 is used
  ///

  final SuggestionsBoxDecoration suggestionsBoxDecoration;

  /// Used to control the `_SuggestionsBox`. Allows manual control to
  /// open, close, toggle, or resize the `_SuggestionsBox`.
  final SuggestionsBoxController? suggestionsBoxController;

  /// The duration to wait after the user stops typing before calling
  /// [suggestionsCallback]
  ///
  /// This is useful, because, if not set, a request for suggestions will be
  /// sent for every character that the user types.
  ///
  /// This duration is set by default to 300 milliseconds
  final Duration debounceDuration;

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
  final WidgetBuilder? loadingBuilder;

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
  final WidgetBuilder? noItemsFoundBuilder;

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
  final ErrorBuilder? errorBuilder;

  /// Used to overcome [Flutter issue 98507](https://github.com/flutter/flutter/issues/98507)
  /// Most commonly experienced when placing the [TypeAheadFormField] on a google map in Flutter Web.
  final bool intercepting;

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
  final AnimationTransitionBuilder? transitionBuilder;

  /// The duration that [transitionBuilder] animation takes.
  ///
  /// This argument is best used with [transitionBuilder] and [animationStart]
  /// to fully control the animation.
  ///
  /// Defaults to 500 milliseconds.
  final Duration animationDuration;

  /// Determine the [SuggestionBox]'s direction.
  ///
  /// If [AxisDirection.down], the [SuggestionBox] will be below the [TextField]
  /// and the [_SuggestionsList] will grow **down**.
  ///
  /// If [AxisDirection.up], the [SuggestionBox] will be above the [TextField]
  /// and the [_SuggestionsList] will grow **up**.
  ///
  /// [AxisDirection.left] and [AxisDirection.right] are not allowed.
  final AxisDirection direction;

  /// The value at which the [transitionBuilder] animation starts.
  ///
  /// This argument is best used with [transitionBuilder] and [animationDuration]
  /// to fully control the animation.
  ///
  /// Defaults to 0.25.
  final double animationStart;

  /// The configuration of the [TextField](https://docs.flutter.io/flutter/material/TextField-class.html)
  /// that the TypeAhead widget displays
  final TextFieldConfiguration textFieldConfiguration;

  /// How far below the text field should the suggestions box be
  ///
  /// Defaults to 5.0
  final double suggestionsBoxVerticalOffset;

  /// If set to true, suggestions will be fetched immediately when the field is
  /// added to the view.
  ///
  /// But the suggestions box will only be shown when the field receives focus.
  /// To make the field receive focus immediately, you can set the `autofocus`
  /// property in the [textFieldConfiguration] to true
  ///
  /// Defaults to false
  final bool getImmediateSuggestions;

  /// If set to true, no loading box will be shown while suggestions are
  /// being fetched. [loadingBuilder] will also be ignored.
  ///
  /// Defaults to false.
  final bool hideOnLoading;

  /// If set to true, nothing will be shown if there are no results.
  /// [noItemsFoundBuilder] will also be ignored.
  ///
  /// Defaults to false.
  final bool hideOnEmpty;

  /// If set to true, nothing will be shown if there is an error.
  /// [errorBuilder] will also be ignored.
  ///
  /// Defaults to false.
  final bool hideOnError;

  /// If set to false, the suggestions box will stay opened after
  /// the keyboard is closed.
  ///
  /// Defaults to true.
  final bool hideSuggestionsOnKeyboardHide;

  /// If set to false, the suggestions box will show a circular
  /// progress indicator when retrieving suggestions.
  ///
  /// Defaults to true.
  final bool keepSuggestionsOnLoading;

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
  final bool keepSuggestionsOnSuggestionSelected;

  /// If set to true, in the case where the suggestions box has less than
  /// _SuggestionsBoxController.minOverlaySpace to grow in the desired [direction], the direction axis
  /// will be temporarily flipped if there's more room available in the opposite
  /// direction.
  ///
  /// Defaults to false
  final bool autoFlipDirection;

  /// If set to false, suggestion list will not be reversed according to the
  /// [autoFlipDirection] property.
  ///
  /// Defaults to true.
  final bool autoFlipListDirection;

  /// Minimum height below [autoFlipDirection] is triggered
  ///
  /// Defaults to 64.0.
  final double autoFlipMinHeight;

  final bool hideKeyboard;

  /// The minimum number of characters which must be entered before
  /// [suggestionsCallback] is triggered.
  ///
  /// Defaults to 0.
  final int minCharsForSuggestions;

  /// If set to true and if the user scrolls through the suggestion list, hide the keyboard automatically.
  /// If set to false, the keyboard remains visible.
  /// Throws an exception, if hideKeyboardOnDrag and hideSuggestionsOnKeyboardHide are both set to true as
  /// they are mutual exclusive.
  ///
  /// Defaults to false
  final bool hideKeyboardOnDrag;

  /// Allows a bypass of a problem on Flutter 3.7+ with the accessibility through Overlay
  /// that prevents flutter_typeahead to register a click on the list of suggestions properly.
  ///
  /// Defaults to false
  final bool ignoreAccessibleNavigation;

  // Adds a callback for the suggestion box opening or closing
  final void Function(bool)? onSuggestionsBoxToggle;

  /// Creates a [TypeAheadField]
  const TypeAheadField({
    required this.suggestionsCallback,
    required this.itemBuilder,
    this.itemSeparatorBuilder,
    this.layoutArchitecture,
    this.intercepting = false,
    required this.onSuggestionSelected,
    this.textFieldConfiguration = const TextFieldConfiguration(),
    this.suggestionsBoxDecoration = const SuggestionsBoxDecoration(),
    this.debounceDuration = const Duration(milliseconds: 300),
    this.suggestionsBoxController,
    this.scrollController,
    this.loadingBuilder,
    this.noItemsFoundBuilder,
    this.errorBuilder,
    this.transitionBuilder,
    this.animationStart = 0.25,
    this.animationDuration = const Duration(milliseconds: 500),
    this.getImmediateSuggestions = false,
    this.suggestionsBoxVerticalOffset = 5.0,
    this.direction = AxisDirection.down,
    this.hideOnLoading = false,
    this.hideOnEmpty = false,
    this.hideOnError = false,
    this.hideSuggestionsOnKeyboardHide = true,
    this.keepSuggestionsOnLoading = true,
    this.keepSuggestionsOnSuggestionSelected = false,
    this.autoFlipDirection = false,
    this.autoFlipListDirection = true,
    this.autoFlipMinHeight = 64.0,
    this.hideKeyboard = false,
    this.minCharsForSuggestions = 0,
    this.onSuggestionsBoxToggle,
    this.hideKeyboardOnDrag = false,
    this.ignoreAccessibleNavigation = false,
    super.key,
  })  : assert(animationStart >= 0.0 && animationStart <= 1.0),
        assert(
            direction == AxisDirection.down || direction == AxisDirection.up),
        assert(minCharsForSuggestions >= 0),
        assert(!hideKeyboardOnDrag ||
            hideKeyboardOnDrag && !hideSuggestionsOnKeyboardHide);

  @override
  State<TypeAheadField<T>> createState() => _TypeAheadFieldState<T>();
}

class _TypeAheadFieldState<T> extends State<TypeAheadField<T>>
    with WidgetsBindingObserver {
  FocusNode? _focusNode;
  final KeyboardSuggestionSelectionNotifier
      _keyboardSuggestionSelectionNotifier =
      KeyboardSuggestionSelectionNotifier();
  TextEditingController? _textEditingController;
  SuggestionsBox? _suggestionsBox;

  TextEditingController? get _effectiveController =>
      widget.textFieldConfiguration.controller ?? _textEditingController;
  FocusNode? get _effectiveFocusNode =>
      widget.textFieldConfiguration.focusNode ?? _focusNode;
  late VoidCallback _focusNodeListener;

  final LayerLink _layerLink = LayerLink();

  // Timer that resizes the suggestion box on each tick. Only active when the user is scrolling.
  Timer? _resizeOnScrollTimer;
  // The rate at which the suggestion box will resize when the user is scrolling
  final Duration _resizeOnScrollRefreshRate = const Duration(milliseconds: 500);
  // Will have a value if the typeahead is inside a scrollable widget
  ScrollPosition? _scrollPosition;

  // Keyboard detection
  final Stream<bool>? _keyboardVisibility =
      (supportedPlatform) ? KeyboardVisibilityController().onChange : null;
  late StreamSubscription<bool>? _keyboardVisibilitySubscription;

  bool _areSuggestionsFocused = false;
  late final _shouldRefreshSuggestionsFocusIndex =
      ShouldRefreshSuggestionFocusIndexNotifier(
          textFieldFocusNode: _effectiveFocusNode);

  @override
  void didChangeMetrics() {
    // Catch keyboard event and orientation change; resize suggestions list
    this._suggestionsBox!.onChangeMetrics();
  }

  @override
  void dispose() {
    this._suggestionsBox!.close();
    this._suggestionsBox!.widgetMounted = false;
    WidgetsBinding.instance.removeObserver(this);
    _keyboardVisibilitySubscription?.cancel();
    _effectiveFocusNode!.removeListener(_focusNodeListener);
    _focusNode?.dispose();
    _resizeOnScrollTimer?.cancel();
    _scrollPosition?.removeListener(_scrollResizeListener);
    _textEditingController?.dispose();
    _keyboardSuggestionSelectionNotifier.dispose();
    super.dispose();
  }

  KeyEventResult _onKeyEvent(FocusNode _, RawKeyEvent event) {
    if (event.isKeyPressed(LogicalKeyboardKey.arrowUp) ||
        event.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
      // do nothing to avoid puzzling users until keyboard arrow nav is implemented
    } else {
      _keyboardSuggestionSelectionNotifier.onKeyboardEvent(event);
    }
    return KeyEventResult.ignored;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    if (widget.textFieldConfiguration.controller == null) {
      this._textEditingController = TextEditingController();
    }

    final textFieldConfigurationFocusNode =
        widget.textFieldConfiguration.focusNode;
    if (textFieldConfigurationFocusNode == null) {
      this._focusNode = FocusNode(onKey: _onKeyEvent);
    } else if (textFieldConfigurationFocusNode.onKey == null) {
      // * we add the _onKeyEvent callback to the textFieldConfiguration focusNode
      textFieldConfigurationFocusNode.onKey = ((node, event) {
        final keyEventResult = _onKeyEvent(node, event);
        return keyEventResult;
      });
    } else {
      final onKeyCopy = textFieldConfigurationFocusNode.onKey!;
      textFieldConfigurationFocusNode.onKey = ((node, event) {
        _onKeyEvent(node, event);
        return onKeyCopy(node, event);
      });
    }

    this._suggestionsBox = SuggestionsBox(
      context,
      widget.direction,
      widget.autoFlipDirection,
      widget.autoFlipListDirection,
      widget.autoFlipMinHeight,
    );

    widget.suggestionsBoxController?.suggestionsBox = this._suggestionsBox;
    widget.suggestionsBoxController?.effectiveFocusNode =
        this._effectiveFocusNode;

    this._focusNodeListener = () {
      if (_effectiveFocusNode!.hasFocus) {
        this._suggestionsBox!.open();
      } else if (!_areSuggestionsFocused) {
        if (widget.hideSuggestionsOnKeyboardHide) {
          this._suggestionsBox!.close();
        }
      }

      widget.onSuggestionsBoxToggle?.call(this._suggestionsBox!.isOpened);
    };

    this._effectiveFocusNode!.addListener(_focusNodeListener);

    // hide suggestions box on keyboard closed
    this._keyboardVisibilitySubscription =
        _keyboardVisibility?.listen((isVisible) {
      if (widget.hideSuggestionsOnKeyboardHide && !isVisible) {
        _effectiveFocusNode!.unfocus();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((duration) {
      if (mounted) {
        this._initOverlayEntry();
        // calculate initial suggestions list size
        this._suggestionsBox!.resize();

        // in case we already missed the focus event
        if (this._effectiveFocusNode!.hasFocus) {
          this._suggestionsBox!.open();
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final scrollableState = Scrollable.maybeOf(context);
    if (scrollableState != null) {
      // The TypeAheadField is inside a scrollable widget
      _scrollPosition = scrollableState.position;

      _scrollPosition!.removeListener(_scrollResizeListener);
      _scrollPosition!.isScrollingNotifier.addListener(_scrollResizeListener);
    }
  }

  void _scrollResizeListener() {
    bool isScrolling = _scrollPosition!.isScrollingNotifier.value;
    _resizeOnScrollTimer?.cancel();
    if (isScrolling) {
      // Scroll started
      _resizeOnScrollTimer =
          Timer.periodic(_resizeOnScrollRefreshRate, (timer) {
        _suggestionsBox!.resize();
      });
    } else {
      // Scroll finished
      _suggestionsBox!.resize();
    }
  }

  void _initOverlayEntry() {
    this._suggestionsBox!.overlayEntry = OverlayEntry(
      builder: (context) {
        void giveTextFieldFocus() {
          _effectiveFocusNode?.requestFocus();
          _areSuggestionsFocused = false;
        }

        void onSuggestionFocus() {
          if (!_areSuggestionsFocused) {
            _areSuggestionsFocused = true;
          }
        }

        final suggestionsList = SuggestionsList<T>(
          suggestionsBox: _suggestionsBox,
          decoration: widget.suggestionsBoxDecoration,
          debounceDuration: widget.debounceDuration,
          intercepting: widget.intercepting,
          controller: this._effectiveController,
          loadingBuilder: widget.loadingBuilder,
          scrollController: widget.scrollController,
          noItemsFoundBuilder: widget.noItemsFoundBuilder,
          errorBuilder: widget.errorBuilder,
          transitionBuilder: widget.transitionBuilder,
          suggestionsCallback: widget.suggestionsCallback,
          animationDuration: widget.animationDuration,
          animationStart: widget.animationStart,
          getImmediateSuggestions: widget.getImmediateSuggestions,
          onSuggestionSelected: (selection) {
            if (!widget.keepSuggestionsOnSuggestionSelected) {
              this._effectiveFocusNode!.unfocus();
              this._suggestionsBox!.close();
            }
            widget.onSuggestionSelected(selection);
          },
          itemBuilder: widget.itemBuilder,
          itemSeparatorBuilder: widget.itemSeparatorBuilder,
          layoutArchitecture: widget.layoutArchitecture,
          direction: _suggestionsBox!.direction,
          hideOnLoading: widget.hideOnLoading,
          hideOnEmpty: widget.hideOnEmpty,
          hideOnError: widget.hideOnError,
          keepSuggestionsOnLoading: widget.keepSuggestionsOnLoading,
          minCharsForSuggestions: widget.minCharsForSuggestions,
          keyboardSuggestionSelectionNotifier:
              _keyboardSuggestionSelectionNotifier,
          shouldRefreshSuggestionFocusIndexNotifier:
              _shouldRefreshSuggestionsFocusIndex,
          giveTextFieldFocus: giveTextFieldFocus,
          onSuggestionFocus: onSuggestionFocus,
          onKeyEvent: _onKeyEvent,
          hideKeyboardOnDrag: widget.hideKeyboardOnDrag,
        );

        double w = _suggestionsBox!.textBoxWidth;
        if (widget.suggestionsBoxDecoration.constraints != null) {
          if (widget.suggestionsBoxDecoration.constraints!.minWidth != 0.0 &&
              widget.suggestionsBoxDecoration.constraints!.maxWidth !=
                  double.infinity) {
            w = (widget.suggestionsBoxDecoration.constraints!.minWidth +
                    widget.suggestionsBoxDecoration.constraints!.maxWidth) /
                2;
          } else if (widget.suggestionsBoxDecoration.constraints!.minWidth !=
                  0.0 &&
              widget.suggestionsBoxDecoration.constraints!.minWidth > w) {
            w = widget.suggestionsBoxDecoration.constraints!.minWidth;
          } else if (widget.suggestionsBoxDecoration.constraints!.maxWidth !=
                  double.infinity &&
              widget.suggestionsBoxDecoration.constraints!.maxWidth < w) {
            w = widget.suggestionsBoxDecoration.constraints!.maxWidth;
          }
        }

        final Widget compositedFollower = CompositedTransformFollower(
          link: this._layerLink,
          showWhenUnlinked: false,
          offset: Offset(
              widget.suggestionsBoxDecoration.offsetX,
              _suggestionsBox!.direction == AxisDirection.down
                  ? _suggestionsBox!.textBoxHeight +
                      widget.suggestionsBoxVerticalOffset
                  : -widget.suggestionsBoxVerticalOffset),
          child: _suggestionsBox!.direction == AxisDirection.down
              ? suggestionsList
              : FractionalTranslation(
                  translation:
                      const Offset(0.0, -1.0), // visually flips list to go up
                  child: suggestionsList,
                ),
        );

        // When wrapped in the Positioned widget, the suggestions box widget
        // is placed before the Scaffold semantically. In order to have the
        // suggestions box navigable from the search input or keyboard,
        // Semantics > Align > ConstrainedBox are needed. This does not change
        // the style visually. However, when VO/TB are not enabled it is
        // necessary to use the Positioned widget to allow the elements to be
        // properly tappable.
        return MediaQuery.of(context).accessibleNavigation &&
                !widget.ignoreAccessibleNavigation
            ? Semantics(
                container: true,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: w),
                    child: compositedFollower,
                  ),
                ),
              )
            : Positioned(
                width: w,
                child: compositedFollower,
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: this._layerLink,
      child: PointerInterceptor(
        intercepting: widget.intercepting,
        child: TextField(
          focusNode: this._effectiveFocusNode,
          controller: this._effectiveController,
          decoration: widget.textFieldConfiguration.decoration,
          style: widget.textFieldConfiguration.style,
          textAlign: widget.textFieldConfiguration.textAlign,
          enabled: widget.textFieldConfiguration.enabled,
          keyboardType: widget.textFieldConfiguration.keyboardType,
          autofocus: widget.textFieldConfiguration.autofocus,
          inputFormatters: widget.textFieldConfiguration.inputFormatters,
          autocorrect: widget.textFieldConfiguration.autocorrect,
          expands: widget.textFieldConfiguration.expands,
          maxLines: widget.textFieldConfiguration.maxLines,
          textAlignVertical: widget.textFieldConfiguration.textAlignVertical,
          minLines: widget.textFieldConfiguration.minLines,
          maxLength: widget.textFieldConfiguration.maxLength,
          maxLengthEnforcement:
              widget.textFieldConfiguration.maxLengthEnforcement,
          obscureText: widget.textFieldConfiguration.obscureText,
          onChanged: widget.textFieldConfiguration.onChanged,
          onSubmitted: widget.textFieldConfiguration.onSubmitted,
          onEditingComplete: widget.textFieldConfiguration.onEditingComplete,
          onTap: widget.textFieldConfiguration.onTap,
          onTapOutside: widget.textFieldConfiguration.onTapOutside,
          scrollPadding: widget.textFieldConfiguration.scrollPadding,
          textInputAction: widget.textFieldConfiguration.textInputAction,
          textCapitalization: widget.textFieldConfiguration.textCapitalization,
          keyboardAppearance: widget.textFieldConfiguration.keyboardAppearance,
          cursorWidth: widget.textFieldConfiguration.cursorWidth,
          cursorRadius: widget.textFieldConfiguration.cursorRadius,
          cursorColor: widget.textFieldConfiguration.cursorColor,
          textDirection: widget.textFieldConfiguration.textDirection,
          enableInteractiveSelection:
              widget.textFieldConfiguration.enableInteractiveSelection,
          readOnly: widget.hideKeyboard,
          autofillHints: widget.textFieldConfiguration.autofillHints,
        ),
      ),
    );
  }
}
