import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/src/common/base/connector_widget.dart';
import 'package:flutter_typeahead/src/common/base/suggestions_controller.dart';

/// Controls whether the box is open or closed based on the field focus state.
class SuggestionsFieldOpenConnector<T> extends StatefulWidget {
  const SuggestionsFieldOpenConnector({
    super.key,
    required this.controller,
    required this.child,
    this.hideOnUnfocus = true,
  });

  final SuggestionsController<T> controller;
  final Widget child;
  final bool hideOnUnfocus;

  @override
  State<SuggestionsFieldOpenConnector<T>> createState() =>
      _SuggestionsFieldOpenConnectorState<T>();
}

class _SuggestionsFieldOpenConnectorState<T>
    extends State<SuggestionsFieldOpenConnector<T>> {
  late SuggestionsFocusState lastFocusState;
  late bool wasOpen;

  @override
  void initState() {
    super.initState();
    wasOpen = widget.controller.isOpen;
    lastFocusState = widget.controller.focusState;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (lastFocusState != SuggestionsFocusState.blur) {
        widget.controller.open();
      }
    });
  }

  void onControllerFocus() {
    if (lastFocusState == widget.controller.focusState) return;
    lastFocusState = widget.controller.focusState;
    switch (lastFocusState) {
      case SuggestionsFocusState.blur:
        if (widget.hideOnUnfocus) {
          widget.controller.close();
        }
        break;
      case SuggestionsFocusState.box:
      case SuggestionsFocusState.field:
        widget.controller.open();
        break;
    }
  }

  void onControllerOpen() {
    if (wasOpen == widget.controller.isOpen) return;
    wasOpen = widget.controller.isOpen;
    if (wasOpen) {
      widget.controller.focusField();
    } else if (!widget.controller.retainFocus) {
      widget.controller.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConnectorWidget(
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
    );
  }
}
