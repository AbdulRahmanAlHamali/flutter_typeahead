import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_typeahead/src/common/base/suggestions_controller.dart';
import 'package:flutter_typeahead/src/common/box/suggestions_box_focus_connector.dart';

void main() {
  group('SuggestionsBoxFocusConnector', () {
    late SuggestionsController controller;

    setUp(() {
      controller = SuggestionsController();
    });

    tearDown(() {
      controller.dispose();
    });

    testWidgets('sets controller box focus state on focus',
        (WidgetTester tester) async {
      FocusNode node = FocusNode();

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SuggestionsBoxFocusConnector(
              controller: controller,
              child: Focus(
                focusNode: node,
                child: const SizedBox(),
              ),
            ),
          ),
        ),
      );

      expect(controller.focusState, SuggestionsFocusState.blur);
      node.requestFocus();

      await tester.pump();
      expect(controller.focusState, SuggestionsFocusState.box);
    });

    testWidgets('sets controller blur focus state on unfocus',
        (WidgetTester tester) async {
      controller.focusBox();
      FocusNode node = FocusNode();
      FocusNode otherNode = FocusNode();

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Column(
              children: [
                SuggestionsBoxFocusConnector(
                  controller: controller,
                  child: Focus(
                    focusNode: node,
                    child: const SizedBox(),
                  ),
                ),
                Focus(
                  focusNode: otherNode,
                  child: const SizedBox(),
                ),
              ],
            ),
          ),
        ),
      );

      otherNode.requestFocus();
      await tester.pump();

      expect(controller.focusState, SuggestionsFocusState.blur);
    });

    testWidgets(
        'sets controller child focus state when arrow up key is pressed and effective direction is down',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SuggestionsBoxFocusConnector(
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

    testWidgets(
        'sets controller child focus state when arrow down key is pressed and effective direction is up',
        (WidgetTester tester) async {
      controller.effectiveDirection = VerticalDirection.up;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SuggestionsBoxFocusConnector(
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

    testWidgets('unfocuses node when controller blur is called',
        (WidgetTester tester) async {
      FocusNode node = FocusNode();

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SuggestionsBoxFocusConnector(
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

      controller.unfocus();
      await tester.pump();
      expect(node.hasFocus, isFalse);
    });

    testWidgets('focuses node when controller focus box is called',
        (WidgetTester tester) async {
      FocusNode node = FocusNode();

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SuggestionsBoxFocusConnector(
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

    testWidgets('unfocuses if no child is focused',
        (WidgetTester tester) async {
      FocusNode node = FocusNode();

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SuggestionsBoxFocusConnector(
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
