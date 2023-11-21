import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/src/common/base/suggestions_controller.dart';

/// A widget that helps reopening the suggestions list when the user taps it.
///
/// This happens after a suggestion has been selected.
class SuggestionsFieldTapConnector extends StatelessWidget {
  const SuggestionsFieldTapConnector({
    super.key,
    required this.controller,
    required this.child,
  });

  final SuggestionsController controller;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TextFieldTapRegion(
      child: Listener(
        behavior: HitTestBehavior.deferToChild,
        onPointerDown: (event) {
          if (!controller.isOpen && controller.retainFocus) {
            controller.open();
          }
        },
        child: child,
      ),
    );
  }
}
