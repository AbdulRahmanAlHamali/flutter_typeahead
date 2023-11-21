import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/src/common/base/connector_widget.dart';
import 'package:flutter_typeahead/src/common/base/suggestions_controller.dart';

/// Enables navigating to the suggestions box from the text field using
/// the keyboard.
class SuggestionsFieldTraversalConnector<T> extends StatefulWidget {
  const SuggestionsFieldTraversalConnector({
    super.key,
    required this.focusNode,
    required this.controller,
    required this.child,
  });

  final FocusNode focusNode;
  final SuggestionsController<T> controller;
  final Widget child;

  @override
  State<SuggestionsFieldTraversalConnector<T>> createState() =>
      _SuggestionsFieldTraversalConnectorState<T>();
}

class _SuggestionsFieldTraversalConnectorState<T>
    extends State<SuggestionsFieldTraversalConnector<T>> {
  KeyEventResult onKeyEvent(FocusNode node, KeyEvent key) {
    if (key is! KeyDownEvent) return KeyEventResult.ignored;
    if (!widget.controller.isOpen) return KeyEventResult.ignored;
    if (key.logicalKey == LogicalKeyboardKey.arrowDown) {
      if (widget.controller.effectiveDirection == VerticalDirection.down) {
        widget.controller.focus();
        return KeyEventResult.handled;
      }
    } else if (key.logicalKey == LogicalKeyboardKey.arrowUp) {
      if (widget.controller.effectiveDirection == VerticalDirection.up) {
        widget.controller.focus();
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

  void onControllerFocus() {
    switch (widget.controller.focusState) {
      case SuggestionsFocusState.box:
        break;
      case SuggestionsFocusState.blur:
        if (widget.focusNode.hasFocus) {
          widget.focusNode.unfocus();
        }
        break;
      case SuggestionsFocusState.child:
        if (!widget.focusNode.hasFocus) {
          widget.focusNode.requestFocus();
        }
        break;
    }
  }

  void onNodeFocus() {
    if (widget.focusNode.hasFocus) {
      widget.controller.focusChild();
    } else if (widget.controller.focusState == SuggestionsFocusState.child) {
      widget.controller.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConnectorWidget(
      value: widget.focusNode,
      connect: (value) {
        FocusOnKeyEventCallback? previousOnKeyEvent =
            widget.focusNode.onKeyEvent;
        widget.focusNode.onKeyEvent = wrapOnKeyEvent(previousOnKeyEvent);
        return previousOnKeyEvent;
      },
      disconnect: (value, previousOnKeyEvent) =>
          widget.focusNode.onKeyEvent = previousOnKeyEvent,
      child: ConnectorWidget(
        value: widget.focusNode,
        connect: (value) => value.addListener(onNodeFocus),
        disconnect: (value, key) => value.removeListener(onNodeFocus),
        child: widget.child,
      ),
    );
  }
}
