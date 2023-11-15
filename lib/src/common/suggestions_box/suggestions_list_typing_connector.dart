import 'package:flutter/material.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_controller.dart';

/// A widget that helps reopening the suggestions list when the text changes.
///
/// This happens after a suggestion has been selected.
class SuggestionsListTypingConnector extends StatefulWidget {
  const SuggestionsListTypingConnector({
    super.key,
    required this.controller,
    required this.textEditingController,
    required this.child,
  });

  final SuggestionsController controller;
  final TextEditingController textEditingController;
  final Widget child;

  @override
  State<SuggestionsListTypingConnector> createState() =>
      _SuggestionsListTypingConnectorState();
}

class _SuggestionsListTypingConnectorState
    extends State<SuggestionsListTypingConnector> {
  String? previousText;

  @override
  void initState() {
    super.initState();
    widget.textEditingController.addListener(onTextChange);
  }

  @override
  void didUpdateWidget(covariant SuggestionsListTypingConnector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.textEditingController != widget.textEditingController) {
      oldWidget.textEditingController.removeListener(onTextChange);
      widget.textEditingController.addListener(onTextChange);
    }
  }

  @override
  void dispose() {
    widget.textEditingController.removeListener(onTextChange);
    super.dispose();
  }

  void onTextChange() {
    if (previousText == widget.textEditingController.text) return;
    previousText = widget.textEditingController.text;

    if (!widget.controller.isOpen && widget.controller.retainFocus) {
      widget.controller.open();
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
