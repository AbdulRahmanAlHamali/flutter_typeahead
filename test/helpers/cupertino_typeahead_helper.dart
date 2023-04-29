import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

/// Helper class to get the cupertino typeahead test page
class CupertinoTypeAheadHelper {
  static Widget getCupertinoTypeAheadPage() {
    return MaterialApp(
      home: CupertinoTypeAheadPage(),
    );
  }
}

/// The widget that will be returned for the cupertino typeahead test page
class CupertinoTypeAheadPage extends StatefulWidget {
  final String? title;

  const CupertinoTypeAheadPage({Key? super.key, this.title});

  @override
  State<CupertinoTypeAheadPage> createState() => _CupertinoTypeAheadPageState();
}

class _CupertinoTypeAheadPageState extends State<CupertinoTypeAheadPage> {
  final List<TextEditingController> _controllers = [];

  /// Items that will be used to search
  final List<String> foodItems = [
    "Bread",
    "Burger",
    "Cheese",
    "Milk",
    "Milkshake",
    "Orange"
  ];

  /// This is to trigger a loading builder when searching for items
  Future<List<String>> _getFoodItems(String pattern) async {
    pattern = pattern.trim();
    if (pattern.isNotEmpty) {
      return Future.delayed(
          const Duration(seconds: 2),
              () => foodItems
              .where(
                  (item) => item.toLowerCase().contains(pattern.toLowerCase()))
              .toList());
    } else {
      return Future.delayed(const Duration(seconds: 2), () => []);
    }
  }

  /// Widget that will be displayed when no results were found
  Widget _getNoResultText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text("No results found!"),
    );
  }

  /// Widget that returns the CupertineTypeAheadFormField
  Widget _getTypeAhead() {
    final controller = TextEditingController();
    _controllers.add(controller);

    return CupertinoTypeAheadFormField<String>(
      textFieldConfiguration: CupertinoTextFieldConfiguration(
        inputFormatters: [LengthLimitingTextInputFormatter(50)],
        controller: controller,
      ),
      autoFlipDirection: true,
      loadingBuilder: (context) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          constraints: BoxConstraints(
            minHeight: 50,
            maxHeight: 150,
          ),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
      suggestionsCallback: _getFoodItems,
      noItemsFoundBuilder: _getNoResultText,
      itemBuilder: (context, String suggestion) {
        return CupertinoListTile(
          backgroundColor: Colors.white,
          title: Text(suggestion),
        );
      },
      suggestionsBoxDecoration: CupertinoSuggestionsBoxDecoration(
        hasScrollbar: true,
      ),
      getImmediateSuggestions: false,
      onSuggestionSelected: (String suggestion) => controller.text = suggestion,
      minCharsForSuggestions: 1,
    );
  }

  @override
  void dispose() {
    for (TextEditingController controller in _controllers) controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Cupertino TypeAhead test'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10),
          child: ListView.separated(
            shrinkWrap: true,
            separatorBuilder: (context, index) => SizedBox(height: 100),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => _getTypeAhead(),
            itemCount: 6,
          ),
        ),
      ),
    );
  }
}
