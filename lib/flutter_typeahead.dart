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
///   autofocus: true,
///   style: DefaultTextStyle.of(context).style.copyWith(
///     fontStyle: FontStyle.italic
///   ),
///   decoration: InputDecoration(
///     border: OutlineInputBorder()
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
/// In the code above, the `autofocus`, `style` and `decoration` are the same as
/// those of `TextField`, and are not mandatory.
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
///           controller: this._typeAheadController,
///           decoration: InputDecoration(
///             labelText: 'City'
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
/// Here, we assign to the `controller` property a `TextEditingController` that
/// we call `_typeAheadController`. We use this controller in the
/// `onSuggestionSelected` callback to set the value of the `TextField` to the
/// selected suggestion.
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
/// You can customize the field with all the usual customizations available for
/// `TextField` in Flutter. Examples include: `decoration`, `style`, `controller`,
/// `focusNode`, `autofocus`, `enabled`, etc.
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
/// #### Customizing the decoration of the suggestions box
/// You can also customize the decoration of the suggestions box using the
/// `suggestionsBoxDecoration` parameter. For example, to give it a blue border,
/// you can write:
/// ```dart
/// suggestionsBoxDecoration: BoxDecoration(
///   border: Border.all(
///     color: Colors.blue
///   )
/// )
/// ```
library flutter_typeahead;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef FutureOr<List<T>> SuggestionsCallback<T>(String pattern);
typedef Widget ItemBuilder<T>(BuildContext context, T itemData);
typedef void SuggestionSelectionCallback<T>(T suggestion);
typedef Widget ErrorBuilder(BuildContext context, Object error);
typedef AnimationTransitionBuilder(BuildContext context, Widget child, AnimationController controller);

/// A [FormField](https://docs.flutter.io/flutter/widgets/FormField-class.html)
/// implementation of [TypeAheadField], that allows the value to be saved,
/// validated, etc.
///
/// See also:
///
/// * [TypeAheadField], A [TextField](https://docs.flutter.io/flutter/material/TextField-class.html)
/// that displays a list of suggestions as the user types
class TypeAheadFormField<T> extends FormField<String> {
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

  /// Creates a [TypeAheadFormField]
  TypeAheadFormField({
    Key key,
    String initialValue,
    bool autovalidate: false,
    FormFieldSetter<String> onSaved,
    FormFieldValidator<String> validator,
    this.controller,
    ErrorBuilder errorBuilder,
    TextAlign textAlign: TextAlign.start,
    TextStyle style,
    WidgetBuilder noItemsFoundBuilder,
    WidgetBuilder loadingBuilder,
    Duration debounceDuration: const Duration(milliseconds: 300),
    BoxDecoration suggestionsBoxDecoration,
    InputDecoration decoration,
    ValueChanged<String> onFieldSubmitted,
    bool obscureText: false,
    int maxLength,
    bool maxLengthEnforced: true,
    int maxLines: 1,
    bool autocorrect: true,
    List<TextInputFormatter> inputFormatters,
    bool autofocus: false,
    TextInputType keyboardType: TextInputType.text,
    bool enabled: true,
    @required SuggestionSelectionCallback<T> onSuggestionSelected,
    @required ItemBuilder<T> itemBuilder,
    @required SuggestionsCallback<T> suggestionsCallback,
    FocusNode focusNode,
    AnimationTransitionBuilder transitionBuilder,
    Duration animationDuration: const Duration(milliseconds: 500),
    double animationStart: 0.25
  }) : super(
    key: key,
    onSaved: onSaved,
    validator: validator,
    autovalidate: autovalidate,
    initialValue: controller != null ? controller.text : (initialValue ?? ''),
    builder: (FormFieldState<String> field) {

      final _TypeAheadFormFieldState state = field;

      return TypeAheadField(
        transitionBuilder: transitionBuilder,
        errorBuilder: errorBuilder,
        textAlign: textAlign,
        style: style,
        noItemsFoundBuilder: noItemsFoundBuilder,
        loadingBuilder: loadingBuilder,
        debounceDuration: debounceDuration,
        suggestionsBoxDecoration: suggestionsBoxDecoration,
        decoration: decoration.copyWith(errorText: state.errorText),
        onSubmitted: onFieldSubmitted,
        onChanged: state.didChange,
        obscureText: obscureText,
        maxLength: maxLength,
        maxLengthEnforced: maxLengthEnforced,
        maxLines: maxLines,
        autocorrect: autocorrect,
        inputFormatters: inputFormatters,
        autofocus: autofocus,
        keyboardType: keyboardType,
        enabled: enabled,
        controller: state._effectiveController,
        onSuggestionSelected: onSuggestionSelected,
        itemBuilder: itemBuilder,
        suggestionsCallback: suggestionsCallback,
        focusNode: focusNode,
        animationStart: animationStart,
        animationDuration: animationDuration,
      );
    }
  );

