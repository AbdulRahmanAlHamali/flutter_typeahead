import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_typeahead/src/common/base/floater.dart';

import 'helpers.dart';

// The test space is 900x900, with the target at (300,300) size 300x300.
// This creates a perfect 3x3 grid of equal 300x300 cells:
//
//   +------+--------+------+
//   |  TL  |   TC   |  TR  |  row 0
//   +------+--------+------+
//   |  ML  | TARGET |  MR  |  row 1
//   +------+--------+------+
//   |  BL  |   BC   |  BR  |  row 2
//   +------+--------+------+
//     col0    col1    col2

const _space = defaultSpace;
const _cell = defaultCell;

const _cellNames = [
  ['TL', 'TC', 'TR'],
  ['ML', 'TG', 'MR'],
  ['BL', 'BC', 'BR'],
];

/// Describes how a direction maps onto the 3x3 grid.
///
/// The floater opens from the target in the given direction.
/// [homeRow]/[homeCol] is the cell where the floater naturally appears.
/// [oppositeRow]/[oppositeCol] is the cell on the far side of the target from home.
///
/// The main axis is the axis along the opening direction.
/// The cross axis is perpendicular to it.
class _DirectionConfig {
  final String name;
  final AxisDirection direction;
  final int homeRow, homeCol;
  final int oppositeRow, oppositeCol;

  /// Whether the main axis maps to grid rows ('row') or grid columns ('col').
  final bool mainAxisIsRow;

  /// Cross axis indices in the perpendicular axis.
  final int crossStart, crossCenter, crossEnd;

  const _DirectionConfig({
    required this.name,
    required this.direction,
    required this.homeRow,
    required this.homeCol,
    required this.oppositeRow,
    required this.oppositeCol,
    required this.mainAxisIsRow,
    required this.crossStart,
    required this.crossCenter,
    required this.crossEnd,
  });
}

const _directions = [
  _DirectionConfig(
    name: 'down',
    direction: AxisDirection.down,
    homeRow: 2,
    homeCol: 1,
    oppositeRow: 0,
    oppositeCol: 1,
    mainAxisIsRow: true,
    crossStart: 0,
    crossCenter: 1,
    crossEnd: 2,
  ),
  _DirectionConfig(
    name: 'up',
    direction: AxisDirection.up,
    homeRow: 0,
    homeCol: 1,
    oppositeRow: 2,
    oppositeCol: 1,
    mainAxisIsRow: true,
    crossStart: 0,
    crossCenter: 1,
    crossEnd: 2,
  ),
  _DirectionConfig(
    name: 'left',
    direction: AxisDirection.left,
    homeRow: 1,
    homeCol: 0,
    oppositeRow: 1,
    oppositeCol: 2,
    mainAxisIsRow: false,
    crossStart: 0,
    crossCenter: 1,
    crossEnd: 2,
  ),
  _DirectionConfig(
    name: 'right',
    direction: AxisDirection.right,
    homeRow: 1,
    homeCol: 2,
    oppositeRow: 1,
    oppositeCol: 0,
    mainAxisIsRow: false,
    crossStart: 0,
    crossCenter: 1,
    crossEnd: 2,
  ),
];

/// Computes which main-axis indices the floater occupies.
///
/// Main axis states:
///   T,F → [home]                 standard: just the opening side
///   T,T → [target]               overlap target exactly
///   F,F → [target, home]         expand through target
///   F,T → [opposite, target]     shifted to opposite side
List<int> _mainAxisIndices(_DirectionConfig dir, bool top, bool bottom) {
  final home = dir.mainAxisIsRow ? dir.homeRow : dir.homeCol;
  const target = 1;
  final opposite = dir.mainAxisIsRow ? dir.oppositeRow : dir.oppositeCol;

  if (top && !bottom) return [home];
  if (top && bottom) return [target];
  if (!top && !bottom) return [target, home];
  /* !top && bottom */ return [opposite, target];
}

/// Computes which cross-axis indices the floater occupies.
///
/// Cross axis states:
///   T,T → [center]               target extent only
///   T,F → [center, end]          extend toward cross end
///   F,T → [start, center]        extend toward cross start
///   F,F → [start, center, end]   full cross extent
List<int> _crossAxisIndices(_DirectionConfig dir, bool left, bool right) {
  final indices = [dir.crossCenter];
  if (!left) indices.add(dir.crossStart);
  if (!right) indices.add(dir.crossEnd);
  return indices;
}

/// Computes the set of occupied grid cells as (row, col) pairs.
Set<(int, int)> _occupiedCells(
  _DirectionConfig dir,
  bool top,
  bool bottom,
  bool left,
  bool right,
) {
  final mainIndices = _mainAxisIndices(dir, top, bottom);
  final crossIndices = _crossAxisIndices(dir, left, right);

  final cells = <(int, int)>{};
  for (final m in mainIndices) {
    for (final c in crossIndices) {
      if (dir.mainAxisIsRow) {
        cells.add((m, c));
      } else {
        cells.add((c, m));
      }
    }
  }
  return cells;
}

/// Computes the expected bounding box (offset, size) from a set of grid cells.
(Offset, Size) _expectedBounds(Set<(int, int)> cells) {
  final rows = cells.map((c) => c.$1);
  final cols = cells.map((c) => c.$2);
  final minRow = rows.reduce(math.min);
  final maxRow = rows.reduce(math.max);
  final minCol = cols.reduce(math.min);
  final maxCol = cols.reduce(math.max);
  return (
    Offset(minCol * _cell, minRow * _cell),
    Size((maxCol - minCol + 1) * _cell, (maxRow - minRow + 1) * _cell),
  );
}

/// Returns a human-readable label for a set of cells, e.g. "BC+BR".
String _cellLabel(Set<(int, int)> cells) {
  final names = cells.map((c) => _cellNames[c.$1][c.$2]).toList()..sort();
  return names.join('+');
}

void main() {
  for (final dir in _directions) {
    group('direction=${dir.name}', () {
      for (final top in [true, false]) {
        for (final bottom in [true, false]) {
          for (final left in [true, false]) {
            for (final right in [true, false]) {
              final cells = _occupiedCells(dir, top, bottom, left, right);
              final label = _cellLabel(cells);
              final (expectedOffset, expectedSize) = _expectedBounds(cells);

              testWidgets(
                'anchor(T:$top B:$bottom L:$left R:$right) → $label',
                (tester) async {
                  tester.view.physicalSize = const Size(_space, _space);
                  tester.view.devicePixelRatio = 1.0;
                  addTearDown(() {
                    tester.view.resetPhysicalSize();
                    tester.view.resetDevicePixelRatio();
                  });

                  final data = await pumpFloater(
                    tester,
                    direction: dir.direction,
                    anchor: FloaterAnchor.only(
                      top: top,
                      bottom: bottom,
                      left: left,
                      right: right,
                    ),
                  );

                  expect(data, isNotNull, reason: 'FloaterData was not set');
                  expect(
                    data!.size,
                    expectedSize,
                    reason: 'size for $label',
                  );
                  expect(
                    data.offset,
                    expectedOffset,
                    reason: 'offset for $label',
                  );
                },
              );
            }
          }
        }
      }
    });
  }
}
