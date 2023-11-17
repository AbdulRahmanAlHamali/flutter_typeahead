import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/connector_widget.dart';

/// Connects a focus node to the keyboard traversal of the suggestions box.
class SuggestionsTraversalConnector<T> extends StatelessWidget {
  const SuggestionsTraversalConnector({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.child,
  });

  final SuggestionsController<T> controller;
  final FocusNode focusNode;
  final Widget child;

  /// Handles passing key events to the controller.
  KeyEventResult onKeyEvent(FocusNode node, KeyEvent key) {
    if (key is! KeyDownEvent) return KeyEventResult.ignored;
    switch (key.logicalKey) {
      case LogicalKeyboardKey.arrowDown:
        controller.sendKey(VerticalDirection.down);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.arrowUp:
        controller.sendKey(VerticalDirection.up);
        return KeyEventResult.handled;
      default:
        return KeyEventResult.ignored;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConnectorWidget(
      value: focusNode,
      connect: (value) {
        FocusOnKeyEventCallback? previousOnKeyEvent = focusNode.onKeyEvent;

        focusNode.onKeyEvent = ((node, event) {
          KeyEventResult result = onKeyEvent(node, event);
          KeyEventResult? otherResult = previousOnKeyEvent?.call(node, event);
          return switch (otherResult) {
            null || KeyEventResult.ignored => result,
            _ => otherResult,
          };
        });

        return previousOnKeyEvent;
      },
      disconnect: (value, previousOnKeyEvent) =>
          focusNode.onKeyEvent = previousOnKeyEvent,
      child: child,
    );
  }
}
