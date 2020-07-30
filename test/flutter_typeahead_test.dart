import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class TestPage extends StatefulWidget {

  TestPage({Key key}) : super(key: key);

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
              TypeAheadFormField(
                textFieldConfiguration: TextFieldConfiguration (
                  autofocus: true,
                  inputFormatters: [LengthLimitingTextInputFormatter(50)],
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: 'Type Ahead'
                  )
                ),
                suggestionsCallback: (pattern) {
                  if (pattern != null && pattern.length > 0) return [pattern + 'aaa', pattern + 'bbb'];
                  else return null;
                },
                noItemsFoundBuilder: (context) => null,
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion),
                  );
                },
                onSuggestionSelected: (suggestion) =>  this._controller.text = suggestion
              ),
            ],
          ),
        )
    );
  }
}

void main() {
  testWidgets('Test load and dispose TypeAheadFormField', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: TestPage()));
    await tester.pumpAndSettle();

    expect(find.text('Type Ahead'), findsOneWidget);
    expect(find.text('Default text'), findsOneWidget);

  });
}
