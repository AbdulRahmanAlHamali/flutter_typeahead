import 'package:flutter/material.dart';
import 'package:flutter_typeahead/src/common/base/connector_widget.dart';
import 'package:flutter_typeahead/src/common/base/suggestions_controller.dart';

/// A widget that helps reopening the suggestions list when the text changes.
///
/// This happens after a suggestion has been selected.
class SuggestionsSearchTypingConnector<T> extends StatefulWidget {
  const SuggestionsSearchTypingConnector({
    super.key,
    required this.controller,
    required this.textEditingController,
    required this.child,
  });

  final SuggestionsController<T> controller;
  final TextEditingController textEditingController;
  final Widget child;

  @override
  State<SuggestionsSearchTypingConnector<T>> createState() =>
      _SuggestionsSearchTypingConnectorState<T>();
}

class _SuggestionsSearchTypingConnectorState<T>
    extends State<SuggestionsSearchTypingConnector<T>> {
  String? previousText;

  void onTextChange() {
    if (previousText == widget.textEditingController.text) return;
    previousText = widget.textEditingController.text;

    // We only reopen the suggestions box,
    // if it was closed while retaining focus.
    // This is usually the case when a suggestion was selected.
    // Otherwise, we want to respect [showOnFocus] by staying closed
    // so that developers can control when the suggestions box opens.
    if (widget.controller.retainFocus) {
      widget.controller.open();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConnectorWidget(
      value: widget.textEditingController,
      connect: (value) => value.addListener(onTextChange),
      disconnect: (value, key) => value.removeListener(onTextChange),
      child: widget.child,
    );
  }
}
