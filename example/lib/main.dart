import 'dart:async';
import 'dart:io' show Platform;
import 'dart:math';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isCupertino = !kIsWeb && Platform.isIOS;

  @override
  Widget build(BuildContext context) {
    if (!isCupertino) {
      return MaterialApp(
        title: 'flutter_typeahead demo',
        scrollBehavior: MaterialScrollBehavior().copyWith(
            dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch}),
        home: DefaultTabController(
          length: 5,
          child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.phone_iphone),
                  onPressed: () => setState(() {
                    isCupertino = true;
                  }),
                ),
                title: TabBar(
                  isScrollable: true,
                  tabs: [
                    Tab(text: 'Example 1: Navigation'),
                    Tab(text: 'Example 2: Form'),
                    Tab(text: 'Example 3: Scroll'),
                    Tab(text: 'Example 4: Alternative Layout'),
                    Tab(text: 'Example 5: Pull to load more')
                  ],
                ),
              ),
              body: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: TabBarView(children: [
                  NavigationExample(),
                  FormExample(),
                  ScrollExample(),
                  AlternativeLayoutArchitecture(),
                  PullToLoadMorePage(),
                ]),
              )),
        ),
      );
    } else {
      return CupertinoApp(
        title: 'Cupertino demo',
        home: Scaffold(
          appBar: CupertinoNavigationBar(
            leading: IconButton(
              icon: Icon(Icons.android),
              onPressed: () => setState(() {
                isCupertino = false;
              }),
            ),
            middle: Text('Cupertino demo'),
          ),
          body: CupertinoPageScaffold(
            child: FavoriteCitiesPage(),
          ),
        ),
      );
    }
  }
}

class NavigationExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(32.0),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 10.0,
          ),
          TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
              autofillHints: ["AutoFillHints 1", "AutoFillHints 2"],
              autofocus: true,
              style: DefaultTextStyle.of(context)
                  .style
                  .copyWith(fontStyle: FontStyle.italic),
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'What are you looking for?'),
            ),
            suggestionsCallback: (String pattern) async {
              return await BackendService.getSuggestions(pattern);
            },
            showKeyboadAfterPressAgain: true,
            itemBuilder: (context, Map<String, String> suggestion) {
              return ListTile(
                leading: Icon(Icons.shopping_cart),
                title: Text(suggestion['name']!),
                subtitle: Text('\$${suggestion['price']}'),
              );
            },
            itemSeparatorBuilder: (context, index) {
              return Divider(height: 1);
            },
            onSuggestionSelected: (Map<String, String> suggestion) {
              Navigator.of(context).push<void>(MaterialPageRoute(
                  builder: (context) => ProductPage(product: suggestion)));
            },
            suggestionsBoxDecoration: SuggestionsBoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              elevation: 8.0,
              color: Theme.of(context).cardColor,
            ),
          ),
        ],
      ),
    );
  }
}

class FormExample extends StatefulWidget {
  @override
  _FormExampleState createState() => _FormExampleState();
}

