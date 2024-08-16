import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_typeahead/src/common/base/suggestions_controller.dart';

void main() {
  group('SuggestionsController', () {
    late SuggestionsController<String> controller;

    setUp(() {
      controller = SuggestionsController<String>();
    });

    tearDown(() {
      controller.dispose();
    });

    test('sets suggestions', () {
      expect(controller.suggestions, isNull);
      controller.suggestions = ['a', 'b', 'c'];
      expect(controller.suggestions, equals(['a', 'b', 'c']));
    });

    test('refreshes the suggestions', () async {
      expect(controller.suggestions, isNull);
      controller.suggestions = ['a', 'b', 'c'];
      bool called = false;
      controller.$refreshes.listen((_) => called = true);
      controller.refresh();
      await Future<void>.value();
      expect(controller.suggestions, null);
      expect(called, isTrue);
    });

    test('sets loading state', () {
      expect(controller.isLoading, isFalse);
      controller.isLoading = true;
      expect(controller.isLoading, isTrue);
    });

    test('sets error state', () {
      expect(controller.hasError, isFalse);
      controller.error = 'error';
      expect(controller.hasError, isTrue);
      expect(controller.error, equals('error'));
    });

    test('sets highlighted index', () {
      controller.suggestions = ['a', 'b', 'c'];
      expect(controller.highlighted, isNull);
      controller.highlighted = 1;
      expect(controller.highlighted, equals(1));
      controller.highlightNext();
      expect(controller.highlighted, equals(2));
      controller.highlightPrevious();
      expect(controller.highlighted, equals(1));
      controller.unhighlight();
      expect(controller.highlighted, isNull);
    });

    test('sets highlighted suggestion', () {
      controller.suggestions = ['a', 'b', 'c'];
      expect(controller.highlightedSuggestion, isNull);
      controller.highlightedSuggestion = 'b';
      expect(controller.highlightedSuggestion, equals('b'));
      controller.highlightNext();
      expect(controller.highlightedSuggestion, equals('c'));
      controller.highlightPrevious();
      expect(controller.highlightedSuggestion, equals('b'));
      controller.highlightedSuggestion = null;
      expect(controller.highlightedSuggestion, isNull);
    });

    test('opens suggestions list', () {
      bool wasOpened = false;
      controller.addListener(() => wasOpened = controller.isOpen);
      controller.open();
      expect(controller.isOpen, isTrue);
      expect(wasOpened, isTrue);
    });

    test('closes suggestions list', () {
      bool wasOpened = false;
      controller.addListener(() => wasOpened = controller.isOpen);
      controller.open();
      controller.close();
      expect(controller.isOpen, isFalse);
      expect(wasOpened, isFalse);
    });

    test('toggles suggestions list state', () {
      controller.toggle();
      expect(controller.isOpen, isTrue);
      controller.toggle();
      expect(controller.isOpen, isFalse);
    });

    test('opens suggestion list while not gaining focus', () {
      controller.open(gainFocus: false);
      expect(controller.isOpen, isTrue);
      expect(controller.gainFocus, isFalse);
    });

    test('closes suggestions list while retaining box focus', () {
      controller.open();
      controller.close(retainFocus: true);
      expect(controller.isOpen, isFalse);
      expect(controller.retainFocus, isTrue);
    });

    test('dispose closes suggestions list', () async {
      controller.open();
      controller.dispose();
      expect(controller.isOpen, isFalse);
      // we reset the controller afterwards because otherwise our teardown
      // will try to dispose it again.
      controller = SuggestionsController();
    });

    test('sends resize event', () async {
      bool called = false;
      controller.$resizes.listen((_) => called = true);
      controller.resize();
      await Future<void>.value();
      expect(called, isTrue);
    });

    test('shifts focus to suggestions list', () {
      controller.focusBox();
      expect(controller.focusState, equals(SuggestionsFocusState.box));
    });

    test('shifts focus away from suggestions list', () {
      controller.focusBox();
      controller.unfocus();
      expect(controller.focusState, equals(SuggestionsFocusState.blur));
    });

    test('shifts focus to suggestions box', () {
      controller.focusField();
      expect(controller.focusState, equals(SuggestionsFocusState.field));
    });

    test('sets direction', () {
      controller.direction = VerticalDirection.up;
      expect(controller.direction, equals(VerticalDirection.up));
    });

    test('sets effective direction', () {
      controller.effectiveDirection = VerticalDirection.up;
      expect(controller.effectiveDirection, equals(VerticalDirection.up));
    });

    testWidgets('can be found in context', (WidgetTester tester) async {
      final key = GlobalKey();
      await tester.pumpWidget(
        SuggestionsControllerProvider<String>(
          controller: controller,
          child: Container(key: key),
        ),
      );
      expect(
        SuggestionsController.of<String>(key.currentContext!),
        equals(controller),
      );
    });

    testWidgets('throws if not found in context', (WidgetTester tester) async {
      await tester.pumpWidget(Container());
      expect(
        () => SuggestionsController.of<String>(
          tester.element(
            find.byType(Container),
          ),
        ),
        throwsFlutterError,
      );
    });

    testWidgets('may be found in context', (WidgetTester tester) async {
      final key = GlobalKey();
      await tester.pumpWidget(
        Container(
          key: key,
          child: SuggestionsControllerProvider<String>(
            controller: controller,
            child: Container(),
          ),
        ),
      );
      expect(
        SuggestionsController.maybeOf<String>(key.currentContext!),
        equals(null),
      );
    });
  });
}
