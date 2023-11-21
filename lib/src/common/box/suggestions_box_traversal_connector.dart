import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/src/common/base/connector_widget.dart';
import 'package:flutter_typeahead/src/common/base/suggestions_controller.dart';

/// Enables navigating to the text field from the suggestions box using
/// the keyboard.
class SuggestionsBoxTraversalConnector<T> extends StatefulWidget {
  const SuggestionsBoxTraversalConnector({
    super.key,
    required this.controller,
    required this.child,
  });

  final SuggestionsController<T> controller;
  final Widget child;

  @override
  State<SuggestionsBoxTraversalConnector<T>> createState() =>
      _SuggestionsBoxTraversalConnectorState<T>();
}

class _SuggestionsBoxTraversalConnectorState<T>
    extends State<SuggestionsBoxTraversalConnector<T>> {
  late final FocusScopeNode focusNode = FocusScopeNode(
    debugLabel: 'SuggestionsBoxFocusScope',
    onKeyEvent: onKey,
  );

  KeyEventResult onKey(FocusNode node, KeyEvent key) {
    if (key is! KeyDownEvent) return KeyEventResult.ignored;
    if (widget.controller.effectiveDirection == VerticalDirection.down &&
        key.logicalKey == LogicalKeyboardKey.arrowUp) {
      bool canMove = node.focusInDirection(TraversalDirection.up);
      if (!canMove) {
        widget.controller.focusChild();
        return KeyEventResult.handled;
      }
    } else if (widget.controller.effectiveDirection == VerticalDirection.up &&
        key.logicalKey == LogicalKeyboardKey.arrowDown) {
      bool canMove = node.focusInDirection(TraversalDirection.down);
      if (!canMove) {
        widget.controller.focusChild();
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  void onControllerFocus() {
    switch (widget.controller.focusState) {
      case SuggestionsFocusState.child:
        break;
      case SuggestionsFocusState.blur:
        if (focusNode.hasFocus) {
          focusNode.unfocus();
        }
        break;
      case SuggestionsFocusState.box:
        if (!focusNode.hasFocus) {
          focusNode.requestFocus();
          if (focusNode.focusedChild == null) {
            focusNode.focusInDirection(TraversalDirection.down);
          }
        }
        break;
    }
  }

  void onNodeFocus() {
    if (focusNode.hasFocus) {
      widget.controller.focus();
    } else if (widget.controller.focusState == SuggestionsFocusState.box) {
      widget.controller.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConnectorWidget(
      value: widget.controller,
      connect: (value) => value.addListener(onControllerFocus),
      disconnect: (value, key) => value.removeListener(onControllerFocus),
      child: ConnectorWidget(
        value: focusNode,
        connect: (value) => value.addListener(onNodeFocus),
        disconnect: (value, key) => value.removeListener(onNodeFocus),
        child: FocusScope(
          node: focusNode,
          child: widget.child,
        ),
      ),
    );
  }
}
