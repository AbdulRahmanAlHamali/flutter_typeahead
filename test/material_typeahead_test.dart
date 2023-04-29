import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'helpers/material_typeahead_helper.dart';

/// Material Typeahead widget tests where there are 6 typeaheads. To test overlays and other widgets.
void main() {
  group("Material TypeAhead widget tests", () {
    testWidgets("Initial UI Test", (WidgetTester tester) async {
      await tester.pumpWidget(MaterialTypeAheadHelper.getMaterialTypeAheadPage());
      await tester.pumpAndSettle();

      expect(find.text("Material TypeAhead test"), findsOneWidget);
      expect(find.byType(TypeAheadFormField<String>), findsNWidgets(6));
      expect(find.byType(CompositedTransformFollower), findsNothing);
    });

    testWidgets("No results found test", (WidgetTester tester) async {
      await tester.pumpWidget(MaterialTypeAheadHelper.getMaterialTypeAheadPage());
      await tester.pumpAndSettle();

      final typeAheadField = find.byType(TypeAheadFormField<String>).first;
      await tester.tap(typeAheadField);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await tester.enterText(typeAheadField, "Chocolates");
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.byType(CompositedTransformFollower), findsNWidgets(2));

      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.text("No results found!"), findsOneWidget);
    });

    testWidgets("Search one item", (WidgetTester tester) async {
      await tester.pumpWidget(MaterialTypeAheadHelper.getMaterialTypeAheadPage());
      await tester.pumpAndSettle();

      final typeAheadField = find.byType(TypeAheadFormField<String>).first;
      await tester.tap(typeAheadField);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await tester.enterText(typeAheadField, "Cheese");
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.byType(CompositedTransformFollower), findsNWidgets(2));

      await tester.tap(find.text("Cheese").last);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.text("Cheese"), findsOneWidget);
    });

    testWidgets("Search two items", (WidgetTester tester) async {
      await tester.pumpWidget(MaterialTypeAheadHelper.getMaterialTypeAheadPage());
      await tester.pumpAndSettle();

      final typeAheadField = find.byType(TypeAheadFormField<String>).first;
      await tester.tap(typeAheadField);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await tester.enterText(typeAheadField, "B");
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text("Bread"), findsOneWidget);
      expect(find.text("Burger"), findsOneWidget);
    });

    testWidgets("Search with first type ahead and check the offset of the first suggestion box", (WidgetTester tester) async {
      await tester.pumpWidget(MaterialTypeAheadHelper.getMaterialTypeAheadPage());
      await tester.pumpAndSettle();

      final typeAheadField = find.byType(TypeAheadFormField<String>).first;
      await tester.tap(typeAheadField);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await tester.enterText(typeAheadField, "Bread");
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final typeAheadSuggestionBox = find.byType(CompositedTransformFollower).last;
      final CompositedTransformFollower typeAheadSuggestionBoxTester = tester.widget<CompositedTransformFollower>(typeAheadSuggestionBox);
      expect(typeAheadSuggestionBoxTester.offset, Offset(0.0, 61.0));
    });

    testWidgets("Search with last type ahead and check the offset of the last suggestion box", (WidgetTester tester) async {
      await tester.pumpWidget(MaterialTypeAheadHelper.getMaterialTypeAheadPage());
      await tester.pumpAndSettle();

      final typeAheadField = find.byType(TypeAheadFormField<String>).last;
      final scrollView = find.descendant(of: find.byType(SingleChildScrollView), matching: find.byType(Scrollable));

      await tester.dragUntilVisible(typeAheadField, scrollView, Offset(0, 1000));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await tester.tap(typeAheadField);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await tester.enterText(typeAheadField, "Milk");
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final typeAheadSuggestionBox = find.byType(CompositedTransformFollower).last;
      final CompositedTransformFollower typeAheadSuggestionBoxTester = tester.widget<CompositedTransformFollower>(typeAheadSuggestionBox);
      expect(typeAheadSuggestionBoxTester.offset, Offset(0.0, -5.0));
    });
  });
}
