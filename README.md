<meta name='keywords' content='flutter, typeahead, autocomplete, customizable, floating'>

[![Pub](https://img.shields.io/pub/v/flutter_typeahead)](https://pub.dev/packages/flutter_typeahead)

# Flutter TypeAhead

A TypeAhead (autocomplete) widget for Flutter, where you can show suggestions to
users as they type

<img src="https://raw.githubusercontent.com/AbdulRahmanAlHamali/flutter_typeahead/master/flutter_typeahead.gif">

## Features

- Shows suggestions in an overlay that floats on top of other widgets
- Allows you to specify what the suggestions will look like through a
  builder function
- Allows you to specify what happens when the user taps a suggestion
- Accepts all the parameters that traditional TextFields accept, like
  decoration, custom TextEditingController, text styling, etc.
- Provides two versions, a normal version and a [FormField](https://docs.flutter.io/flutter/widgets/FormField-class.html)
  version that accepts validation, submitting, etc.
- Provides high customizable; you can customize the suggestion box decoration,
  the loading bar, the animation, the debounce duration, etc.

## Installation

See the [installation instructions on pub](https://pub.dartlang.org/packages/flutter_typeahead/install).

Note: As for Typeahead 3.x this package is based on Dart 2.12 (null-safety). You may also want to explore the new built in Flutter 2 widgets that have similar behavior.

Note: As of Typeahead 5.x this package is based on Dart 3.0 (null-safety enforced). To use this package, please upgrade your Flutter SDK.

## Usage examples

You can import the package with:

```dart
import 'package:flutter_typeahead/flutter_typeahead.dart';
```

Use it as follows:

### Material Example 1:

```dart
TypeAheadField(
  textFieldConfiguration: TextFieldConfiguration(
    autofocus: true,
    style: DefaultTextStyle.of(context).style.copyWith(
      fontStyle: FontStyle.italic
    ),
    decoration: InputDecoration(
      border: OutlineInputBorder()
    )
  ),
  suggestionsCallback: (pattern) =>
      BackendService.getSuggestions(pattern),
  itemBuilder: (context, suggestion) {
    return ListTile(
      leading: Icon(Icons.shopping_cart),
      title: Text(suggestion['name']),
      subtitle: Text('\$${suggestion['price']}'),
    );
  },
  onSuggestionSelected: (suggestion) {
    Navigator.of(context).push<void>(MaterialPageRoute(
      builder: (context) => ProductPage(product: suggestion)
    ));
  },
)
```

In the code above, the `textFieldConfiguration` property allows us to
configure the displayed `TextField` as we want. In this example, we are
configuring the `autofocus`, `style` and `decoration` properties.

The `suggestionsCallback` is called with the search string that the user
types, and is expected to return a `List` of data either synchronously or
asynchronously. In this example, we are calling an asynchronous function
called `BackendService.getSuggestions` which fetches the list of
suggestions.

The `itemBuilder` is called to build a widget for each suggestion.
In this example, we build a simple `ListTile` that shows the name and the
price of the item. Please note that you shouldn't provide an `onTap`
callback here. The TypeAhead widget takes care of that.

The `onSuggestionSelected` is a callback called when the user taps a
suggestion. In this example, when the user taps a
suggestion, we navigate to a page that shows us the information of the
tapped product.

### Material Example 2:

Here's another example, where we use the TypeAheadFormField inside a `Form`:

```dart
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
final TextEditingController _typeAheadController = TextEditingController();
String _selectedCity;

// ...

Form(
  key: this._formKey,
  child: Padding(
    padding: EdgeInsets.all(32),
    child: Column(
      children: [
        Text('What is your favorite city?'),
        TypeAheadFormField(
          textFieldConfiguration: TextFieldConfiguration(
            controller: this._typeAheadController,
            decoration: InputDecoration(labelText: 'City')
          ),
          suggestionsCallback: (pattern) =>
              CitiesService.getSuggestions(pattern),
          itemBuilder: (context, suggestion) => ListTile(
            title: Text(suggestion),
          ),
          transitionBuilder: (context, suggestionsBox, controller) =>
              suggestionsBox,
          onSuggestionSelected: (suggestion) {
            this._typeAheadController.text = suggestion;
          },
          validator: (value) =>
              value!.isEmpty ? 'Please select a city' : null,
          onSaved: (value) => this._selectedCity = value,
        ),
        SizedBox(height: 12),
        RaisedButton(
          child: Text('Submit'),
          onPressed: () {
            if (this._formKey.currentState.validate()) {
              this._formKey.currentState.save();
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('Your Favorite City is ${this._selectedCity}')
              ));
            }
          },
        )
      ],
    ),
  ),
)
```

Here, we assign to the `controller` property of the `textFieldConfiguration`
a `TextEditingController` that we call `_typeAheadController`.
We use this controller in the `onSuggestionSelected` callback to set the
value of the `TextField` to the selected suggestion.

The `validator` callback can be used like any `FormField.validator`
function. In our example, it checks whether a value has been entered,
and displays an error message if not. The `onSaved` callback is used to
save the value of the field to the `_selectedCity` member variable.

The `transitionBuilder` allows us to customize the animation of the
suggestion box. In this example, we are returning the suggestionsBox
immediately, meaning that we don't want any animation.

### Custom Layout Architecture:

By default, TypeAhead uses a `ListView` to render the items created by `itemBuilder`. If you specify a `layoutArchitecture` component, it will use this component instead. For example, here's how we render the items in a grid using the standard `GridView`:

```dart
TypeAheadField(
  ...,
  layoutArchitecture: (items, scrollContoller) => GridView.count(
    controller: scrollContoller,
    crossAxisCount: 2,
    crossAxisSpacing: 8,
    mainAxisSpacing: 8,
    primary: false,
    shrinkWrap: true,
    children: items.toList(),
  ),
);
```

## Customizations

TypeAhead widgets consist of a TextField and a suggestion box that shows
as the user types. Both are highly customizable.

### Customizing the TextField

You can customize the text field using the `textFieldConfiguration` property.
You provide this property with an instance of `TextFieldConfiguration`,
which allows you to configure all the usual properties of `TextField`, like
`decoration`, `style`, `controller`, `focusNode`, `autofocus`, `enabled`,
etc.

### Customizing the suggestions box

TypeAhead provides default configurations for the suggestions box. You can,
however, override most of them. This is done by passing a `SuggestionsDecoration`
to the `suggestionsDecoration` property.

Use the `offset` property in `SuggestionsDecoration` to shift the suggestions box along the x and y axis.
You may also pass BoxConstraints to `constraints` in `SuggestionsBoxDecoration` to adjust the width
and height of the suggestions box. Using the two together will allow the suggestions box to be placed
almost anywhere.

The suggestions box scrollbar is by default only visible during scrolling. Use the `scrollbarThumbAlwaysVisible` property to override this behaviour if you want to give the user a visual clue that there are more suggestions available in the list.
(The value will be passed to the `thumbVisibility` property of the Scrollbar widget).

The `scrollbarTrackAlwaysVisible` property (Material only!) can be used to make the scrollbar track stay visible even when not scrolling.

#### Customizing the loader, the error and the empty message

You can use the `loadingBuilder`, `errorBuilder` and `noItemsFoundBuilder` to
customize their corresponding widgets. For example, to show a custom error
widget:

```dart
errorBuilder: (context, error) =>
  Text(
    '$error',
    style: TextStyle(
      color: Theme.of(context).errorColor
    )
  )
```

By default, the suggestions box will maintain the old suggestions while new
suggestions are being retrieved. To show a circular progress indicator
during retrieval instead, set `keepSuggestionsOnLoading` to false.

#### Hiding the suggestions box

There are three scenarios when you can hide the suggestions box.

Set `hideOnLoading` to true to hide the box while suggestions are being
retrieved. This will also ignore the `loadingBuilder`. Set `hideOnEmpty`
to true to hide the box when there are no suggestions. This will also ignore
the `noItemsFoundBuilder`. Set `hideOnError` to true to hide the box when there
is an error retrieving suggestions. This will also ignore the `errorBuilder`.

By default, the suggestions box will automatically hide when the keyboard is hidden.
To change this behavior, set `hideWithKeyboard` to false.

#### Customizing the animation

You can customize the suggestion box animation through 3 parameters: the
`animationDuration`, the `animationStart`, and the `transitionBuilder`.

The `animationDuration` specifies how long the animation should take, while the
`animationStart` specified what point (between 0.0 and 1.0) the animation
should start and end on.

The `transitionBuilder` is a callback that is used build the animation:

```dart
transitionBuilder: (context, child, controller) =>
  FadeTransition(
    child: child,
    opacity: CurvedAnimation(
      parent: controller,
      curve: Curves.fastOutSlowIn
    ),
  )
```

This uses [FadeTransition](https://docs.flutter.io/flutter/widgets/FadeTransition-class.html)
to fade the `suggestionsBox` into the view. Note how the
`animationController` was provided as the parent of the animation.

In order to fully remove the animation, `transitionBuilder` should simply
return the `suggestionsBox`. This callback could also be used to wrap the
`suggestionsBox` with any desired widgets, not necessarily for animation.

#### Customizing the debounce duration

The suggestions box does not fire for each character the user types. Instead,
we wait until the user is idle for a duration of time, and then call the
`suggestionsCallback`. The duration defaults to 300 milliseconds, but can be
configured using the `debounceDuration` parameter.

#### Customizing the decoration of the suggestions

You can also customize the decoration of the suggestions box using the
`suggestionsDecoration` property.

For example, you may remove the elevation or the offset of the suggestions box:

```dart
suggestionsDecoration: SuggestionsDecoration(
  elevation: 0.0
  offset: Offset(0.0, 0.0)
)
```

#### Customizing the growth direction of the suggestions list

By default, the list grows towards the bottom. However, you can use the `direction` property to customize the growth direction to be one of `AxisDirection.down` or `AxisDirection.up`, the latter of which will cause the list to grow up, where the first suggestion is at the bottom of the list, and the last suggestion is at the top.

Set `autoFlipDirection` to `true` to allow the suggestions list to automatically flip direction whenever it detects that there is not enough space for the current direction. This is useful for scenarios where the `TypeAheadField` is in a scrollable widget or when the developer wants to ensure the list is always viewable despite different user screen sizes.

#### Controlling the suggestions box

Manual control of the suggestions box can be achieved by creating an instance of `SuggestionsController` and
passing it to the `suggestionsController` property. This will allow you to manually open, close, toggle, or
resize the suggestions box.

## For more information

Visit the [API Documentation](https://pub.dartlang.org/documentation/flutter_typeahead/latest/)

## Team:

| [<img src="https://avatars.githubusercontent.com/u/16646600?v=3" width="100px;"/>](https://github.com/AbdulRahmanAlHamali) | [<img src="https://avatars.githubusercontent.com/u/2034925?v=3" width="100px;"/>](https://github.com/sjmcdowall) | [<img src="https://avatars.githubusercontent.com/u/5499214?v=3" width="100px;"/>](https://github.com/KaYBlitZ) |
| -------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------- |
| AbdulRahman AlHamali                                                                                                       | S McDowall                                                                                                       | Kenneth Liang                                                                                                  |

## Shout out to the contributors!

This project is the result of the collective effort of contributors who participated effectively by submitting pull requests, reporting issues, and answering questions. Thank you for your proactiveness, and we hope `flutter_typeahead` made your lifes at least a little easier!

## How you can help

[Contribution Guidelines](CONTRIBUTING.md)