class _FormExampleState extends State<FormExample> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _typeAheadController = TextEditingController();

  String? _selectedCity;

  SuggestionsBoxController suggestionBoxController = SuggestionsBoxController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // close the suggestions box when the user taps outside of it
      onTap: () {
        suggestionBoxController.close();
      },
      child: Container(
        // Add zero opacity to make the gesture detector work
        color: Colors.amber.withOpacity(0),
        // Create the form for the user to enter their favorite city
        child: Form(
          key: this._formKey,
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Column(
              children: <Widget>[
                Text('What is your favorite city?'),
                TypeAheadFormField(
                  textFieldConfiguration: TextFieldConfiguration(
                    decoration: InputDecoration(labelText: 'City'),
                    controller: this._typeAheadController,
                  ),
                  suggestionsCallback: (pattern, {int? page}) {
                    return CitiesService.getSuggestions(pattern);
                  },
                  itemBuilder: (context, String suggestion) {
                    return ListTile(
                      title: Text(suggestion),
                    );
                  },
                  itemSeparatorBuilder: (context, index) {
                    return Divider();
                  },
                  transitionBuilder: (context, suggestionsBox, controller) {
                    return suggestionsBox;
                  },
                  onSuggestionSelected: (String suggestion) {
                    this._typeAheadController.text = suggestion;
                  },
                  suggestionsBoxController: suggestionBoxController,
                  validator: (value) =>
                      value!.isEmpty ? 'Please select a city' : null,
                  onSaved: (value) => this._selectedCity = value,
                ),
                Spacer(),
                ElevatedButton(
                  child: Text('Submit'),
                  onPressed: () {
                    if (this._formKey.currentState!.validate()) {
                      this._formKey.currentState!.save();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Your Favorite City is ${this._selectedCity}'),
                        ),
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProductPage extends StatelessWidget {
  final Map<String, String> product;

  ProductPage({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          children: [
            Text(
              this.product['name']!,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              this.product['price']! + ' USD',
              style: Theme.of(context).textTheme.titleMedium,
            )
          ],
        ),
      ),
    );
  }
}

/// This example shows how to use the [TypeAheadField] in a [ListView] that
/// scrolls. The [TypeAheadField] will resize to fit the suggestions box when
/// scrolling.
class ScrollExample extends StatelessWidget {
  final List<String> items = List.generate(50, (index) => "Item $index");

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Suggestion box will resize when scrolling"),
        ),
      ),
      SizedBox(height: 200),
      TypeAheadField<String>(
        getImmediateSuggestions: true,
        textFieldConfiguration: TextFieldConfiguration(
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'What are you looking for?'),
        ),
        suggestionsCallback: (String pattern) async {
          return items
              .where((item) =>
                  item.toLowerCase().startsWith(pattern.toLowerCase()))
              .toList();
        },
        itemBuilder: (context, String suggestion) {
          return ListTile(
            title: Text(suggestion),
          );
        },
        itemSeparatorBuilder: (context, index) {
          return Divider();
        },
        onSuggestionSelected: (String suggestion) {
          print("Suggestion selected");
        },
      ),
      SizedBox(height: 500),
    ]);
  }
}

/// This is a fake service that mimics a backend service.
/// It returns a list of suggestions after a 1 second delay.
/// In a real app, this would be a service that makes a network request.
class BackendService {
  static Future<List<Map<String, String>>> getSuggestions(String query,
      [int? page]) async {
    await Future<void>.delayed(Duration(seconds: 1));
    return List.generate(20, (index) {
      return {
        'name': query + index.toString(),
        'price': Random().nextInt(100).toString()
      };
    });
  }
}

/// A fake service to filter cities based on a query.
class CitiesService {
  static final List<String> cities = [
    'Beirut',
    'Damascus',
    'San Fransisco',
    'Rome',
    'Los Angeles',
    'Madrid',
    'Bali',
    'Barcelona',
    'Paris',
    'Bucharest',
    'New York City',
    'Philadelphia',
    'Sydney',
  ];

