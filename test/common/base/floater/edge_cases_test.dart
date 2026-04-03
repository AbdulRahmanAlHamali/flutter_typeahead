import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_typeahead/src/common/base/floater.dart';

import 'helpers.dart';

void main() {
  void setupView(WidgetTester tester, double size) {
    tester.view.physicalSize = Size(size, size);
    tester.view.devicePixelRatio = 1.0;
  }

  void tearDownView(WidgetTester tester) {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  }

  group('zero-size target', () {
    // 400x400 space, target at (200, 200) size 0x0.
    // For direction=down, default anchor:
    //   home region = from target bottom (200) to space bottom (400) = 200
    //   cross region = target width = 0
    // The floater has zero width but full height below.

    testWidgets('zero-size target has zero cross extent', (tester) async {
      setupView(tester, 400);
      addTearDown(() => tearDownView(tester));

      final data = await pumpFloater(tester,
          targetLeft: 200, targetTop: 200, targetWidth: 0, targetHeight: 0);

      expect(data, isNotNull);
      expect(data!.size.width, 0);
      expect(data.size.height, 200);
    });

    testWidgets('zero-size target with L:F R:F gets full width',
        (tester) async {
      setupView(tester, 400);
      addTearDown(() => tearDownView(tester));

      final data = await pumpFloater(tester,
          targetLeft: 200,
          targetTop: 200,
          targetWidth: 0,
          targetHeight: 0,
          anchor: const FloaterAnchor.only(
              bottom: false, left: false, right: false));

      expect(data, isNotNull);
      expect(data!.size.width, 400);
      expect(data.size.height, 200);
    });
  });

  group('target at space edge', () {
    // 400x400 space, target at (0, 350) size 100x50.
    // direction=down: home region = 350+50 to 400 = 0 height.

    testWidgets('target at bottom edge: zero space below', (tester) async {
      setupView(tester, 400);
      addTearDown(() => tearDownView(tester));

      final data = await pumpFloater(tester,
          targetLeft: 0, targetTop: 350, targetWidth: 100, targetHeight: 50);

      expect(data, isNotNull);
      expect(data!.size.height, 0);
    });

    testWidgets('target at top edge: full space below', (tester) async {
      setupView(tester, 400);
      addTearDown(() => tearDownView(tester));

      final data = await pumpFloater(tester,
          targetLeft: 0, targetTop: 0, targetWidth: 100, targetHeight: 50);

      expect(data, isNotNull);
      expect(data!.size.height, 350);
      expect(data.offset.dy, 50);
    });

    testWidgets('target at right edge: zero space right', (tester) async {
      setupView(tester, 400);
      addTearDown(() => tearDownView(tester));

      final data = await pumpFloater(tester,
          targetLeft: 300,
          targetTop: 100,
          targetWidth: 100,
          targetHeight: 50,
          direction: AxisDirection.right);

      expect(data, isNotNull);
      expect(data!.size.width, 0);
    });
  });

  group('autoFlip', () {
    // 400x400 space, target at (100, 350) size 200x30.
    // direction=down: space below = 400-350-30 = 20 (less than autoFlipHeight=100)
    // direction=up: space above = 350
    // autoFlip should switch to up.

    testWidgets('flips from down to up when insufficient space',
        (tester) async {
      setupView(tester, 400);
      addTearDown(() => tearDownView(tester));

      final data = await pumpFloater(tester,
          targetLeft: 100,
          targetTop: 350,
          targetWidth: 200,
          targetHeight: 30,
          autoFlip: true,
          autoFlipHeight: 100);

      expect(data, isNotNull);
      expect(data!.effectiveDirection, AxisDirection.up);
      expect(data.size.height, 350);
    });

    testWidgets('does not flip when sufficient space', (tester) async {
      setupView(tester, 400);
      addTearDown(() => tearDownView(tester));

      final data = await pumpFloater(tester,
          targetLeft: 100,
          targetTop: 100,
          targetWidth: 200,
          targetHeight: 30,
          autoFlip: true,
          autoFlipHeight: 100);

      expect(data, isNotNull);
      expect(data!.effectiveDirection, AxisDirection.down);
      expect(data.size.height, 270);
    });

    testWidgets('flips from left to right when insufficient space',
        (tester) async {
      setupView(tester, 400);
      addTearDown(() => tearDownView(tester));

      final data = await pumpFloater(tester,
          targetLeft: 20,
          targetTop: 100,
          targetWidth: 30,
          targetHeight: 200,
          direction: AxisDirection.left,
          autoFlip: true,
          autoFlipHeight: 100);

      expect(data, isNotNull);
      expect(data!.effectiveDirection, AxisDirection.right);
      expect(data.size.width, 350);
    });

    testWidgets('does not flip when disabled', (tester) async {
      setupView(tester, 400);
      addTearDown(() => tearDownView(tester));

      final data = await pumpFloater(tester,
          targetLeft: 100,
          targetTop: 350,
          targetWidth: 200,
          targetHeight: 30,
          autoFlip: false);

      expect(data, isNotNull);
      expect(data!.effectiveDirection, AxisDirection.down);
      expect(data.size.height, 20);
    });
  });

  group('padding larger than available space', () {
    // 400x400 space, target at (100, 100) size 200x200.
    // direction=down: floater from y=300 to y=400, height=100.
    // padding.top=150 would eat more than available height.

    testWidgets('padding exceeding space clamps to zero size', (tester) async {
      setupView(tester, 400);
      addTearDown(() => tearDownView(tester));

      final data = await pumpFloater(tester,
          targetLeft: 100,
          targetTop: 100,
          targetWidth: 200,
          targetHeight: 200,
          padding: const EdgeInsets.only(top: 150));

      expect(data, isNotNull);
      expect(data!.size.height, 0);
    });

    testWidgets('padding exactly equal to space gives zero size',
        (tester) async {
      setupView(tester, 400);
      addTearDown(() => tearDownView(tester));

      final data = await pumpFloater(tester,
          targetLeft: 100,
          targetTop: 100,
          targetWidth: 200,
          targetHeight: 200,
          padding: const EdgeInsets.only(top: 100));

      expect(data, isNotNull);
      expect(data!.size.height, 0);
    });
  });

  group('asymmetric target position', () {
    // 800x600 space, target at (50, 20) size 100x30.
    // This creates very unequal grid cells.
    // direction=down, default anchor:
    //   floater at x=50, y=50, width=100, height=550

    testWidgets('non-centered target computes correct rect', (tester) async {
      tester.view.physicalSize = const Size(800, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tearDownView(tester));

      final data = await pumpFloater(tester,
          targetLeft: 50, targetTop: 20, targetWidth: 100, targetHeight: 30);

      expect(data, isNotNull);
      expect(data!.offset, const Offset(50, 50));
      expect(data.size, const Size(100, 550));
    });

    testWidgets('non-centered target with L:F R:F', (tester) async {
      tester.view.physicalSize = const Size(800, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tearDownView(tester));

      final data = await pumpFloater(tester,
          targetLeft: 50,
          targetTop: 20,
          targetWidth: 100,
          targetHeight: 30,
          anchor: const FloaterAnchor.only(
              bottom: false, left: false, right: false));

      expect(data, isNotNull);
      expect(data!.offset, const Offset(0, 50));
      expect(data.size, const Size(800, 550));
    });
  });
}
