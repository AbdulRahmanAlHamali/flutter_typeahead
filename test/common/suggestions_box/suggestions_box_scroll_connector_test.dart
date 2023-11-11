import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_controller.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_box_scroll_connector.dart';

void main() {
  group('SuggestionsBoxScrollConnector', () {
    late SuggestionsController controller;

    setUp(() {
      controller = SuggestionsController();
    });

    tearDown(() {
      controller.dispose();
    });

    testWidgets('resizes the suggestions box when scrolling',
        (WidgetTester tester) async {
      bool resizeCalled = false;
      controller.open();
      controller.resizeEvents.listen((_) => resizeCalled = true);

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: ListView(
              children: [
                SuggestionsBoxScrollConnector(
                  controller: controller,
                  child: const SizedBox(),
                ),
              ],
            ),
          ),
        ),
      );

      expect(resizeCalled, isFalse);

      await tester.drag(find.byType(ListView), const Offset(0, -100));
      await tester.pump();

      expect(resizeCalled, true);
    });
  });
}
