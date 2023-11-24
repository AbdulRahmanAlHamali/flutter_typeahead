import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_typeahead/src/common/base/suggestions_controller.dart';
import 'package:flutter_typeahead/src/common/box/suggestions_box_traversal_connector.dart';

void main() {
  group('SuggestionsBoxTraversalConnector', () {
    late SuggestionsController controller;

    setUp(() {
      controller = SuggestionsController();
    });

    tearDown(() {
      controller.dispose();
    });

    testWidgets('sets field focus when arrow up pressed and direction is down',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SuggestionsBoxTraversalConnector(
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

      expect(controller.focusState, SuggestionsFocusState.field);
    });

    testWidgets('sets field focus when arrow down pressed and direction is up',
        (WidgetTester tester) async {
      controller.effectiveDirection = VerticalDirection.up;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SuggestionsBoxTraversalConnector(
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

      expect(controller.focusState, SuggestionsFocusState.field);
    });

    testWidgets('focuses first child node when focused',
        (WidgetTester tester) async {
      FocusNode node = FocusNode();

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SuggestionsBoxTraversalConnector(
              controller: controller,
              child: Focus(
                focusNode: node,
                child: const SizedBox(),
              ),
            ),
          ),
        ),
      );

      controller.focusBox();
      await tester.pump();
      expect(node.hasFocus, isTrue);
    });

    testWidgets('unfocuses node if no child is focused',
        (WidgetTester tester) async {
      FocusNode node = FocusNode();

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SuggestionsBoxTraversalConnector(
              controller: controller,
              child: Focus(
                focusNode: node,
                autofocus: true,
                child: const SizedBox(),
              ),
            ),
          ),
        ),
      );

      node.unfocus();
      await tester.pump();

      expect(controller.focusState, SuggestionsFocusState.blur);
    });
  });
}
