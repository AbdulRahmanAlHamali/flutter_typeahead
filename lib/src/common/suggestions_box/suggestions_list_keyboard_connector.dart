import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_controller.dart';

/// Enables keyboard navigation for the suggestions list.
class SuggestionsListKeyboardConnector extends StatefulWidget {
  const SuggestionsListKeyboardConnector({
    super.key,
    required this.controller,
    this.direction = AxisDirection.down,
    required this.child,
  });

  final SuggestionsController controller;
  final AxisDirection direction;
  final Widget child;

  @override
  State<SuggestionsListKeyboardConnector> createState() =>
      _SuggestionsListKeyboardConnectorState();
}

class _SuggestionsListKeyboardConnectorState
    extends State<SuggestionsListKeyboardConnector> {
  late final FocusScopeNode focusNode = FocusScopeNode(
    debugLabel: 'SuggestionsListFocus',
    onKeyEvent: (node, key) => widget.controller.sendKey(node, key),
  );

  late StreamSubscription<LogicalKeyboardKey>? keyEventsSubscription;
  int suggestionIndex = -1;
  bool wasFocused = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(onControllerChanged);
    keyEventsSubscription = widget.controller.keys.listen(onKeyEvent);
    focusNode.addListener(onFocusChanged);
  }

  @override
  void didUpdateWidget(covariant SuggestionsListKeyboardConnector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(onControllerChanged);
      keyEventsSubscription?.cancel();
      widget.controller.addListener(onControllerChanged);
      keyEventsSubscription = widget.controller.keys.listen(onKeyEvent);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(onControllerChanged);
    keyEventsSubscription?.cancel();
    focusNode.removeListener(onFocusChanged);
    super.dispose();
  }

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

  void onKeyEvent(LogicalKeyboardKey key) {
    Map<LogicalKeyboardKey, int> keyMap = {
      LogicalKeyboardKey.arrowUp: -1,
      LogicalKeyboardKey.arrowDown: 1,
    };

    if (widget.direction == AxisDirection.up) {
      keyMap = {
        LogicalKeyboardKey.arrowUp: 1,
        LogicalKeyboardKey.arrowDown: -1,
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
    return FocusScope(
      node: focusNode,
      child: widget.child,
    );
  }
}
