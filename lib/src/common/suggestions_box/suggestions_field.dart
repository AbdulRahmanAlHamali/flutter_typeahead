import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/floater.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_controller.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_field_focus_connector.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_field_keyboard_connector.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_field_tap_connector.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_traversal_connector.dart';

/// A widget that displays a list of suggestions above or below another widget.
class SuggestionsField<T> extends StatefulWidget {
  const SuggestionsField({
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
    this.hideWithKeyboard = true,
    this.constraints,
    this.offset,
  });

  /// The controller of the suggestions box.
  final SuggestionsController<T>? controller;

  /// The builder for the suggestions list.
  final Widget Function(
    BuildContext context,
    SuggestionsController<T> controller,
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
  /// If disabled, the suggestions box will remain open when the user taps outside of the suggestions box.
  ///
  /// Defaults to true.
  /// {@endtemplate}
  final bool hideOnUnfocus;

  /// {@template flutter_typeahead.SuggestionsBox.hideWithKeyboard}
  /// Whether the suggestions box should be hidden when the keyboard is closed.
  ///
  /// Defaults to true.
  /// {@endtemplate}
  final bool hideWithKeyboard;

  @override
  State<SuggestionsField<T>> createState() => _SuggestionsFieldState<T>();
}

class _SuggestionsFieldState<T> extends State<SuggestionsField<T>> {
  final FloaterLink link = FloaterLink();
  late SuggestionsController<T> controller;
  late StreamSubscription<void> resizeSubscription;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? SuggestionsController<T>();
    resizeSubscription = controller.resizes.listen((_) => onResize());
  }

  @override
  void didUpdateWidget(covariant SuggestionsField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      if (oldWidget.controller == null) {
        controller.dispose();
      }
      controller = widget.controller ?? SuggestionsController<T>();
      resizeSubscription.cancel();
      resizeSubscription = controller.resizes.listen((_) => onResize());
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

  void onResize() {
    if (controller.isOpen) {
      link.markNeedsBuild();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Floater(
      link: link,
      direction: widget.direction,
      offset: widget.offset ?? const Offset(0, 5),
      followHeight: false,
      autoFlip: widget.autoFlipDirection,
      autoFlipHeight: widget.autoFlipMinHeight,
      builder: (context) {
        Widget list = widget.suggestionsBuilder(context, controller);

        if (widget.constraints != null) {
          Alignment alignment = Alignment.topCenter;
          if (widget.direction == AxisDirection.up) {
            alignment = Alignment.bottomCenter;
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
        child: SuggestionsFieldFocusConnector(
          controller: controller,
          focusNode: widget.focusNode,
          hideOnUnfocus: widget.hideOnUnfocus,
          child: SuggestionsTraversalConnector<T>(
            controller: controller,
            focusNode: widget.focusNode,
            child: SuggestionsFieldKeyboardConnector(
              controller: controller,
              hideWithKeyboard: widget.hideWithKeyboard,
              child: SuggestionsFieldTapConnector(
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
