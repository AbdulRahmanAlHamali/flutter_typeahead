import 'package:material_ui/material_ui.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

void main() {
  group('TypeAheadField', () {
    testWidgets('renders', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: CupertinoTypeAheadField<String>(
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
      const theme = CupertinoThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xFFE91E63),
        barBackgroundColor: Color(0xFF3F51B5),
        textTheme: CupertinoTextThemeData(
          textStyle: TextStyle(color: Color(0xFF00BCD4), fontSize: 21),
        ),
      );

      await tester.pumpWidget(
        CupertinoApp(
          theme: theme,
          home: CupertinoPageScaffold(
            child: CupertinoTypeAheadField<String>(
              itemBuilder: (context, value) => Text(value),
              onSelected: (value) {},
              suggestionsCallback: (search) => ['a', 'b', 'c'],
            ),
          ),
        ),
      );
      await tester.tap(find.byType(EditableText));
      await tester.pumpAndSettle();

      final cursor = tester.widget<EditableText>(find.byType(EditableText));
      final boxColors = tester
          .widgetList<DecoratedBox>(
            find.ancestor(
              of: find.text('a'),
              matching: find.byType(DecoratedBox),
            ),
          )
          .map((box) => box.decoration)
          .whereType<BoxDecoration>()
          .map((decoration) => decoration.color)
          .toList();
      final itemStyle = DefaultTextStyle.of(
        tester.element(find.text('a')),
      ).style;
      expect(cursor.cursorColor, theme.primaryColor);
      expect(boxColors, contains(theme.barBackgroundColor));
      expect(itemStyle.color, theme.textTheme.textStyle.color);
      expect(itemStyle.fontSize, 21);
    });
  });
}
