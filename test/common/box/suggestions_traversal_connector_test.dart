import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_typeahead/src/common/box/suggestions_traversal_connector.dart';

void main() {
  group('SuggestionsTraversalConnector Tests', () {
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

    testWidgets('proxies key events to the controller',
        (WidgetTester tester) async {
      bool keyEventCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: SuggestionsTraversalConnector(
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

    testWidgets('preserves the previous onKeyEvent method',
        (WidgetTester tester) async {
      bool keyEventCalled = false;

      focusNode.onKeyEvent = (node, event) {
        keyEventCalled = true;
        return KeyEventResult.ignored;
      };

      focusNode.requestFocus();

      await tester.pumpWidget(
        MaterialApp(
          home: SuggestionsTraversalConnector(
            controller: controller,
            focusNode: focusNode,
            child: Focus(
              focusNode: focusNode,
              child: Container(),
            ),
          ),
        ),
      );

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();

      expect(keyEventCalled, isTrue);
    });
  });
}
