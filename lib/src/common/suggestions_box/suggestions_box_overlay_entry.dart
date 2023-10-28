import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_box_decoration.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_box_follower.dart';

class SuggestionsBoxOverlayEntry extends StatelessWidget {
  const SuggestionsBoxOverlayEntry({
    super.key,
    required this.layerLink,
    required this.suggestionsListBuilder,
    required this.direction,
    required this.width,
    required this.height,
    required this.maxHeight,
    this.verticalOffset = 5,
    this.decoration,
    this.ignoreAccessibleNavigation = false,
  });

  final LayerLink layerLink;
  final WidgetBuilder suggestionsListBuilder;
  final AxisDirection direction;
  final double width;
  final double height;
  final double maxHeight;
  final double verticalOffset;
  final BaseSuggestionsBoxDecoration? decoration;
  final bool ignoreAccessibleNavigation;

  @override
  Widget build(BuildContext context) {
    Widget child = suggestionsListBuilder(context);

    BoxConstraints constraints;
    if (decoration?.constraints == null) {
      constraints = BoxConstraints(
        maxHeight: maxHeight,
      );
    } else {
      constraints = decoration!.constraints!.copyWith(
        minHeight: min(
          decoration!.constraints!.minHeight,
          maxHeight,
        ),
        maxHeight: min(
          decoration!.constraints!.maxHeight,
          maxHeight,
        ),
      );
    }

    child = ConstrainedBox(
      constraints: constraints,
      child: child,
    );

    child = SuggestionsBoxFollower(
      layerLink: layerLink,
      direction: direction,
      width: width,
      height: height,
      constraints: decoration?.constraints,
      offset: Offset(
        decoration?.offsetX ?? 0.0,
        verticalOffset,
      ),
      child: child,
    );

    bool accessibleNavigation = MediaQuery.of(context).accessibleNavigation;
    if (ignoreAccessibleNavigation) {
      accessibleNavigation = false;
    }

    if (accessibleNavigation) {
      // When wrapped in the Positioned widget, the suggestions box widget
      // is placed before the Scaffold semantically. In order to have the
      // suggestions box navigable from the search input or keyboard,
      // Semantics > Align > ConstrainedBox are needed. This does not change
      // the style visually. However, when VO/TB are not enabled it is
      // necessary to use the Positioned widget to allow the elements to be
      // properly tappable.
      return Semantics(
        container: true,
        child: Align(
          alignment: Alignment.topLeft,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: width),
            child: child,
          ),
        ),
      );
    } else {
      return Positioned(
        width: width,
        child: child,
      );
    }
  }
}
