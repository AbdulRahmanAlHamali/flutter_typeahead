import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_list_keyboard_connector.dart';

void main() {
  group('SuggestionsListKeyboardConnector Tests', () {
    late SuggestionsController controller;
    late List<FocusNode> focusNodes;
    late FocusNode outsideFocusNode;

    void onSuggestionsListUnfocus() {
      if (!controller.suggestionsFocused) {
        outsideFocusNode.requestFocus();
      }
    }

    setUp(() {
      controller = SuggestionsController();
      controller.addListener(onSuggestionsListUnfocus);
      focusNodes =
          List.generate(2, (_) => FocusNode(onKeyEvent: controller.onKeyEvent));
      outsideFocusNode = FocusNode(
        onKeyEvent: controller.onKeyEvent,
      );
    });

    tearDown(() {
      controller.removeListener(onSuggestionsListUnfocus);
      controller.dispose();
      for (final node in focusNodes) {
        node.dispose();
      }
      outsideFocusNode.dispose();
    });

    testWidgets(
        'Focus moves into, along, and out of the suggestion list with keyboard events',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SuggestionsListKeyboardConnector(
                controller: controller,
                direction: AxisDirection.down,
                child: Column(
                  children: List.generate(
                    focusNodes.length,
                    (index) => Focus(
                      focusNode: focusNodes[index],
                      child: const SizedBox(),
                    ),
                  ),
                ),
              ),
              Focus(
                focusNode: outsideFocusNode,
                autofocus: true,
                child: const SizedBox(),
              ),
            ],
          ),
        ),
      );

      // Focus starts outside the suggestion list
      expect(focusNodes.any((element) => element.hasFocus), isFalse);
      expect(controller.suggestionsFocused, isFalse);
      expect(outsideFocusNode.hasFocus, isTrue);

      // Focus moves into the suggestion list
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      expect(focusNodes.first.hasFocus, isTrue);
      expect(controller.suggestionsFocused, isTrue);

      // Focus moves along the suggestion list
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      expect(focusNodes.last.hasFocus, isTrue);

      // Focus stops at the end of the suggestion list
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      expect(focusNodes.last.hasFocus, isTrue);

      // Focus moves along the suggestion list
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await tester.pump();
      expect(focusNodes.first.hasFocus, isTrue);

      // Focus moves out of the suggestion list
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await tester.pump();
      expect(focusNodes.any((element) => element.hasFocus), isFalse);
      expect(controller.suggestionsFocused, isFalse);
    });

    testWidgets(
        'Focus moves in the opposite direction when AxisDirection is up',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SuggestionsListKeyboardConnector(
                controller: controller,
                direction: AxisDirection.up,
                child: Column(
                  children: List.generate(
                    focusNodes.length,
                    (index) => Focus(
                      focusNode: focusNodes[index],
                      child: const SizedBox(),
                    ),
                  ),
                ),
              ),
              Focus(
                focusNode: outsideFocusNode,
                autofocus: true,
                child: const SizedBox(),
              ),
            ],
          ),
        ),
      );

      // Focus moves into the suggestion list
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await tester.pump();
      expect(focusNodes.first.hasFocus, isTrue);
      expect(controller.suggestionsFocused, isTrue);

      // Focus moves out of the suggestion list
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      expect(focusNodes.any((element) => element.hasFocus), isFalse);
      expect(controller.suggestionsFocused, isFalse);
    });
  });
}
