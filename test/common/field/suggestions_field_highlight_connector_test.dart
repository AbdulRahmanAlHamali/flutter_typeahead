import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_typeahead/src/common/base/suggestions_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/src/common/field/suggestions_field_highlight_connector.dart';

void main() {
  group('SuggestionsFieldHighlightConnector', () {
    late SuggestionsController controller;

    setUp(() {
      controller = SuggestionsController();
      controller.suggestions = ['a', 'b'];
    });

    tearDown(() {
      controller.dispose();
    });

    testWidgets(
        'increments highlighted suggestion when direction down and arrow down key is pressed',
        (WidgetTester tester) async {
      controller.open();

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SuggestionsFieldHighlightConnector(
              controller: controller,
              child: const Focus(
                autofocus: true,
                child: SizedBox(),
              ),
            ),
          ),
        ),
      );

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();

      expect(controller.highlighted, 0);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);

      expect(controller.highlighted, 1);
    });

    testWidgets(
      'decrements highlighted suggestion when direction down and arrow up key is pressed',
      (WidgetTester tester) async {
        controller.open();
        controller.highlighted = 1;

        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: SuggestionsFieldHighlightConnector(
                controller: controller,
                child: const Focus(
                  autofocus: true,
                  child: SizedBox(),
                ),
              ),
            ),
          ),
        );

        await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
        await tester.pump();

        expect(controller.highlighted, 0);

        await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);

        expect(controller.highlighted, null);
      },
    );

    testWidgets(
        'increments highlighted suggestion when direction up and arrow up key is pressed',
        (WidgetTester tester) async {
      controller.open();
      controller.effectiveDirection = VerticalDirection.up;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SuggestionsFieldHighlightConnector(
              controller: controller,
              child: const Focus(
                autofocus: true,
                child: SizedBox(),
              ),
            ),
          ),
        ),
      );

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await tester.pump();

      expect(controller.highlighted, 0);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);

      expect(controller.highlighted, 1);
    });

    testWidgets('selects highlighted suggestion when enter key is pressed',
        (WidgetTester tester) async {
      controller.open();
      controller.highlighted = 1;
      String? selected;

      controller.selections.listen((event) {
        selected = event;
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SuggestionsFieldHighlightConnector(
              controller: controller,
              child: const Focus(
                autofocus: true,
                child: SizedBox(),
              ),
            ),
          ),
        ),
      );

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);

      expect(selected, 'b');
      expect(controller.highlighted, null);
    });

    testWidgets('closes suggestions when escape key is pressed',
        (WidgetTester tester) async {
      controller.open();
      controller.highlighted = 1;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SuggestionsFieldHighlightConnector(
              controller: controller,
              child: const Focus(
                autofocus: true,
                child: SizedBox(),
              ),
            ),
          ),
        ),
      );

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);

      expect(controller.isOpen, isFalse);
    });
  });
}
