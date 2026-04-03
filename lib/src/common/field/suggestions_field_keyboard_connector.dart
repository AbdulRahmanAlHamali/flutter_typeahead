import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/src/common/base/suggestions_controller.dart';

/// Hides the suggestions box when the keyboard is closed.
class SuggestionsFieldKeyboardConnector<T> extends StatefulWidget {
  const SuggestionsFieldKeyboardConnector({
    super.key,
    required this.controller,
    required this.child,
    this.hideWithKeyboard = true,
  });

  final SuggestionsController<T> controller;
  final Widget child;
  final bool hideWithKeyboard;

  @override
  State<SuggestionsFieldKeyboardConnector<T>> createState() =>
      _SuggestionsFieldKeyboardConnectorState<T>();
}

class _SuggestionsFieldKeyboardConnectorState<T>
    extends State<SuggestionsFieldKeyboardConnector<T>>
    with WidgetsBindingObserver {
  bool _wasKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _wasKeyboardVisible =
        WidgetsBinding.instance.platformDispatcher.views.any(
      (view) => view.viewInsets.bottom > 0,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final isKeyboardVisible =
        WidgetsBinding.instance.platformDispatcher.views.any(
      (view) => view.viewInsets.bottom > 0,
    );
    if (_wasKeyboardVisible && !isKeyboardVisible && widget.hideWithKeyboard) {
      widget.controller.close();
    }
    _wasKeyboardVisible = isKeyboardVisible;
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
