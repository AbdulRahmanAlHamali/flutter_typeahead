import 'dart:async';
import 'dart:io' show Platform;
import 'dart:math';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

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
        scrollBehavior: const MaterialScrollBehavior().copyWith(
            dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch}),
        home: DefaultTabController(
          length: 4,
          child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.phone_iphone),
                  onPressed: () => setState(() {
                    isCupertino = true;
                  }),
                ),
                title: const TabBar(tabs: [
                  Tab(text: 'Example 1: Navigation'),
                  Tab(text: 'Example 2: Form'),
                  Tab(text: 'Example 3: Scroll'),
                  Tab(text: 'Example 4: Alternative Layout')
                ]),
              ),
              body: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: const TabBarView(
                  children: [
                    NavigationExample(),
                    FormExample(),
                    ScrollExample(),
                    AlternativeLayoutExample(),
                  ],
                ),
              )),
        ),
      );
    } else {
      return CupertinoApp(
        title: 'Cupertino demo',
        theme: const CupertinoThemeData(
          brightness: Brightness.light,
        ),
        home: Scaffold(
          appBar: CupertinoNavigationBar(
            leading: IconButton(
              icon: const Icon(Icons.android),
              onPressed: () => setState(() {
                isCupertino = false;
              }),
            ),
            middle: const Text('Cupertino demo'),
          ),
          body: const CupertinoPageScaffold(
            child: CupertinoFormExample(),
          ),
        ), //MyHomePage(),
      );
    }
  }
}

class NavigationExample extends StatelessWidget {
  const NavigationExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
              autofillHints: ["AutoFillHints 1", "AutoFillHints 2"],
              autofocus: true,
              style: DefaultTextStyle.of(context)
                  .style
                  .copyWith(fontStyle: FontStyle.italic),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'What are you looking for?',
              ),
            ),
            suggestionsCallback: (pattern) =>
                BackendService.getSuggestions(pattern),
            itemBuilder: (context, suggestion) => ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: Text(suggestion['name']!),
              subtitle: Text('\$${suggestion['price']}'),
            ),
            itemSeparatorBuilder: (context, index) => const Divider(height: 1),
            onSuggestionSelected: (suggestion) {
              Navigator.of(context).push<void>(
                MaterialPageRoute(
                  builder: (context) => ProductPage(product: suggestion),
                ),
              );
            },
            suggestionsBoxDecoration: SuggestionsBoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              elevation: 8.0,
              color: Theme.of(context).cardColor,
            ),
          ),
        ),
      ],
    );
  }
}

class FormExample extends StatefulWidget {
  const FormExample({super.key});

  @override
  State<FormExample> createState() => _FormExampleState();
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
      onTap: () => suggestionBoxController.close(),
      child: Container(
        // Add zero opacity to make the gesture detector work
        color: Colors.amber.withOpacity(0),
        // Create the form for the user to enter their favorite city
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: [
                TypeAheadFormField(
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: _typeAheadController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'City',
                      hintText: 'What is your favorite city?',
                    ),
                  ),
                  suggestionsCallback: (pattern) =>
                      CitiesService.getSuggestions(pattern),
                  itemBuilder: (context, suggestion) => ListTile(
                    title: Text(suggestion),
                  ),
                  itemSeparatorBuilder: (context, index) => const Divider(),
                  transitionBuilder: (context, suggestionsBox, controller) =>
                      suggestionsBox,
                  onSuggestionSelected: (suggestion) =>
                      _typeAheadController.text = suggestion,
                  suggestionsBoxController: suggestionBoxController,
                  validator: (value) =>
                      value!.isEmpty ? 'Please select a city' : null,
                  onSaved: (value) => _selectedCity = value,
                ),
                const Spacer(),
                ElevatedButton(
                  child: const Text('Submit'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Your Favorite City is $_selectedCity'),
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
  const ProductPage({super.key, required this.product});

  final Map<String, String> product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product')),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          children: [
            Text(
              product['name']!,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              '${product['price']!} USD',
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
class ScrollExample extends StatefulWidget {
  const ScrollExample({super.key});

  @override
  State<ScrollExample> createState() => _ScrollExampleState();
}

class _ScrollExampleState extends State<ScrollExample> {
  final List<String> items = List.generate(50, (index) => "Item $index");

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 200),
        Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child:
                    Text("The suggestion box will resize as you are scrolling"),
              ),
              TypeAheadField<String>(
                getImmediateSuggestions: true,
                textFieldConfiguration: const TextFieldConfiguration(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'What are you looking for?',
                  ),
                ),
                suggestionsCallback: (pattern) => items
                    .where((item) => item.toLowerCase().startsWith(
                          pattern.toLowerCase(),
                        ))
                    .toList(),
                itemBuilder: (context, suggestion) => ListTile(
                  title: Text(suggestion),
                ),
                itemSeparatorBuilder: (context, index) => const Divider(),
                onSuggestionSelected: (suggestion) =>
                    ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Selected Item $suggestion'),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 500),
      ],
    );
  }
}

