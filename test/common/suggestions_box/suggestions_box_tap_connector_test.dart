import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_box_controller.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_box_tap_connector.dart';

void main() {
  group('SuggestionsBoxTapConnector', () {
    late SuggestionsBoxController controller;

    setUp(() {
      controller = SuggestionsBoxController();
    });

    tearDown(() => controller.dispose());

    testWidgets(
        'opens the suggestions box when tapped if it is not open and retainFocus is true',
        (WidgetTester tester) async {
      controller.open();
      controller.close(retainFocus: true);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SuggestionsBoxTapConnector(
              controller: controller,
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
            child: SuggestionsBoxTapConnector(
              controller: controller,
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
