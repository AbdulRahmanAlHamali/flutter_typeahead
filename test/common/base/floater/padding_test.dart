import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_typeahead/src/common/base/floater.dart';

import 'helpers.dart';

// Same 900x900 grid with 300x300 cells as the position test.
// Target at (300,300) size 300x300.
//
// Padding is direction-relative:
//   top    = main axis start (gap between target and floater)
//   bottom = main axis end (far edge)
//   left   = cross axis start
//   right  = cross axis end

// Default anchor (T:T B:F L:T R:T) used for most cases.
const _default = FloaterAnchor.only(bottom: false);

// Each row: (description, direction, anchor, padding, expectedOffset, expectedSize)
final _cases =
    <(String, AxisDirection, FloaterAnchor, EdgeInsets, Offset, Size)>[
  // direction=down, default anchor → BC cell: offset=(300,600), size=(300,300)
  (
    'down: top=10 shrinks main start',
    AxisDirection.down,
    _default,
    const EdgeInsets.only(top: 10),
    const Offset(300, 610),
    const Size(300, 290)
  ),
  (
    'down: bottom=10 shrinks main end',
    AxisDirection.down,
    _default,
    const EdgeInsets.only(bottom: 10),
    const Offset(300, 600),
    const Size(300, 290)
  ),
  (
    'down: left=10 shrinks cross start',
    AxisDirection.down,
    _default,
    const EdgeInsets.only(left: 10),
    const Offset(310, 600),
    const Size(290, 300)
  ),
  (
    'down: right=10 shrinks cross end',
    AxisDirection.down,
    _default,
    const EdgeInsets.only(right: 10),
    const Offset(300, 600),
    const Size(290, 300)
  ),
  (
    'down: all sides LTRB(10,20,30,40)',
    AxisDirection.down,
    _default,
    const EdgeInsets.fromLTRB(10, 20, 30, 40),
    const Offset(310, 620),
    const Size(260, 240)
  ),

  // direction=up, default anchor → TC cell: offset=(300,0), size=(300,300)
  (
    'up: top=10 shrinks main start',
    AxisDirection.up,
    _default,
    const EdgeInsets.only(top: 10),
    const Offset(300, 0),
    const Size(300, 290)
  ),
  (
    'up: bottom=10 shrinks main end',
    AxisDirection.up,
    _default,
    const EdgeInsets.only(bottom: 10),
    const Offset(300, 10),
    const Size(300, 290)
  ),
  (
    'up: left=10 shrinks cross start',
    AxisDirection.up,
    _default,
    const EdgeInsets.only(left: 10),
    const Offset(310, 0),
    const Size(290, 300)
  ),
  (
    'up: right=10 shrinks cross end',
    AxisDirection.up,
    _default,
    const EdgeInsets.only(right: 10),
    const Offset(300, 0),
    const Size(290, 300)
  ),

  // direction=left, default anchor → ML cell: offset=(0,300), size=(300,300)
  (
    'left: top=10 shrinks main start',
    AxisDirection.left,
    _default,
    const EdgeInsets.only(top: 10),
    const Offset(0, 300),
    const Size(290, 300)
  ),
  (
    'left: bottom=10 shrinks main end',
    AxisDirection.left,
    _default,
    const EdgeInsets.only(bottom: 10),
    const Offset(10, 300),
    const Size(290, 300)
  ),
  (
    'left: left=10 shrinks cross start',
    AxisDirection.left,
    _default,
    const EdgeInsets.only(left: 10),
    const Offset(0, 310),
    const Size(300, 290)
  ),
  (
    'left: right=10 shrinks cross end',
    AxisDirection.left,
    _default,
    const EdgeInsets.only(right: 10),
    const Offset(0, 300),
    const Size(300, 290)
  ),

  // direction=right, default anchor → MR cell: offset=(600,300), size=(300,300)
  (
    'right: top=10 shrinks main start',
    AxisDirection.right,
    _default,
    const EdgeInsets.only(top: 10),
    const Offset(610, 300),
    const Size(290, 300)
  ),
  (
    'right: bottom=10 shrinks main end',
    AxisDirection.right,
    _default,
    const EdgeInsets.only(bottom: 10),
    const Offset(600, 300),
    const Size(290, 300)
  ),
  (
    'right: left=10 shrinks cross start',
    AxisDirection.right,
    _default,
    const EdgeInsets.only(left: 10),
    const Offset(600, 310),
    const Size(300, 290)
  ),
  (
    'right: right=10 shrinks cross end',
    AxisDirection.right,
    _default,
    const EdgeInsets.only(right: 10),
    const Offset(600, 300),
    const Size(300, 290)
  ),

  // Non-default anchors with padding
  (
    'down L:F R:F: left=10 on full width',
    AxisDirection.down,
    const FloaterAnchor.only(bottom: false, left: false, right: false),
    const EdgeInsets.only(left: 10),
    const Offset(10, 600),
    const Size(890, 300)
  ),
  (
    'down T:F B:F: top=10 on expand-through',
    AxisDirection.down,
    const FloaterAnchor.only(top: false, bottom: false),
    const EdgeInsets.only(top: 10),
    const Offset(300, 310),
    const Size(300, 590)
  ),
];

void main() {
  for (final (desc, direction, anchor, padding, expectedOffset, expectedSize)
      in _cases) {
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
        padding: padding,
      );

      expect(data, isNotNull);
      expect(data!.offset, expectedOffset, reason: 'offset: $desc');
      expect(data.size, expectedSize, reason: 'size: $desc');
    });
  }
}
