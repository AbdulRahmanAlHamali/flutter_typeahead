import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_box_controller.dart';
import 'package:flutter_typeahead/src/typedef.dart';

/// Animates the suggestions list when it is opened or closed.
class SuggestionsListAnimation extends StatefulWidget {
  const SuggestionsListAnimation({
    super.key,
    required this.controller,
    required this.child,
    this.transitionBuilder,
    this.direction = AxisDirection.down,
    this.animationStart,
    this.animationDuration,
  });

  final SuggestionsBoxController controller;
  final Widget child;
  final AnimationTransitionBuilder? transitionBuilder;
  final AxisDirection direction;
  final double? animationStart;
  final Duration? animationDuration;

  @override
  State<SuggestionsListAnimation> createState() =>
      _SuggestionsListAnimationState();
}

class _SuggestionsListAnimationState extends State<SuggestionsListAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late Duration animationDuration;

  bool hidden = false;

  @override
  void initState() {
    super.initState();
    animationDuration =
        widget.animationDuration ?? const Duration(milliseconds: 200);
    animationController = AnimationController(
      vsync: this,
      duration: animationDuration,
    );
    widget.controller.addListener(onOpenedChanged);
    hidden = !widget.controller.isOpen;
    if (!hidden) {
      animationController.value =
          max(widget.animationStart ?? 0, animationController.value);
      animationController.forward();
    }
  }

  @override
  void didUpdateWidget(covariant SuggestionsListAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(onOpenedChanged);
      widget.controller.addListener(onOpenedChanged);
    }
    if (widget.animationDuration != oldWidget.animationDuration) {
      animationDuration =
          widget.animationDuration ?? const Duration(milliseconds: 200);
      animationController.duration = animationDuration;
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    widget.controller.removeListener(onOpenedChanged);
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
      child = widget.transitionBuilder!(context, child, animationController);
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
      maintainState: true,
      visible: !hidden,
      child: child,
    );

    return child;
  }
}
