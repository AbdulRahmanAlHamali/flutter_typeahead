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
///       children: <Widget>[
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
library flutter_typeahead;

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef FutureOr<List<T>> SuggestionsCallback<T>(String pattern);
typedef Widget ItemBuilder<T>(BuildContext context, T itemData);
typedef void SuggestionSelectionCallback<T>(T suggestion);
typedef Widget ErrorBuilder(BuildContext context, Object error);
typedef AnimationTransitionBuilder(
    BuildContext context, Widget child, AnimationController controller);

/// A [FormField](https://docs.flutter.io/flutter/widgets/FormField-class.html)
/// implementation of [TypeAheadField], that allows the value to be saved,
/// validated, etc.
///
/// See also:
///
/// * [TypeAheadField], A [TextField](https://docs.flutter.io/flutter/material/TextField-class.html)
/// that displays a list of suggestions as the user types
class TypeAheadFormField<T> extends FormField<String> {
  /// The configuration of the [TextField](https://docs.flutter.io/flutter/material/TextField-class.html)
  /// that the TypeAhead widget displays
  final TextFieldConfiguration textFieldConfiguration;

  /// Creates a [TypeAheadFormField]
  TypeAheadFormField(
      {Key key,
      String initialValue,
      bool getImmediateSuggestions: false,
      bool autovalidate: false,
      FormFieldSetter<String> onSaved,
      FormFieldValidator<String> validator,
      ErrorBuilder errorBuilder,
      WidgetBuilder noItemsFoundBuilder,
      WidgetBuilder loadingBuilder,
      Duration debounceDuration: const Duration(milliseconds: 300),
      SuggestionsBoxDecoration suggestionsBoxDecoration:
          const SuggestionsBoxDecoration(),
      @required SuggestionSelectionCallback<T> onSuggestionSelected,
      @required ItemBuilder<T> itemBuilder,
      @required SuggestionsCallback<T> suggestionsCallback,
      double suggestionsBoxVerticalOffset: 5.0,
      this.textFieldConfiguration: const TextFieldConfiguration(),
      AnimationTransitionBuilder transitionBuilder,
      Duration animationDuration: const Duration(milliseconds: 500),
      double animationStart: 0.25,
      AxisDirection direction: AxisDirection.down,
      bool hideOnLoading: false,
      bool hideOnEmpty: false,
      bool hideOnError: false})
      : assert(
            initialValue == null || textFieldConfiguration.controller == null),
        super(
            key: key,
            onSaved: onSaved,
            validator: validator,
            autovalidate: autovalidate,
            initialValue: textFieldConfiguration.controller != null
                ? textFieldConfiguration.controller.text
                : (initialValue ?? ''),
            builder: (FormFieldState<String> field) {
              final _TypeAheadFormFieldState state = field;

              return TypeAheadField(
                getImmediateSuggestions: getImmediateSuggestions,
                transitionBuilder: transitionBuilder,
                errorBuilder: errorBuilder,
                noItemsFoundBuilder: noItemsFoundBuilder,
                loadingBuilder: loadingBuilder,
                debounceDuration: debounceDuration,
                suggestionsBoxDecoration: suggestionsBoxDecoration,
                textFieldConfiguration: textFieldConfiguration.copyWith(
                  decoration: textFieldConfiguration.decoration
                      .copyWith(errorText: state.errorText),
                  onChanged: state.didChange,
                  controller: state._effectiveController,
                ),
                suggestionsBoxVerticalOffset: suggestionsBoxVerticalOffset,
                onSuggestionSelected: onSuggestionSelected,
                itemBuilder: itemBuilder,
                suggestionsCallback: suggestionsCallback,
                animationStart: animationStart,
                animationDuration: animationDuration,
                direction: direction,
                hideOnLoading: hideOnLoading,
                hideOnEmpty: hideOnEmpty,
                hideOnError: hideOnError,
              );
            });

  @override
  _TypeAheadFormFieldState<T> createState() => _TypeAheadFormFieldState<T>();
}

class _TypeAheadFormFieldState<T> extends FormFieldState<String> {
  TextEditingController _controller;

  TextEditingController get _effectiveController =>
      widget.textFieldConfiguration.controller ?? _controller;

