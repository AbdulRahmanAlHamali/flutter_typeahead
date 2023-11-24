import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/src/common/base/connector_widget.dart';
import 'package:flutter_typeahead/src/common/base/suggestions_controller.dart';

/// Enables navigating to the suggestions box from the text field using
/// the keyboard.
class SuggestionsFieldTraversalConnector<T> extends StatelessWidget {
  const SuggestionsFieldTraversalConnector({
    super.key,
    required this.focusNode,
    required this.controller,
    required this.child,
  });

  final FocusNode focusNode;
  final SuggestionsController<T> controller;
  final Widget child;

  KeyEventResult onKeyEvent(FocusNode node, KeyEvent key) {
    if (key is! KeyDownEvent) return KeyEventResult.ignored;
    if (!controller.isOpen) return KeyEventResult.ignored;
    if (key.logicalKey == LogicalKeyboardKey.arrowDown) {
      if (controller.effectiveDirection == VerticalDirection.down) {
        controller.focusBox();
        return KeyEventResult.handled;
      }
    } else if (key.logicalKey == LogicalKeyboardKey.arrowUp) {
      if (controller.effectiveDirection == VerticalDirection.up) {
        controller.focusBox();
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  FocusOnKeyEventCallback wrapOnKeyEvent(
    FocusOnKeyEventCallback? previousOnKeyEvent,
  ) {
    return (node, event) {
      KeyEventResult result = onKeyEvent(node, event);
      if (result == KeyEventResult.ignored && previousOnKeyEvent != null) {
        return previousOnKeyEvent(node, event);
      }
      return result;
    };
  }

  @override
  Widget build(BuildContext context) {
    return ConnectorWidget(
      value: focusNode,
      connect: (value) {
        FocusOnKeyEventCallback? previousOnKeyEvent = focusNode.onKeyEvent;
        focusNode.onKeyEvent = wrapOnKeyEvent(previousOnKeyEvent);
        return previousOnKeyEvent;
      },
      disconnect: (value, previousOnKeyEvent) =>
          focusNode.onKeyEvent = previousOnKeyEvent,
      child: child,
    );
  }
}
