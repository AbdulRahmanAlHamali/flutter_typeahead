import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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
      tester.view.viewInsets =
          const FakeViewPadding(bottom: 300);
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

      tester.view.viewInsets = FakeViewPadding.zero;
      // Trigger didChangeMetrics by pumping after inset change.
      await tester.pump();

      expect(controller.isOpen, isFalse);

      tester.view.resetViewInsets();
    });

    testWidgets(
        'does not close suggestions box when keyboard is hidden and hideOnUnfocus is false',
        (WidgetTester tester) async {
      tester.view.viewInsets =
          const FakeViewPadding(bottom: 300);
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

      tester.view.viewInsets = FakeViewPadding.zero;
      await tester.pump();

      expect(controller.isOpen, isTrue);

      tester.view.resetViewInsets();
    });
  });
}
