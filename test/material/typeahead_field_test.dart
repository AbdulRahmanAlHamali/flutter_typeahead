import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

void main() {
  group('TypeAheadField', () {
    testWidgets('renders', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: TypeAheadField<String>(
              itemBuilder: (context, value) => Text(value),
              onSelected: (value) {},
              suggestionsCallback: (search) {
                return ['a', 'b', 'c'];
              },
            ),
          ),
        ),
      );
    });
  });
}
