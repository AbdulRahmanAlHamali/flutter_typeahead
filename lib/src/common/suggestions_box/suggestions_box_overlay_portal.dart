import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_blox_floater.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_box_controller.dart';

class SuggestionsBoxOverlayPortal extends StatefulWidget {
  const SuggestionsBoxOverlayPortal({
    super.key,
    required this.controller,
    required this.listBuilder,
    required this.child,
    this.direction = AxisDirection.down,
    this.constraints,
    this.offset,
  });

  final SuggestionsBoxController controller;

  final WidgetBuilder listBuilder;
  final Widget child;

  final AxisDirection direction;
  final BoxConstraints? constraints;
  final Offset? offset;

  @override
  State<SuggestionsBoxOverlayPortal> createState() =>
      _SuggestionsBoxOverlayPortalState();
}

class _SuggestionsBoxOverlayPortalState
    extends State<SuggestionsBoxOverlayPortal> {
  FloaterLink link = FloaterLink();
  late StreamSubscription<void> resizeSubscription;

  @override
  void initState() {
    super.initState();
    resizeSubscription =
        widget.controller.resizeEvents.listen((_) => link.markNeedsBuild());
  }

  @override
  void didUpdateWidget(covariant SuggestionsBoxOverlayPortal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      resizeSubscription.cancel();
      resizeSubscription =
          widget.controller.resizeEvents.listen((_) => link.markNeedsBuild());
    }
  }

  @override
  void dispose() {
    resizeSubscription.cancel();
    link.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Offset offset = widget.offset ?? const Offset(0, 5);

    if (widget.direction == AxisDirection.up) {
      offset = Offset(offset.dx, -offset.dy);
    }

    return Floater(
      link: link,
      direction: widget.direction,
      offset: offset,
      followHeight: false,
      builder: (context) {
        Widget list = widget.listBuilder(context);

        if (widget.constraints != null) {
          list = Align(
            alignment: Alignment.topLeft,
            child: ConstrainedBox(
              constraints: widget.constraints!,
              child: list,
            ),
          );
        }

        list = Semantics(
          container: true,
          child: list,
        );

        return list;
      },
      child: FloaterTarget(
        link: link,
        child: widget.child,
      ),
    );
  }
}
