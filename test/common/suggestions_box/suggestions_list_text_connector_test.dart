import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_list_reopen_connector.dart';

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
            child: SuggestionsListReopenConnector(
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

    testWidgets(
        'opens the suggestions box when tapped if it is not open and retainFocus is true',
        (WidgetTester tester) async {
      controller.open();
      controller.close(retainFocus: true);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SuggestionsListReopenConnector(
              controller: controller,
              textEditingController: textEditingController,
              child: InkWell(
                onTap: () {},
              ),
            ),
          ),
        ),
      );

      expect(controller.isOpen, isFalse);

      await tester.tap(find.byType(InkWell));
      await tester.pump();

      expect(controller.isOpen, isTrue);
    });

    testWidgets(
        'does not open the suggestions box when tapped if it is not open and retainFocus is false',
        (WidgetTester tester) async {
      controller.open();
      controller.close(retainFocus: false);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SuggestionsListReopenConnector(
              controller: controller,
              textEditingController: textEditingController,
              child: InkWell(
                onTap: () {},
              ),
            ),
          ),
        ),
      );

      expect(controller.isOpen, isFalse);

      await tester.tap(find.byType(InkWell));
      await tester.pump();

      expect(controller.isOpen, isFalse);
    });
  });
}
