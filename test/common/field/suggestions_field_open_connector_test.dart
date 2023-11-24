import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_typeahead/src/common/base/suggestions_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/src/common/field/suggestions_field_open_connector.dart';

void main() {
  group('SuggestionsFieldOpenConnector', () {
    late SuggestionsController controller;

    setUp(() {
      controller = SuggestionsController();
    });

    tearDown(() {
      controller.dispose();
    });

    testWidgets('opens suggestions box when focus is gained',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SuggestionsFieldOpenConnector(
            controller: controller,
            child: const SizedBox(),
          ),
        ),
      );

      controller.focusField();
      await tester.pump();

      expect(controller.isOpen, isTrue);
    });

    testWidgets('closes suggestions box when focus is lost',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SuggestionsFieldOpenConnector(
            controller: controller,
            child: const SizedBox(),
          ),
        ),
      );

      controller.focusField();
      await tester.pump();
      controller.unfocus();
      await tester.pump();

      expect(controller.isOpen, isFalse);
    });

    testWidgets('opens the suggestions box if node was already focused',
        (WidgetTester tester) async {
      controller.focusField();

      await tester.pumpWidget(
        MaterialApp(
          home: SuggestionsFieldOpenConnector(
            controller: controller,
            child: const SizedBox(),
          ),
        ),
      );

      expect(controller.isOpen, isTrue);
    });

    testWidgets(
        'does not close suggestions box when focus is lost and hideOnUnfocus is false',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SuggestionsFieldOpenConnector(
            controller: controller,
            hideOnUnfocus: false,
            child: const SizedBox(),
          ),
        ),
      );

      controller.focusField();
      await tester.pump();
      controller.unfocus();
      await tester.pump();

      expect(controller.isOpen, isTrue);
    });

    testWidgets('focuses field when box is opened',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SuggestionsFieldOpenConnector(
            controller: controller,
            child: const SizedBox(),
          ),
        ),
      );

      controller.open();
      await tester.pump();

      expect(controller.focusState, SuggestionsFocusState.field);
    });

    testWidgets('unfocuses field when suggestions box is closed',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SuggestionsFieldOpenConnector(
            controller: controller,
            child: const SizedBox(),
          ),
        ),
      );

      controller.close();
      await tester.pump();

      expect(controller.focusState, SuggestionsFocusState.blur);
    });

    testWidgets('opens suggestions box when focus is box',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SuggestionsFieldOpenConnector(
            controller: controller,
            child: const SizedBox(),
          ),
        ),
      );

      controller.focusBox();
      await tester.pump();

      expect(controller.isOpen, isTrue);
    });
  });
}
