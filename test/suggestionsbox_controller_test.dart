import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class TestPage extends StatefulWidget {
  final SuggestionsBoxController suggestionsBoxController;
  TestPage({Key? key, required this.suggestionsBoxController})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => TestPageState();
}

class TestPageState extends State<TestPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = 'Default text';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Test'),
        ),
        body: Form(
          key: _formKey,
          child: TypeAheadFormField<String>(
            suggestionsBoxController: widget.suggestionsBoxController,
            textFieldConfiguration: TextFieldConfiguration(
              controller: _controller,
            ),
            suggestionsCallback: (pattern) {
              return ['aaa'];
            },
            itemBuilder: (context, String suggestion) {
              return ListTile(
                title: Text(suggestion),
              );
            },
            onSuggestionSelected: (String suggestion) =>
                this._controller.text = suggestion,
          ),
        ));
  }
}

void main() {
  group('SuggestionsBoxController', () {
    testWidgets('open, close, toggle', (WidgetTester tester) async {
      final _suggestionsBoxController = SuggestionsBoxController();

      await tester.pumpWidget(MaterialApp(
          home: TestPage(suggestionsBoxController: _suggestionsBoxController)));
      await tester.pumpAndSettle();

      final textFieldFinder = find.byKey(TestKeys.textFieldKey);
      final TextField textField = tester.firstWidget(textFieldFinder);
      expect(textField.focusNode?.hasFocus, false);

      _suggestionsBoxController.open();
      await tester.pumpAndSettle(Duration(milliseconds: 100));
      expect(textField.focusNode?.hasFocus, true);
      expect(_suggestionsBoxController.isOpened(), true);
      var firstSuggestionText = find.text("aaa");
      expect(firstSuggestionText, findsOneWidget);

      _suggestionsBoxController.close();
      await tester.pumpAndSettle(Duration(milliseconds: 100));
      expect(textField.focusNode?.hasFocus, false);
      expect(_suggestionsBoxController.isOpened(), false);
      firstSuggestionText = find.text("aaa");
      expect(firstSuggestionText, findsNothing);

      _suggestionsBoxController.toggle();
      await tester.pumpAndSettle(Duration(milliseconds: 100));
      expect(textField.focusNode?.hasFocus, true);
      expect(_suggestionsBoxController.isOpened(), true);
      firstSuggestionText = find.text("aaa");
      expect(firstSuggestionText, findsOneWidget);

      _suggestionsBoxController.toggle();
      await tester.pumpAndSettle(Duration(milliseconds: 100));
      expect(textField.focusNode?.hasFocus, false);
      expect(_suggestionsBoxController.isOpened(), false);
      firstSuggestionText = find.text("aaa");
      expect(firstSuggestionText, findsNothing);
    });

    testWidgets('openUnfocused, closeUnfocused, toggleUnfocused',
        (WidgetTester tester) async {
      final _suggestionsBoxController = SuggestionsBoxController();

      await tester.pumpWidget(MaterialApp(
          home: TestPage(suggestionsBoxController: _suggestionsBoxController)));
      await tester.pumpAndSettle();

      final textFieldFinder = find.byKey(TestKeys.textFieldKey);
      final TextField textField = tester.firstWidget(textFieldFinder);
      expect(textField.focusNode?.hasFocus, false);

      _suggestionsBoxController.openUnfocused();
      await tester.pumpAndSettle(Duration(milliseconds: 100));
      expect(textField.focusNode?.hasFocus, false);
      expect(_suggestionsBoxController.isOpened(), true);
      var firstSuggestionText = find.text("aaa");
      expect(firstSuggestionText, findsOneWidget);

      _suggestionsBoxController.closeUnfocused();
      await tester.pumpAndSettle(Duration(milliseconds: 100));
      expect(textField.focusNode?.hasFocus, false);
      expect(_suggestionsBoxController.isOpened(), false);
      firstSuggestionText = find.text("aaa");
      expect(firstSuggestionText, findsNothing);

      _suggestionsBoxController.toggleUnfocused();
      await tester.pumpAndSettle(Duration(milliseconds: 100));
      expect(textField.focusNode?.hasFocus, false);
      expect(_suggestionsBoxController.isOpened(), true);
      firstSuggestionText = find.text("aaa");
      expect(firstSuggestionText, findsOneWidget);

      _suggestionsBoxController.toggleUnfocused();
      await tester.pumpAndSettle(Duration(milliseconds: 100));
      expect(textField.focusNode?.hasFocus, false);
      expect(_suggestionsBoxController.isOpened(), false);
      firstSuggestionText = find.text("aaa");
      expect(firstSuggestionText, findsNothing);
    });
  });
}
