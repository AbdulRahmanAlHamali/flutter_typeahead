import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_typeahead/src/common/base/suggestions_controller.dart';
import 'package:flutter_typeahead/src/common/search/suggestions_search_typing_connector.dart';

void main() {
  group('SuggestionsSearchTypingConnector', () {
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
            child: SuggestionsSearchTypingConnector(
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
  });
}
