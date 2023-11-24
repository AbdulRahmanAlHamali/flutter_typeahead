import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/src/common/base/connector_widget.dart';
import 'package:flutter_typeahead/src/common/base/suggestions_controller.dart';

/// Connects the focus of the suggestions field to the controller state.
/// Controls whether the box is open or closed.
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
    );
  }
}
