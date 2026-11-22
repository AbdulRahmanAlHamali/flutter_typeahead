import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_typeahead/src/common/base/suggestions_controller.dart';
import 'package:flutter_typeahead/src/common/field/suggestions_field.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  group('SuggestionsField', () {
    const double offset = 5;

    Future<({Rect field, Rect box, VerticalDirection effectiveDirection})> pump(
      WidgetTester tester, {
      required double fieldTop,
      VerticalDirection direction = VerticalDirection.down,
    }) async {
      tester.view.physicalSize = const Size(400, 400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final controller = SuggestionsController<String>();
      addTearDown(controller.dispose);
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: fieldTop,
                child: SuggestionsField<String>(
                  controller: controller,
                  focusNode: focusNode,
                  direction: direction,
                  autoFlipDirection: true,
                  constraints: const BoxConstraints(maxHeight: 100),
                  builder: (context, controller) =>
                      const SizedBox(key: Key('box'), width: 400, height: 100),
                  child: const SizedBox(key: Key('field'), height: 48),
                ),
              ),
            ],
          ),
        ),
      );

      controller.open();
      await tester.pumpAndSettle();

      return (
        field: tester.getRect(find.byKey(const Key('field'))),
        box: tester.getRect(find.byKey(const Key('box'))),
        effectiveDirection: controller.effectiveDirection,
      );
    }

    testWidgets('keeps the box below the field when it opens downwards', (
      WidgetTester tester,
    ) async {
      final result = await pump(tester, fieldTop: 10);

      expect(result.effectiveDirection, VerticalDirection.down);
      expect(result.box.top, result.field.bottom + offset);
    });

    testWidgets('keeps the box above the field when it opens upwards', (
      WidgetTester tester,
    ) async {
      final result = await pump(
        tester,
        fieldTop: 300,
        direction: VerticalDirection.up,
      );

      expect(result.effectiveDirection, VerticalDirection.up);
      expect(result.box.bottom, result.field.top - offset);
    });

    testWidgets('keeps the box above the field when it flips upwards', (
      WidgetTester tester,
    ) async {
      final result = await pump(tester, fieldTop: 300);

      expect(result.effectiveDirection, VerticalDirection.up);
      expect(result.box.bottom, result.field.top - offset);
    });

    testWidgets('keeps the box below the field when it flips downwards', (
      WidgetTester tester,
    ) async {
      final result = await pump(
        tester,
        fieldTop: 10,
        direction: VerticalDirection.up,
      );

      expect(result.effectiveDirection, VerticalDirection.down);
      expect(result.box.top, result.field.bottom + offset);
    });
  });
}
