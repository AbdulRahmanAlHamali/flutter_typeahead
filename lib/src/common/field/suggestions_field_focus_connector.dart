import 'package:flutter/material.dart';
import 'package:flutter_typeahead/src/common/base/connector_widget.dart';
import 'package:flutter_typeahead/src/common/base/suggestions_controller.dart';

/// Connects the suggestions box to the focus node of the child.
///
/// This is a two way connection:
/// * When the focus of the child changes, the suggestions box is opened or closed.
/// * When the suggestions box is opened, the focus is moved to the suggestions box.
class SuggestionsFieldFocusConnector<T> extends StatefulWidget {
  const SuggestionsFieldFocusConnector({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.child,
    this.hideOnUnfocus = true,
  });

  final SuggestionsController<T> controller;
  final FocusNode focusNode;
  final Widget child;
  final bool hideOnUnfocus;

  @override
  State<SuggestionsFieldFocusConnector<T>> createState() =>
      _SuggestionsFieldFocusConnectorState<T>();
}

class _SuggestionsFieldFocusConnectorState<T>
    extends State<SuggestionsFieldFocusConnector<T>> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      widget.controller.resize();
      if (widget.focusNode.hasFocus) {
        widget.controller.open();
      }
    });
  }

  void onControllerChanged() {
    if (widget.controller.isOpen) {
      widget.focusNode.requestFocus();
    } else if (!widget.controller.retainFocus) {
      widget.focusNode.unfocus();
    }
  }

  void onFocusChanged() {
    if (widget.focusNode.hasFocus) {
      widget.controller.open();
    } else if (!widget.controller.focused) {
      if (widget.hideOnUnfocus) {
        widget.controller.close();
      }
    }
  }

  @override
  Widget build(BuildContext context) => ConnectorWidget(
        value: widget.focusNode,
        connect: (value) => value.addListener(onFocusChanged),
        disconnect: (value, key) => value.removeListener(onFocusChanged),
        child: ConnectorWidget(
          value: widget.controller,
          connect: (value) => value.addListener(onControllerChanged),
          disconnect: (value, key) => value.removeListener(onControllerChanged),
          child: widget.child,
        ),
      );
}
