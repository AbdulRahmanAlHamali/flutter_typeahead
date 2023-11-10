import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_box_controller.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_box_decoration.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_box_dimension_connector.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_box_focus_connector.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_box_keyboard_connector.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_box_overlay_portal.dart';

/// A widget that displays a list of suggestions above or below another widget.
class SuggestionsBox<T> extends StatelessWidget {
  const SuggestionsBox({
    super.key,
    this.direction = AxisDirection.down,
    required this.controller,
    required this.suggestionsListBuilder,
    required this.focusNode,
    required this.child,
    required this.decoration,
    this.autoFlipDirection = false,
    this.autoFlipListDirection = true,
    this.autoFlipMinHeight = 64,
    this.hideOnUnfocus = true,
  });

  /// The controller of the suggestions box.
  final SuggestionsBoxController controller;

  /// The builder for the suggestions list.
  final WidgetBuilder suggestionsListBuilder;

  /// The focus node of the child of the suggestions box.
  final FocusNode focusNode;

  /// The child of the suggestions box.
  final Widget child;

  /// {@macro flutter_typeahead.SuggestionsListConfig.direction}
  final AxisDirection direction;

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

  /// The decoration of the suggestions box.
  final BaseSuggestionsBoxDecoration decoration;

  /// {@template flutter_typeahead.SuggestionsBox.hideOnUnfocus}
  /// Whether the suggestions box should be hidden when the child of the suggestions box loses focus.
  ///
  /// If disabled, the suggestions box will remain open when the user e.g. closes the keyboard.
  ///
  /// Defaults to true.
  /// {@endtemplate}
  final bool hideOnUnfocus;

  @override
  Widget build(BuildContext context) {
    return SuggestionsBoxFocusConnector(
      controller: controller,
      focusNode: focusNode,
      hideOnUnfocus: hideOnUnfocus,
      child: SuggestionsBoxKeyboardConnector(
        controller: controller,
        hideOnUnfocus: hideOnUnfocus,
        child: SuggestionsBoxDimensionConnector(
          controller: controller,
          child: SuggestionsBoxOverlayPortal(
            controller: controller,
            direction: direction,
            listBuilder: suggestionsListBuilder,
            child: child,
          ),
        ),
      ),
    );
  }
}
