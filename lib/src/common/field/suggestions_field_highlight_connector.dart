import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/src/common/base/connector_widget.dart';
import 'package:flutter_typeahead/src/common/base/suggestions_controller.dart';

/// Enables changing the highlighted suggestion in a [SuggestionsController] using
/// keyboard shortcuts.
///
/// Heavily inspired by the [RawAutocomplete] widget.
class SuggestionsFieldHighlightConnector<T> extends StatefulWidget {
  const SuggestionsFieldHighlightConnector({
    super.key,
    required this.controller,
    required this.child,
  });

  final SuggestionsController<T> controller;
  final Widget child;

  @override
  State<SuggestionsFieldHighlightConnector<T>> createState() =>
      _SuggestionsFieldHighlightConnectorState<T>();
}

class _SuggestionsFieldHighlightConnectorState<T>
    extends State<SuggestionsFieldHighlightConnector<T>> {
  late Map<ShortcutActivator, Intent> _shortcuts;

  /// Highlights the previous suggestion in the suggestions box.
  late final _previousOptionAction =
      _ConditionalCallbackAction<SuggestionsPreviousItemIntent>(
          onInvoke: (_) => widget.controller.highlightPrevious());

  /// Highlights the next suggestion in the suggestions box.
  late final _nextOptionAction =
      _ConditionalCallbackAction<SuggestionsNextItemIntent>(
    onInvoke: (_) => widget.controller.highlightNext(),
  );

  /// Dismisses the suggestions box.
  late final _hideOptionsAction = _ConditionalCallbackAction<DismissIntent>(
    onInvoke: (_) {
      widget.controller.unhighlight();
      widget.controller.close(retainFocus: true);
      return null;
    },
  );

  /// Selects the highlighted suggestion.
  late final _selectOptionAction = _ConditionalCallbackAction<ActivateIntent>(
    onInvoke: (_) {
      int? index = widget.controller.highlighted;
      if (index == null) return null;
      T? highlighted = widget.controller.suggestions?.elementAtOrNull(
        index,
      );
      if (highlighted == null) return null;
      widget.controller.select(highlighted);
      widget.controller.unhighlight();
      return null;
    },
  );

  late final Map<Type, _ConditionalCallbackAction> _actions = {
    SuggestionsPreviousItemIntent: _previousOptionAction,
    SuggestionsNextItemIntent: _nextOptionAction,
    ActivateIntent: _selectOptionAction,
    DismissIntent: _hideOptionsAction,
  };

  @override
  void initState() {
    super.initState();
    _createShortcuts();
  }

  void _createShortcuts() {
    _shortcuts = {
      // The shortcuts are different depending on the direction of the suggestions box.
      ...switch (widget.controller.effectiveDirection) {
        VerticalDirection.up => {
            const SingleActivator(LogicalKeyboardKey.arrowUp):
                const SuggestionsNextItemIntent(),
            const SingleActivator(LogicalKeyboardKey.arrowDown):
                const SuggestionsPreviousItemIntent(),
          },
        VerticalDirection.down => {
            const SingleActivator(LogicalKeyboardKey.arrowUp):
                const SuggestionsPreviousItemIntent(),
            const SingleActivator(LogicalKeyboardKey.arrowDown):
                const SuggestionsNextItemIntent(),
          },
      },
      const SingleActivator(LogicalKeyboardKey.enter): const ActivateIntent(),
    };
  }

  void _onControllerChange() {
    for (final action in _actions.values) {
      // When the suggestions box is closed, the actions should be disabled.
      action.enabled = widget.controller.isOpen;
    }
    setState(_createShortcuts);
  }

  @override
  Widget build(BuildContext context) {
    return ConnectorWidget(
      value: widget.controller,
      connect: (controller) => controller.addListener(_onControllerChange),
      disconnect: (controller, _) =>
          controller.removeListener(_onControllerChange),
      child: Shortcuts(
        shortcuts: _shortcuts,
        child: Actions(
          actions: _actions,
          child: widget.child,
        ),
      ),
    );
  }
}

/// An [Intent] to highlight the previous suggestion in the suggestions box.
class SuggestionsPreviousItemIntent extends Intent {
  const SuggestionsPreviousItemIntent();
}

/// An [Intent] to highlight the next suggestion in the suggestions box.
class SuggestionsNextItemIntent extends Intent {
  const SuggestionsNextItemIntent();
}

/// A [CallbackAction] that can be enabled or disabled.
/// Directly inspired by the implementation in [RawAutocomplete].
class _ConditionalCallbackAction<T extends Intent> extends CallbackAction<T> {
  _ConditionalCallbackAction({
    required super.onInvoke,
    this.enabled = true,
  });

  bool enabled;

  @override
  bool isEnabled(covariant T intent) => enabled;

  @override
  bool consumesKey(covariant T intent) => enabled;
}