  @override
  TypeAheadFormField get widget => super.widget;

  @override
  void initState() {
    super.initState();
    if (widget.textFieldConfiguration.controller == null) {
      _controller = TextEditingController(text: widget.initialValue);
    } else {
      widget.textFieldConfiguration.controller
          .addListener(_handleControllerChanged);
    }
  }

  @override
  void didUpdateWidget(TypeAheadFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.textFieldConfiguration.controller !=
        oldWidget.textFieldConfiguration.controller) {
      oldWidget.textFieldConfiguration.controller
          ?.removeListener(_handleControllerChanged);
      widget.textFieldConfiguration.controller
          ?.addListener(_handleControllerChanged);

      if (oldWidget.textFieldConfiguration.controller != null &&
          widget.textFieldConfiguration.controller == null)
        _controller = TextEditingController.fromValue(
            oldWidget.textFieldConfiguration.controller.value);
      if (widget.textFieldConfiguration.controller != null) {
        setValue(widget.textFieldConfiguration.controller.text);
        if (oldWidget.textFieldConfiguration.controller == null)
          _controller = null;
      }
    }
  }

  @override
  void dispose() {
    widget.textFieldConfiguration.controller
        ?.removeListener(_handleControllerChanged);
    super.dispose();
  }

  @override
  void reset() {
    super.reset();
    setState(() {
      _effectiveController.text = widget.initialValue;
    });
  }

  void _handleControllerChanged() {
    // Suppress changes that originated from within this class.
    //
    // In the case where a controller has been passed in to this widget, we
    // register this change listener. In these cases, we'll also receive change
    // notifications for changes originating from within this class -- for
    // example, the reset() method. In such cases, the FormField value will
    // already have been set.
    if (_effectiveController.text != value)
      didChange(_effectiveController.text);
  }
}

/// A [TextField](https://docs.flutter.io/flutter/material/TextField-class.html)
/// that displays a list of suggestions as the user types
///
/// See also:
///
/// * [TypeAheadFormField], a [FormField](https://docs.flutter.io/flutter/widgets/FormField-class.html)
/// implementation of [TypeAheadField] that allows the value to be saved,
/// validated, etc.
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

  /// The decoration of the material sheet that contains the suggestions.
  ///
  /// If null, default decoration with an elevation of 4.0 is used
  final SuggestionsBoxDecoration suggestionsBoxDecoration;

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
  final WidgetBuilder loadingBuilder;

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
  final WidgetBuilder noItemsFoundBuilder;

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
  final ErrorBuilder errorBuilder;

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
  /// To fully remove the animation, just return `suggstionsBox`
  ///
  /// If not specified, a [SizeTransition](https://docs.flutter.io/flutter/widgets/SizeTransition-class.html) is shown.
  final AnimationTransitionBuilder transitionBuilder;

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

  /// Creates a [TypeAheadField]
  TypeAheadField(
      {Key key,
      @required this.suggestionsCallback,
      @required this.itemBuilder,
      @required this.onSuggestionSelected,
      this.textFieldConfiguration: const TextFieldConfiguration(),
      this.suggestionsBoxDecoration: const SuggestionsBoxDecoration(),
      this.debounceDuration: const Duration(milliseconds: 300),
      this.loadingBuilder,
      this.noItemsFoundBuilder,
      this.errorBuilder,
      this.transitionBuilder,
      this.animationStart: 0.25,
      this.animationDuration: const Duration(milliseconds: 500),
      this.getImmediateSuggestions: false,
      this.suggestionsBoxVerticalOffset: 5.0,
      this.direction: AxisDirection.down,
      this.hideOnLoading: false,
      this.hideOnEmpty: false,
      this.hideOnError: false})
      : assert(suggestionsCallback != null),
        assert(itemBuilder != null),
        assert(onSuggestionSelected != null),
        assert(animationStart != null &&
            animationStart >= 0.0 &&
            animationStart <= 1.0),
        assert(animationDuration != null),
        assert(debounceDuration != null),
        assert(textFieldConfiguration != null),
        assert(suggestionsBoxDecoration != null),
        assert(suggestionsBoxVerticalOffset != null),
        assert(
            direction == AxisDirection.down || direction == AxisDirection.up),
        super(key: key);

  @override
  _TypeAheadFieldState<T> createState() => _TypeAheadFieldState<T>();
}

