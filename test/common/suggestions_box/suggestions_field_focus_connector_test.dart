import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_controller.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_field_focus_connector.dart';

void main() {
  group('SuggestionsFieldFocusConnector', () {
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
