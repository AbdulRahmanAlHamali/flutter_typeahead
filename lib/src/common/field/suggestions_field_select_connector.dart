import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/src/common/base/connector_widget.dart';
import 'package:flutter_typeahead/src/common/base/suggestions_controller.dart';

/// Hides the suggestions box when a suggestion is selected.
class SuggestionsFieldSelectConnector<T> extends StatelessWidget {
  const SuggestionsFieldSelectConnector({
    super.key,
    required this.controller,
    required this.child,
    this.hideOnSelect,
    this.onSelected,
  });

  final SuggestionsController<T> controller;
  final Widget child;

  final bool? hideOnSelect;
  final ValueSetter<T>? onSelected;

  void _onSelected(T value) {
    onSelected?.call(value);
    if (hideOnSelect ?? true) {
      controller.close(retainFocus: true);
    } else {
      controller.focusField();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConnectorWidget(
      value: controller,
      connect: (value) => value.selections.listen(_onSelected),
      disconnect: (value, key) => key?.cancel(),
      child: child,
    );
  }
}