class _TypeAheadFieldState<T> extends State<TypeAheadField<T>>
    with WidgetsBindingObserver {
  FocusNode _focusNode;
  TextEditingController _textEditingController;
  _SuggestionsBoxController _suggestionsBoxController;

  TextEditingController get _effectiveController =>
      widget.textFieldConfiguration.controller ?? _textEditingController;
  FocusNode get _effectiveFocusNode =>
      widget.textFieldConfiguration.focusNode ?? _focusNode;

  final LayerLink _layerLink = LayerLink();

  @override
  void didChangeMetrics() {
    // Catch keyboard event and orientation change; resize suggestions list
    this._suggestionsBoxController.onChangeMetrics();
  }

  @override
  void dispose() {
    this._suggestionsBoxController.widgetMounted = false;
    WidgetsBinding.instance.removeObserver(this);
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

    this._suggestionsBoxController =
        _SuggestionsBoxController(context, widget.direction);

    WidgetsBinding.instance.addPostFrameCallback((duration) async {
      await this._initOverlayEntry();
      // calculate initial suggestions list size
      this._suggestionsBoxController.resize();

      this._effectiveFocusNode.addListener(() {
        if (_effectiveFocusNode.hasFocus) {
          this._suggestionsBoxController.open();
        } else {
          this._suggestionsBoxController.close();
        }
      });

      // in case we already missed the focus event
      if (this._effectiveFocusNode.hasFocus) {
        this._suggestionsBoxController.open();
      }
    });
  }

  Future<void> _initOverlayEntry() async {
    RenderBox renderBox = context.findRenderObject();
    var size = renderBox.size;

    this._suggestionsBoxController._overlayEntry =
        OverlayEntry(builder: (context) {
      final suggestionsList = _SuggestionsList<T>(
        suggestionsBoxController: _suggestionsBoxController,
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
          this._effectiveFocusNode.unfocus();
          widget.onSuggestionSelected(selection);
        },
        itemBuilder: widget.itemBuilder,
        direction: widget.direction,
        hideOnLoading: widget.hideOnLoading,
        hideOnEmpty: widget.hideOnEmpty,
        hideOnError: widget.hideOnError,
      );

      return Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: this._layerLink,
          showWhenUnlinked: false,
          offset: Offset(
              0.0,
              widget.direction == AxisDirection.down
                  ? size.height + widget.suggestionsBoxVerticalOffset
                  : -widget.suggestionsBoxVerticalOffset),
          child: widget.direction == AxisDirection.down
              ? suggestionsList
              : FractionalTranslation(
                  translation:
                      Offset(0.0, -1.0), // visually flips list to go up
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
        maxLines: widget.textFieldConfiguration.maxLines,
        maxLength: widget.textFieldConfiguration.maxLength,
        maxLengthEnforced: widget.textFieldConfiguration.maxLengthEnforced,
        obscureText: widget.textFieldConfiguration.obscureText,
        onChanged: widget.textFieldConfiguration.onChanged,
        onSubmitted: widget.textFieldConfiguration.onSubmitted,
        onEditingComplete: widget.textFieldConfiguration.onEditingComplete,
        scrollPadding: widget.textFieldConfiguration.scrollPadding,
        textInputAction: widget.textFieldConfiguration.textInputAction,
        textCapitalization: widget.textFieldConfiguration.textCapitalization,
        keyboardAppearance: widget.textFieldConfiguration.keyboardAppearance,
        cursorWidth: widget.textFieldConfiguration.cursorWidth,
        cursorRadius: widget.textFieldConfiguration.cursorRadius,
        cursorColor: widget.textFieldConfiguration.cursorColor,
      ),
    );
  }
}

class _SuggestionsList<T> extends StatefulWidget {
  final _SuggestionsBoxController suggestionsBoxController;
  final TextEditingController controller;
  final bool getImmediateSuggestions;
  final SuggestionSelectionCallback<T> onSuggestionSelected;
  final SuggestionsCallback<T> suggestionsCallback;
  final ItemBuilder<T> itemBuilder;
  final SuggestionsBoxDecoration decoration;
  final Duration debounceDuration;
  final WidgetBuilder loadingBuilder;
  final WidgetBuilder noItemsFoundBuilder;
  final ErrorBuilder errorBuilder;
  final AnimationTransitionBuilder transitionBuilder;
  final Duration animationDuration;
  final double animationStart;
  final AxisDirection direction;
  final bool hideOnLoading;
  final bool hideOnEmpty;
  final bool hideOnError;

