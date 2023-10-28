import 'package:flutter/widgets.dart';

class SuggestionsBoxFollower extends StatelessWidget {
  const SuggestionsBoxFollower({
    super.key,
    required this.layerLink,
    required this.child,
    required this.direction,
    required this.width,
    required this.height,
    this.constraints,
    this.offset,
  });

  final LayerLink layerLink;
  final Widget child;

  final AxisDirection direction;
  final double width;
  final double height;
  final BoxConstraints? constraints;
  final Offset? offset;

  @override
  Widget build(BuildContext context) {
    double width = this.width;

    BoxConstraints? constraints = this.constraints;

    if (constraints != null) {
      bool hasMinWidth = constraints.minWidth != 0;
      bool hasMaxWidth = constraints.maxWidth != double.infinity;

      if (hasMinWidth && hasMaxWidth) {
        width = (constraints.minWidth + constraints.maxWidth) / 2;
      } else if (hasMinWidth && constraints.minWidth > width) {
        width = constraints.minWidth;
      } else if (hasMaxWidth && constraints.maxWidth < width) {
        width = constraints.maxWidth;
      }
    }

    double offsetX = offset?.dx ?? 0;
    double verticalOffset = offset?.dy ?? 5;

    double offsetY;
    if (direction == AxisDirection.down) {
      offsetY = height + verticalOffset;
    } else {
      offsetY = -verticalOffset;
    }

    Widget child = this.child;

    if (direction == AxisDirection.up) {
      child = FractionalTranslation(
        // visually flips list to go up
        translation: const Offset(0, -1),
        child: child,
      );
    }

    return CompositedTransformFollower(
      link: layerLink,
      showWhenUnlinked: false,
      offset: Offset(offsetX, offsetY),
      child: child,
    );
  }
}