  static List<String> getSuggestions(String query) {
    List<String> matches = <String>[];
    matches.addAll(cities);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}

class FavoriteCitiesPage extends StatefulWidget {
  @override
  _FavoriteCitiesPage createState() => _FavoriteCitiesPage();
}

class _FavoriteCitiesPage extends State<FavoriteCitiesPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _typeAheadController = TextEditingController();
  CupertinoSuggestionsBoxController _suggestionsBoxController =
      CupertinoSuggestionsBoxController();
  String favoriteCity = 'Unavailable';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _suggestionsBoxController.close(),
      child: Container(
        color: Colors.amber.withOpacity(0),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 100.0,
                ),
                Text('What is your favorite city?'),
                CupertinoTypeAheadFormField(
                  getImmediateSuggestions: true,
                  suggestionsBoxController: _suggestionsBoxController,
                  suggestionsBoxDecoration: CupertinoSuggestionsBoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  textFieldConfiguration: CupertinoTextFieldConfiguration(
                    controller: _typeAheadController,
                  ),
                  suggestionsCallback: (pattern, {int? page}) {
                    return Future.delayed(
                      Duration(seconds: 1),
                      () => CitiesService.getSuggestions(pattern),
                    );
                  },
                  itemBuilder: (context, String suggestion) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        suggestion,
                      ),
                    );
                  },
                  itemSeparatorBuilder: (context, index) {
                    return Divider();
                  },
                  onSuggestionSelected: (String suggestion) {
                    _typeAheadController.text = suggestion;
                  },
                  validator: (value) =>
                      value!.isEmpty ? 'Please select a city' : null,
                ),
                SizedBox(
                  height: 10.0,
                ),
                CupertinoButton(
                  child: Text('Submit'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      setState(() {
                        favoriteCity = _typeAheadController.text;
                      });
                    }
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'Your favorite city is $favoriteCity!',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AlternativeLayoutArchitecture extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(32.0),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 10.0,
          ),
          TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
              autofocus: true,
              style: DefaultTextStyle.of(context)
                  .style
                  .copyWith(fontStyle: FontStyle.italic),
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'What are you looking for?'),
            ),
            suggestionsCallback: (pattern) async {
              return await BackendService.getSuggestions(pattern);
            },
            itemBuilder: (context, Map<String, String> suggestion) {
              return ListTile(
                tileColor: Theme.of(context).colorScheme.secondaryContainer,
                leading: Icon(Icons.shopping_cart),
                title: Text(suggestion['name']!),
                subtitle: Text('\$${suggestion['price']}'),
              );
            },
            layoutArchitecture: (items, scrollContoller) {
              return ListView(
                  controller: scrollContoller,
                  shrinkWrap: true,
                  children: [
                    GridView.count(
                      physics: const ScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 5 / 5,
                      shrinkWrap: true,
                      children: items.toList(),
                    ),
                  ]);
            },
            onSuggestionSelected: (Map<String, String> suggestion) {
              Navigator.of(context).push<void>(MaterialPageRoute(
                  builder: (context) => ProductPage(product: suggestion)));
            },
            suggestionsBoxDecoration: SuggestionsBoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              elevation: 8.0,
              color: Theme.of(context).cardColor,
            ),
          ),
        ],
      ),
    );
  }
}

class PullToLoadMorePage extends StatefulWidget {
  @override
  _PullToLoadMorePage createState() => _PullToLoadMorePage();
}

class _PullToLoadMorePage extends State<PullToLoadMorePage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(32.0),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 10.0,
          ),
          TypeAheadField.paged(
            textFieldConfiguration: TextFieldConfiguration(
              autofillHints: ["AutoFillHints 1", "AutoFillHints 2"],
              autofocus: true,
              style: DefaultTextStyle.of(context)
                  .style
                  .copyWith(fontStyle: FontStyle.italic),
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'What are you looking for?'),
            ),
            suggestionsLoadMoreCallback: (pattern, int? page) async {
              return await BackendService.getSuggestions(
                  "page${page}_$pattern", page);
            },
            //minCharsForSuggestions: 2,
            itemBuilder: (context, Map<String, String> suggestion) {
              return ListTile(
                leading: Icon(Icons.shopping_cart),
                title: Text(suggestion['name']!),
                subtitle: Text('\$${suggestion['price']}'),
              );
            },
            itemSeparatorBuilder: (context, index) {
              return Divider();
            },
            transitionBuilder: (context, suggestionsBox, controller) {
              return suggestionsBox;
            },
            onSuggestionSelected: (Map<String, String> suggestion) {
              Navigator.of(context).push<void>(MaterialPageRoute(
                  builder: (context) => ProductPage(product: suggestion)));
            },
            suggestionsBoxDecoration: SuggestionsBoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                elevation: 8.0,
                color: Theme.of(context).cardColor
                //constraints: BoxConstraints(maxHeight: 200)
                ),
          ),
        ],
      ),
    );
  }
}
