import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/root_media_query.dart';

void main() {
  group('rootMediaQueryOf', () {
    testWidgets('returns the root MediaQuery of context',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(200, 200)),
            child: Builder(
              builder: (context) {
                final rootMediaQuery = rootMediaQueryOf(context);

                expect(rootMediaQuery, isNotNull);
                expect(rootMediaQuery, isA<MediaQuery>());
                expect(
                  rootMediaQuery?.data.size,
                  isNot(const Size(200, 200)),
                );

                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });
  });
}
