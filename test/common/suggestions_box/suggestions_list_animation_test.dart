import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_list_animation.dart';

void main() {
  group('SuggestionsListAnimation', () {
    late SuggestionsController controller;

    setUp(() {
      controller = SuggestionsController();
    });

    tearDown(() {
      controller.dispose();
    });

    testWidgets('starts hidden when the controller is not open',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SuggestionsListAnimation(
              controller: controller,
              child: const SizedBox(key: Key('child')),
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('child')), findsNothing);
    });

    testWidgets('starts visible when the controller is open',
        (WidgetTester tester) async {
      controller.open();
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SuggestionsListAnimation(
              controller: controller,
              child: const SizedBox(key: Key('child')),
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('child')), findsOneWidget);
    });

    testWidgets('becomes visible when the controller opens',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SuggestionsListAnimation(
              controller: controller,
              child: const SizedBox(key: Key('child')),
            ),
          ),
        ),
      );

      controller.open();
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('child')), findsOneWidget);
    });

    testWidgets('becomes hidden when the controller closes',
        (WidgetTester tester) async {
      controller.open();
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SuggestionsListAnimation(
              controller: controller,
              child: const SizedBox(key: Key('child')),
            ),
          ),
        ),
      );

      controller.close();
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('child')), findsNothing);
    });
  });
}
