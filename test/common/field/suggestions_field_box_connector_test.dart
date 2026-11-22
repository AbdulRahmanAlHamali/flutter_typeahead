import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_typeahead/src/common/base/suggestions_controller.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_typeahead/src/common/field/suggestions_field_box_connector.dart';

void main() {
  group('SuggestionsFieldBoxConnector', () {
    late SuggestionsController controller;

    setUp(() {
      controller = SuggestionsController();
    });

    tearDown(() {
      controller.dispose();
    });

    testWidgets('opens suggestions box when focus is gained', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SuggestionsFieldBoxConnector(
            controller: controller,
            child: const SizedBox(),
          ),
        ),
      );

      controller.focusField();
      await tester.pump();

      expect(controller.isOpen, isTrue);
    });

    testWidgets('closes suggestions box when focus is lost', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SuggestionsFieldBoxConnector(
            controller: controller,
            child: const SizedBox(),
          ),
        ),
      );

      controller.focusField();
      await tester.pump();
      controller.unfocus();
      await tester.pump();

      expect(controller.isOpen, isFalse);
    });

    testWidgets(
      'closes suggestions box and keeps focus when the keyboard hides',
      (WidgetTester tester) async {
        addTearDown(tester.view.resetViewInsets);
        await tester.pumpWidget(
          MaterialApp(
            home: SuggestionsFieldBoxConnector(
              controller: controller,
              child: const SizedBox(),
            ),
          ),
        );

        controller.focusField();
        tester.view.viewInsets = const FakeViewPadding(bottom: 300);
        await tester.pump();
        tester.view.viewInsets = FakeViewPadding.zero;
        await tester.pump();

        expect(controller.isOpen, isFalse);
        expect(controller.focusState, SuggestionsFocusState.field);
      },
    );

    testWidgets(
      'keeps suggestions box open when the keyboard hides and hideOnUnfocus is false',
      (WidgetTester tester) async {
        addTearDown(tester.view.resetViewInsets);
        await tester.pumpWidget(
          MaterialApp(
            home: SuggestionsFieldBoxConnector(
              controller: controller,
              hideOnUnfocus: false,
              child: const SizedBox(),
            ),
          ),
        );

        controller.focusField();
        tester.view.viewInsets = const FakeViewPadding(bottom: 300);
        await tester.pump();
        tester.view.viewInsets = FakeViewPadding.zero;
        await tester.pump();

        expect(controller.isOpen, isTrue);
      },
    );

    testWidgets(
      'keeps suggestions box open when the keyboard hides while the field is unfocused',
      (WidgetTester tester) async {
        addTearDown(tester.view.resetViewInsets);
        await tester.pumpWidget(
          MaterialApp(
            home: SuggestionsFieldBoxConnector(
              controller: controller,
              child: const SizedBox(),
            ),
          ),
        );

        controller.open(gainFocus: false);
        tester.view.viewInsets = const FakeViewPadding(bottom: 300);
        await tester.pump();
        tester.view.viewInsets = FakeViewPadding.zero;
        await tester.pump();

        expect(controller.isOpen, isTrue);
        expect(controller.focusState, SuggestionsFocusState.blur);
      },
    );

    testWidgets('opens the suggestions box if node was already focused', (
      WidgetTester tester,
    ) async {
      controller.focusField();

      await tester.pumpWidget(
        MaterialApp(
          home: SuggestionsFieldBoxConnector(
            controller: controller,
            child: const SizedBox(),
          ),
        ),
      );

      expect(controller.isOpen, isTrue);
    });

    testWidgets(
      'does not close suggestions box when focus is lost and hideOnUnfocus is false',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: SuggestionsFieldBoxConnector(
              controller: controller,
              hideOnUnfocus: false,
              child: const SizedBox(),
            ),
          ),
        );

        controller.focusField();
        await tester.pump();
        controller.unfocus();
        await tester.pump();

        expect(controller.isOpen, isTrue);
      },
    );

    testWidgets('focuses field when box is opened', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SuggestionsFieldBoxConnector(
            controller: controller,
            child: const SizedBox(),
          ),
        ),
      );

      controller.open();
      await tester.pump();

      expect(controller.focusState, SuggestionsFocusState.field);
    });

    testWidgets(
      'does not focus field when box is opened and gainFocus is false',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: SuggestionsFieldBoxConnector(
              controller: controller,
              child: const SizedBox(),
            ),
          ),
        );

        controller.open(gainFocus: false);
        await tester.pump();

        expect(controller.focusState, SuggestionsFocusState.blur);
      },
    );

    testWidgets('unfocuses field when suggestions box is closed', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SuggestionsFieldBoxConnector(
            controller: controller,
            child: const SizedBox(),
          ),
        ),
      );

      controller.close();
      await tester.pump();

      expect(controller.focusState, SuggestionsFocusState.blur);
    });

    testWidgets(
      'does not unfocus field when suggestions box is closed and retainFocus is true',
      (WidgetTester tester) async {
        controller.open();
        await tester.pumpWidget(
          MaterialApp(
            home: SuggestionsFieldBoxConnector(
              controller: controller,
              child: const SizedBox(),
            ),
          ),
        );

        controller.close(retainFocus: true);
        await tester.pump();

        expect(controller.isOpen, isFalse);
        expect(controller.focusState, SuggestionsFocusState.field);
      },
    );

    testWidgets('opens suggestions box when focus is box', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SuggestionsFieldBoxConnector(
            controller: controller,
            child: const SizedBox(),
          ),
        ),
      );

      controller.focusBox();
      await tester.pump();

      expect(controller.isOpen, isTrue);
    });
  });
}
