import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_typeahead/src/common/search/suggestions_search_text_debouncer.dart';

void main() {
  group('SuggestionsSearchTextDebouncer', () {
    late TextEditingController controller;
    late Duration debounceDuration;

    setUp(() {
      controller = TextEditingController();
      debounceDuration = const Duration(milliseconds: 300);
    });

    tearDown(() {
      controller.dispose();
    });

    testWidgets('calls onChanged when text changes',
        (WidgetTester tester) async {
      String? lastTextValue;

      await tester.pumpWidget(
        MaterialApp(
          home: SuggestionsSearchTextDebouncer(
            controller: controller,
            onChanged: (value) => lastTextValue = value,
            debounceDuration: debounceDuration,
            child: Container(),
          ),
        ),
      );

      controller.text = 'test text';

      await tester.pump(debounceDuration);

      expect(lastTextValue, equals('test text'));
    });

    testWidgets('does not call onChanged when text does not change',
        (WidgetTester tester) async {
      controller.text = 'initial text';
      String? lastTextValue;

      await tester.pumpWidget(
        MaterialApp(
          home: SuggestionsSearchTextDebouncer(
            controller: controller,
            onChanged: (value) => lastTextValue = value,
            debounceDuration: debounceDuration,
            child: Container(),
          ),
        ),
      );

      controller.value = controller.value.copyWith(
        selection: const TextSelection.collapsed(offset: 2),
      );

      await tester.pump(debounceDuration);

      expect(lastTextValue, isNull);
    });

    testWidgets('calls onChanged immediately if duration is Duration.zero',
        (WidgetTester tester) async {
      String? lastTextValue;

      await tester.pumpWidget(
        MaterialApp(
          home: SuggestionsSearchTextDebouncer(
            controller: controller,
            onChanged: (value) => lastTextValue = value,
            debounceDuration: Duration.zero,
            child: Container(),
          ),
        ),
      );

      controller.text = 'test text';

      expect(lastTextValue, equals('test text'));
    });
  });
}
