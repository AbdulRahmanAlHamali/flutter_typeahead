import 'package:example/scroll_example.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'package:example/data.dart';

class MyMaterialApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter_typeahead demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            title: TabBar(tabs: [
              Tab(text: 'Example 1: Navigation'),
              Tab(text: 'Example 2: Form'),
              Tab(text: 'Example 3: Scroll')
            ]),
          ),
          body: TabBarView(children: [
            NavigationExample(),
            FormExample(),
            ScrollExample(),
          ])),
    );
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
                leading: Icon(Icons.shopping_cart),
                title: Text(suggestion['name']!),
                subtitle: Text('\$${suggestion['price']}'),
              );
            },
            onSuggestionSelected: (Map<String, String> suggestion) {
              Navigator.of(context).push<void>(MaterialPageRoute(
                  builder: (context) => ProductPage(product: suggestion)));
            },
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

  @override
  Widget build(BuildContext context) {
    return Form(
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
              suggestionsCallback: (pattern) {
                return CitiesService.getSuggestions(pattern);
              },
              itemBuilder: (context, String suggestion) {
                return ListTile(
                  title: Text(suggestion),
                );
              },
              transitionBuilder: (context, suggestionsBox, controller) {
                return suggestionsBox;
              },
              onSuggestionSelected: (String suggestion) {
                this._typeAheadController.text = suggestion;
              },
              validator: (value) =>
                  value!.isEmpty ? 'Please select a city' : null,
              onSaved: (value) => this._selectedCity = value,
            ),
            SizedBox(
              height: 10.0,
            ),
            ElevatedButton(
              child: Text('Submit'),
              onPressed: () {
                if (this._formKey.currentState!.validate()) {
                  this._formKey.currentState!.save();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('Your Favorite City is ${this._selectedCity}'),
                    ),
                  );
                }
              },
            )
          ],
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
              style: Theme.of(context).textTheme.headline5,
            ),
            Text(
              this.product['price']! + ' USD',
              style: Theme.of(context).textTheme.subtitle1,
            )
          ],
        ),
      ),
    );
  }
}
