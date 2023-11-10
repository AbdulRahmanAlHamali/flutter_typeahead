import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_box_dimension_connector.dart';

void main() {
  group('SuggestionsBoxDimensionConnector', () {
    late SuggestionsBoxController controller;

    setUp(() {
      controller = SuggestionsBoxController();
    });

    tearDown(() {
      controller.dispose();
    });

    testWidgets('updates dimensions when metrics change',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SuggestionsBoxDimensionConnector(
              controller: controller,
              child: const SizedBox(),
            ),
          ),
        ),
      );

      bool hasResized = false;
      controller.resizeEvents.listen((_) => hasResized = true);

      tester.view.viewInsets = const FakeViewPadding(bottom: 100);
      await tester.pumpAndSettle();

      await tester.pump(const Duration(milliseconds: 1200));

      expect(hasResized, isTrue);
    });
  });
}
