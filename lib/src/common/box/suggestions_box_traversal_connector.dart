import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
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
    onKeyEvent: onKey,
  );

  KeyEventResult onKey(FocusNode node, KeyEvent key) {
    if (key is! KeyDownEvent) return KeyEventResult.ignored;
    if (widget.controller.effectiveDirection == VerticalDirection.down &&
        key.logicalKey == LogicalKeyboardKey.arrowUp) {
      bool canMove = node.focusInDirection(TraversalDirection.up);
      if (!canMove) {
        widget.controller.focusField();
        return KeyEventResult.handled;
      }
    } else if (widget.controller.effectiveDirection == VerticalDirection.up &&
        key.logicalKey == LogicalKeyboardKey.arrowDown) {
      bool canMove = node.focusInDirection(TraversalDirection.down);
      if (!canMove) {
        widget.controller.focusField();
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  void onControllerFocus() {
    if (widget.controller.focusState == SuggestionsFocusState.box) {
      if (focusNode.focusedChild == null) {
        focusNode.focusInDirection(TraversalDirection.down);
      }
    }
  }

  void onNodeFocus() {
    if (focusNode.hasFocus) {
      if (focusNode.focusedChild == null) {
        widget.controller.unfocus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConnectorWidget(
      value: focusNode,
      connect: (value) => value.addListener(onNodeFocus),
      disconnect: (value, key) => value.removeListener(onNodeFocus),
      child: ConnectorWidget(
        value: widget.controller,
        connect: (value) => value.addListener(onControllerFocus),
        disconnect: (value, key) => value.removeListener(onControllerFocus),
        child: FocusScope(
          node: focusNode,
          child: widget.child,
        ),
      ),
    );
  }
}
