import 'dart:async';
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_typeahead/src/cupertino/field/cupertino_text_field_configuration.dart';
import 'package:flutter_typeahead/src/cupertino/suggestions_box/cupertino_suggestions_box.dart';
import 'package:flutter_typeahead/src/cupertino/suggestions_box/cupertino_suggestions_box_controller.dart';
import 'package:flutter_typeahead/src/cupertino/suggestions_box/cupertino_suggestions_box_decoration.dart';
import 'package:flutter_typeahead/src/cupertino/suggestions_box/cupertino_suggestions_list.dart';
import 'package:flutter_typeahead/src/typedef.dart';
import 'package:flutter_typeahead/src/utils.dart';

/// A [CupertinoTextField](https://docs.flutter.io/flutter/cupertino/CupertinoTextField-class.html)
/// that displays a list of suggestions as the user types
///
/// See also:
///
/// * [TypeAheadFormField], a [FormField](https://docs.flutter.io/flutter/widgets/FormField-class.html)
/// implementation of [TypeAheadField] that allows the value to be saved,
/// validated, etc.
class CupertinoTypeAheadField<T> extends StatefulWidget {
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
  ///   return Padding(
  ///     padding: const EdgeInsets.all(4.0),
  ///     child: Text(
  ///       suggestion,
  ///     ),
  ///   );
  /// }
  /// ```
  final ItemBuilder<T> itemBuilder;

  /// The decoration of the material sheet that contains the suggestions.
  final CupertinoSuggestionsBoxDecoration suggestionsBoxDecoration;

  /// Used to control the `_SuggestionsBox`. Allows manual control to
  /// open, close, toggle, or resize the `_SuggestionsBox`.
  final CupertinoSuggestionsBoxController? suggestionsBoxController;

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
  /// If not specified, a [CupertinoActivityIndicator](https://docs.flutter.io/flutter/cupertino/CupertinoActivityIndicator-class.html) is shown
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
  final ErrorBuilder? errorBuilder;

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

  /// The configuration of the [CupertinoTextField](https://docs.flutter.io/flutter/cupertino/CupertinoTextField-class.html)
  /// that the TypeAhead widget displays
  final CupertinoTextFieldConfiguration textFieldConfiguration;

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

  /// Creates a [CupertinoTypeAheadField]
  CupertinoTypeAheadField({
    Key? key,
    required this.suggestionsCallback,
    required this.itemBuilder,
    required this.onSuggestionSelected,
    this.textFieldConfiguration = const CupertinoTextFieldConfiguration(),
    this.suggestionsBoxDecoration = const CupertinoSuggestionsBoxDecoration(),
    this.debounceDuration = const Duration(milliseconds: 300),
    this.suggestionsBoxController,
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
    this.minCharsForSuggestions = 0,
    this.hideKeyboardOnDrag = true,
  })  : assert(animationStart >= 0.0 && animationStart <= 1.0),
        assert(direction == AxisDirection.down || direction == AxisDirection.up),
        assert(minCharsForSuggestions >= 0),
        assert(!hideKeyboardOnDrag || hideKeyboardOnDrag && !hideSuggestionsOnKeyboardHide),
        super(key: key);

  @override
  _CupertinoTypeAheadFieldState<T> createState() => _CupertinoTypeAheadFieldState<T>();
}

class _CupertinoTypeAheadFieldState<T> extends State<CupertinoTypeAheadField<T>> with WidgetsBindingObserver {
  FocusNode? _focusNode;
  TextEditingController? _textEditingController;
  CupertinoSuggestionsBox? _suggestionsBox;

  TextEditingController? get _effectiveController => widget.textFieldConfiguration.controller ?? _textEditingController;

  FocusNode? get _effectiveFocusNode => widget.textFieldConfiguration.focusNode ?? _focusNode;
  late VoidCallback _focusNodeListener;

  final LayerLink _layerLink = LayerLink();

  // Timer that resizes the suggestion box on each tick. Only active when the user is scrolling.
  Timer? _resizeOnScrollTimer;

  // The rate at which the suggestion box will resize when the user is scrolling
  final Duration _resizeOnScrollRefreshRate = const Duration(milliseconds: 500);

  // Will have a value if the typeahead is inside a scrollable widget
  ScrollPosition? _scrollPosition;

  // Keyboard detection
  final Stream<bool>? _keyboardVisibility = (supportedPlatform) ? KeyboardVisibilityController().onChange : null;
  late StreamSubscription<bool>? _keyboardVisibilitySubscription;

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
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    if (widget.textFieldConfiguration.controller == null) {
      this._textEditingController = TextEditingController();
    }

    if (widget.textFieldConfiguration.focusNode == null) {
      this._focusNode = FocusNode();
    }

    this._suggestionsBox = CupertinoSuggestionsBox(
      context,
      widget.direction,
      widget.autoFlipDirection,
      widget.autoFlipListDirection,
    );

    widget.suggestionsBoxController?.suggestionsBox = this._suggestionsBox;
    widget.suggestionsBoxController?.effectiveFocusNode = this._effectiveFocusNode;

    this._focusNodeListener = () {
      if (_effectiveFocusNode!.hasFocus) {
        this._suggestionsBox!.open();
      } else {
        this._suggestionsBox!.close();
      }
    };

    this._effectiveFocusNode!.addListener(_focusNodeListener);

    // hide suggestions box on keyboard closed
    this._keyboardVisibilitySubscription = _keyboardVisibility?.listen((bool isVisible) {
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
      _resizeOnScrollTimer = Timer.periodic(_resizeOnScrollRefreshRate, (timer) {
        _suggestionsBox!.resize();
      });
    } else {
      // Scroll finished
      _suggestionsBox!.resize();
    }
  }

