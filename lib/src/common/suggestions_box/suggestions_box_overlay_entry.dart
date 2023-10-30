import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_box_decoration.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_box_follower.dart';

@immutable
class SuggestionsBoxOverlayEntryConfig {
  const SuggestionsBoxOverlayEntryConfig({
    required this.layerLink,
    required this.suggestionsListBuilder,
    required this.direction,
    required this.width,
    required this.height,
    required this.maxHeight,
    required this.decoration,
    this.ignoreAccessibleNavigation = false,
  });

  final LayerLink layerLink;
  final WidgetBuilder suggestionsListBuilder;
  final AxisDirection direction;
  final double width;
  final double height;
  final double maxHeight;
  final BaseSuggestionsBoxDecoration decoration;
  final bool ignoreAccessibleNavigation;

  SuggestionsBoxOverlayEntryConfig copyWith({
    LayerLink? layerLink,
    WidgetBuilder? suggestionsListBuilder,
    AxisDirection? direction,
    double? width,
    double? height,
    double? maxHeight,
    BaseSuggestionsBoxDecoration? decoration,
    bool? ignoreAccessibleNavigation,
  }) {
    return SuggestionsBoxOverlayEntryConfig(
      layerLink: layerLink ?? this.layerLink,
      suggestionsListBuilder:
          suggestionsListBuilder ?? this.suggestionsListBuilder,
      direction: direction ?? this.direction,
      width: width ?? this.width,
      height: height ?? this.height,
      maxHeight: maxHeight ?? this.maxHeight,
      decoration: decoration ?? this.decoration,
      ignoreAccessibleNavigation:
          ignoreAccessibleNavigation ?? this.ignoreAccessibleNavigation,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SuggestionsBoxOverlayEntryConfig &&
          runtimeType == other.runtimeType &&
          layerLink == other.layerLink &&
          suggestionsListBuilder == other.suggestionsListBuilder &&
          direction == other.direction &&
          width == other.width &&
          height == other.height &&
          maxHeight == other.maxHeight &&
          decoration == other.decoration &&
          ignoreAccessibleNavigation == other.ignoreAccessibleNavigation;

  @override
  int get hashCode => Object.hash(
        layerLink,
        suggestionsListBuilder,
        direction,
        width,
        height,
        maxHeight,
        decoration,
        ignoreAccessibleNavigation,
      );
}

class SuggestionsBoxOverlayEntry extends StatelessWidget {
  const SuggestionsBoxOverlayEntry({
    super.key,
    required this.config,
  });

  final ValueNotifier<SuggestionsBoxOverlayEntryConfig> config;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: config,
      builder: (context, value, child) {
        final SuggestionsBoxOverlayEntryConfig(
          :layerLink,
          :suggestionsListBuilder,
          :direction,
          :width,
          // :height,
          :maxHeight,
          :decoration,
          :ignoreAccessibleNavigation
        ) = value;

        Widget child = suggestionsListBuilder(context);

        BoxConstraints? constraints = decoration.constraints;
        if (constraints == null) {
          constraints = BoxConstraints(
            maxHeight: maxHeight,
          );
        } else {
          constraints = constraints.copyWith(
            minHeight: min(
              constraints.minHeight,
              maxHeight,
            ),
            maxHeight: min(
              constraints.maxHeight,
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
          constraints: decoration.constraints,
          offset: Offset(
            decoration.offsetX,
            decoration.offsetY,
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
      },
    );
  }
}
