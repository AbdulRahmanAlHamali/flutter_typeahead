import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/connector_widget.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_controller.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_traversal_connector.dart';

/// Enables keyboard navigation for the suggestions list.
class SuggestionsListKeyboardConnector<T> extends StatefulWidget {
  const SuggestionsListKeyboardConnector({
    super.key,
    required this.controller,
    this.direction = AxisDirection.down,
    required this.child,
  });

  final SuggestionsController<T> controller;
  final AxisDirection direction;
  final Widget child;

  @override
  State<SuggestionsListKeyboardConnector<T>> createState() =>
      _SuggestionsListKeyboardConnectorState<T>();
}

class _SuggestionsListKeyboardConnectorState<T>
    extends State<SuggestionsListKeyboardConnector<T>> {
  late final FocusScopeNode focusNode = FocusScopeNode(
    debugLabel: 'SuggestionsListFocus',
  );

  late StreamSubscription<VerticalDirection>? keyEventsSubscription;
  int suggestionIndex = -1;
  bool wasFocused = false;

  void onFocusChanged() {
    if (focusNode.hasFocus) {
      List<FocusNode> children = focusNode.children.toList();
      for (int i = 0; i < children.length; i++) {
        if (children[i].hasFocus) {
          updateSelected(i);
          return;
        }
      }
    } else {
      updateSelected(-1);
    }
  }

  /// Handles the state of the controller updating
  /// the [SuggestionsController.focused] property
  void onControllerChanged() {
    bool hasFocus = widget.controller.focused;
    if (hasFocus != wasFocused) {
      wasFocused = hasFocus;
      if (hasFocus) {
        updateSelected(suggestionIndex);
      } else {
        updateSelected(-1);
      }
    }
  }

  void onKeyEvent(VerticalDirection key) {
    Map<VerticalDirection, int> keyMap = {
      VerticalDirection.up: -1,
      VerticalDirection.down: 1,
    };

    if (widget.direction == AxisDirection.up) {
      keyMap = {
        VerticalDirection.up: 1,
        VerticalDirection.down: -1,
      };
    }

    if (keyMap.containsKey(key)) {
      int delta = keyMap[key]!;
      updateSelected(suggestionIndex + delta);
    }
  }

  void updateSelected(int index) {
    if (index == suggestionIndex) return;
    if (index <= -1) {
      suggestionIndex = -1;
      if (focusNode.hasFocus) {
        widget.controller.unfocus();
      }
    } else {
      List<FocusNode> children = focusNode.children.toList();
      if (children.isEmpty) return;
      suggestionIndex = index.clamp(0, children.length - 1);
      FocusNode target = children[suggestionIndex];
      if (!target.hasFocus) {
        target.requestFocus();
      }
      widget.controller.focus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConnectorWidget(
      value: focusNode,
      connect: (value) => value.addListener(onFocusChanged),
      disconnect: (value, key) => value.removeListener(onFocusChanged),
      child: ConnectorWidget(
        value: widget.controller,
        connect: (value) => value.addListener(onControllerChanged),
        disconnect: (value, key) => value.removeListener(onControllerChanged),
        child: ConnectorWidget(
          value: widget.controller.keys,
          connect: (value) => value.listen(onKeyEvent),
          disconnect: (value, key) => key?.cancel(),
          child: FocusScope(
            node: focusNode,
            child: SuggestionsTraversalConnector<T>(
              controller: widget.controller,
              focusNode: focusNode,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
