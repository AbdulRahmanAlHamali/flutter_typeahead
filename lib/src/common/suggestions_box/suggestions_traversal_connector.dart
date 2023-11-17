import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

/// Connects a focus node to the keyboard traversal of the suggestions box.
class SuggestionsTraversalConnector<T> extends StatefulWidget {
  const SuggestionsTraversalConnector({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.child,
  });

  final SuggestionsController<T> controller;
  final FocusNode focusNode;
  final Widget child;

  @override
  State<SuggestionsTraversalConnector<T>> createState() =>
      _SuggestionsTraversalConnectorState<T>();
}

class _SuggestionsTraversalConnectorState<T>
    extends State<SuggestionsTraversalConnector<T>> {
  /// The previous onKeyEvent callback of the focus node.
  FocusOnKeyEventCallback? previousOnKeyEvent;

  @override
  void initState() {
    super.initState();
    registerFocusNode(widget.focusNode);
  }

  /// Registers a focus node with the suggestions box.
  ///
  /// This overrides the focus node's onKeyEvent to call the controller's onKeyEvent.
  void registerFocusNode(FocusNode focusNode) {
    previousOnKeyEvent = focusNode.onKeyEvent;
    focusNode.onKeyEvent = ((node, event) {
      KeyEventResult result = onKeyEvent(node, event);
      KeyEventResult? otherResult = previousOnKeyEvent?.call(node, event);
      return switch (otherResult) {
        null || KeyEventResult.ignored => result,
        _ => otherResult,
      };
    });
  }

  /// Handles passing key events to the controller.
  KeyEventResult onKeyEvent(FocusNode node, KeyEvent key) {
    if (key is! KeyDownEvent) return KeyEventResult.ignored;
    switch (key.logicalKey) {
      case LogicalKeyboardKey.arrowDown:
        widget.controller.sendKey(VerticalDirection.down);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.arrowUp:
        widget.controller.sendKey(VerticalDirection.up);
        return KeyEventResult.handled;
      default:
        return KeyEventResult.ignored;
    }
  }

  /// Unregisters a focus node with the suggestions box.
  ///
  /// This restores the focus node's onKeyEvent to the previous value.
  void unregisterFocusNode(FocusNode focusNode) {
    focusNode.onKeyEvent = previousOnKeyEvent;
    previousOnKeyEvent = null;
  }

  @override
  void didUpdateWidget(covariant SuggestionsTraversalConnector<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      unregisterFocusNode(oldWidget.focusNode);
      registerFocusNode(widget.focusNode);
    }
  }

  @override
  void dispose() {
    unregisterFocusNode(widget.focusNode);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
