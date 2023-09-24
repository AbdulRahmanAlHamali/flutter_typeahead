import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

/// Helper class to get the material typeahead test page
class MaterialTypeAheadHelper {
  static Widget getMaterialTypeAheadPage({
    SuggestionsBoxDecoration? suggestionsBoxDecoration,
  }) {
    return MaterialApp(
      home: MaterialTypeAheadPage(
        suggestionsBoxDecoration: suggestionsBoxDecoration,
      ),
    );
  }
}

/// The widget that will be returned for the material typeahead test page
class MaterialTypeAheadPage extends StatefulWidget {
  final String? title;
  final SuggestionsBoxDecoration? suggestionsBoxDecoration;
  const MaterialTypeAheadPage({
    super.key,
    this.title,
    this.suggestionsBoxDecoration,
  });

  @override
  State<MaterialTypeAheadPage> createState() => _MaterialTypeAheadPageState();
}

class _MaterialTypeAheadPageState extends State<MaterialTypeAheadPage> {
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
    return const Padding(
      padding: EdgeInsets.all(10),
      child: Text("No results found!"),
    );
  }

  /// Widget that returns the MaterialTypeAheadFormField
  Widget _getTypeAhead() {
    final controller = TextEditingController();
    _controllers.add(controller);

    return TypeAheadFormField<String>(
      textFieldConfiguration: TextFieldConfiguration(
        inputFormatters: [LengthLimitingTextInputFormatter(50)],
        controller: controller,
        decoration: InputDecoration(
            labelText: "Please provide a search term",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            )),
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
          constraints: const BoxConstraints(
            minHeight: 50,
            maxHeight: 150,
          ),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
      suggestionsCallback: _getFoodItems,
      noItemsFoundBuilder: _getNoResultText,
      itemBuilder: (context, String suggestion) {
        return ListTile(
          tileColor: Colors.white,
          title: Text(suggestion),
        );
      },
      suggestionsBoxDecoration: (widget.suggestionsBoxDecoration == null)
          ? const SuggestionsBoxDecoration(
              elevation: 2,
              hasScrollbar: true,
            )
          : widget.suggestionsBoxDecoration!,
      getImmediateSuggestions: false,
      onSuggestionSelected: (String suggestion) => controller.text = suggestion,
      minCharsForSuggestions: 1,
    );
  }

  @override
  void dispose() {
    for (TextEditingController controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Material TypeAhead test'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(10),
        separatorBuilder: (context, index) => const SizedBox(height: 100),
        itemBuilder: (context, index) => _getTypeAhead(),
        itemCount: 6,
      ),
    );
  }
}
