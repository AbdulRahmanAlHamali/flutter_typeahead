import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_typeahead/src/common/box/suggestions_box.dart';
import 'package:flutter_typeahead/src/common/base/suggestions_controller.dart';

void main() {
  group('SuggestionsBox', () {
    late SuggestionsController controller;

    setUp(() {
      controller = SuggestionsController();
    });

    tearDown(() {
      controller.dispose();
    });

    testWidgets('builds correctly', (WidgetTester tester) async {
      controller.open();

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SuggestionsBox(
              controller: controller,
              builder: (context) => const SizedBox(
                key: Key('suggestions'),
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('suggestions')), findsOneWidget);
    });

    testWidgets('allows wrapping', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SuggestionsBox(
              controller: controller,
              builder: (context) => const SizedBox(),
              decorationBuilder: (context, child) => Container(
                key: const Key('wrapper'),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red),
                ),
                child: child,
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('wrapper')), findsOneWidget);
    });
  });
}
