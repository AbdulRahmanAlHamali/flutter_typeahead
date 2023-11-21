import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_typeahead/src/common/base/suggestions_controller.dart';
import 'package:flutter_typeahead/src/common/field/suggestions_field_keyboard_connector.dart';

void main() {
  group('SuggestionsFieldKeyboardConnector', () {
    late SuggestionsController controller;
    late Widget child;

    setUp(() {
      controller = SuggestionsController();
      child = Container();
    });

    tearDown(() {
      controller.dispose();
    });

    testWidgets('closes suggestions box when keyboard is hidden',
        (WidgetTester tester) async {
      KeyboardVisibilityTesting.setVisibilityForTesting(true);
      controller.open();

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SuggestionsFieldKeyboardConnector(
              controller: controller,
              hideWithKeyboard: true,
              child: child,
            ),
          ),
        ),
      );

      KeyboardVisibilityTesting.setVisibilityForTesting(false);

      await tester.pump();

      expect(controller.isOpen, isFalse);
    });

    testWidgets(
        'does not close suggestions box when keyboard is hidden and hideOnUnfocus is false',
        (WidgetTester tester) async {
      KeyboardVisibilityTesting.setVisibilityForTesting(true);
      controller.open();

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SuggestionsFieldKeyboardConnector(
              controller: controller,
              hideWithKeyboard: false,
              child: child,
            ),
          ),
        ),
      );

      KeyboardVisibilityTesting.setVisibilityForTesting(false);

      await tester.pump();

      expect(controller.isOpen, isTrue);
    });
  });
}
