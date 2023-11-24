import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/src/common/base/connector_widget.dart';
import 'package:flutter_typeahead/src/common/base/suggestions_controller.dart';
import 'package:flutter_typeahead/src/common/base/types.dart';

/// Animates the suggestions box when it is opened or closed.
class SuggestionsBoxAnimation<T> extends StatefulWidget {
  const SuggestionsBoxAnimation({
    super.key,
    required this.controller,
    required this.child,
    this.transitionBuilder,
    this.animationDuration,
  });

  final SuggestionsController<T> controller;
  final Widget child;
  final AnimationTransitionBuilder? transitionBuilder;
  final Duration? animationDuration;

  @override
  State<SuggestionsBoxAnimation<T>> createState() =>
      _SuggestionsBoxAnimationState<T>();
}

class _SuggestionsBoxAnimationState<T> extends State<SuggestionsBoxAnimation<T>>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late Duration animationDuration;
  final Duration defaultAnimationDuration = const Duration(milliseconds: 200);

  bool hidden = false;

  @override
  void initState() {
    super.initState();
    animationDuration = widget.animationDuration ?? defaultAnimationDuration;
    animationController = AnimationController(
      vsync: this,
      duration: animationDuration,
    );
    hidden = !widget.controller.isOpen;
    if (!hidden) {
      animationController.forward();
    }
  }

  @override
  void didUpdateWidget(covariant SuggestionsBoxAnimation<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animationDuration != oldWidget.animationDuration) {
      animationDuration = widget.animationDuration ?? defaultAnimationDuration;
      animationController.duration = animationDuration;
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void onOpenedChanged() {
    if (widget.controller.isOpen) {
      setState(() => hidden = false);
      animationController.forward();
    } else {
      animationController.reverse().whenComplete(
            () => setState(() => hidden = true),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child = widget.child;

    if (widget.transitionBuilder != null) {
      child =
          widget.transitionBuilder!(context, animationController.view, child);
    } else {
      child = AnimatedSize(
        alignment: widget.controller.effectiveDirection == VerticalDirection.up
            ? Alignment.bottomCenter
            : Alignment.topCenter,
        duration: animationDuration,
        child: SizeTransition(
          axisAlignment: -1,
          sizeFactor: CurvedAnimation(
            parent: animationController,
            curve: Curves.fastOutSlowIn,
          ),
          child: child,
        ),
      );
    }

    child = Visibility(
      visible: !hidden,
      child: child,
    );

    return ConnectorWidget(
      value: widget.controller,
      connect: (value) => widget.controller.addListener(onOpenedChanged),
      disconnect: (value, key) =>
          widget.controller.removeListener(onOpenedChanged),
      child: child,
    );
  }
}
