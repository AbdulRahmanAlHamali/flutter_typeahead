import 'package:flutter/widgets.dart';

/// Injects a [PrimaryScrollController] into the widget tree.
///
/// Configured to make sure any [ScrollView] that uses `null` as its primary,
/// will use the scroll controller provided by this widget.
class SuggestionsBoxScrollInjector extends StatefulWidget {
  const SuggestionsBoxScrollInjector({
    super.key,
    this.controller,
    required this.child,
  });

  final ScrollController? controller;
  final Widget child;

  @override
  State<SuggestionsBoxScrollInjector> createState() =>
      _SuggestionsBoxScrollInjectorState();
}

class _SuggestionsBoxScrollInjectorState
    extends State<SuggestionsBoxScrollInjector> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.controller ?? ScrollController();
  }

  @override
  void didUpdateWidget(covariant SuggestionsBoxScrollInjector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      if (oldWidget.controller == null) {
        _scrollController.dispose();
      }
      _scrollController = widget.controller ?? ScrollController();
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryScrollController(
      controller: _scrollController,
      automaticallyInheritForPlatforms: TargetPlatform.values.toSet(),
      child: widget.child,
    );
  }
}
