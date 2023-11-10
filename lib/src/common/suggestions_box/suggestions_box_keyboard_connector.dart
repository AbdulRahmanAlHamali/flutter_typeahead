import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

/// Hides the suggestions box when the keyboard is closed.
class SuggestionsBoxKeyboardConnector extends StatefulWidget {
  const SuggestionsBoxKeyboardConnector({
    super.key,
    required this.controller,
    required this.child,
    this.hideOnUnfocus = true,
  });

  final SuggestionsBoxController controller;
  final Widget child;
  final bool hideOnUnfocus;

  @override
  State<SuggestionsBoxKeyboardConnector> createState() =>
      _SuggestionsBoxKeyboardConnectorState();
}

class _SuggestionsBoxKeyboardConnectorState
    extends State<SuggestionsBoxKeyboardConnector> {
  late StreamSubscription<bool> keyboardSubscription;

  @override
  void initState() {
    super.initState();
    keyboardSubscription =
        KeyboardVisibilityController().onChange.listen(onKeyboardChanged);
  }

  @override
  void dispose() {
    keyboardSubscription.cancel();
    super.dispose();
  }

  /// hide suggestions box on keyboard closed
  void onKeyboardChanged(bool visible) {
    if (!visible && widget.hideOnUnfocus) {
      widget.controller.close();
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
