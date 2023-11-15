import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_controller.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_box_focus_connector.dart';

void main() {
  group('SuggestionsBoxFocusConnector', () {
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

    testWidgets('opens suggestions box when focus is gained',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SuggestionsBoxFocusConnector(
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
          home: SuggestionsBoxFocusConnector(
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
          home: SuggestionsBoxFocusConnector(
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
          home: SuggestionsBoxFocusConnector(
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
          home: SuggestionsBoxFocusConnector(
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
          home: SuggestionsBoxFocusConnector(
            controller: controller,
            focusNode: focusNode,
            child: Focus(
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

    testWidgets('proxies key events to the controller',
        (WidgetTester tester) async {
      bool keyEventCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: SuggestionsBoxFocusConnector(
            controller: controller,
            focusNode: focusNode,
            child: Focus(
              focusNode: focusNode,
              child: Container(),
            ),
          ),
        ),
      );

      controller.keys.listen((event) => keyEventCalled = true);

      focusNode.requestFocus();
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();

      expect(keyEventCalled, isTrue);
    });

    testWidgets('reconnects if new focus node is given',
        (WidgetTester tester) async {
      final newFocusNode = FocusNode();

      await tester.pumpWidget(
        MaterialApp(
          home: SuggestionsBoxFocusConnector(
            controller: controller,
            focusNode: focusNode,
            child: Focus(
              focusNode: focusNode,
              child: Container(),
            ),
          ),
        ),
      );

      newFocusNode.requestFocus();
      await tester.pump();

      await tester.pumpWidget(
        MaterialApp(
          home: SuggestionsBoxFocusConnector(
            controller: controller,
            focusNode: newFocusNode,
            child: Focus(
              focusNode: newFocusNode,
              child: Container(),
            ),
          ),
        ),
      );

      expect(controller.isOpen, isTrue);
    });

    testWidgets('reconnects if new controller is given',
        (WidgetTester tester) async {
      final newController = SuggestionsController();

      await tester.pumpWidget(
        MaterialApp(
          home: SuggestionsBoxFocusConnector(
            controller: controller,
            focusNode: focusNode,
            child: Focus(
              focusNode: focusNode,
              child: Container(),
            ),
          ),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: SuggestionsBoxFocusConnector(
            controller: newController,
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

      expect(newController.isOpen, isTrue);
    });
  });
}
