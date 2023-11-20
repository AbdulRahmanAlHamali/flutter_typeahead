import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/connector_widget.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/floater.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_box.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_controller.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_field_focus_connector.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_field_keyboard_connector.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_field_select_connector.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_field_tap_connector.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_traversal_connector.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/typedef.dart';

/// A widget that displays a list of suggestions above or below another widget.
class SuggestionsField<T> extends StatefulWidget {
  const SuggestionsField({
    super.key,
    this.controller,
    required this.builder,
    required this.child,
    required this.focusNode,
    this.onSelected,
    this.direction,
    this.autoFlipDirection = false,
    this.autoFlipMinHeight = 64,
    this.hideOnUnfocus = true,
    this.hideOnSelect = true,
    this.hideWithKeyboard = true,
    this.constraints,
    this.offset,
    this.scrollController,
    this.wrapperBuilder,
    this.transitionBuilder,
    this.animationDuration,
  });

  /// {@macro flutter_typeahead.SuggestionsBox.controller}
  final SuggestionsController<T>? controller;

  /// {@template flutter_typeahead.SuggestionsField.focusNode}
  /// The focus node of the child, usually an [EditableText] widget.
  ///
  /// This is used to show and hide the suggestions box.
  /// {@endtemplate}
  final FocusNode focusNode;

  /// {@macro flutter_typeahead.SuggestionsBox.builder}
  final Widget Function(
    BuildContext context,
    SuggestionsController<T> controller,
  ) builder;

  /// {@template flutter_typeahead.SuggestionsField.fieldBuilder}
  /// The child of the suggestions field.
  ///
  /// This is typically an [EditableText] widget.
  /// {@endtemplate}
  final Widget child;

  /// {@template flutter_typeahead.SuggestionsField.onSelected}
  /// Called when a suggestion is selected.
  ///
  /// If [hideOnSelect] is true, the suggestions box will be closed after this callback is called.
  ///
  /// You may also add a callback like this to the [SuggestionsController.selections] stream.
  /// {@endtemplate}
  final ValueSetter<T>? onSelected;

  /// {@template flutter_typeahead.SuggestionsField.direction}
  /// The direction in which the suggestions box opens.
  ///
  /// Must be either [AxisDirection.down] or [AxisDirection.up].
  ///
  /// Defaults to [AxisDirection.down].
  /// {@endtemplate}
  final AxisDirection? direction;

  /// {@template flutter_typeahead.SuggestionsField.constraints}
  /// The constraints to be applied to the suggestions box.
  /// {@endtemplate}
  final BoxConstraints? constraints;

  /// {@template flutter_typeahead.SuggestionsField.offset}
  /// The offset of the suggestions box.
  /// The value is automatically flipped if the suggestions box is flipped.
  ///
  /// Defaults to `Offset(0, 5)`.
  /// {@endtemplate}
  final Offset? offset;

  /// {@template flutter_typeahead.SuggestionsField.autoFlipDirection}
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

  /// {@template flutter_typeahead.SuggestionsField.autoFlipMinHeight}
  /// The minimum height the suggesttions box can have before attempting to flip.
  ///
  /// Defaults to 64.
  /// {@endtemplate}
  final double autoFlipMinHeight;

  /// {@template flutter_typeahead.SuggestionsField.hideOnUnfocus}
  /// Whether the suggestions box should be hidden when the child of the suggestions box loses focus.
  ///
  /// If disabled, the suggestions box will remain open when the user taps outside of the suggestions box.
  ///
  /// Defaults to true.
  /// {@endtemplate}
  final bool hideOnUnfocus;

  /// {@template flutter_typeahead.SuggestionsField.hideOnSelect}
  /// Whether to keep the suggestions visible even after a suggestion has been selected.
  ///
  /// Note that if this is disabled, the only way
  /// to close the suggestions box is either via the
  /// [SuggestionsController] or when the user closes the software
  /// keyboard with [hideOnUnfocus] set to true.
  ///
  /// Users with a physical keyboard will be unable to close the
  /// box without additional logic.
  ///
  /// Defaults to `true`.
  /// {@endtemplate}
  final bool hideOnSelect;

  /// {@template flutter_typeahead.SuggestionsField.hideWithKeyboard}
  /// Whether the suggestions box should be hidden when the keyboard is closed.
  ///
  /// Defaults to true.
  /// {@endtemplate}
  final bool hideWithKeyboard;

  /// {@macro flutter_typeahead.SuggestionsBox.scrollController}
  final ScrollController? scrollController;

  /// {@macro flutter_typeahead.SuggestionsBox.wrapperBuilder}
  final Widget Function(BuildContext context, Widget child)? wrapperBuilder;

  /// {@macro flutter_typeahead.SuggestionsBox.transitionBuilder}
  final AnimationTransitionBuilder? transitionBuilder;

  /// {@macro flutter_typeahead.SuggestionsBox.animationDuration}
  final Duration? animationDuration;

  @override
  State<SuggestionsField<T>> createState() => _SuggestionsFieldState<T>();
}

class _SuggestionsFieldState<T> extends State<SuggestionsField<T>> {
  final FloaterLink link = FloaterLink();
  late SuggestionsController<T> controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? SuggestionsController<T>();
    if (widget.direction != null) {
      controller.direction = widget.direction!;
    }
  }

  @override
  void didUpdateWidget(covariant SuggestionsField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      if (oldWidget.controller == null) {
        controller.dispose();
      }
      controller = widget.controller ?? SuggestionsController<T>();
    }
    if (widget.direction != oldWidget.direction && widget.direction != null) {
      controller.direction = widget.direction!;
    }
  }

  @override
  void dispose() {
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
    return SuggestionsControllerProvider<T>(
      controller: controller,
      child: Floater(
        link: link,
        direction: controller.direction,
        offset: widget.offset ?? const Offset(0, 5),
        followHeight: false,
        autoFlip: widget.autoFlipDirection,
        autoFlipHeight: widget.autoFlipMinHeight,
        builder: (context) {
          FloaterData data = Floater.of(context);

          if (data.effectiveDirection != controller.effectiveDirection) {
            // It is generally discouraged to add side-effects in build methods.
            // However, this is a place where we can update the effective direction
            // of the controller easily. Adding a new Widget seemed like bloat.
            // The post frame delay is necessary to avoid triggering a build during a build.
            // For maximum cleanliness, we could use a StatefulWidget
            // and update the controller in didUpdateWidget. Tread carefully.
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              controller.effectiveDirection = data.effectiveDirection;
            });
          }

          Widget list = SuggestionsBox(
            controller: controller,
            scrollController: widget.scrollController,
            builder: (context) => widget.builder(context, controller),
            wrapperBuilder: widget.wrapperBuilder,
            transitionBuilder: widget.transitionBuilder,
            animationDuration: widget.animationDuration,
          );

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
          child: ConnectorWidget(
            value: controller,
            connect: (value) => value.resizes.listen((_) => onResize()),
            disconnect: (value, key) => key?.cancel(),
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
                    child: SuggestionsFieldSelectConnector(
                      controller: controller,
                      hideOnSelect: widget.hideOnSelect,
                      onSelected: widget.onSelected,
                      child: widget.child,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
