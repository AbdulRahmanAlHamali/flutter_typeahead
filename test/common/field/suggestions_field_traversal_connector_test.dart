import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_typeahead/src/common/base/suggestions_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/src/common/field/suggestions_field_traversal_connector.dart';

void main() {
  group('SuggestionsFieldTraversalConnector', () {
    late SuggestionsController controller;
    late FocusNode focusNode;

    setUp(() {
      controller = SuggestionsController();
      focusNode = FocusNode();
    });

    tearDown(() {
      controller.dispose();
      focusNode.dispose();
    });

    testWidgets(
        'sets focus to box when direction down and arrow down key is pressed',
        (WidgetTester tester) async {
      controller.open();

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SuggestionsFieldTraversalConnector(
              controller: controller,
              focusNode: focusNode,
              child: Focus(
                autofocus: true,
                focusNode: focusNode,
                child: const SizedBox(),
              ),
            ),
          ),
        ),
      );

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();

      expect(controller.focusState, SuggestionsFocusState.box);
    });

    testWidgets(
        'sets focus to box when direction up and arrow up key is pressed',
        (WidgetTester tester) async {
      controller.open();
      controller.effectiveDirection = VerticalDirection.up;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SuggestionsFieldTraversalConnector(
              controller: controller,
              focusNode: focusNode,
              child: Focus(
                autofocus: true,
                focusNode: focusNode,
                child: const SizedBox(),
              ),
            ),
          ),
        ),
      );

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await tester.pump();

      expect(controller.focusState, SuggestionsFocusState.box);
    });

    testWidgets('proxies focus node key events when ignored by key handler',
        (WidgetTester tester) async {
      controller.open();
      bool previousOnKeyEventCalled = false;
      focusNode.onKeyEvent = (node, event) {
        previousOnKeyEventCalled = true;
        return KeyEventResult.ignored;
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SuggestionsFieldTraversalConnector(
              controller: controller,
              focusNode: focusNode,
              child: Focus(
                autofocus: true,
                focusNode: focusNode,
                child: const SizedBox(),
              ),
            ),
          ),
        ),
      );

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();

      expect(previousOnKeyEventCalled, true);
    });
  });
}
