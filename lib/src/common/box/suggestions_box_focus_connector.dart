import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/src/common/base/connector_widget.dart';
import 'package:flutter_typeahead/src/common/base/suggestions_controller.dart';

/// Connects the focus of the suggestions box to the controller state.
class SuggestionsBoxFocusConnector<T> extends StatefulWidget {
  const SuggestionsBoxFocusConnector({
    super.key,
    required this.controller,
    required this.child,
  });

  final SuggestionsController<T> controller;
  final Widget child;

  @override
  State<SuggestionsBoxFocusConnector<T>> createState() =>
      _SuggestionsBoxFocusConnectorState<T>();
}

class _SuggestionsBoxFocusConnectorState<T>
    extends State<SuggestionsBoxFocusConnector<T>> {
  late final FocusNode focusNode = FocusNode(
    canRequestFocus: false,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      onControllerFocus();
    });
  }

  void onControllerFocus() {
    switch (widget.controller.focusState) {
      case SuggestionsFocusState.field:
        break;
      case SuggestionsFocusState.blur:
        if (focusNode.hasFocus) {
          focusNode.unfocus();
        }
        break;
      case SuggestionsFocusState.box:
        if (!focusNode.hasFocus) {
          for (final node in focusNode.children) {
            if (node.canRequestFocus) {
              node.requestFocus();
              break;
            }
          }
        }
        break;
    }
  }

  void onNodeFocus() {
    if (focusNode.hasFocus) {
      widget.controller.focusBox();
    } else if (widget.controller.focusState == SuggestionsFocusState.box) {
      widget.controller.unfocus();
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
        child: Focus(
          focusNode: focusNode,
          child: widget.child,
        ),
      ),
    );
  }
}
