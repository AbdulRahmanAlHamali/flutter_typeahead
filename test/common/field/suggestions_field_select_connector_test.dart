import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_typeahead/src/common/base/suggestions_controller.dart';
import 'package:flutter_typeahead/src/common/field/suggestions_field_select_connector.dart';

void main() {
  group('SuggestionsFieldSelectConnector', () {
    late SuggestionsController controller;

    setUp(() {
      controller = SuggestionsController();
    });

    tearDown(() {
      controller.dispose();
    });

    testWidgets(
        'closes the suggestions box when a suggestion is selected and hideOnSelect is true',
        (WidgetTester tester) async {
      final connector = SuggestionsFieldSelectConnector(
        controller: controller,
        hideOnSelect: true,
        child: const SizedBox(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: connector,
          ),
        ),
      );

      controller.open();
      expect(controller.isOpen, isTrue);

      controller.select('test');
      await tester.pump();

      expect(controller.isOpen, isFalse);
    });

    testWidgets(
        'does not close the suggestions box when a suggestion is selected and hideOnSelect is false',
        (WidgetTester tester) async {
      final connector = SuggestionsFieldSelectConnector(
        controller: controller,
        hideOnSelect: false,
        child: const SizedBox(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: connector,
          ),
        ),
      );

      controller.open();
      expect(controller.isOpen, isTrue);

      controller.select('test');
      await tester.pump();

      expect(controller.isOpen, isTrue);
    });

    testWidgets('calls onSelected when a suggestion is selected',
        (WidgetTester tester) async {
      String? selectedValue;

      final connector = SuggestionsFieldSelectConnector(
        controller: controller,
        child: const SizedBox(),
        onSelected: (value) {
          selectedValue = value;
        },
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: connector,
          ),
        ),
      );

      controller.select('test');
      await tester.pump();

      expect(selectedValue, 'test');
    });
  });
}
