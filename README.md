# Flutter TypeAhead
A TypeAhead widget for Flutter, where you can show suggestions to
users as they type

<img src="https://raw.githubusercontent.com/AbdulRahmanAlHamali/flutter_typeahead/master/flutter_typeahead.gif">

## Features
* Shows suggestions in an overlay that floats on top of other widgets
* Allows you to specify what the suggestions will look like through a
builder function
* Allows you to specify what happens when the user taps a suggestion
* Accepts all the parameters that traditional `TextFields` accept, like
decoration, custom `TextEditingController`, text styling, etc.
* Provides two versions, a normal version and a [FormField](https://docs.flutter.io/flutter/widgets/FormField-class.html)
version that accepts validation, submitting, etc.
* Provides high customizability; you can customize the suggestion box decoration,
the loading bar, the animation, the debounce duration, etc.

## Installation
See the [installation instructions on pub](https://pub.dartlang.org/packages/flutter_typeahead#-installing-tab-).

## Usage examples
After you import the package:
```dart
import 'package:flutter_typeahead/flutter_typeahead.dart';
```

You can then use it as follows:
```dart
TypeAheadField(
  autofocus: true,
  style: DefaultTextStyle.of(context).style.copyWith(
    fontStyle: FontStyle.italic
  ),
  decoration: InputDecoration(
    border: OutlineInputBorder()
  ),
  suggestionsCallback: (pattern) async {
    return BackendService.getSuggestions(pattern);
  },
  itemBuilder: (context, suggestion) {
    return ListTile(
      leading: Icon(Icons.shopping_cart),
      title: Text(suggestion['name']),
      subtitle: Text('\$${suggestion['price']}'),
    );
  },
  onSuggestionSelected: (suggestion) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ProductPage(product: suggestion)
    ));
  },
)
```
In the code above, the `autfocus`, `style` and `decoration` are the same as
those of `TextField`, and are not mandatory.

The `suggestionCallback` is called with the search string that the user
types, and is expected to return a `List` of data, either synchronously or
asynchronously. In this example, we call some function called
`BackendService.getSuggestions` and provide it with the search pattern

The `itemBuilder` is called to build a widget for each suggestion.
In this example, we build a simple `ListTile` that shows the name and the
price of the item. Please note that you shouldn't provide an `onTap`
callback here. The TypeAhead widget takes care of that.

The `onSuggestionSelected` is a callback that provides us with the
suggestion that the user tapped. In this example, when the user taps a
suggestion, we navigate to a page that shows us the information of the
tapped product.

Here's another example, where we use the TypeAheadFormField inside a `Form`:
```dart
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
final TextEditingController _typeAheadController = TextEditingController();
String _selectedCity;
...
..
.
Form(
  key: this._formKey,
  child: Padding(
    padding: EdgeInsets.all(32.0),
    child: Column(
      children: <Widget>[
        Text(
          'What is your favorite city?'
        ),
        TypeAheadFormField(
          controller: this._typeAheadController,
          decoration: InputDecoration(
            labelText: 'City'
          ),
          suggestionsCallback: (pattern) {
            return CitiesService.getSuggestions(pattern);
          },
          itemBuilder: (context, suggestion) {
            return ListTile(
              title: Text(suggestion),
            );
          },
          transitionBuilder: (context, suggestionsBox, controller) {
            return suggestionsBox;
          },
          onSuggestionSelected: (suggestion) {
            this._typeAheadController.text = suggestion;
          },
          validator: (value) {
            if (value.isEmpty) {
              return 'Please select a city';
            }
          },
          onSaved: (value) => this._selectedCity = value,
        ),
        SizedBox(height: 10.0,),
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
Here, we are assigning to the `controller` property a
`TextEditingController` that we called `_typeAheadController`. We use this
controller in the `onSuggestionSelected` callback to set the value of the
`TextField` to the selected suggestion.

The `validator` callback can be used like any `FormField.validator` function.
In our example, it checks whether a value has been entered, and displays an
error message if not. The `onSaved` callback is used to save the value of
the field to the `_selectedCity` member variable

The `transitionBuilder` allows us to customize the animation of the
suggestion box. In this example, we are just returning the suggestionBox
immediately, meaning that we don't want any animation.

## Customizations
TypeAhead widgets consist of a `TextField` and a suggestion box that shows
as the user types. Both are highly customizable

### Customizing the TextField
You can customize the field with all the usual customizations available for
`TextField` in Flutter. Examples include: decoration, style, controller,
focusNode, autofocus, enabled, etc.

### Customizing the Suggestions Box
TypeAhead provides default configurations for the suggestions box. You can,
however, override most of them.

#### Customizing the loader, the error and the "no items found" message
You can use the loadingBuilder, errorBuilder and noItemsFoundBuilder to
customize their corresponding widgets. For example, to show a custom error
widget:
```dart
errorBuilder: (BuildContext context, Object error) =>
  Text(
    '$error',
    style: TextStyle(
      color: Theme.of(context).errorColor
    )
  )
```
#### Customizing the animation
You can customize the suggestion box animation through 3 parameters: the
`animationDuration`, the `animationStart`, and the `transitionBuilder`. The
`animationDuration` specifies how long the animation should take, while the
`animationStart` specified what point (between 0.0 and 1.0) the animation
should start from. The `transitionBuilder` accepts the `suggestionsBox` and
`animationController` as parameters, and should return a widget that uses
the `animationController` to animate the display of the `suggestionsBox`.
For example:
```dart
transitionBuilder: (context, suggestionsBox, animationController) =>
  FadeTransition(
    child: suggestionsBox,
    opacity: CurvedAnimation(
      parent: animationController,
      curve: Curves.fastOutSlowIn
    ),
  )
```
In order to fully remove the animation, this callback should simply return
the `suggestionsBox`. This callback could also be used to wrap the
`suggestionsBox` with any desired widgets, not necessarily for animation.

#### Customizing the debounce duration
The suggestion box does not fire for each character the user types. Instead,
we wait until the user is idle for a duration of time, and then we call the
`suggestionsCallback`. The duration defaults to 300 milliseconds, but can be
configured using the `debounceDuration` parameter

#### Customizing the decoration of the suggestions box
You can also customize the decoration of the suggestions box. For example,
to give it a blue border, you can write:
```dart
decoration: BoxDecoration(
  border: Border.all(
    color: Colors.blue
  )
)
```