  _SuggestionsList({
    @required this.suggestionsBoxController,
    this.controller,
    this.getImmediateSuggestions: false,
    this.onSuggestionSelected,
    this.suggestionsCallback,
    this.itemBuilder,
    this.decoration,
    this.debounceDuration,
    this.loadingBuilder,
    this.noItemsFoundBuilder,
    this.errorBuilder,
    this.transitionBuilder,
    this.animationDuration,
    this.animationStart,
    this.direction,
    this.hideOnLoading,
    this.hideOnEmpty,
    this.hideOnError,
  });

  @override
  _SuggestionsListState<T> createState() => _SuggestionsListState<T>();
}

class _SuggestionsListState<T> extends State<_SuggestionsList<T>>
    with SingleTickerProviderStateMixin {
  List<T> _suggestions;
  VoidCallback _controllerListener;
  Timer _debounceTimer;
  bool _isLoading;
  Object _error;
  AnimationController _animationController;
  String _lastTextValue;
  Object _activeCallbackIdentity;

  @override
  void initState() {
    super.initState();

    this._animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    this._isLoading = false;
    this._lastTextValue = widget.controller.text;

    // If we started with some text, get suggestions immediately
    if (widget.controller.text.isNotEmpty || widget.getImmediateSuggestions) {
      this._getSuggestions();
    }

    this._controllerListener = () {
      // If we came here because of a change in selected text, not because of
      // actual change in text
      if (widget.controller.text == this._lastTextValue) return;

      this._lastTextValue = widget.controller.text;

      this._debounceTimer = Timer(widget.debounceDuration, () async {
        if (this._debounceTimer.isActive) return;

        // If already closed
        if (!this.mounted) return;

        await this._getSuggestions();
      });
    };

    widget.controller.addListener(this._controllerListener);
  }

  Future<void> _getSuggestions() async {
    setState(() {
      this._animationController.forward(from: 1.0);

      this._isLoading = true;
      this._error = null;
    });

    var suggestions = [];
    Object error;

    final Object callbackIdentity = Object();
    this._activeCallbackIdentity = callbackIdentity;

    try {
      suggestions = await widget.suggestionsCallback(widget.controller.text);
    } catch (e) {
      error = e;
    }

    // If another callback has been issued, omit this one
    if (this._activeCallbackIdentity != callbackIdentity) return;

    if (this.mounted) {
      // if it wasn't removed in the meantime
      setState(() {
        double animationStart = widget.animationStart;
        if (error != null || suggestions.length == 0) {
          animationStart = 1.0;
        }
        this._animationController.forward(from: animationStart);

        this._error = error;
        this._isLoading = false;
        this._suggestions = suggestions;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
    widget.controller.removeListener(this._controllerListener);
  }

  @override
  Widget build(BuildContext context) {
    if (this._suggestions == null && this._isLoading == false)
      return Container();

    Widget child;
    if (this._isLoading) {
      if (widget.hideOnLoading) {
        child = Container(height: 0);
      } else {
        child = widget.loadingBuilder != null
            ? widget.loadingBuilder(context)
            : Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: CircularProgressIndicator(),
                ),
              );
      }
    } else if (this._error != null) {
      if (widget.hideOnError) {
        child = Container(height: 0);
      } else {
        child = widget.errorBuilder != null
            ? widget.errorBuilder(context, this._error)
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Error: ${this._error}',
                  style: TextStyle(color: Theme.of(context).errorColor),
                ),
              );
      }
    } else if (this._suggestions.length == 0) {
      if (widget.hideOnEmpty) {
        child = Container(height: 0);
      } else {
        child = widget.noItemsFoundBuilder != null
            ? widget.noItemsFoundBuilder(context)
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'No Items Found!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Theme.of(context).disabledColor, fontSize: 18.0),
                ),
              );
      }
    } else {
      child = ListView(
        padding: EdgeInsets.zero,
        primary: false,
        shrinkWrap: true,
        reverse: widget.direction == AxisDirection.down
            ? false
            : true, // reverses the list to start at the bottom
        children: this._suggestions.map((T suggestion) {
          return InkWell(
            child: widget.itemBuilder(context, suggestion),
            onTap: () {
              widget.onSuggestionSelected(suggestion);
            },
          );
        }).toList(),
      );

      if (widget.decoration.hasScrollbar) {
        child = Scrollbar(child: child);
      }
    }

    var animationChild = widget.transitionBuilder != null
        ? widget.transitionBuilder(context, child, this._animationController)
        : SizeTransition(
            axisAlignment: -1.0,
            sizeFactor: CurvedAnimation(
                parent: this._animationController, curve: Curves.fastOutSlowIn),
            child: child,
          );

    BoxConstraints constraints;
    if (widget.decoration.constraints == null) {
      constraints = BoxConstraints(
        maxHeight: widget.suggestionsBoxController.maxHeight,
      );
    } else {
      double maxHeight = min(widget.decoration.constraints.maxHeight,
          widget.suggestionsBoxController.maxHeight);
      constraints = widget.decoration.constraints.copyWith(
        minHeight: min(widget.decoration.constraints.minHeight, maxHeight),
        maxHeight: maxHeight,
      );
    }

    var container = Material(
      elevation: widget.decoration.elevation,
      color: widget.decoration.color,
      shape: widget.decoration.shape,
      borderRadius: widget.decoration.borderRadius,
      shadowColor: widget.decoration.shadowColor,
      child: ConstrainedBox(
        constraints: constraints,
        child: animationChild,
      ),
    );

    return container;
  }
}

