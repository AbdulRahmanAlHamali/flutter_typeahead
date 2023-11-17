import 'package:flutter/widgets.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/connector_widget.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_controller.dart';

/// Hides the suggestions box when the keyboard is closed.
class SuggestionsBoxKeyboardConnector extends StatelessWidget {
  const SuggestionsBoxKeyboardConnector({
    super.key,
    required this.controller,
    required this.child,
    this.hideWithKeyboard = true,
  });

  final SuggestionsController controller;
  final Widget child;
  final bool hideWithKeyboard;

  @override
  Widget build(BuildContext context) {
    return ConnectorWidget(
      // [KeyboardVisibilityController] is a singleton.
      value: KeyboardVisibilityController(),
      connect: (value) => value.onChange.listen((visible) {
        if (!visible && hideWithKeyboard) {
          controller.close();
        }
      }),
      disconnect: (value, key) => key?.cancel(),
      child: child,
    );
  }
}
