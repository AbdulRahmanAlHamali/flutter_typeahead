import 'package:flutter/material.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_controller.dart';

/// Connects the suggestions box to the focus node of the child.
///
/// This is a two way connection:
/// * When the focus of the child changes, the suggestions box is opened or closed.
/// * When the suggestions box is opened, the focus is moved to the suggestions box.
class SuggestionsBoxFocusConnector extends StatefulWidget {
  const SuggestionsBoxFocusConnector({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.child,
    this.hideOnUnfocus = true,
  });

  /// The controller of the suggestions box.
  final SuggestionsController controller;

  /// The focus node of the child of the suggestions box.
  final FocusNode focusNode;

  /// The child of the suggestions box.
  final Widget child;

  /// Whether the suggestions box should be hidden when the focus is lost.
  final bool hideOnUnfocus;

  @override
  State<SuggestionsBoxFocusConnector> createState() =>
      _SuggestionsBoxFocusConnectorState();
}

class _SuggestionsBoxFocusConnectorState
    extends State<SuggestionsBoxFocusConnector> {
  /// The previous onKeyEvent callback of the focus node.
  FocusOnKeyEventCallback? previousOnKeyEvent;

  @override
  void initState() {
    super.initState();
    registerFocusNode(widget.focusNode);
    widget.controller.addListener(onControllerChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      widget.controller.resize();
      if (widget.focusNode.hasFocus) {
        widget.controller.open();
      }
    });
  }

  @override
  void didUpdateWidget(covariant SuggestionsBoxFocusConnector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      unregisterFocusNode(oldWidget.focusNode);
      registerFocusNode(widget.focusNode);
    }
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(onControllerChanged);
      widget.controller.addListener(onControllerChanged);
    }
  }

  @override
  void dispose() {
    unregisterFocusNode(widget.focusNode);
    widget.controller.removeListener(onControllerChanged);
    super.dispose();
  }

  /// Registers a focus node with the suggestions box.
  ///
  /// This overrides the focus node's onKeyEvent to call the controller's onKeyEvent.
  void registerFocusNode(FocusNode focusNode) {
    focusNode.addListener(onFocusChanged);
    previousOnKeyEvent = focusNode.onKeyEvent;
    focusNode.onKeyEvent = ((node, event) {
      final keyEventResult = onKeyEvent(node, event);
      return previousOnKeyEvent?.call(node, event) ?? keyEventResult;
    });
  }

  /// Handles passing key events to the controller.
  KeyEventResult onKeyEvent(FocusNode node, KeyEvent key) {
    return widget.controller.onKeyEvent(node, key);
  }

  /// Unregisters a focus node with the suggestions box.
  ///
  /// This restores the focus node's onKeyEvent to the previous value.
  void unregisterFocusNode(FocusNode focusNode) {
    focusNode.removeListener(onFocusChanged);
    focusNode.onKeyEvent = previousOnKeyEvent;
    previousOnKeyEvent = null;
  }

  void onControllerChanged() {
    if (widget.controller.isOpen) {
      widget.focusNode.requestFocus();
    } else if (!widget.controller.retainFocus) {
      widget.focusNode.unfocus();
    }
  }

  /// Handles when the focus of the child of the suggestions box changes.
  void onFocusChanged() {
    if (widget.focusNode.hasFocus) {
      widget.controller.open();
    } else if (!widget.controller.suggestionsFocused) {
      if (widget.hideOnUnfocus) {
        widget.controller.close();
      }
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