  @override
  _TypeAheadFormFieldState<T> createState() => _TypeAheadFormFieldState();
}

class _TypeAheadFormFieldState<T> extends FormFieldState<String> {
  TextEditingController _controller;

  TextEditingController get _effectiveController => widget.controller ?? _controller;

  @override
  TypeAheadFormField get widget => super.widget;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = TextEditingController(text: widget.initialValue);
      print(widget.initialValue);
    } else {
      widget.controller.addListener(_handleControllerChanged);
    }
  }

  @override
  void didUpdateWidget(TypeAheadFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && widget.controller == null)
        _controller = TextEditingController.fromValue(oldWidget.controller.value);
      if (widget.controller != null) {
        setValue(widget.controller.text);
        if (oldWidget.controller == null)
          _controller = null;
      }
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleControllerChanged);
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

  /// The decoration to show around the text field.
  ///
  /// Same as [TextField.decoration](https://docs.flutter.io/flutter/material/TextField/decoration.html)
  final InputDecoration decoration;
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
  final ValueChanged<String> onChanged;
  /// Called when the user indicates that they are done editing the text in the
  /// field.
  ///
  /// Same as [TextField.onSubmitted](https://docs.flutter.io/flutter/material/TextField/onSubmitted.html)
  final ValueChanged<String> onSubmitted;
  /// The decoration of the container that contains the suggestions.
  ///
  /// If null, default decoration with black borders and white background is
  /// used
  final BoxDecoration suggestionsBoxDecoration;
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
  /// The value at which the [transitionBuilder] animation starts.
  ///
  /// This argument is best used with [transitionBuilder] and [animationDuration]
  /// to fully control the animation.
  ///
  /// Defaults to 0.25.
  final double animationStart;

  /// Creates a [TypeAheadField]
  TypeAheadField({
    Key key,
    this.decoration : const InputDecoration(),
    @required this.suggestionsCallback,
    @required this.itemBuilder,
    this.controller,
    @required this.onSuggestionSelected,
    this.focusNode,
    this.style,
    this.textAlign: TextAlign.start,
    this.enabled,
    this.keyboardType: TextInputType.text,
    this.autofocus: false,
    this.inputFormatters,
    this.autocorrect: true,
    this.maxLines: 1,
    this.maxLength,
    this.maxLengthEnforced: true,
    this.obscureText: false,
    this.onChanged,
    this.onSubmitted,
    this.suggestionsBoxDecoration,
    this.debounceDuration: const Duration(milliseconds: 300),
    this.loadingBuilder,
    this.noItemsFoundBuilder,
    this.errorBuilder,
    this.transitionBuilder,
    this.animationStart: 0.25,
    this.animationDuration: const Duration (milliseconds: 500)
  }):
      assert(suggestionsCallback != null),
      assert(itemBuilder != null),
      assert(onSuggestionSelected != null),
      assert(animationStart != null && animationStart >= 0.0 && animationStart <= 1.0),
      assert(animationDuration != null),
      assert(debounceDuration != null),
      assert(textAlign != null),
      assert(autofocus != null),
      assert(obscureText != null),
      assert(autocorrect != null),
      assert(maxLengthEnforced != null),
      assert(maxLines == null || maxLines > 0),
      assert(maxLength == null || maxLength > 0),
      super(key: key);

  @override
  _TypeAheadFieldState createState() => _TypeAheadFieldState();
}

class _TypeAheadFieldState<T> extends State<TypeAheadField<T>> {

  FocusNode _focusNode;
  TextEditingController _controller;
  OverlayEntry _suggestionsOverlayEntry;

  TextEditingController get _effectiveController => widget.controller ?? _controller;
  FocusNode get _effectiveFocusNode => widget.focusNode ?? _focusNode;

  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();

    if (widget.controller == null) {
      this._controller = TextEditingController();
    }

    if (widget.focusNode == null) {
      this._focusNode = FocusNode();
    }

