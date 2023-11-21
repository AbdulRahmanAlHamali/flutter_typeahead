import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_typeahead/src/common/box/suggestions_box_scroll_injector.dart';

void main() {
  group('SuggestionsBoxScrollInjector', () {
    late ScrollController scrollController;

    setUp(() {
      scrollController = ScrollController();
    });

    tearDown(() {
      scrollController.dispose();
    });

    testWidgets('creates and disposes a ScrollController if none is provided',
        (WidgetTester tester) async {
      ScrollController? controller;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(platform: TargetPlatform.android),
          home: Material(
            child: SuggestionsBoxScrollInjector(
              child: Builder(
                builder: (context) {
                  controller = PrimaryScrollController.of(context);
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      );

      expect(controller, isNotNull);

      await tester.pumpWidget(
        const SizedBox(),
      );

      expect(controller!.dispose, throwsFlutterError);
    });

    testWidgets('exchanges the ScrollController if one is provided',
        (WidgetTester tester) async {
      ScrollController? controller;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(platform: TargetPlatform.android),
          home: Material(
            child: SuggestionsBoxScrollInjector(
              child: Builder(
                builder: (context) {
                  controller = PrimaryScrollController.of(context);
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      );

      expect(controller, isNotNull);

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(platform: TargetPlatform.android),
          home: Material(
            child: SuggestionsBoxScrollInjector(
              controller: scrollController,
              child: Builder(
                builder: (context) {
                  controller = PrimaryScrollController.of(context);
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      );

      expect(controller, equals(scrollController));
    });

    testWidgets('configures the PrimaryScrollController for all platforms',
        (WidgetTester tester) async {
      for (final platform in TargetPlatform.values) {
        ScrollController? controller;
        bool? shouldInherit;

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(platform: platform),
            home: Material(
              child: SuggestionsBoxScrollInjector(
                controller: scrollController,
                child: Builder(
                  builder: (context) {
                    shouldInherit = PrimaryScrollController.shouldInherit(
                        context, Axis.vertical);
                    controller = PrimaryScrollController.of(context);
                    return const SizedBox();
                  },
                ),
              ),
            ),
          ),
        );

        expect(controller, equals(scrollController));
        expect(shouldInherit, isTrue);
      }
    });
  });
}
