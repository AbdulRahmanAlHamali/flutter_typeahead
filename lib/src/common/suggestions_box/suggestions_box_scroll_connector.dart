import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_box_controller.dart';

/// A widget that helps resizing the suggestions box when the user is scrolling.
// TODO: this does not work well on Windows.
class SuggestionsBoxScrollConnector extends StatefulWidget {
  const SuggestionsBoxScrollConnector({
    super.key,
    required this.controller,
    required this.child,
  });

  final SuggestionsBoxController controller;
  final Widget child;

  @override
  State<SuggestionsBoxScrollConnector> createState() =>
      _SuggestionsBoxScrollConnectorState();
}

class _SuggestionsBoxScrollConnectorState
    extends State<SuggestionsBoxScrollConnector> {
  // Timer that resizes the suggestion box every resizeRate when the user is scrolling
  Timer? resizeTicker;

  // The rate at which the suggestion box will resize when the user is scrolling
  final Duration resizeRate = const Duration(milliseconds: 500);

  // The position of the surrounding scrollable, if any
  ScrollPosition? scrollPosition;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final scrollableState = Scrollable.maybeOf(context);
    scrollPosition?.removeListener(_onScrollPositionChanged);
    scrollPosition = scrollableState?.position;
    scrollPosition?.isScrollingNotifier.addListener(_onScrollPositionChanged);
  }

  @override
  void dispose() {
    resizeTicker?.cancel();
    scrollPosition?.removeListener(_onScrollPositionChanged);
    super.dispose();
  }

  void _onScrollPositionChanged() {
    bool isScrolling = scrollPosition!.isScrollingNotifier.value;
    resizeTicker?.cancel();
    if (isScrolling) {
      resizeTicker =
          Timer.periodic(resizeRate, (_) => widget.controller.resize());
    } else {
      widget.controller.resize();
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