/// Supply an instance of this class to the [TypeAhead.suggestionsBoxDecoration]
/// property to configure the suggestions box decoration
class SuggestionsBoxDecoration {
  /// The z-coordinate at which to place the suggestions box. This controls the size
  /// of the shadow below the box.
  ///
  /// Same as [Material.elevation](https://docs.flutter.io/flutter/material/Material/elevation.html)
  final double elevation;

  /// The color to paint the suggestions box.
  ///
  /// Same as [Material.color](https://docs.flutter.io/flutter/material/Material/color.html)
  final Color color;

  /// Defines the material's shape as well its shadow.
  ///
  /// Same as [Material.shape](https://docs.flutter.io/flutter/material/Material/shape.html)
  final ShapeBorder shape;

  /// Defines if a scrollbar will be displayed or not.
  final bool hasScrollbar;

  /// If non-null, the corners of this box are rounded by this [BorderRadius](https://docs.flutter.io/flutter/painting/BorderRadius-class.html).
  ///
  /// Same as [Material.borderRadius](https://docs.flutter.io/flutter/material/Material/borderRadius.html)
  final BorderRadius borderRadius;

  /// The color to paint the shadow below the material.
  ///
  /// Same as [Material.shadowColor](https://docs.flutter.io/flutter/material/Material/shadowColor.html)
  final Color shadowColor;

  /// The constraints to be applied to the suggestions box
  final BoxConstraints constraints;

  /// Creates a SuggestionsBoxDecoration
  const SuggestionsBoxDecoration(
      {this.elevation: 4.0,
      this.color,
      this.shape,
      this.hasScrollbar: true,
      this.borderRadius,
      this.shadowColor: const Color(0xFF000000),
      this.constraints})
      : assert(shadowColor != null),
        assert(elevation != null);
}

