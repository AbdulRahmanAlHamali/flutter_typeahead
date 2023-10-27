import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_box_decoration.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_list_config.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/text_field_configuration.dart';
import 'package:flutter_typeahead/src/should_refresh_suggestion_focus_index_notifier.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

abstract class BaseTypeAheadField<T> extends StatefulWidget {
  const BaseTypeAheadField({
    required this.suggestionsCallback,
    required this.itemBuilder,
    this.itemSeparatorBuilder,
    this.layoutArchitecture,
    this.intercepting = false,
    required this.onSuggestionSelected,
    required this.textFieldConfiguration,
    this.debounceDuration = const Duration(milliseconds: 300),
    this.suggestionsBox,
    this.scrollController,
    this.loadingBuilder,
    this.noItemsFoundBuilder,
    this.errorBuilder,
    this.transitionBuilder,
    this.animationStart = 0.25,
    this.animationDuration = const Duration(milliseconds: 500),
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
        assert(minCharsForSuggestions >= 0),
        assert(!hideKeyboardOnDrag ||
            hideKeyboardOnDrag && !hideSuggestionsOnKeyboardHide);

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

  /// Item separator builder
  /// same as [ListView.separated.separatorBuilder]
  final IndexedWidgetBuilder? itemSeparatorBuilder;

  /// By default, we render the suggestions in a ListView, using
  /// the `itemBuilder` to construct each element of the list.  Specify
  /// your own `layoutArchitecture` if you want to be responsible
  /// for layinng out the widgets using some other system (like a grid).
  final LayoutArchitecture? layoutArchitecture;

  /// Used to control the scroll behavior of item-builder list
  final ScrollController? scrollController;

  /// The decoration of the sheet that contains the suggestions.
  BaseSuggestionsBoxDecoration? get suggestionsBoxDecoration;

  /// Allows directly controlling the suggestions box,
  /// like opening and closing it programmatically.
  final SuggestionsBox? suggestionsBox;

  /// The duration to wait after the user stops typing before calling
  /// [suggestionsCallback].
  ///
  /// This prevents making unnecessary calls to [suggestionsCallback] while the
  /// user is still typing.
  ///
  /// This is 300 milliseconds by default.
  /// If you wish to immediately get suggestions, use `Duration.zero`.
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

  /// Determine the [SuggestionsBox]'s direction.
  ///
  /// If [AxisDirection.down], the [SuggestionsBox] will be below the [TextField]
  /// and the [_SuggestionsList] will grow **down**.
  ///
  /// If [AxisDirection.up], the [SuggestionsBox] will be above the [TextField]
  /// and the [_SuggestionsList] will grow **up**.
  ///
  /// [AxisDirection.left] and [AxisDirection.right] are not allowed.
  ///
  /// This is ignored if [suggestionsBox] is provided.
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
  final BaseTextFieldConfiguration textFieldConfiguration;

  /// How far below the text field should the suggestions box be
  ///
  /// Defaults to 5.0
  final double suggestionsBoxVerticalOffset;

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
  ///
  /// This is ignored if [suggestionsBox] is provided.
  final bool autoFlipDirection;

  /// If set to false, suggestion list will not be reversed according to the
  /// [autoFlipDirection] property.
  ///
  /// Defaults to true.
  ///
  /// This is ignored if [suggestionsBox] is provided.
  final bool autoFlipListDirection;

  /// Minimum height below [autoFlipDirection] is triggered
  ///
  /// Defaults to 64.0.
  ///
  /// This is ignored if [suggestionsBox] is provided.
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

  Widget buildSuggestionsList(
      BuildContext context, SuggestionsListConfig<T> config);

  Widget buildTextField(
      BuildContext context, BaseTextFieldConfiguration config);

  @override
  State<BaseTypeAheadField<T>> createState() => _BaseTypeAheadFieldState<T>();
}

class _BaseTypeAheadFieldState<T> extends State<BaseTypeAheadField<T>>
    with WidgetsBindingObserver {
  late SuggestionsBox _suggestionsBox;

  late TextEditingController _textEditingController;

  late FocusNode _focusNode;

  final LayerLink _layerLink = LayerLink();

  // Timer that resizes the suggestion box on each tick. Only active when the user is scrolling.
  Timer? _resizeOnScrollTimer;
  // The rate at which the suggestion box will resize when the user is scrolling
  final Duration _resizeOnScrollRefreshRate = const Duration(milliseconds: 500);
  // Will have a value if the typeahead is inside a scrollable widget
  ScrollPosition? _scrollPosition;

  late StreamSubscription<bool>? _keyboardVisibilitySubscription;

  bool _areSuggestionsFocused = false;
  late final _shouldRefreshSuggestionsFocusIndex =
      ShouldRefreshSuggestionFocusIndexNotifier(textFieldFocusNode: _focusNode);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _suggestionsBox = widget.suggestionsBox ??
        SuggestionsBox(
          // These properties are only used if the suggestionsBox is not provided
          direction: widget.direction,
          autoFlipDirection: widget.autoFlipDirection,
          autoFlipListDirection: widget.autoFlipListDirection,
          autoFlipMinHeight: widget.autoFlipMinHeight,
        );

    _registerSuggestionsBox(_suggestionsBox);

    _textEditingController =
        widget.textFieldConfiguration.controller ?? TextEditingController();

    _focusNode = widget.textFieldConfiguration.focusNode ?? FocusNode();
    _registerFocusNode(_focusNode);

    _keyboardVisibilitySubscription = KeyboardVisibilityController()
        .onChange
        .listen(_onKeyboardVisibilityChanged);
  }

  @override
  void didUpdateWidget(covariant BaseTypeAheadField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_textEditingController != widget.textFieldConfiguration.controller) {
      if (oldWidget.textFieldConfiguration.controller == null) {
        _textEditingController.dispose();
      }
      _textEditingController =
          widget.textFieldConfiguration.controller ?? TextEditingController();
    }

    if (_focusNode != widget.textFieldConfiguration.focusNode) {
      _focusNode.removeListener(_onFocusChanged);
      if (oldWidget.textFieldConfiguration.focusNode == null) {
        _focusNode.dispose();
      }
      _focusNode = widget.textFieldConfiguration.focusNode ?? FocusNode();
      _registerFocusNode(_focusNode);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final scrollableState = Scrollable.maybeOf(context);
    _scrollPosition?.removeListener(_scrollResizeListener);
    _scrollPosition = scrollableState?.position;
    _scrollPosition?.isScrollingNotifier.addListener(_scrollResizeListener);
  }

  @override
  void didChangeMetrics() {
    // Catch keyboard event and orientation change; resize suggestions list
    _suggestionsBox.updateDimensions();
  }

  @override
  void dispose() {
    _suggestionsBox.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _keyboardVisibilitySubscription?.cancel();
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    _resizeOnScrollTimer?.cancel();
    _scrollPosition?.removeListener(_scrollResizeListener);
    _textEditingController.dispose();
    super.dispose();
  }

  /// Creates the overlay entry and show the suggestions box on the screen.
  void _registerSuggestionsBox(SuggestionsBox box) {
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      if (!mounted) return;
      _initOverlayEntry();
      box.resize();
      if (_focusNode.hasFocus) {
        box.open();
      }
    });
  }

  void _registerFocusNode(FocusNode focusNode) {
    var previousOnKey = focusNode.onKey;
    focusNode.onKey = ((node, event) {
      final keyEventResult = _suggestionsBox.onKeyEvent(node, event);
      return previousOnKey?.call(node, event) ?? keyEventResult;
    });

    _focusNode.addListener(_onFocusChanged);
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus) {
      _suggestionsBox.open();
    } else if (!_areSuggestionsFocused) {
      if (widget.hideSuggestionsOnKeyboardHide) {
        _suggestionsBox.close();
      }
    }

    widget.onSuggestionsBoxToggle?.call(_suggestionsBox.isOpen);
  }

  /// hide suggestions box on keyboard closed
  void _onKeyboardVisibilityChanged(bool visible) {
    if (!visible && widget.hideSuggestionsOnKeyboardHide) {
      _suggestionsBox.close();
    }
  }

  void _onSuggestionSelected(T selection) {
    if (!widget.keepSuggestionsOnSuggestionSelected) {
      _focusNode.unfocus();
      _suggestionsBox.close();
    }
    widget.onSuggestionSelected(selection);
  }

  void _scrollResizeListener() {
    bool isScrolling = _scrollPosition!.isScrollingNotifier.value;
    _resizeOnScrollTimer?.cancel();
    if (isScrolling) {
      // Scroll started
      _resizeOnScrollTimer = Timer.periodic(
          _resizeOnScrollRefreshRate, (_) => _suggestionsBox.resize());
    } else {
      // Scroll finished
      _suggestionsBox.resize();
    }
  }

  void _initOverlayEntry() {
    _suggestionsBox.attach(
      context: context,
      overlayEntry: OverlayEntry(
        builder: (context) {
          void giveTextFieldFocus() {
            _focusNode.requestFocus();
            _areSuggestionsFocused = false;
          }

          void onSuggestionFocus() {
            if (!_areSuggestionsFocused) {
              _areSuggestionsFocused = true;
            }
          }

          final suggestionsList = widget.buildSuggestionsList(
            context,
            SuggestionsListConfig(
              suggestionsBox: _suggestionsBox,
              debounceDuration: widget.debounceDuration,
              intercepting: widget.intercepting,
              controller: _textEditingController,
              loadingBuilder: widget.loadingBuilder,
              scrollController: widget.scrollController,
              noItemsFoundBuilder: widget.noItemsFoundBuilder,
              errorBuilder: widget.errorBuilder,
              transitionBuilder: widget.transitionBuilder,
              suggestionsCallback: widget.suggestionsCallback,
              animationDuration: widget.animationDuration,
              animationStart: widget.animationStart,
              onSuggestionSelected: _onSuggestionSelected,
              itemBuilder: widget.itemBuilder,
              itemSeparatorBuilder: widget.itemSeparatorBuilder,
              layoutArchitecture: widget.layoutArchitecture,
              hideOnLoading: widget.hideOnLoading,
              hideOnEmpty: widget.hideOnEmpty,
              hideOnError: widget.hideOnError,
              keepSuggestionsOnLoading: widget.keepSuggestionsOnLoading,
              minCharsForSuggestions: widget.minCharsForSuggestions,
              shouldRefreshSuggestionFocusIndexNotifier:
                  _shouldRefreshSuggestionsFocusIndex,
              giveTextFieldFocus: giveTextFieldFocus,
              onSuggestionFocus: onSuggestionFocus,
              hideKeyboardOnDrag: widget.hideKeyboardOnDrag,
            ),
          );

          double width = _suggestionsBox.width;
          BoxConstraints? constraints =
              widget.suggestionsBoxDecoration?.constraints;
          if (constraints != null) {
            if (constraints.minWidth != 0.0 &&
                constraints.maxWidth != double.infinity) {
              width = (constraints.minWidth + constraints.maxWidth) / 2;
            } else if (constraints.minWidth != 0.0 &&
                constraints.minWidth > width) {
              width = constraints.minWidth;
            } else if (constraints.maxWidth != double.infinity &&
                constraints.maxWidth < width) {
              width = constraints.maxWidth;
            }
          }

          final Widget compositedFollower = CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(
                widget.suggestionsBoxDecoration?.offsetX ?? 0.0,
                _suggestionsBox.direction == AxisDirection.down
                    ? _suggestionsBox.height +
                        widget.suggestionsBoxVerticalOffset
                    : -widget.suggestionsBoxVerticalOffset),
            child: _suggestionsBox.direction == AxisDirection.down
                ? suggestionsList
                : FractionalTranslation(
                    // visually flips list to go up
                    translation: const Offset(0, -1),
                    child: suggestionsList,
                  ),
          );

          bool accessibleNavigation =
              MediaQuery.of(context).accessibleNavigation;
          if (widget.ignoreAccessibleNavigation) {
            accessibleNavigation = false;
          }

          if (accessibleNavigation) {
            // When wrapped in the Positioned widget, the suggestions box widget
            // is placed before the Scaffold semantically. In order to have the
            // suggestions box navigable from the search input or keyboard,
            // Semantics > Align > ConstrainedBox are needed. This does not change
            // the style visually. However, when VO/TB are not enabled it is
            // necessary to use the Positioned widget to allow the elements to be
            // properly tappable.
            return Semantics(
              container: true,
              child: Align(
                alignment: Alignment.topLeft,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: width),
                  child: compositedFollower,
                ),
              ),
            );
          } else {
            return Positioned(
              width: width,
              child: compositedFollower,
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: PointerInterceptor(
        intercepting: widget.intercepting,
        child: widget.buildTextField(
          context,
          widget.textFieldConfiguration.copyWith(
            focusNode: _focusNode,
            controller: _textEditingController,
            readOnly: widget.hideKeyboard,
          ),
        ),
      ),
    );
  }
}
