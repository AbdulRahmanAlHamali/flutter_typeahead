import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_typeahead/src/common/base/types.dart';
import 'package:flutter_typeahead/src/common/box/suggestions_list.dart';
import 'package:flutter_typeahead/src/common/base/suggestions_controller.dart';

void main() {
  group('SuggestionsList', () {
    late SuggestionsController<String> controller;
    late List<String> suggestions;
    late SuggestionsItemBuilder<String> itemBuilder;
    late WidgetBuilder loadingBuilder;
    late SuggestionsErrorBuilder errorBuilder;
    late WidgetBuilder emptyBuilder;

    setUp(() {
      controller = SuggestionsController();
      suggestions = ['test1', 'test2', 'test3'];
      itemBuilder =
          (context, suggestion) => Text(key: Key(suggestion), suggestion);
      loadingBuilder =
          (context) => const Text(key: Key('loading'), 'Loading...');
      errorBuilder =
          (context, error) => Text(key: const Key('error'), '$error');
      emptyBuilder =
          (context) => const Text(key: Key('empty'), 'No suggestions');
    });

    tearDown(() {
      controller.dispose();
    });

    testWidgets('shows loading builder when isLoading is true',
        (WidgetTester tester) async {
      controller.isLoading = true;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SuggestionsList(
              controller: controller,
              itemBuilder: itemBuilder,
              loadingBuilder: loadingBuilder,
              errorBuilder: errorBuilder,
              emptyBuilder: emptyBuilder,
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('loading')), findsOneWidget);
    });

    testWidgets('shows error builder when isError is true',
        (WidgetTester tester) async {
      controller.error = 'An error occurred';

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SuggestionsList(
              controller: controller,
              itemBuilder: itemBuilder,
              loadingBuilder: loadingBuilder,
              errorBuilder: errorBuilder,
              emptyBuilder: emptyBuilder,
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('error')), findsOneWidget);
    });

    testWidgets('shows empty builder when suggestions list is empty',
        (WidgetTester tester) async {
      controller.suggestions = [];

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SuggestionsList(
              controller: controller,
              itemBuilder: itemBuilder,
              loadingBuilder: loadingBuilder,
              errorBuilder: errorBuilder,
              emptyBuilder: emptyBuilder,
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('empty')), findsOneWidget);
    });

    testWidgets('shows list of suggestions', (WidgetTester tester) async {
      controller.suggestions = suggestions;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SuggestionsList(
              controller: controller,
              itemBuilder: itemBuilder,
              loadingBuilder: loadingBuilder,
              errorBuilder: errorBuilder,
              emptyBuilder: emptyBuilder,
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('test1')), findsOneWidget);
      expect(find.byKey(const Key('test2')), findsOneWidget);
      expect(find.byKey(const Key('test3')), findsOneWidget);
    });

    testWidgets('shows nothing when suggestions list is null',
        (WidgetTester tester) async {
      controller.suggestions = null;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SuggestionsList(
              controller: controller,
              itemBuilder: itemBuilder,
              loadingBuilder: loadingBuilder,
              errorBuilder: errorBuilder,
              emptyBuilder: emptyBuilder,
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('loading')), findsNothing);
      expect(find.byKey(const Key('error')), findsNothing);
      expect(find.byKey(const Key('empty')), findsNothing);
      expect(find.byKey(const Key('test1')), findsNothing);
      expect(find.byKey(const Key('test2')), findsNothing);
      expect(find.byKey(const Key('test3')), findsNothing);
    });

    testWidgets(
        'reverses the suggestions list based on effective controller direction',
        (WidgetTester tester) async {
      controller.suggestions = suggestions;
      controller.effectiveDirection = VerticalDirection.up;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SuggestionsList(
              controller: controller,
              itemBuilder: itemBuilder,
              loadingBuilder: loadingBuilder,
              errorBuilder: errorBuilder,
              emptyBuilder: emptyBuilder,
            ),
          ),
        ),
      );

      final list = tester.widget<ListView>(find.byType(ListView));
      expect(list.reverse, true);
    });

    testWidgets('uses custom list builder', (WidgetTester tester) async {
      controller.suggestions = suggestions;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SuggestionsList(
              controller: controller,
              itemBuilder: itemBuilder,
              loadingBuilder: loadingBuilder,
              errorBuilder: errorBuilder,
              emptyBuilder: emptyBuilder,
              listBuilder: (context, children) => GridView.count(
                crossAxisCount: 2,
                children: children,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(GridView), findsOneWidget);
    });
  });
}
