import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_typeahead/src/common/base/floater.dart';

import 'helpers.dart';

// Same 900x900 grid with 300x300 cells as the position test.
// Target at (300,300) size 300x300.
//
// View padding represents system UI areas (status bar, keyboard, etc.)
// that shrink the available space before the floater rect is computed.

const _default = FloaterAnchor.only(bottom: false);

// Each row: (description, direction, anchor, viewPadding, padding, expectedOffset, expectedSize)
//
// Base cases without view padding for reference:
//   down default → BC: offset=(300,600), size=(300,300)
//   up default   → TC: offset=(300,0),   size=(300,300)

final _cases = <(
  String,
  AxisDirection,
  FloaterAnchor,
  EdgeInsets,
  EdgeInsets,
  Offset,
  Size
)>[
  // Keyboard (bottom inset) shrinks downward floater
  (
    'keyboard shrinks down floater',
    AxisDirection.down,
    _default,
    const EdgeInsets.only(bottom: 100),
    EdgeInsets.zero,
    const Offset(300, 600),
    const Size(300, 200)
  ),

  // Keyboard does not affect upward floater
  (
    'keyboard does not affect up floater',
    AxisDirection.up,
    _default,
    const EdgeInsets.only(bottom: 100),
    EdgeInsets.zero,
    const Offset(300, 0),
    const Size(300, 300)
  ),

  // Status bar (top inset) shrinks upward floater
  (
    'status bar shrinks up floater',
    AxisDirection.up,
    _default,
    const EdgeInsets.only(top: 50),
    EdgeInsets.zero,
    const Offset(300, 50),
    const Size(300, 250)
  ),

  // Status bar does not affect downward floater
  (
    'status bar does not affect down floater',
    AxisDirection.down,
    _default,
    const EdgeInsets.only(top: 50),
    EdgeInsets.zero,
    const Offset(300, 600),
    const Size(300, 300)
  ),

  // Left inset shrinks full-width floater
  (
    'left inset shrinks full-width floater',
    AxisDirection.down,
    const FloaterAnchor.only(bottom: false, left: false, right: false),
    const EdgeInsets.only(left: 50),
    EdgeInsets.zero,
    const Offset(50, 600),
    const Size(850, 300)
  ),

  // Right inset shrinks rightward floater
  (
    'right inset shrinks right floater',
    AxisDirection.right,
    _default,
    const EdgeInsets.only(right: 80),
    EdgeInsets.zero,
    const Offset(600, 300),
    const Size(220, 300)
  ),

  // View padding + floater padding stack
  (
    'keyboard + padding.top stack on down floater',
    AxisDirection.down,
    _default,
    const EdgeInsets.only(bottom: 100),
    const EdgeInsets.only(top: 10),
    const Offset(300, 610),
    const Size(300, 190)
  ),
];

void main() {
  for (final (
        desc,
        direction,
        anchor,
        viewPadding,
        padding,
        expectedOffset,
        expectedSize
      ) in _cases) {
    testWidgets(desc, (tester) async {
      tester.view.physicalSize = const Size(defaultSpace, defaultSpace);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final data = await pumpFloater(
        tester,
        direction: direction,
        anchor: anchor,
        viewPadding: viewPadding,
        padding: padding,
      );

      expect(data, isNotNull);
      expect(data!.offset, expectedOffset, reason: 'offset: $desc');
      expect(data.size, expectedSize, reason: 'size: $desc');
    });
  }
}
