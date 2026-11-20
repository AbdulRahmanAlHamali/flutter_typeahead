import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_typeahead/src/common/base/suggestions_controller.dart';
import 'package:flutter_typeahead/src/common/base/types.dart';
import 'package:flutter_typeahead/src/common/search/suggestions_search.dart';

void main() {
  group('SuggestionsSearch', () {
    late SuggestionsController<String> controller;
    late TextEditingController textEditingController;
    late SuggestionsCallback<String> suggestionsCallback;
    late Duration debounceDuration;

    setUp(() {
      controller = SuggestionsController<String>();
      controller.open();
      textEditingController = TextEditingController();
      suggestionsCallback = (pattern) async {
        return [
          '${pattern}1',
          '${pattern}2',
        ];
      };
      debounceDuration = const Duration(milliseconds: 0);
    });

    tearDown(() {
      controller.dispose();
      textEditingController.dispose();
    });

    testWidgets('loads entries correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SuggestionsSearch<String>(
              controller: controller,
              textEditingController: textEditingController,
              suggestionsCallback: suggestionsCallback,
              debounceDuration: debounceDuration,
              child: const SizedBox(),
            ),
          ),
        ),
      );

      textEditingController.text = 'test';
      await tester.pump();

      expect(controller.suggestions, ['test1', 'test2']);
    });

    for (final (name, thrown) in [
      ('exception', Exception('Failed to load')),
      ('error', StateError('Failed to load')),
    ]) {
      testWidgets('sets error correctly for an $name',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: SuggestionsSearch<String>(
                controller: controller,
                textEditingController: textEditingController,
                suggestionsCallback: (pattern) async {
                  throw thrown;
                },
                debounceDuration: debounceDuration,
                child: const SizedBox(),
              ),
            ),
          ),
        );

        textEditingController.text = 'test';
        await tester.pump();

        expect(controller.error, thrown);
        expect(controller.isLoading, isFalse);
      });
    }

    testWidgets('loads when mounted with a controller left loading',
        (WidgetTester tester) async {
      Widget search(SuggestionsCallback<String> callback) => MaterialApp(
            home: Material(
              child: SuggestionsSearch<String>(
                key: ValueKey(callback),
                controller: controller,
                textEditingController: textEditingController,
                suggestionsCallback: callback,
                debounceDuration: debounceDuration,
                child: const SizedBox(),
              ),
            ),
          );

      final pending = Completer<List<String>>();
      await tester.pumpWidget(search((pattern) => pending.future));
      expect(controller.isLoading, isTrue);

      await tester.pumpWidget(search(suggestionsCallback));
      await tester.pump();

      expect(controller.suggestions, ['1', '2']);
      expect(controller.isLoading, isFalse);
    });

    testWidgets('reloads entries when text changes',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SuggestionsSearch<String>(
              controller: controller,
              textEditingController: textEditingController,
              suggestionsCallback: suggestionsCallback,
              debounceDuration: debounceDuration,
              child: const SizedBox(),
            ),
          ),
        ),
      );

      textEditingController.text = 'test';
      await tester.pump();

      expect(controller.suggestions, ['test1', 'test2']);

      textEditingController.text = 'new';
      await tester.pump();

      expect(controller.suggestions, ['new1', 'new2']);
    });

    testWidgets('reloads entries when suggestions are set to null',
        (WidgetTester tester) async {
      int count = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SuggestionsSearch<String>(
              controller: controller,
              textEditingController: textEditingController,
              suggestionsCallback: (pattern) async {
                count++;
                return [count.toString()];
              },
              debounceDuration: debounceDuration,
              child: const SizedBox(),
            ),
          ),
        ),
      );

      expect(controller.suggestions, ['1']);

      controller.refresh();
      await tester.pump();

      expect(controller.suggestions, ['2']);
    });

    testWidgets('loads when controller opens', (WidgetTester tester) async {
      controller.close();

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SuggestionsSearch<String>(
              controller: controller,
              textEditingController: textEditingController,
              suggestionsCallback: suggestionsCallback,
              debounceDuration: debounceDuration,
              child: const SizedBox(),
            ),
          ),
        ),
      );

      expect(controller.suggestions, isNull);

      controller.open();
      await tester.pump();

      expect(controller.suggestions, ['1', '2']);
    });

    testWidgets('loads when queued up', (WidgetTester tester) async {
      controller.open();

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SuggestionsSearch<String>(
              controller: controller,
              textEditingController: textEditingController,
              suggestionsCallback: suggestionsCallback,
              debounceDuration: debounceDuration,
              child: const SizedBox(),
            ),
          ),
        ),
      );

      textEditingController.text = 'test';
      textEditingController.text = 'new';

      await tester.pump();

      expect(controller.suggestions, ['new1', 'new2']);
    });
  });
}
