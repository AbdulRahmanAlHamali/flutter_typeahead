import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_controller.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_list_typing_connector.dart';

void main() {
  group('SuggestionsListTypingConnector', () {
    late SuggestionsController controller;
    late TextEditingController textEditingController;

    setUp(() {
      controller = SuggestionsController();
      textEditingController = TextEditingController();
    });

    tearDown(() {
      controller.dispose();
      textEditingController.dispose();
    });

    testWidgets(
        'opens the suggestions list when the text changes and the box is closed',
        (WidgetTester tester) async {
      controller.open();
      controller.close(retainFocus: true);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SuggestionsListTypingConnector(
              controller: controller,
              textEditingController: textEditingController,
              child: const SizedBox(),
            ),
          ),
        ),
      );

      expect(controller.isOpen, isFalse);

      textEditingController.text = 'test';
      await tester.pump();

      expect(controller.isOpen, isTrue);
    });

    testWidgets('reconnects to a new controller when the controller changes',
        (WidgetTester tester) async {
      final TextEditingController newController = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SuggestionsListTypingConnector(
              controller: controller,
              textEditingController: textEditingController,
              child: const SizedBox(),
            ),
          ),
        ),
      );

      controller.open();
      controller.close(retainFocus: true);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SuggestionsListTypingConnector(
              controller: controller,
              textEditingController: newController,
              child: const SizedBox(),
            ),
          ),
        ),
      );

      expect(controller.isOpen, isFalse);

      newController.text = 'test2';

      await tester.pump();

      expect(controller.isOpen, isTrue);
    });
  });
}