class AlternativeLayoutExample extends StatelessWidget {
  const AlternativeLayoutExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(32),
          child: TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
              autofocus: true,
              style: DefaultTextStyle.of(context)
                  .style
                  .copyWith(fontStyle: FontStyle.italic),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'What are you looking for?',
              ),
            ),
            suggestionsCallback: (pattern) =>
                BackendService.getSuggestions(pattern),
            itemBuilder: (context, suggestion) => ListTile(
              tileColor: Theme.of(context).colorScheme.secondaryContainer,
              leading: const Icon(Icons.shopping_cart),
              title: Text(suggestion['name']!),
              subtitle: Text('\$${suggestion['price']}'),
            ),
            layoutArchitecture: (items, scrollContoller) => GridView.count(
              controller: scrollContoller,
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 5 / 5,
              primary: false,
              shrinkWrap: true,
              children: items.toList(),
            ),
            onSuggestionSelected: (Map<String, String> suggestion) {
              Navigator.of(context).push<void>(
                MaterialPageRoute(
                  builder: (context) => ProductPage(product: suggestion),
                ),
              );
            },
            suggestionsBoxDecoration: SuggestionsBoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              elevation: 8.0,
              color: Theme.of(context).cardColor,
            ),
          ),
        ),
      ],
    );
  }
}

/// This is a fake service that mimics a backend service.
/// It returns a list of suggestions after a 1 second delay.
/// In a real app, this would be a service that makes a network request.
class BackendService {
  static Future<List<Map<String, String>>> getSuggestions(String query) async {
    await Future<void>.delayed(const Duration(seconds: 1));

    return List.generate(3, (index) {
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

  static Future<List<String>> getSuggestions(String query) async {
    List<String> matches = <String>[];
    matches.addAll(cities);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}

class CupertinoFormExample extends StatefulWidget {
  const CupertinoFormExample({super.key});

  @override
  State<CupertinoFormExample> createState() => _FavoriteCitiesPage();
}

class _FavoriteCitiesPage extends State<CupertinoFormExample> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _typeAheadController = TextEditingController();
  final SuggestionsBoxController _suggestionsBoxController =
      SuggestionsBoxController();
  String favoriteCity = 'Unavailable';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _suggestionsBoxController.close,
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('What is your favorite city?'),
                  const SizedBox(height: 10),
                  CupertinoTypeAheadFormField(
                    suggestionsBoxController: _suggestionsBoxController,
                    suggestionsBoxDecoration: CupertinoSuggestionsBoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textFieldConfiguration: CupertinoTextFieldConfiguration(
                      controller: _typeAheadController,
                    ),
                    suggestionsCallback: (pattern) => Future.delayed(
                      const Duration(seconds: 1),
                      () => CitiesService.getSuggestions(pattern),
                    ),
                    itemBuilder: (context, suggestion) => Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(
                        suggestion,
                      ),
                    ),
                    itemSeparatorBuilder: (context, index) => const Divider(),
                    onSuggestionSelected: (suggestion) =>
                        _typeAheadController.text = suggestion,
                    validator: (value) =>
                        value!.isEmpty ? 'Please select a city' : null,
                  ),
                ],
              ),
              const Spacer(),
              CupertinoButton(
                child: const Text('Submit'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    setState(() => favoriteCity = _typeAheadController.text);
                  }
                },
              ),
              const SizedBox(height: 10),
              Text(
                'Your favorite city is $favoriteCity!',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
