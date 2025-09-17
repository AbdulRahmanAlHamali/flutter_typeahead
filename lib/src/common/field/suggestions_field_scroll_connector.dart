import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/src/common/base/suggestions_controller.dart';

/// A widget that listens for scroll position changes and triggers resize events
/// on the suggestions controller to ensure the floater repositions correctly
/// when the target widget scrolls.
class SuggestionsFieldScrollConnector<T> extends StatefulWidget {
  const SuggestionsFieldScrollConnector({
    super.key,
    required this.controller,
    required this.child,
  });

  final SuggestionsController<T> controller;
  final Widget child;

  @override
  State<SuggestionsFieldScrollConnector<T>> createState() =>
      _SuggestionsFieldScrollConnectorState<T>();
}

class _SuggestionsFieldScrollConnectorState<T>
    extends State<SuggestionsFieldScrollConnector<T>> {
  Timer? _debounceTimer;
  ScrollPosition? _scrollPosition;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateScrollPosition();
  }

  void _updateScrollPosition() {
    final ScrollableState? scrollableState = Scrollable.maybeOf(context);
    final ScrollPosition? newPosition = scrollableState?.position;

    if (_scrollPosition != newPosition) {
      _scrollPosition?.removeListener(_onScrollChanged);
      _scrollPosition = newPosition;
      _scrollPosition?.addListener(_onScrollChanged);
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _scrollPosition?.removeListener(_onScrollChanged);
    super.dispose();
  }

  void _onScrollChanged() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 50), () {
      if (mounted && widget.controller.isOpen) {
        widget.controller.resize();
      }
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
