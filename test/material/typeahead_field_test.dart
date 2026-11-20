import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

void main() {
  group('TypeAheadField', () {
    testWidgets('renders', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: TypeAheadField<String>(
              itemBuilder: (context, value) => Text(value),
              onSelected: (value) {},
              suggestionsCallback: (search) {
                return ['a', 'b', 'c'];
              },
            ),
          ),
        ),
      );
    });

    testWidgets('uses the app theme in the field and the suggestions box', (
      WidgetTester tester,
    ) async {
      final theme = ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE91E63)),
        hoverColor: const Color(0xFF00BCD4),
      );
      final controller = SuggestionsController<String>();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: Scaffold(
            body: TypeAheadField<String>(
              suggestionsController: controller,
              itemBuilder: (context, value) => Text(value),
              onSelected: (value) {},
              suggestionsCallback: (search) => ['a', 'b', 'c'],
            ),
          ),
        ),
      );
      await tester.tap(find.byType(EditableText));
      await tester.pumpAndSettle();
      controller.highlighted = 0;
      await tester.pumpAndSettle();

      final cursor = tester.widget<EditableText>(find.byType(EditableText));
      final highlight = tester.widget<Container>(
        find
            .ancestor(of: find.text('a'), matching: find.byType(Container))
            .first,
      );
      expect(cursor.cursorColor, theme.colorScheme.primary);
      expect(highlight.color, theme.hoverColor);
    });
  });
}