/// Supply an instance of this class to the [TypeAhead.textFieldConfiguration]
/// property to configure the displayed text field
class TextFieldConfiguration<T> {
  /// The decoration to show around the text field.
  ///
  /// Same as [TextField.decoration](https://docs.flutter.io/flutter/material/TextField/decoration.html)
  final InputDecoration decoration;

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController](https://docs.flutter.io/flutter/widgets/TextEditingController-class.html).
  /// A typical use case for this field in the TypeAhead widget is to set the
  /// text of the widget when a suggestion is selected. For example:
  ///
  /// ```dart
  /// final _controller = TextEditingController();
  /// ...
  /// ...
  /// TypeAheadField(
  ///   controller: _controller,
  ///   ...
  ///   ...
  ///   onSuggestionSelected: (suggestion) {
  ///     _controller.text = suggestion['city_name'];
  ///   }
  /// )
  /// ```
  final TextEditingController controller;

  /// Controls whether this widget has keyboard focus.
  ///
  /// Same as [TextField.focusNode](https://docs.flutter.io/flutter/material/TextField/focusNode.html)
  final FocusNode focusNode;

  /// The style to use for the text being edited.
  ///
  /// Same as [TextField.style](https://docs.flutter.io/flutter/material/TextField/style.html)
  final TextStyle style;

  /// How the text being edited should be aligned horizontally.
  ///
  /// Same as [TextField.textAlign](https://docs.flutter.io/flutter/material/TextField/textAlign.html)
  final TextAlign textAlign;

  /// If false the textfield is "disabled": it ignores taps and its
  /// [decoration] is rendered in grey.
  ///
  /// Same as [TextField.enabled](https://docs.flutter.io/flutter/material/TextField/enabled.html)
  final bool enabled;

  /// The type of keyboard to use for editing the text.
  ///
  /// Same as [TextField.keyboardType](https://docs.flutter.io/flutter/material/TextField/keyboardType.html)
  final TextInputType keyboardType;

  /// Whether this text field should focus itself if nothing else is already
  /// focused.
  ///
  /// Same as [TextField.autofocus](https://docs.flutter.io/flutter/material/TextField/autofocus.html)
  final bool autofocus;

  /// Optional input validation and formatting overrides.
  ///
  /// Same as [TextField.inputFormatters](https://docs.flutter.io/flutter/material/TextField/inputFormatters.html)
  final List<TextInputFormatter> inputFormatters;

  /// Whether to enable autocorrection.
  ///
  /// Same as [TextField.autocorrect](https://docs.flutter.io/flutter/material/TextField/autocorrect.html)
  final bool autocorrect;

  /// The maximum number of lines for the text to span, wrapping if necessary.
  ///
  /// Same as [TextField.maxLines](https://docs.flutter.io/flutter/material/TextField/maxLines.html)
  final int maxLines;

  /// The maximum number of characters (Unicode scalar values) to allow in the
  /// text field.
  ///
  /// Same as [TextField.maxLength](https://docs.flutter.io/flutter/material/TextField/maxLength.html)
  final int maxLength;

  /// If true, prevents the field from allowing more than [maxLength]
  /// characters.
  ///
  /// Same as [TextField.maxLengthEnforced](https://docs.flutter.io/flutter/material/TextField/maxLengthEnforced.html)
  final bool maxLengthEnforced;

  /// Whether to hide the text being edited (e.g., for passwords).
  ///
  /// Same as [TextField.obscureText](https://docs.flutter.io/flutter/material/TextField/obscureText.html)
  final bool obscureText;

  /// Called when the text being edited changes.
  ///
  /// Same as [TextField.onChanged](https://docs.flutter.io/flutter/material/TextField/onChanged.html)
  final ValueChanged<T> onChanged;

  /// Called when the user indicates that they are done editing the text in the
  /// field.
  ///
  /// Same as [TextField.onSubmitted](https://docs.flutter.io/flutter/material/TextField/onSubmitted.html)
  final ValueChanged<T> onSubmitted;

  /// The color to use when painting the cursor.
  ///
  /// Same as [TextField.cursorColor](https://docs.flutter.io/flutter/material/TextField/cursorColor.html)
  final Color cursorColor;

  /// How rounded the corners of the cursor should be. By default, the cursor has a null Radius
  ///
  /// Same as [TextField.cursorRadius](https://docs.flutter.io/flutter/material/TextField/cursorRadius.html)
  final Radius cursorRadius;

  /// How thick the cursor will be.
  ///
  /// Same as [TextField.cursorWidth](https://docs.flutter.io/flutter/material/TextField/cursorWidth.html)
  final double cursorWidth;

  /// The appearance of the keyboard.
  ///
  /// Same as [TextField.keyboardAppearance](https://docs.flutter.io/flutter/material/TextField/keyboardAppearance.html)
  final Brightness keyboardAppearance;

  /// Called when the user submits editable content (e.g., user presses the "done" button on the keyboard).
  ///
  /// Same as [TextField.onEditingComplete](https://docs.flutter.io/flutter/material/TextField/onEditingComplete.html)
  final VoidCallback onEditingComplete;

  /// Configures padding to edges surrounding a Scrollable when the Textfield scrolls into view.
  ///
  /// Same as [TextField.scrollPadding](https://docs.flutter.io/flutter/material/TextField/scrollPadding.html)
  final EdgeInsets scrollPadding;

  /// Configures how the platform keyboard will select an uppercase or lowercase keyboard.
  ///
  /// Same as [TextField.TextCapitalization](https://docs.flutter.io/flutter/material/TextField/textCapitalization.html)
  final TextCapitalization textCapitalization;

  /// The type of action button to use for the keyboard.
  ///
  /// Same as [TextField.textInputAction](https://docs.flutter.io/flutter/material/TextField/textInputAction.html)
  final TextInputAction textInputAction;

  /// Creates a TextFieldConfiguration
  const TextFieldConfiguration(
      {this.decoration: const InputDecoration(),
      this.style,
      this.controller,
      this.onChanged,
      this.onSubmitted,
      this.obscureText: false,
      this.maxLengthEnforced: true,
      this.maxLength,
      this.maxLines: 1,
      this.autocorrect: true,
      this.inputFormatters,
      this.autofocus: false,
      this.keyboardType: TextInputType.text,
      this.enabled: true,
      this.textAlign: TextAlign.start,
      this.focusNode,
      this.cursorColor,
      this.cursorRadius,
      this.textInputAction,
      this.textCapitalization: TextCapitalization.none,
      this.cursorWidth: 2.0,
      this.keyboardAppearance,
      this.onEditingComplete,
      this.scrollPadding: const EdgeInsets.all(20.0)});

  /// Copies the [TextFieldConfiguration] and only changes the specified
  /// properties
  copyWith(
      {InputDecoration decoration,
      TextStyle style,
      TextEditingController controller,
      ValueChanged<T> onChanged,
      ValueChanged<T> onSubmitted,
      bool obscureText,
      bool maxLengthEnforced,
      int maxLength,
      int maxLines,
      bool autocorrect,
      List<TextInputFormatter> inputFormatters,
      bool autofocus,
      TextInputType keyboardType,
      bool enabled,
      TextAlign textAlign,
      FocusNode focusNode,
      Color cursorColor,
      Radius cursorRadius,
      double cursorWidth,
      Brightness keyboardAppearance,
      VoidCallback onEditingComplete,
      EdgeInsets scrollPadding,
      TextCapitalization textCapitalization,
      TextInputAction textInputAction}) {
    return TextFieldConfiguration(
        decoration: decoration ?? this.decoration,
        style: style ?? this.style,
        controller: controller ?? this.controller,
        onChanged: onChanged ?? this.onChanged,
        onSubmitted: onSubmitted ?? this.onSubmitted,
        obscureText: obscureText ?? this.obscureText,
        maxLengthEnforced: maxLengthEnforced ?? this.maxLengthEnforced,
        maxLength: maxLength ?? this.maxLength,
        maxLines: maxLines ?? this.maxLines,
        autocorrect: autocorrect ?? this.autocorrect,
        inputFormatters: inputFormatters ?? this.inputFormatters,
        autofocus: autofocus ?? this.autofocus,
        keyboardType: keyboardType ?? this.keyboardType,
        enabled: enabled ?? this.enabled,
        textAlign: textAlign ?? this.textAlign,
        focusNode: focusNode ?? this.focusNode,
        cursorColor: cursorColor ?? this.cursorColor,
        cursorRadius: cursorRadius ?? this.cursorRadius,
        cursorWidth: cursorWidth ?? this.cursorWidth,
        keyboardAppearance: keyboardAppearance ?? this.keyboardAppearance,
        onEditingComplete: onEditingComplete ?? this.onEditingComplete,
        scrollPadding: scrollPadding ?? this.scrollPadding,
        textCapitalization: textCapitalization ?? this.textCapitalization,
        textInputAction: textInputAction ?? this.textInputAction);
  }
}

