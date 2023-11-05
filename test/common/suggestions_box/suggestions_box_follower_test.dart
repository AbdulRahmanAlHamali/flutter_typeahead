import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_box_follower.dart';

void main() {
  group('SuggestionsBoxFollower', () {
    late LayerLink layerLink;
    late Widget child;

    setUp(() {
      layerLink = LayerLink();
      child = Container();
    });

    testWidgets('builds with default offset', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SuggestionsBoxFollower(
              layerLink: layerLink,
              direction: AxisDirection.down,
              child: child,
            ),
          ),
        ),
      );

      final follower = tester.widget<CompositedTransformFollower>(
        find.byType(CompositedTransformFollower),
      );

      expect(follower.offset, const Offset(0, 5));
    });

    testWidgets('builds with custom offset', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SuggestionsBoxFollower(
              layerLink: layerLink,
              direction: AxisDirection.down,
              offset: const Offset(10, 20),
              child: child,
            ),
          ),
        ),
      );

      final follower = tester.widget<CompositedTransformFollower>(
        find.byType(CompositedTransformFollower),
      );

      expect(follower.offset, const Offset(10, 20));
    });

    testWidgets('builds with direction down', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SuggestionsBoxFollower(
              layerLink: layerLink,
              direction: AxisDirection.down,
              child: child,
            ),
          ),
        ),
      );

      final follower = tester.widget<CompositedTransformFollower>(
        find.byType(CompositedTransformFollower),
      );

      expect(follower.targetAnchor, Alignment.bottomLeft);
    });

    testWidgets('builds with direction up', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SuggestionsBoxFollower(
              layerLink: layerLink,
              direction: AxisDirection.up,
              child: child,
            ),
          ),
        ),
      );

      final follower = tester.widget<CompositedTransformFollower>(
        find.byType(CompositedTransformFollower),
      );

      expect(follower.targetAnchor, Alignment.topLeft);
    });
  });
}
