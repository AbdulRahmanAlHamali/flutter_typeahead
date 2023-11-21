import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_typeahead/src/common/base/suggestions_controller.dart';
import 'package:flutter_typeahead/src/common/field/suggestions_field_focus_connector.dart';
import 'package:flutter/material.dart';

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
        'focuses the controller when arrow down key is pressed and effective direction is down',
        (WidgetTester tester) async {
      controller.open();

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SuggestionsFieldFocusConnector(
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
        'focuses the controller when arrow up key is pressed and effective direction is up',
        (WidgetTester tester) async {
      controller.open();
      controller.effectiveDirection = VerticalDirection.up;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SuggestionsFieldFocusConnector(
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

    testWidgets('calls the previous onKeyEvent if ignored by inner callback',
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
            child: SuggestionsFieldFocusConnector(
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

    testWidgets('calls onfocus on controller when node loses focus',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SuggestionsFieldFocusConnector(
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

      expect(controller.focusState, SuggestionsFocusState.child);

      focusNode.unfocus();
      await tester.pump();

      expect(controller.focusState, SuggestionsFocusState.blur);
    });

    testWidgets('focuses when controller focuses', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Stack(
              children: [
                SuggestionsFieldFocusConnector(
                  controller: controller,
                  focusNode: focusNode,
                  child: Focus(
                    focusNode: focusNode,
                    child: const SizedBox(),
                  ),
                ),
                const Focus(
                  autofocus: true,
                  child: SizedBox(),
                ),
              ],
            ),
          ),
        ),
      );

      expect(focusNode.hasFocus, false);

      controller.focusChild();
      await tester.pump();

      expect(focusNode.hasFocus, true);
    });

    testWidgets('unfocuses when controller unfocuses child', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Stack(
              children: [
                SuggestionsFieldFocusConnector(
                  controller: controller,
                  focusNode: focusNode,
                  child: Focus(
                    autofocus: true,
                    focusNode: focusNode,
                    child: const SizedBox(),
                  ),
                ),
                const Focus(
                  child: SizedBox(),
                ),
              ],
            ),
          ),
        ),
      );

      expect(focusNode.hasFocus, true);

      controller.unfocus();
      await tester.pump();

      expect(focusNode.hasFocus, false);
    });

    testWidgets('opens suggestions box when focus is gained',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SuggestionsFieldFocusConnector(
            controller: controller,
            focusNode: focusNode,
            child: Focus(
              focusNode: focusNode,
              child: Container(),
            ),
          ),
        ),
      );

      focusNode.requestFocus();
      await tester.pump();

      expect(controller.isOpen, isTrue);
    });

    testWidgets('closes suggestions box when focus is lost',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SuggestionsFieldFocusConnector(
            controller: controller,
            focusNode: focusNode,
            child: Focus(
              focusNode: focusNode,
              child: Container(),
            ),
          ),
        ),
      );

      focusNode.requestFocus();
      await tester.pump();
      focusNode.unfocus();
      await tester.pump();

      expect(controller.isOpen, isFalse);
    });

    testWidgets('opens the suggestions list if node was already focused',
        (WidgetTester tester) async {
      focusNode.requestFocus();

      await tester.pumpWidget(
        MaterialApp(
          home: Focus(
            focusNode: focusNode,
            child: Container(),
          ),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: SuggestionsFieldFocusConnector(
            controller: controller,
            focusNode: focusNode,
            child: Focus(
              focusNode: focusNode,
              child: Container(),
            ),
          ),
        ),
      );

      expect(controller.isOpen, isTrue);
    });

    testWidgets(
        'does not close suggestions list when focus is lost and hideOnUnfocus is false',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SuggestionsFieldFocusConnector(
            controller: controller,
            focusNode: focusNode,
            hideOnUnfocus: false,
            child: Focus(
              focusNode: focusNode,
              child: Container(),
            ),
          ),
        ),
      );

      focusNode.requestFocus();
      await tester.pump();
      focusNode.unfocus();
      await tester.pump();

      expect(controller.isOpen, isTrue);
    });

    testWidgets('focuses the node if the suggestions box is open',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SuggestionsFieldFocusConnector(
            controller: controller,
            focusNode: focusNode,
            child: Focus(
              focusNode: focusNode,
              child: Container(),
            ),
          ),
        ),
      );

      controller.open();
      await tester.pump();

      expect(focusNode.hasFocus, isTrue);
    });

    testWidgets('unfocuses the node if the suggestions box is closed',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SuggestionsFieldFocusConnector(
            controller: controller,
            focusNode: focusNode,
            child: Focus(
              autofocus: true,
              focusNode: focusNode,
              child: Container(),
            ),
          ),
        ),
      );

      controller.close();
      await tester.pump();

      expect(focusNode.hasFocus, isFalse);
    });
  });
}
