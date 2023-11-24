import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_typeahead/src/common/base/suggestions_controller.dart';
import 'package:flutter_typeahead/src/common/field/suggestions_field_focus_connector.dart';
import 'package:flutter/material.dart';

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

    testWidgets('sets focus to blur when focus node is unfocused',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SuggestionsFieldFocusConnector(
              controller: controller,
              focusNode: focusNode,
              child: Focus(
                autofocus: true,
                focusNode: focusNode,
                child: const SizedBox(),
              ),
            ),
          ),
        ),
      );

      expect(controller.focusState, SuggestionsFocusState.field);

      focusNode.unfocus();
      await tester.pump();

      expect(controller.focusState, SuggestionsFocusState.blur);
    });

    testWidgets('focuses node when focus is child',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Stack(
              children: [
                SuggestionsFieldFocusConnector(
                  controller: controller,
                  focusNode: focusNode,
                  child: Focus(
                    focusNode: focusNode,
                    child: const SizedBox(),
                  ),
                ),
                const Focus(
                  autofocus: true,
                  child: SizedBox(),
                ),
              ],
            ),
          ),
        ),
      );

      expect(focusNode.hasFocus, false);

      controller.focusField();
      await tester.pump();

      expect(focusNode.hasFocus, true);
    });

    testWidgets('unfocuses node when focus is blur', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Stack(
              children: [
                SuggestionsFieldFocusConnector(
                  controller: controller,
                  focusNode: focusNode,
                  child: Focus(
                    autofocus: true,
                    focusNode: focusNode,
                    child: const SizedBox(),
                  ),
                ),
                const Focus(
                  child: SizedBox(),
                ),
              ],
            ),
          ),
        ),
      );

      expect(focusNode.hasFocus, true);

      controller.unfocus();
      await tester.pump();

      expect(focusNode.hasFocus, false);
    });
  });
}