  void _initOverlayEntry() {
    this._suggestionsBox!.overlayEntry = OverlayEntry(builder: (context) {
      final suggestionsList = CupertinoSuggestionsList<T>(
        suggestionsBox: _suggestionsBox,
        decoration: widget.suggestionsBoxDecoration,
        debounceDuration: widget.debounceDuration,
        controller: this._effectiveController,
        loadingBuilder: widget.loadingBuilder,
        noItemsFoundBuilder: widget.noItemsFoundBuilder,
        errorBuilder: widget.errorBuilder,
        transitionBuilder: widget.transitionBuilder,
        suggestionsCallback: widget.suggestionsCallback,
        animationDuration: widget.animationDuration,
        animationStart: widget.animationStart,
        getImmediateSuggestions: widget.getImmediateSuggestions,
        onSuggestionSelected: (T selection) {
          if (!widget.keepSuggestionsOnSuggestionSelected) {
            this._effectiveFocusNode!.unfocus();
            this._suggestionsBox!.close();
          }
          widget.onSuggestionSelected(selection);
        },
        itemBuilder: widget.itemBuilder,
        direction: _suggestionsBox!.direction,
        hideOnLoading: widget.hideOnLoading,
        hideOnEmpty: widget.hideOnEmpty,
        hideOnError: widget.hideOnError,
        keepSuggestionsOnLoading: widget.keepSuggestionsOnLoading,
        minCharsForSuggestions: widget.minCharsForSuggestions,
        hideKeyboardOnDrag: widget.hideKeyboardOnDrag,
      );

      double w = _suggestionsBox!.textBoxWidth;
      if (widget.suggestionsBoxDecoration.constraints != null) {
        if (widget.suggestionsBoxDecoration.constraints!.minWidth != 0.0 &&
            widget.suggestionsBoxDecoration.constraints!.maxWidth != double.infinity) {
          w = (widget.suggestionsBoxDecoration.constraints!.minWidth +
                  widget.suggestionsBoxDecoration.constraints!.maxWidth) /
              2;
        } else if (widget.suggestionsBoxDecoration.constraints!.minWidth != 0.0 &&
            widget.suggestionsBoxDecoration.constraints!.minWidth > w) {
          w = widget.suggestionsBoxDecoration.constraints!.minWidth;
        } else if (widget.suggestionsBoxDecoration.constraints!.maxWidth != double.infinity &&
            widget.suggestionsBoxDecoration.constraints!.maxWidth < w) {
          w = widget.suggestionsBoxDecoration.constraints!.maxWidth;
        }
      }

      return Positioned(
        width: w,
        child: CompositedTransformFollower(
          link: this._layerLink,
          showWhenUnlinked: false,
          offset: Offset(
              widget.suggestionsBoxDecoration.offsetX,
              _suggestionsBox!.direction == AxisDirection.down
                  ? _suggestionsBox!.textBoxHeight + widget.suggestionsBoxVerticalOffset
                  : -widget.suggestionsBoxVerticalOffset),
          child: _suggestionsBox!.direction == AxisDirection.down
              ? suggestionsList
              : FractionalTranslation(
                  translation: Offset(0.0, -1.0), // visually flips list to go up
                  child: suggestionsList,
                ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: this._layerLink,
      child: CupertinoTextField(
        controller: this._effectiveController,
        focusNode: this._effectiveFocusNode,
        decoration: widget.textFieldConfiguration.decoration,
        padding: widget.textFieldConfiguration.padding,
        placeholder: widget.textFieldConfiguration.placeholder,
        prefix: widget.textFieldConfiguration.prefix,
        prefixMode: widget.textFieldConfiguration.prefixMode,
        suffix: widget.textFieldConfiguration.suffix,
        suffixMode: widget.textFieldConfiguration.suffixMode,
        clearButtonMode: widget.textFieldConfiguration.clearButtonMode,
        keyboardType: widget.textFieldConfiguration.keyboardType,
        textInputAction: widget.textFieldConfiguration.textInputAction,
        textCapitalization: widget.textFieldConfiguration.textCapitalization,
        style: widget.textFieldConfiguration.style,
        textAlign: widget.textFieldConfiguration.textAlign,
        autofocus: widget.textFieldConfiguration.autofocus,
        obscureText: widget.textFieldConfiguration.obscureText,
        autocorrect: widget.textFieldConfiguration.autocorrect,
        maxLines: widget.textFieldConfiguration.maxLines,
        minLines: widget.textFieldConfiguration.minLines,
        maxLength: widget.textFieldConfiguration.maxLength,
        maxLengthEnforcement: widget.textFieldConfiguration.maxLengthEnforcement,
        onChanged: widget.textFieldConfiguration.onChanged,
        onEditingComplete: widget.textFieldConfiguration.onEditingComplete,
        onTap: widget.textFieldConfiguration.onTap,
//         onTapOutside: (_){},
        onSubmitted: widget.textFieldConfiguration.onSubmitted,
        inputFormatters: widget.textFieldConfiguration.inputFormatters,
        enabled: widget.textFieldConfiguration.enabled,
        cursorWidth: widget.textFieldConfiguration.cursorWidth,
        cursorRadius: widget.textFieldConfiguration.cursorRadius,
        cursorColor: widget.textFieldConfiguration.cursorColor,
        keyboardAppearance: widget.textFieldConfiguration.keyboardAppearance,
        scrollPadding: widget.textFieldConfiguration.scrollPadding,
        enableInteractiveSelection: widget.textFieldConfiguration.enableInteractiveSelection,
      ),
    );
  }
}
