import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

/// A widget that helps reopening the suggestions list,
/// after a suggestion has been selected.
///
/// This happens when the user starts typing again or
/// taps on the text field.
class SuggestionsListReopenConnector extends StatefulWidget {
  const SuggestionsListReopenConnector({
    super.key,
    required this.controller,
    required this.textEditingController,
    required this.child,
  });

  final SuggestionsBoxController controller;
  final TextEditingController textEditingController;
  final Widget child;

  @override
  State<SuggestionsListReopenConnector> createState() =>
      _SuggestionsListReopenConnectorState();
}

class _SuggestionsListReopenConnectorState
    extends State<SuggestionsListReopenConnector> {
  String? previousText;

  @override
  void initState() {
    super.initState();
    widget.textEditingController.addListener(onTextChange);
  }

  @override
  void didUpdateWidget(covariant SuggestionsListReopenConnector oldWidget) {
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

  /// Opens the suggestions list if the text has changed.
  void onTextChange() {
    if (previousText == widget.textEditingController.text) return;
    previousText = widget.textEditingController.text;

    if (!widget.controller.isOpen && widget.controller.retainFocus) {
      widget.controller.open();
    }
  }

  /// Opens the suggestions list if the user taps on the text field.
  void onTapField() {
    if (!widget.controller.isOpen && widget.controller.retainFocus) {
      widget.controller.open();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldTapRegion(
      child: Listener(
        behavior: HitTestBehavior.deferToChild,
        onPointerDown: (event) => onTapField(),
        child: widget.child,
      ),
    );
  }
}
