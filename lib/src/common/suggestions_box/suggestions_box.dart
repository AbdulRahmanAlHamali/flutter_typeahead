import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_blox_floater.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_box_controller.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_box_dimension_connector.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_box_focus_connector.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_box_keyboard_connector.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_box_tap_connector.dart';

/// A widget that displays a list of suggestions above or below another widget.
class SuggestionsBox extends StatefulWidget {
  const SuggestionsBox({
    super.key,
    this.direction = AxisDirection.down,
    required this.controller,
    required this.suggestionsBuilder,
    required this.focusNode,
    required this.child,
    this.autoFlipDirection = false,
    this.autoFlipListDirection = true,
    this.autoFlipMinHeight = 64,
    this.hideOnUnfocus = true,
    this.constraints,
    this.offset,
  });

  /// The controller of the suggestions box.
  final SuggestionsBoxController? controller;

  /// The builder for the suggestions list.
  final Widget Function(
    BuildContext context,
    SuggestionsBoxController controller,
  ) suggestionsBuilder;

  /// The focus node of the child of the suggestions box.
  final FocusNode focusNode;

  /// The child of the suggestions box.
  final Widget child;

  /// {@macro flutter_typeahead.SuggestionsListConfig.direction}
  final AxisDirection direction;

  /// {@template flutter_typeahead.SuggestionsBox.constraints}
  /// The constraints to be applied to the suggestions box
  /// {@endtemplate}
  final BoxConstraints? constraints;

  /// {@macro flutter_typeahead.BaseSuggestionsBoxDecoration.offset}
  final Offset? offset;

  /// {@template flutter_typeahead.SuggestionsBox.autoFlipDirection}
  /// Whether the suggestions box should automatically flip direction if there's not enough space
  /// in the desired direction, but there is enough space in the opposite direction.
  ///
  /// Defaults to false.
  ///
  /// See also:
  /// * [autoFlipListDirection], which controls whether the suggestions list should be reversed if the suggestions box is flipped.
  /// * [autoFlipMinHeight], which controls the minimum height the suggesttions box can have before attempting to flip.
  /// {@endtemplate}
  final bool autoFlipDirection;

  /// {@macro flutter_typeahead.SuggestionsListConfig.autoFlipListDirection}
  final bool autoFlipListDirection;

  /// {@template flutter_typeahead.SuggestionsBox.autoFlipMinHeight}
  /// The minimum height the suggesttions box can have before attempting to flip.
  ///
  /// Defaults to 64.
  /// {@endtemplate}
  final double autoFlipMinHeight;

  /// {@template flutter_typeahead.SuggestionsBox.hideOnUnfocus}
  /// Whether the suggestions box should be hidden when the child of the suggestions box loses focus.
  ///
  /// If disabled, the suggestions box will remain open when the user e.g. closes the keyboard.
  ///
  /// Defaults to true.
  /// {@endtemplate}
  final bool hideOnUnfocus;

  @override
  State<SuggestionsBox> createState() => _SuggestionsBoxState();
}

class _SuggestionsBoxState extends State<SuggestionsBox> {
  final FloaterLink link = FloaterLink();
  late SuggestionsBoxController controller;
  late StreamSubscription<void> resizeSubscription;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? SuggestionsBoxController();
    resizeSubscription =
        controller.resizeEvents.listen((_) => link.markNeedsBuild());
  }

  @override
  void didUpdateWidget(covariant SuggestionsBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      if (oldWidget.controller == null) {
        controller.dispose();
      }
      controller = widget.controller ?? SuggestionsBoxController();
      resizeSubscription.cancel();
      resizeSubscription =
          controller.resizeEvents.listen((_) => link.markNeedsBuild());
    }
  }

  @override
  void dispose() {
    resizeSubscription.cancel();
    if (widget.controller == null) {
      controller.dispose();
    }
    link.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Offset offset = widget.offset ?? const Offset(0, 5);

    if (widget.direction == AxisDirection.up) {
      offset = Offset(offset.dx, -offset.dy);
    }

    return Floater(
      link: link,
      direction: widget.direction,
      offset: offset,
      followHeight: false,
      builder: (context) {
        Widget list = widget.suggestionsBuilder(context, controller);

        if (widget.constraints != null) {
          Alignment alignment = Alignment.topLeft;
          if (widget.direction == AxisDirection.up) {
            alignment = Alignment.bottomLeft;
          }
          list = Align(
            alignment: alignment,
            child: ConstrainedBox(
              constraints: widget.constraints!,
              child: list,
            ),
          );
        }

        list = Semantics(
          container: true,
          child: list,
        );

        return list;
      },
      child: FloaterTarget(
        link: link,
        child: SuggestionsBoxFocusConnector(
          controller: controller,
          focusNode: widget.focusNode,
          hideOnUnfocus: widget.hideOnUnfocus,
          child: SuggestionsBoxKeyboardConnector(
            controller: controller,
            hideOnUnfocus: widget.hideOnUnfocus,
            child: SuggestionsBoxTapConnector(
              controller: controller,
              child: SuggestionsBoxDimensionConnector(
                controller: controller,
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
