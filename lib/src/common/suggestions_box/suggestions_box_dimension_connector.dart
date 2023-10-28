import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/root_media_query.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_box_controller.dart';

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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    // Catch keyboard event and orientation change; resize suggestions list
    updateDimensions();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Delays until the keyboard has toggled or the orientation has fully changed
  Future<void> updateDimensions() async {
    const int waitMetricsTimeoutMillis = 1000;

    // initial viewInsets which are before the keyboard is toggled
    EdgeInsets initial = MediaQuery.of(context).viewInsets;
    // initial MediaQuery for orientation change
    MediaQuery? initialRootMediaQuery = rootMediaQueryOf(context);

    int timer = 0;
    // viewInsets or MediaQuery have changed once keyboard has toggled or orientation has changed
    while (timer < waitMetricsTimeoutMillis) {
      // TODO: reduce delay if showDialog ever exposes detection of animation end
      int step = 170;

      await Future.delayed(Duration(milliseconds: step));
      timer += step;

      if (!context.mounted) return;

      if (MediaQuery.of(context).viewInsets != initial ||
          rootMediaQueryOf(context) != initialRootMediaQuery) {
        widget.controller.resize();
      }
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
