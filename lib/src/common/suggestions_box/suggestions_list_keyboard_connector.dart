import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_box_controller.dart';

/// Enables keyboard navigation for the suggestions list.
class SuggestionsListKeyboardConnector<T> extends StatefulWidget {
  const SuggestionsListKeyboardConnector({
    super.key,
    required this.controller,
    required this.child,
  });

  final SuggestionsBoxController controller;
  final Widget child;

  @override
  State<SuggestionsListKeyboardConnector<T>> createState() =>
      _SuggestionsListKeyboardConnectorState<T>();
}

class _SuggestionsListKeyboardConnectorState<T>
    extends State<SuggestionsListKeyboardConnector<T>> {
  late final FocusScopeNode focusNode = FocusScopeNode(
    debugLabel: 'SuggestionsListFocus',
    onKeyEvent: (node, key) => widget.controller.onKeyEvent(node, key),
  );

  late StreamSubscription<LogicalKeyboardKey>? keyEventsSubscription;
  int suggestionIndex = -1;
  bool wasFocused = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(onControllerChanged);
    keyEventsSubscription = widget.controller.keyEvents.listen(onKeyEvent);
    focusNode.addListener(onFocusChanged);
  }

  @override
  void didUpdateWidget(
      covariant SuggestionsListKeyboardConnector<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(onControllerChanged);
      keyEventsSubscription?.cancel();
      widget.controller.addListener(onControllerChanged);
      keyEventsSubscription = widget.controller.keyEvents.listen(onKeyEvent);
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
  /// the [SuggestionsBoxController.suggestionsFocused] property
  void onControllerChanged() {
    bool hasFocus = widget.controller.suggestionsFocused;
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
    if (key == LogicalKeyboardKey.arrowDown) {
      updateSelected(suggestionIndex + 1);
    } else if (key == LogicalKeyboardKey.arrowUp) {
      updateSelected(suggestionIndex - 1);
    }
  }

  void updateSelected(int index) {
    // TODO: enable this feature
    // This seems to work, but was disabled for some reason. We will leave it disabled
    // until we can figure out why it was disabled.
    return;

    // ignore: dead_code
    if (index == suggestionIndex) return;
    if (index <= -1) {
      suggestionIndex = -1;
      if (focusNode.hasFocus) {
        widget.controller.unfocusSuggestions();
      }
    } else {
      List<FocusNode> children = focusNode.children.toList();
      if (children.isEmpty) return;
      suggestionIndex = index.clamp(0, children.length - 1);
      FocusNode target = children[suggestionIndex];
      if (!target.hasFocus) {
        target.requestFocus();
      }
      widget.controller.focusSuggestions();
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
