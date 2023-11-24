import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/src/common/base/connector_widget.dart';
import 'package:flutter_typeahead/src/common/base/suggestions_controller.dart';

/// Connects the focus of the suggestions field to the controller state.
class SuggestionsFieldFocusConnector<T> extends StatefulWidget {
  const SuggestionsFieldFocusConnector({
    super.key,
    required this.focusNode,
    required this.controller,
    required this.child,
  });

  final FocusNode focusNode;
  final SuggestionsController<T> controller;
  final Widget child;

  @override
  State<SuggestionsFieldFocusConnector<T>> createState() =>
      _SuggestionsFieldFocusConnectorState<T>();
}

class _SuggestionsFieldFocusConnectorState<T>
    extends State<SuggestionsFieldFocusConnector<T>> {
  late SuggestionsFocusState lastFocusState;

  @override
  void initState() {
    super.initState();
    lastFocusState = widget.controller.focusState;
  }

  void onControllerFocus() {
    if (lastFocusState == widget.controller.focusState) return;
    lastFocusState = widget.controller.focusState;
    switch (lastFocusState) {
      case SuggestionsFocusState.box:
        break;
      case SuggestionsFocusState.blur:
        if (!widget.focusNode.hasFocus) return;
        widget.focusNode.unfocus();

        break;
      case SuggestionsFocusState.field:
        if (widget.focusNode.hasFocus) return;
        widget.focusNode.requestFocus();
        break;
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
        connect: (value) => value.addListener(onControllerFocus),
        disconnect: (value, key) => value.removeListener(onControllerFocus),
        child: widget.child,
      ),
    );
  }
}
