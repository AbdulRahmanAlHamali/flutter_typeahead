import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class SuggestionsBoxTapConnector extends StatelessWidget {
  const SuggestionsBoxTapConnector({
    super.key,
    required this.controller,
    required this.child,
  });

  final SuggestionsBoxController controller;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TextFieldTapRegion(
      child: Listener(
        behavior: HitTestBehavior.translucent,
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
