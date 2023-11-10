import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_box_controller.dart';

/// Ensures the suggestions list is resized when the keyboard is toggled.
class SuggestionsBoxDimensionConnector extends StatefulWidget {
  const SuggestionsBoxDimensionConnector({
    super.key,
    required this.controller,
    required this.child,
  });

  final SuggestionsBoxController controller;
  final Widget child;

  @override
  State<SuggestionsBoxDimensionConnector> createState() =>
      _SuggestionsBoxDimensionConnectorState();
}

class _SuggestionsBoxDimensionConnectorState
    extends State<SuggestionsBoxDimensionConnector>
    with WidgetsBindingObserver {
  /// We do not want to run multiple updates at the same time.
  Timer? timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() => updateDimensions();

  @override
  void dispose() {
    timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// The way android handles keyboard visibility is
  /// incredibly inconsistent and unreliable.
  ///
  /// To counter-act this, we continously resize
  /// the suggestions box for a second whenever the keyboard is toggled.
  Future<void> updateDimensions() async {
    const Duration pollingDuration = Duration(seconds: 1);
    const Duration pollingInterval = Duration(milliseconds: 170);
    DateTime start = DateTime.now();

    // The suggestions list is an OverlayEntry, so we
    // use the Overlay to get the correct MediaQueryData.
    OverlayState overlay = Overlay.of(context);
    MediaQueryData mediaQuery = MediaQuery.of(overlay.context);

    EdgeInsets insets = mediaQuery.viewInsets;

    timer?.cancel();
    timer = Timer.periodic(pollingInterval, (timer) {
      if (!context.mounted) {
        timer.cancel();
        return;
      }
      if (DateTime.now().difference(start) > pollingDuration) {
        timer.cancel();
        return;
      }

      MediaQueryData currentMediaQuery = MediaQuery.of(overlay.context);
      bool mediaQueryChanged = mediaQuery != currentMediaQuery;
      bool insetsChanged = insets != currentMediaQuery.viewInsets;

      if (mediaQueryChanged || insetsChanged) {
        widget.controller.resize();
      }
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
