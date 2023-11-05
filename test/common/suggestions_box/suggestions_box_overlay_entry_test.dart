import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_box_decoration.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_box_overlay_entry.dart';

class MockSuggestionsBoxDecoration extends BaseSuggestionsBoxDecoration {
  const MockSuggestionsBoxDecoration({
    super.hasScrollbar,
    super.scrollbarThumbAlwaysVisible,
    super.constraints,
    super.color,
    super.offsetX,
    super.offsetY,
  });
}

void main() {
  final LayerLink layerLink = LayerLink();
  Widget suggestionsListBuilder(BuildContext context) => Container();
  const AxisDirection direction = AxisDirection.down;
  const double width = 100;
  const double height = 200;
  const double maxHeight = 300;
  const BaseSuggestionsBoxDecoration decoration =
      MockSuggestionsBoxDecoration();
  const bool ignoreAccessibleNavigation = false;

  final config = SuggestionsBoxOverlayEntryConfig(
    layerLink: layerLink,
    suggestionsListBuilder: suggestionsListBuilder,
    direction: direction,
    width: width,
    height: height,
    maxHeight: maxHeight,
    decoration: decoration,
    ignoreAccessibleNavigation: ignoreAccessibleNavigation,
  );

  group('SuggestionsBoxOverlayEntryConfig', () {
    test('copyWith changes the provided properties', () {
      final LayerLink newLayerLink = LayerLink();
      Widget newSuggestionsListBuilder(BuildContext context) =>
          const SizedBox();
      const AxisDirection newDirection = AxisDirection.up;
      const double newWidth = 200;
      const double newHeight = 300;
      const double newMaxHeight = 400;
      const BaseSuggestionsBoxDecoration newDecoration =
          MockSuggestionsBoxDecoration(color: Colors.red);
      const bool newIgnoreAccessibleNavigation = true;

      final newConfig = config.copyWith(
        layerLink: newLayerLink,
        suggestionsListBuilder: newSuggestionsListBuilder,
        direction: newDirection,
        width: newWidth,
        height: newHeight,
        maxHeight: newMaxHeight,
        decoration: newDecoration,
        ignoreAccessibleNavigation: newIgnoreAccessibleNavigation,
      );

      expect(config == newConfig, isFalse);
      expect(config.hashCode == newConfig.hashCode, isFalse);

      expect(newConfig.layerLink, newLayerLink);
      expect(newConfig.suggestionsListBuilder, newSuggestionsListBuilder);
      expect(newConfig.direction, newDirection);
      expect(newConfig.width, newWidth);
      expect(newConfig.height, newHeight);
      expect(newConfig.maxHeight, newMaxHeight);
      expect(newConfig.decoration, newDecoration);
      expect(
          newConfig.ignoreAccessibleNavigation, newIgnoreAccessibleNavigation);
    });

    test('copyWith does not change the provided properties', () {
      final config = SuggestionsBoxOverlayEntryConfig(
        layerLink: layerLink,
        suggestionsListBuilder: suggestionsListBuilder,
        direction: direction,
        width: width,
        height: height,
        maxHeight: maxHeight,
        decoration: decoration,
        ignoreAccessibleNavigation: ignoreAccessibleNavigation,
      );

      final newConfig = config.copyWith();

      expect(config == newConfig, isTrue);
      expect(config.hashCode == newConfig.hashCode, isTrue);
    });
  });

  group('SuggestionsBoxOverlayEntry', () {
    testWidgets('builds normally', (WidgetTester tester) async {
      final config = ValueNotifier(
        SuggestionsBoxOverlayEntryConfig(
          layerLink: layerLink,
          suggestionsListBuilder: suggestionsListBuilder,
          direction: direction,
          width: width,
          height: height,
          maxHeight: maxHeight,
          decoration: decoration,
          ignoreAccessibleNavigation: false,
        ),
      );

      OverlayEntry entry = OverlayEntry(
        builder: (context) => SuggestionsBoxOverlayEntry(config: config),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Overlay(
              initialEntries: [entry],
            ),
          ),
        ),
      );

      expect(find.byType(Positioned), findsOneWidget);
    });

    testWidgets('builds differently when accessibility is enabled',
        (WidgetTester tester) async {
      final config = ValueNotifier(
        SuggestionsBoxOverlayEntryConfig(
          layerLink: layerLink,
          suggestionsListBuilder: suggestionsListBuilder,
          direction: direction,
          width: width,
          height: height,
          maxHeight: maxHeight,
          decoration: decoration,
          ignoreAccessibleNavigation: false,
        ),
      );

      OverlayEntry entry = OverlayEntry(
        builder: (context) => SuggestionsBoxOverlayEntry(config: config),
      );

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(
            accessibleNavigation: true,
          ),
          child: MaterialApp(
            home: Material(
              child: Overlay(
                initialEntries: [entry],
              ),
            ),
          ),
        ),
      );

      expect(find.byType(Align), findsOneWidget);
    });

    testWidgets('builds normally when accessibility is ignored',
        (WidgetTester tester) async {
      final config = ValueNotifier(
        SuggestionsBoxOverlayEntryConfig(
          layerLink: layerLink,
          suggestionsListBuilder: suggestionsListBuilder,
          direction: direction,
          width: width,
          height: height,
          maxHeight: maxHeight,
          decoration: decoration,
          ignoreAccessibleNavigation: true,
        ),
      );

      OverlayEntry entry = OverlayEntry(
        builder: (context) => SuggestionsBoxOverlayEntry(config: config),
      );

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(
            accessibleNavigation: true,
          ),
          child: MaterialApp(
            home: Material(
              child: Overlay(
                initialEntries: [entry],
              ),
            ),
          ),
        ),
      );

      expect(find.byType(Positioned), findsOneWidget);

      config.value = config.value.copyWith(
        ignoreAccessibleNavigation: false,
      );

      await tester.pump();

      expect(find.byType(Align), findsOneWidget);
    });
  });
}
