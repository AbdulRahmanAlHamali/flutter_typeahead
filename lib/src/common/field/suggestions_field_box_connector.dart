import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/src/common/base/connector_widget.dart';
import 'package:flutter_typeahead/src/common/base/suggestions_controller.dart';

/// Controls whether the box is open or closed based on the field focus state.
class SuggestionsFieldBoxConnector<T> extends StatefulWidget {
  const SuggestionsFieldBoxConnector({
    super.key,
    required this.controller,
    required this.child,
    this.showOnFocus = true,
    this.hideOnUnfocus = true,
  });

  final SuggestionsController<T> controller;
  final Widget child;
  final bool showOnFocus;
  final bool hideOnUnfocus;

  @override
  State<SuggestionsFieldBoxConnector<T>> createState() =>
      _SuggestionsFieldBoxConnectorState<T>();
}

class _SuggestionsFieldBoxConnectorState<T>
    extends State<SuggestionsFieldBoxConnector<T>> {
  late bool wasFocused;
  late bool wasOpen;

  @override
  void initState() {
    super.initState();
    wasOpen = widget.controller.isOpen;
    wasFocused = widget.controller.focusState.hasFocus;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (wasFocused && widget.showOnFocus) {
        widget.controller.open();
      }
      if (wasOpen && widget.controller.gainFocus) {
        widget.controller.focusField();
      }
    });
  }

  void onControllerFocus() {
    bool isFocused = widget.controller.focusState.hasFocus;
    if (wasFocused == isFocused) return;
    wasFocused = isFocused;
    if (isFocused) {
      if (widget.showOnFocus) {
        widget.controller.open();
      }
    } else {
      if (widget.hideOnUnfocus) {
        widget.controller.close();
      }
    }
  }

  void onControllerOpen() {
    if (wasOpen == widget.controller.isOpen) return;
    wasOpen = widget.controller.isOpen;
    if (wasOpen) {
      if (widget.controller.gainFocus) {
        widget.controller.focusField();
      }
    } else {
      if (widget.controller.retainFocus) {
        widget.controller.focusField();
      } else {
        widget.controller.unfocus();
      }
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