    this._effectiveFocusNode.addListener(() async {
      if (_effectiveFocusNode.hasFocus) {

        if (this._suggestionsOverlayEntry == null) {

          RenderBox renderBox = context.findRenderObject();

          while (!renderBox.hasSize) { // This happens in case of autofocus
            // Keep waiting and checking if the renderbox has been laid out yet
            // Not a very clean solution, a better one would have been to wait
            // for some event that tells us that it has been laid out now.
            // However, I couldn't find such event
            await Future.delayed(Duration(milliseconds: 10));
          }

          var size = renderBox.size;

          this._suggestionsOverlayEntry = OverlayEntry(
            builder: (context) {
              return Positioned(
                width: size.width,
                child: CompositedTransformFollower(
                  link: this._layerLink,
                  showWhenUnlinked: false,
                  offset: Offset(0.0, size.height),
                  child: _SuggestionsList<T>(
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
                    onSuggestionSelected: (T selection) {
                      this._effectiveFocusNode.unfocus();
                      widget.onSuggestionSelected(selection);
                    },
                    itemBuilder: widget.itemBuilder,
                  ),
                ),
              );
            }
          );
        }

        Overlay.of(context).insert(this._suggestionsOverlayEntry);
      } else {
        this._suggestionsOverlayEntry.remove();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: this._layerLink,
      child: TextField(
        focusNode: this._effectiveFocusNode,
        controller: this._effectiveController,
        decoration: widget.decoration,
        style: widget.style,
        textAlign: widget.textAlign,
        enabled: widget.enabled,
        keyboardType: widget.keyboardType,
        autofocus: widget.autofocus,
        inputFormatters: widget.inputFormatters,
        autocorrect: widget.autocorrect,
        maxLines: widget.maxLines,
        maxLength: widget.maxLength,
        maxLengthEnforced: widget.maxLengthEnforced,
        obscureText: widget.obscureText,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
      ),
    );
  }
}

class _SuggestionsList<T> extends StatefulWidget {

  final TextEditingController controller;
  final SuggestionSelectionCallback<T> onSuggestionSelected;
  final SuggestionsCallback suggestionsCallback;
  final ItemBuilder itemBuilder;
  final BoxDecoration decoration;
  final Duration debounceDuration;
  final WidgetBuilder loadingBuilder;
  final WidgetBuilder noItemsFoundBuilder;
  final ErrorBuilder errorBuilder;
  final AnimationTransitionBuilder transitionBuilder;
  final Duration animationDuration;
  final double animationStart;

  _SuggestionsList({
    this.controller,
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
  });

  @override
  _SuggestionsListState createState() => _SuggestionsListState();
}

class _SuggestionsListState<T> extends State<_SuggestionsList<T>> with SingleTickerProviderStateMixin {

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

    this._controllerListener = () {

      // If we came here because of a change in selected text, not because of
      // actual change in text
      if (widget.controller.text == this._lastTextValue) return;

      this._lastTextValue = widget.controller.text;

      this._debounceTimer = Timer(widget.debounceDuration, () async {
        if (this._debounceTimer.isActive) return;

        // If already closed
        if (!this.mounted) return;

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

        if (this.mounted) { // if it wasn't removed in the meantime
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

      });
    };

    widget.controller.addListener(this._controllerListener);
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(this._controllerListener);
  }

  @override
  Widget build(BuildContext context) {

    if (this._suggestions == null && this._isLoading == false) return Container();

    Widget child;
    if (this._isLoading) {

      child = widget.loadingBuilder != null ? widget.loadingBuilder(context) :
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: CircularProgressIndicator(),
          ),
        );

    } else if (this._error != null) {

      child = widget.errorBuilder != null ? widget.errorBuilder(context, this._error) :
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Error: ${this._error}',
            style: TextStyle(
              color: Theme.of(context).errorColor
            ),
          ),
        );

    } else if (this._suggestions.length == 0) {

      child = widget.noItemsFoundBuilder != null? widget.noItemsFoundBuilder(context) :
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'No Items Found!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).disabledColor,
              fontSize: 18.0
            ),
          ),
        );

    } else {

      child = ListView(
        padding: EdgeInsets.zero,
        primary: false,
        shrinkWrap: true,
        children: this._suggestions.map((T suggestion) {
          return InkWell(
            child: widget.itemBuilder(context, suggestion),
            onTap: () {
              widget.onSuggestionSelected(suggestion);
            },
          );
        }).toList(),
      );

    }

    var container = Material(
      child: Container(
        decoration: widget.decoration ?? BoxDecoration(
            border: Border.all(
                color: Colors.black
            ),
            color: Colors.white
        ),
        child: child,
      ),
    );

    return widget.transitionBuilder != null? widget.transitionBuilder(context, container, this._animationController) :
      SizeTransition(
        axisAlignment: -1.0,
        sizeFactor: CurvedAnimation(
          parent: this._animationController,
          curve: Curves.fastOutSlowIn
        ),
        child: container,
      );
  }
}

