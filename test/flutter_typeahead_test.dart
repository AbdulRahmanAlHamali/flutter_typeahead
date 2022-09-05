import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class TestPage extends StatefulWidget {
  final int minCharsForSuggestions;
  TestPage({Key? key, this.minCharsForSuggestions: 0}) : super(key: key);

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
        // https://medium.com/flutterpub/create-beautiful-forms-with-flutter-47075cfe712
        body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            children: [
              TypeAheadFormField<String>(
                textFieldConfiguration: TextFieldConfiguration(
                    autofocus: true,
                    inputFormatters: [LengthLimitingTextInputFormatter(50)],
                    controller: _controller,
                    decoration: InputDecoration(labelText: 'Type Ahead')),
                suggestionsCallback: (pattern) {
                  if (pattern.length > 0)
                    return [pattern + 'aaa', pattern + 'bbb'];
                  else
                    return [];
                },
                noItemsFoundBuilder: (context) => const SizedBox(),
                itemBuilder: (context, String suggestion) {
                  return ListTile(
                    title: Text(suggestion),
                  );
                },
                onSuggestionSelected: (String suggestion) =>
                    this._controller.text = suggestion,
                minCharsForSuggestions: widget.minCharsForSuggestions,
              ),
            ],
          ),
        ));
  }
}

class CupertinoTestPage extends StatefulWidget {
  final int minCharsForSuggestions;
  CupertinoTestPage({Key? key, this.minCharsForSuggestions: 0})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => CupertinoTestPageState();
}

class CupertinoTestPageState extends State<CupertinoTestPage> {
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
        // https://medium.com/flutterpub/create-beautiful-forms-with-flutter-47075cfe712
        body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            children: [
              CupertinoTypeAheadFormField<String>(
                  textFieldConfiguration: CupertinoTextFieldConfiguration(
                    autofocus: true,
                    inputFormatters: [LengthLimitingTextInputFormatter(50)],
                    controller: _controller,
                  ),
                  suggestionsCallback: (pattern) {
                    if (pattern.length > 0)
                      return [pattern + 'aaa', pattern + 'bbb'];
                    else
                      return [];
                  },
                  noItemsFoundBuilder: (context) => const SizedBox(),
                  itemBuilder: (context, String suggestion) {
                    return Text(suggestion);
                  },
                  onSuggestionSelected: (String suggestion) =>
                      this._controller.text = suggestion,
                  minCharsForSuggestions: widget.minCharsForSuggestions),
            ],
          ),
        ));
  }
}

void main() {
  group('TypeAheadFormField', () {
    testWidgets('load and dispose', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: TestPage()));
      await tester.pumpAndSettle();

      expect(find.text('Type Ahead'), findsOneWidget);
      expect(find.text('Default text'), findsOneWidget);
    });
    testWidgets('text input', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: TestPage()));
      await tester.pumpAndSettle();

      // Not using tester.enterText because the text input should already be focused.
      tester.testTextInput.enterText("test");
      await tester.pumpAndSettle(Duration(milliseconds: 2000));
      expect(find.text("testaaa"), findsOneWidget);
      expect(find.text("testbbb"), findsOneWidget);
      tester.testTextInput.enterText("test2");
      await tester.pumpAndSettle(Duration(milliseconds: 2000));
      expect(find.text("testaaa"), findsNothing);
      expect(find.text("testbbb"), findsNothing);
      expect(find.text("test2aaa"), findsOneWidget);
      expect(find.text("test2bbb"), findsOneWidget);
    });

    testWidgets('min chars for suggestions', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
          home: TestPage(
        minCharsForSuggestions: 4,
      )));
      await tester.pumpAndSettle();

      tester.testTextInput.enterText("333");
      await tester.pumpAndSettle(Duration(milliseconds: 2000));
      expect(find.text("333aaa"), findsNothing);
      expect(find.text("333bbb"), findsNothing);
      tester.testTextInput.enterText("4444");
      await tester.pumpAndSettle(Duration(milliseconds: 2000));
      expect(find.text("4444aaa"), findsOneWidget);
      expect(find.text("4444bbb"), findsOneWidget);
    });
    // testWidgets('entering text works', (WidgetTester tester) async {
    //   await tester.pumpWidget(MaterialApp(home: TestPage()));
    //   await tester.pumpAndSettle();
    //   await tester.enterText(find.byType(TypeAheadFormField), 'new text');
    // });

    testWidgets('handle key up/down events', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: TestPage()));
      await tester.pumpAndSettle();

      tester.testTextInput.enterText("keyTest");
      await tester.pumpAndSettle(Duration(milliseconds: 2000));

      final textFieldFinder = find.byKey(TestKeys.textFieldKey);
      final TextField textField = tester.firstWidget(textFieldFinder);

      final firstSuggestionText = find.text("keyTestaaa");
      final firstSuggestionWrapperFinder = find.ancestor(
          of: firstSuggestionText,
          matching: find.byKey(TestKeys.getSuggestionKey(0)));
      final InkWell firstSuggestion =
          tester.firstWidget(firstSuggestionWrapperFinder);

      expect(textFieldFinder, findsOneWidget);

      expect(firstSuggestionText, findsOneWidget);
      expect(firstSuggestionWrapperFinder, findsOneWidget);

      expect(textField.focusNode?.hasFocus, true);
      expect(firstSuggestion.focusNode?.hasFocus, false);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);

      expect(textField.focusNode?.hasFocus, false);
      expect(firstSuggestion.focusNode?.hasFocus, true);
    });
  });
  group('CupertinoTypeAheadFormField', () {
    testWidgets('load and dispose', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: CupertinoTestPage()));
      await tester.pumpAndSettle();

      expect(find.text('Default text'), findsOneWidget);
    });
    testWidgets('text input', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: CupertinoTestPage()));
      await tester.pumpAndSettle();

      // Not using tester.enterText because the text input should already be focused.
      tester.testTextInput.enterText("test");
      await tester.pump(Duration(milliseconds: 2000));
      expect(find.text("testaaa"), findsOneWidget);
      expect(find.text("testbbb"), findsOneWidget);
      tester.testTextInput.enterText("test2");
      await tester.pump(Duration(milliseconds: 2000));
      expect(find.text("testaaa"), findsNothing);
      expect(find.text("testbbb"), findsNothing);
      expect(find.text("test2aaa"), findsOneWidget);
      expect(find.text("test2bbb"), findsOneWidget);
    });

    testWidgets('min chars for suggestions', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
          home: TestPage(
        minCharsForSuggestions: 4,
      )));
      await tester.pumpAndSettle();

      tester.testTextInput.enterText("333");
      await tester.pumpAndSettle(Duration(milliseconds: 2000));
      expect(find.text("333aaa"), findsNothing);
      expect(find.text("333bbb"), findsNothing);
      tester.testTextInput.enterText("4444");
      await tester.pumpAndSettle(Duration(milliseconds: 2000));
      expect(find.text("4444aaa"), findsOneWidget);
      expect(find.text("4444bbb"), findsOneWidget);
    });
  });
}