class _SuggestionsBoxController {
  static const double defaultHeight = 300.0;
  static const int waitMetricsTimeoutMillis = 1000;

  final BuildContext context;
  final AxisDirection direction;

  OverlayEntry _overlayEntry;

  bool _isOpened = false;
  bool widgetMounted = true;
  double maxHeight = defaultHeight;

  _SuggestionsBoxController(this.context, this.direction);

  open() {
    if (this._isOpened) return;
    assert(this._overlayEntry != null);
    Overlay.of(context).insert(this._overlayEntry);
    this._isOpened = true;
  }

  close() {
    if (!this._isOpened) return;
    assert(this._overlayEntry != null);
    this._overlayEntry.remove();
    this._isOpened = false;
  }

  toggle() {
    if (this._isOpened) {
      this.close();
    } else {
      this.open();
    }
  }

  MediaQuery _findRootMediaQuery() {
    MediaQuery rootMediaQuery;
    context.visitAncestorElements((element) {
      if (element.widget is MediaQuery) {
        rootMediaQuery = element.widget as MediaQuery;
      }
      return true;
    });

    return rootMediaQuery;
  }

  /// Delays until the keyboard has toggled or the orientation has fully changed
  Future<bool> _waitChangeMetrics() async {
    if (widgetMounted) {
      // initial viewInsets which are before the keyboard is toggled
      EdgeInsets initial = MediaQuery.of(context).viewInsets;
      // initial MediaQuery for orientation change
      MediaQuery initialRootMediaQuery = _findRootMediaQuery();

      int timer = 0;
      // viewInsets or MediaQuery have changed once keyboard has toggled or orientation has changed
      while (widgetMounted && timer < waitMetricsTimeoutMillis) {
        if (MediaQuery.of(context).viewInsets != initial ||
            _findRootMediaQuery() != initialRootMediaQuery) {
          return true;
        }
        await Future.delayed(const Duration(milliseconds: 10));
        timer += 10;
      }
    }

    return false;
  }

