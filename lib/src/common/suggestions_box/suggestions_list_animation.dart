import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/connector_widget.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_controller.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/typedef.dart';

/// Animates the suggestions list when it is opened or closed.
class SuggestionsListAnimation<T> extends StatefulWidget {
  const SuggestionsListAnimation({
    super.key,
    required this.controller,
    required this.child,
    this.transitionBuilder,
    this.direction = AxisDirection.down,
    this.animationStart,
    this.animationDuration,
  });

  final SuggestionsController<T> controller;
  final Widget child;
  final AnimationTransitionBuilder? transitionBuilder;
  final AxisDirection direction;
  final double? animationStart;
  final Duration? animationDuration;

  @override
  State<SuggestionsListAnimation<T>> createState() =>
      _SuggestionsListAnimationState<T>();
}

class _SuggestionsListAnimationState<T>
    extends State<SuggestionsListAnimation<T>>
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
      animationController.value =
          max(widget.animationStart ?? 0, animationController.value);
      animationController.forward();
    }
  }

  @override
  void didUpdateWidget(covariant SuggestionsListAnimation<T> oldWidget) {
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

  /// Handles when the suggestions box is opened or closed via the controller.
  void onOpenedChanged() {
    if (widget.controller.isOpen) {
      setState(() => hidden = false);
      animationController.value =
          max(widget.animationStart ?? 0, animationController.value);
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
      child = SizeTransition(
        axisAlignment: -1,
        sizeFactor: CurvedAnimation(
          parent: animationController,
          curve: Curves.fastOutSlowIn,
        ),
        child: child,
      );
    }

    child = AnimatedSize(
      alignment: widget.direction == AxisDirection.up
          ? Alignment.bottomCenter
          : Alignment.topCenter,
      duration: animationDuration,
      child: child,
    );

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
