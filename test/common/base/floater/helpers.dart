import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_typeahead/src/common/base/floater.dart';

const defaultSpace = 900.0;
const defaultCell = 300.0;

/// Pumps a Floater in a controlled space with the target at a known position.
///
/// The default setup is a 900x900 overlay with the target at (300,300) size 300x300,
/// creating a 3x3 grid of equal 300x300 cells.
Future<FloaterData?> pumpFloater(
  WidgetTester tester, {
  AxisDirection direction = AxisDirection.down,
  FloaterAnchor anchor = const FloaterAnchor.only(bottom: false),
  EdgeInsets padding = EdgeInsets.zero,
  EdgeInsets viewPadding = EdgeInsets.zero,
  EdgeInsets viewInsets = EdgeInsets.zero,
  double targetLeft = defaultCell,
  double targetTop = defaultCell,
  double targetWidth = defaultCell,
  double targetHeight = defaultCell,
  bool autoFlip = false,
  double autoFlipHeight = 100,
}) async {
  FloaterData? data;
  final link = FloaterLink();

  await tester.pumpWidget(
    Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: MediaQueryData(padding: viewPadding, viewInsets: viewInsets),
        child: Overlay(
          initialEntries: [
            OverlayEntry(
              builder: (context) => Stack(
                children: [
                  Positioned(
                    left: targetLeft,
                    top: targetTop,
                    width: targetWidth,
                    height: targetHeight,
                    child: Floater(
                      link: link,
                      direction: direction,
                      anchor: anchor,
                      padding: padding,
                      autoFlip: autoFlip,
                      autoFlipHeight: autoFlipHeight,
                      builder: (context) {
                        data = Floater.of(context);
                        return const SizedBox();
                      },
                      child: FloaterTarget(
                        link: link,
                        child: const SizedBox.expand(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );

  await tester.pumpAndSettle();
  return data;
}
