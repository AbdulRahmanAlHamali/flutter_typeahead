import 'package:flutter/widgets.dart';

class SuggestionsBoxFollower extends StatelessWidget {
  const SuggestionsBoxFollower({
    super.key,
    required this.layerLink,
    required this.child,
    required this.direction,
    this.constraints,
    this.offset,
  });

  final LayerLink layerLink;
  final Widget child;

  final AxisDirection direction;
  final BoxConstraints? constraints;
  final Offset? offset;

  @override
  Widget build(BuildContext context) {
    double offsetX = offset?.dx ?? 0;
    double offsetY = offset?.dy ?? 5;
    Alignment anchor = Alignment.bottomLeft;
    Widget child = this.child;

    if (direction == AxisDirection.up) {
      offsetY = -offsetY;
      anchor = Alignment.topLeft;
      child = FractionalTranslation(
        translation: const Offset(0, -1),
        child: child,
      );
    }

    return CompositedTransformFollower(
      link: layerLink,
      showWhenUnlinked: false,
      offset: Offset(offsetX, offsetY),
      targetAnchor: anchor,
      child: child,
    );
  }
}
