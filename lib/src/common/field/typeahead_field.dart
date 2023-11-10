import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_typeahead/src/common/field/typeahead_field_config.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_box.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_list_config.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/text_field_configuration.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

/// {@template flutter_typeahead.BaseTypeAheadField}
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
///     padding: EdgeInsets.all(32),
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
///         SizedBox(height: 10),
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
/// `animationStart` specified what point (between 0 and 1) the animation
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
///   elevation: 0,
/// )
/// ```
///
/// See also:
/// * [TypeAheadFormField], A [FormField](https://docs.flutter.io/flutter/widgets/FormField-class.html) implementation of [TypeAheadField] that allows the value to be saved, validated, etc.
/// {@endtemplate}
abstract class BaseTypeAheadField<T> extends StatefulWidget
    implements TypeaheadFieldConfig<T> {
  const BaseTypeAheadField({
    super.key,
    this.animationDuration = const Duration(milliseconds: 500),
    this.animationStart = 0.25,
    this.autoFlipDirection = false,
    this.autoFlipListDirection = true,
    this.autoFlipMinHeight = 64,
    this.debounceDuration = const Duration(milliseconds: 300),
    this.direction = AxisDirection.down,
    this.errorBuilder,
    this.hideKeyboardOnDrag = false,
    this.hideOnEmpty = false,
    this.hideOnError = false,
    this.hideOnLoading = false,
    this.hideOnUnfocus = true,
    this.intercepting = false,
    required this.itemBuilder,
    this.itemSeparatorBuilder,
    this.keepSuggestionsOnLoading = true,
    this.keepSuggestionsOnSelect = false,
    this.layoutArchitecture,
    this.loadingBuilder,
    this.minCharsForSuggestions = 0,
    this.noItemsFoundBuilder,
    required this.onSuggestionSelected,
    this.scrollController,
    this.suggestionsBoxController,
    required this.suggestionsCallback,
    this.transitionBuilder,
  })  : assert(animationStart >= 0 && animationStart <= 1),
        assert(minCharsForSuggestions >= 0),
        assert(
          !hideKeyboardOnDrag || hideKeyboardOnDrag && !hideOnUnfocus,
        );

  @override
  final Duration animationDuration;
  @override
  final double animationStart;
  @override
  final bool autoFlipDirection;
  @override
  final bool autoFlipListDirection;
  @override
  final double autoFlipMinHeight;
  @override
  final Duration debounceDuration;
  @override
  final AxisDirection direction;
  @override
  final ErrorBuilder? errorBuilder;
  @override
  final bool hideKeyboardOnDrag;
  @override
  final bool hideOnEmpty;
  @override
  final bool hideOnError;
  @override
  final bool hideOnLoading;
  @override
  final bool hideOnUnfocus;
  @override
  final ItemBuilder<T> itemBuilder;
  @override
  final IndexedWidgetBuilder? itemSeparatorBuilder;
  @override
  final bool intercepting;
  @override
  final bool keepSuggestionsOnLoading;
  @override
  final bool keepSuggestionsOnSelect;
  @override
  final LayoutArchitecture? layoutArchitecture;
  @override
  final WidgetBuilder? loadingBuilder;
  @override
  final int minCharsForSuggestions;
  @override
  final WidgetBuilder? noItemsFoundBuilder;
  @override
  final SuggestionSelectionCallback<T> onSuggestionSelected;
  @override
  final ScrollController? scrollController;
  @override
  final SuggestionsBoxController? suggestionsBoxController;
  @override
  final SuggestionsCallback<T> suggestionsCallback;
  @override
  final AnimationTransitionBuilder? transitionBuilder;

  Widget buildSuggestionsList(
    BuildContext context,
    SuggestionsListConfig<T> config,
  );

  Widget buildTextField(
    BuildContext context,
    BaseTextFieldConfiguration config,
  );

  @override
  State<BaseTypeAheadField<T>> createState() => _BaseTypeAheadFieldState<T>();
}

class _BaseTypeAheadFieldState<T> extends State<BaseTypeAheadField<T>> {
  late TextEditingController _textEditingController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _textEditingController =
        widget.textFieldConfiguration.controller ?? TextEditingController();
    _focusNode = widget.textFieldConfiguration.focusNode ?? FocusNode();
  }

  @override
  void didUpdateWidget(covariant BaseTypeAheadField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.textFieldConfiguration.controller !=
        widget.textFieldConfiguration.controller) {
      if (oldWidget.textFieldConfiguration.controller == null) {
        _textEditingController.dispose();
      }
      _textEditingController =
          widget.textFieldConfiguration.controller ?? TextEditingController();
    }
    if (oldWidget.textFieldConfiguration.focusNode !=
        widget.textFieldConfiguration.focusNode) {
      if (oldWidget.textFieldConfiguration.focusNode == null) {
        _focusNode.dispose();
      }
      _focusNode = widget.textFieldConfiguration.focusNode ?? FocusNode();
    }
  }

  @override
  void dispose() {
    if (widget.textFieldConfiguration.controller == null) {
      _textEditingController.dispose();
    }
    if (widget.textFieldConfiguration.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SuggestionsBox(
      controller: widget.suggestionsBoxController,
      direction: widget.direction,
      offset: widget.suggestionsBoxDecoration.offset,
      focusNode: _focusNode,
      autoFlipDirection: widget.autoFlipDirection,
      autoFlipMinHeight: widget.autoFlipMinHeight,
      hideOnUnfocus: widget.hideOnUnfocus,
      suggestionsBuilder: (context, suggestionsBoxController) =>
          widget.buildSuggestionsList(
        context,
        SuggestionsListConfig<T>(
          animationDuration: widget.animationDuration,
          animationStart: widget.animationStart,
          autoFlipListDirection: widget.autoFlipListDirection,
          controller: _textEditingController,
          debounceDuration: widget.debounceDuration,
          direction: widget.direction,
          errorBuilder: widget.errorBuilder,
          hideKeyboardOnDrag: widget.hideKeyboardOnDrag,
          hideOnEmpty: widget.hideOnEmpty,
          hideOnError: widget.hideOnError,
          hideOnLoading: widget.hideOnLoading,
          itemBuilder: widget.itemBuilder,
          itemSeparatorBuilder: widget.itemSeparatorBuilder,
          keepSuggestionsOnLoading: widget.keepSuggestionsOnLoading,
          keepSuggestionsOnSelect: widget.keepSuggestionsOnSelect,
          layoutArchitecture: widget.layoutArchitecture,
          loadingBuilder: widget.loadingBuilder,
          minCharsForSuggestions: widget.minCharsForSuggestions,
          noItemsFoundBuilder: widget.noItemsFoundBuilder,
          onSuggestionSelected: widget.onSuggestionSelected,
          scrollController: widget.scrollController,
          suggestionsBoxController: suggestionsBoxController,
          suggestionsCallback: widget.suggestionsCallback,
          transitionBuilder: widget.transitionBuilder,
        ),
      ),
      child: PointerInterceptor(
        intercepting: widget.intercepting,
        child: widget.buildTextField(
          context,
          widget.textFieldConfiguration.copyWith(
            focusNode: _focusNode,
            controller: _textEditingController,
          ),
        ),
      ),
    );
  }
}