  void resize() {
    // check to see if widget is still mounted
    // user may have closed the widget with the keyboard still open
    if (widgetMounted) {
      TypeAheadField widget = context.widget as TypeAheadField;

      if (direction == AxisDirection.down) {
        // height of window
        double h = MediaQuery.of(context).size.height;

        RenderBox box = context.findRenderObject();
        // top of text box
        double textBoxAbsY = box.localToGlobal(Offset.zero).dy;
        double textBoxHeight = box.size.height;

        // height of keyboard
        double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

        // we need to find the root MediaQuery for the unsafe area height
        // we cannot use BuildContext.ancestorWidgetOfExactType because
        // widgets like SafeArea creates a new MediaQuery with the padding removed
        MediaQuery rootMediaQuery = _findRootMediaQuery();

        // unsafe area, ie: iPhone X 'home button'
        // keyboardHeight includes unsafeAreaHeight, if keyboard is showing, set to 0
        double unsafeAreaHeight = keyboardHeight == 0 && rootMediaQuery != null
            ? rootMediaQuery.data.padding.bottom
            : 0;

        maxHeight = h -
            keyboardHeight -
            unsafeAreaHeight -
            textBoxHeight -
            textBoxAbsY -
            2 * widget.suggestionsBoxVerticalOffset;
      } else {
        // AxisDirection.up
        RenderBox box = context.findRenderObject();
        // top of text box
        double textBoxAbsY = box.localToGlobal(Offset.zero).dy;

        // we need to find the root MediaQuery for the unsafe area height
        // we cannot use BuildContext.ancestorWidgetOfExactType because
        // widgets like SafeArea creates a new MediaQuery with the padding removed
        MediaQuery rootMediaQuery = _findRootMediaQuery();

        // unsafe area, ie: iPhone X notch
        double unsafeAreaHeight = rootMediaQuery.data.padding.top;

        maxHeight = textBoxAbsY -
            unsafeAreaHeight -
            2 * widget.suggestionsBoxVerticalOffset;
      }

      if (maxHeight < 0) maxHeight = 0;

      _overlayEntry.markNeedsBuild();
    }
  }

  Future<void> onChangeMetrics() async {
    if (await _waitChangeMetrics()) {
      resize();
    }
  }
}
