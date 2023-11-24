import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/src/common/base/connector_widget.dart';
import 'package:flutter_typeahead/src/common/base/suggestions_controller.dart';

/// Connects a focus node to the opening and closing of the suggestions box.
/// Enables navigating to the suggestions box from the text field using
/// the keyboard.
class SuggestionsFieldFocusConnector<T> extends StatefulWidget {
  const SuggestionsFieldFocusConnector({
    super.key,
    required this.focusNode,
    required this.controller,
    required this.child,
    this.hideOnUnfocus = true,
  });

  final FocusNode focusNode;
  final SuggestionsController<T> controller;
  final Widget child;
  final bool hideOnUnfocus;

  @override
  State<SuggestionsFieldFocusConnector<T>> createState() =>
      _SuggestionsFieldFocusConnectorState<T>();
}

class _SuggestionsFieldFocusConnectorState<T>
    extends State<SuggestionsFieldFocusConnector<T>> {
  late SuggestionsFocusState lastFocusState;
  late bool wasOpen;

  @override
  void initState() {
    super.initState();
    wasOpen = widget.controller.isOpen;
    lastFocusState = widget.controller.focusState;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (widget.focusNode.hasFocus) {
        widget.controller.open();
      }
    });
  }

  KeyEventResult onKeyEvent(FocusNode node, KeyEvent key) {
    if (key is! KeyDownEvent) return KeyEventResult.ignored;
    if (!widget.controller.isOpen) return KeyEventResult.ignored;
    if (key.logicalKey == LogicalKeyboardKey.arrowDown) {
      if (widget.controller.effectiveDirection == VerticalDirection.down) {
        widget.controller.focusBox();
        return KeyEventResult.handled;
      }
    } else if (key.logicalKey == LogicalKeyboardKey.arrowUp) {
      if (widget.controller.effectiveDirection == VerticalDirection.up) {
        widget.controller.focusBox();
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
    if (lastFocusState == widget.controller.focusState) return;
    lastFocusState = widget.controller.focusState;
    switch (lastFocusState) {
      case SuggestionsFocusState.blur:
        if (widget.focusNode.hasFocus) {
          widget.focusNode.unfocus();
        }
        if (widget.hideOnUnfocus) {
          widget.controller.close();
        }
        break;
      case SuggestionsFocusState.box:
        widget.controller.open();
        break;
      case SuggestionsFocusState.field:
        widget.controller.open();
        if (!widget.focusNode.hasFocus) {
          widget.focusNode.requestFocus();
        }
        break;
    }
  }

  void onControllerOpen() {
    if (wasOpen == widget.controller.isOpen) return;
    wasOpen = widget.controller.isOpen;
    if (wasOpen) {
      widget.focusNode.requestFocus();
    } else if (!widget.controller.retainFocus) {
      widget.focusNode.unfocus();
    }
  }

  void onNodeFocus() {
    if (widget.focusNode.hasFocus) {
      widget.controller.focusField();
    } else if (widget.controller.focusState == SuggestionsFocusState.field) {
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
        child: ConnectorWidget(
          value: widget.controller,
          connect: (value) {
            value.addListener(onControllerFocus);
            value.addListener(onControllerOpen);
          },
          disconnect: (value, key) {
            value.removeListener(onControllerFocus);
            value.removeListener(onControllerOpen);
          },
          child: widget.child,
        ),
      ),
    );
  }
}
