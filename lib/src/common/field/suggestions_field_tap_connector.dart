import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/src/common/base/suggestions_controller.dart';

/// A widget that helps reopening the suggestions list when the user taps it.
///
/// This happens after a suggestion has been selected.
class SuggestionsFieldTapConnector<T> extends StatelessWidget {
  const SuggestionsFieldTapConnector({
    super.key,
    required this.controller,
    required this.child,
  });

  final SuggestionsController<T> controller;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TextFieldTapRegion(
      child: Listener(
        behavior: HitTestBehavior.deferToChild,
        onPointerDown: (event) {
          // We only reopen the suggestions box,
          // if it was closed while retaining focus.
          // This is usually the case when a suggestion was selected.
          // Otherwise, we want to respect [showOnFocus] by staying closed
          // so that developers can control when the suggestions box opens.
          if (controller.retainFocus) {
            controller.open();
          }
        },
        child: child,
      ),
    );
  }
}
