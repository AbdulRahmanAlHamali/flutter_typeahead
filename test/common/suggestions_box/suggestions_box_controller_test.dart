import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_controller.dart';

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

    test('closes suggestions list while retaining box focus', () {
      controller.open();
      controller.close(retainFocus: true);
      expect(controller.isOpen, isFalse);
      expect(controller.retainFocus, isTrue);
    });

    test('opens suggestions list and resets retain focus', () {
      controller.open();
      controller.close(retainFocus: true);
      controller.open();
      expect(controller.isOpen, isTrue);
      expect(controller.retainFocus, isFalse);
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
      controller.resizes.listen((_) => called = true);
      controller.resize();
      await Future<void>.value();
      expect(called, isTrue);
    });

    test('shifts focus to suggestions list', () {
      controller.focus();
      expect(controller.focused, isTrue);
    });

    test('shifts focus away from suggestions list', () {
      controller.focus();
      controller.unfocus();
      expect(controller.focused, isFalse);
    });

    test('shifts focus to suggestions box', () {
      controller.focusChild();
      expect(controller.focused, isFalse);
    });

    test('sends up or down arrow key down event', () async {
      bool called = false;
      controller.keys.listen((_) => called = true);
      controller.sendKey(VerticalDirection.down);
      await Future<void>.value();
      expect(called, isTrue);
    });
  });
}
