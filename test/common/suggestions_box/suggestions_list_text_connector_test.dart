import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_list_text_connector.dart';

void main() {
  group('SuggestionsListTextConnector', () {
    late SuggestionsBoxController controller;
    late TextEditingController textEditingController;

    setUp(() {
      controller = SuggestionsBoxController();
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
            child: SuggestionsListTextConnector(
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
