import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// Holds the last known size and offset of the widget
/// to which the floater is attached.
typedef FloaterInfo = ({
  Size size,
  Offset offset,
});

/// Connects a [Floater] with a [FloaterTarget].
///
/// All public members are for internal use only.
class FloaterLink extends ValueNotifier<FloaterInfo> {
  FloaterLink()
      : super(
          (size: Size.zero, offset: Offset.zero),
        );

  final LayerLink layerLink = LayerLink();

  /// Manually trigger an update of the floater.
  ///
  /// This is useful when our automatic resizing fails,
  /// however, that should not happen.
  void markNeedsBuild() => notifyListeners();
}

/// A widgt to which a [Floater] can be attached.
class FloaterTarget extends StatelessWidget {
  const FloaterTarget({
    super.key,
    required this.link,
    required this.child,
  });

  final FloaterLink link;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: link.layerLink,
      child: _FloaterTarget(
        link: link,
        child: child,
      ),
    );
  }
}

class _FloaterTarget extends SingleChildRenderObjectWidget {
  const _FloaterTarget({
    Key? key,
    Widget? child,
    required this.link,
  }) : super(key: key, child: child);

  final FloaterLink link;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderFloaterTarget(
      controller: link,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, _RenderFloaterTarget renderObject) {
    renderObject.controller = link;
  }

  @override
  void didUnmountRenderObject(_RenderFloaterTarget renderObject) {
    renderObject.controller = null;
  }
}

class _RenderFloaterTarget extends RenderProxyBox {
  _RenderFloaterTarget({
    RenderBox? child,
    required this.controller,
  }) : super(child);

  FloaterLink? controller;

  @override
  void performLayout() {
    super.performLayout();
    controller?.value = (
      size: size,
      offset: controller!.value.offset,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);
    controller?.value = (
      size: controller!.value.size,
      offset: localToGlobal(Offset.zero),
    );
  }
}

/// A widget that can float next to a [FloaterTarget], inheriting its size.
///
/// Floaters use the surrounding [Overlay] to position themselves.
class Floater extends StatefulWidget {
  const Floater({
    super.key,
    this.child,
    required this.builder,
    required this.link,
    this.followWidth = true,
    this.followHeight = true,
    this.direction = AxisDirection.down,
    this.offset = Offset.zero,
    this.autoFlip = false,
    this.autoFlipHeight = 64,
  });

  final Widget? child;
  final WidgetBuilder builder;
  final FloaterLink link;

  final bool followWidth;
  final bool followHeight;

  final AxisDirection direction;
  final Offset offset;

  final bool autoFlip;
  final double autoFlipHeight;

  @override
  State<Floater> createState() => _FloaterState();
}

class _FloaterState extends State<Floater> with WidgetsBindingObserver {
  OverlayPortalController controller = OverlayPortalController();

  List<dynamic>? dependencies;
  EdgeInsets? insets;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    widget.link.addListener(updateOverlay);
    maybeUpdateOverlay();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    maybeUpdateOverlay();
  }

  @override
  void dispose() {
    widget.link.removeListener(updateOverlay);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    // When the keyboard is toggled, we need to update the floater,
    // since its constraints might have changed.
    OverlayState overlay = Overlay.of(context);
    MediaQueryData mediaQuery = MediaQuery.of(overlay.context);
    if (insets != mediaQuery.viewInsets) {
      insets = mediaQuery.viewInsets;
      updateOverlay();
    }
  }

  void maybeUpdateOverlay() {
    final List<dynamic> newDependencies = createDependencies();
    if (!listEquals(dependencies, newDependencies)) {
      dependencies = newDependencies;
      updateOverlay();
    }
  }

  void updateOverlay() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
      controller.show();
    });
  }

  List<dynamic> createDependencies() {
    return [
      widget.link,
      widget.link.value,
      widget.direction,
      widget.offset,
      widget.followWidth,
      widget.followHeight,
    ];
  }

  Size getDiretionSize(
    AxisDirection direction,
    Size overlaySize,
    Offset floaterOffset,
    Offset extra,
    Size size,
  ) {
    floaterOffset = getDirectionOffset(
      direction,
      floaterOffset,
      extra,
    );
    return switch (direction) {
      AxisDirection.down => Size(
          overlaySize.width,
          overlaySize.height - floaterOffset.dy - size.height,
        ),
      AxisDirection.up => Size(
          overlaySize.width,
          floaterOffset.dy,
        ),
      AxisDirection.left => Size(
          floaterOffset.dx,
          overlaySize.height,
        ),
      AxisDirection.right => Size(
          overlaySize.width - floaterOffset.dx - size.width,
          overlaySize.height,
        ),
    };
  }

  Offset getDirectionOffset(
    AxisDirection direction,
    Offset base,
    Offset extra,
  ) {
    return switch (direction) {
      AxisDirection.down => base + extra,
      AxisDirection.right => base + Offset(extra.dy, -extra.dx),
      AxisDirection.up => base + Offset(-extra.dx, -extra.dy),
      AxisDirection.left => base + Offset(-extra.dy, extra.dx),
    };
  }

  (Alignment, Alignment) getDirectionAnchors(AxisDirection direction) {
    return switch (direction) {
      AxisDirection.down => (Alignment.bottomCenter, Alignment.topCenter),
      AxisDirection.up => (Alignment.topCenter, Alignment.bottomCenter),
      AxisDirection.left => (Alignment.centerLeft, Alignment.centerRight),
      AxisDirection.right => (Alignment.centerRight, Alignment.centerLeft),
    };
  }

  EdgeInsets getDirectionPadding(AxisDirection direction, EdgeInsets padding) {
    return switch (direction) {
      AxisDirection.down => EdgeInsets.only(
          bottom: padding.bottom,
          left: padding.left,
          right: padding.right,
        ),
      AxisDirection.up => EdgeInsets.only(
          top: padding.top,
          left: padding.left,
          right: padding.right,
        ),
      AxisDirection.left => EdgeInsets.only(
          left: padding.left,
          top: padding.top,
          bottom: padding.bottom,
        ),
      AxisDirection.right => EdgeInsets.only(
          right: padding.right,
          top: padding.top,
          bottom: padding.bottom,
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: controller,
      child: widget.child,
      overlayChildBuilder: (context) => Builder(
        builder: (context) {
          final FloaterInfo(:size, :offset) = widget.link.value;
          OverlayState overlay = Overlay.of(context);

          final RenderBox overlayBox =
              overlay.context.findRenderObject()! as RenderBox;

          Size available;
          Alignment targetAnchor;
          Alignment followerAnchor;

          Offset overlayOffset = overlayBox.localToGlobal(Offset.zero);
          Size overlaySize = overlayBox.size;

          MediaQueryData mediaQuery = MediaQuery.of(overlay.context);
          EdgeInsets viewPadding = mediaQuery.padding + mediaQuery.viewInsets;

          overlayOffset = Offset(
            max(overlayOffset.dx, viewPadding.left),
            max(overlayOffset.dy, viewPadding.top),
          );

          overlaySize = Size(
            overlaySize.width - viewPadding.left - viewPadding.right,
            overlaySize.height - viewPadding.top - viewPadding.bottom,
          );

          Offset floaterOffset = offset - overlayOffset;

          floaterOffset = Offset(
            max(0, floaterOffset.dx),
            max(0, floaterOffset.dy),
          );

          EdgeInsets padding = viewPadding;

          AxisDirection direction = widget.direction;

          available = getDiretionSize(
            direction,
            overlaySize,
            floaterOffset,
            widget.offset,
            size,
          );

          if (widget.autoFlip && available.height < widget.autoFlipHeight) {
            AxisDirection opposite = flipAxisDirection(widget.direction);
            Size maybeAvailable = getDiretionSize(
              opposite,
              overlaySize,
              floaterOffset,
              widget.offset,
              size,
            );
            if (maybeAvailable.height > available.height) {
              direction = opposite;
              available = maybeAvailable;
            }
          }

          available = Size(
            max(0, available.width),
            max(0, available.height),
          );

          (targetAnchor, followerAnchor) = getDirectionAnchors(direction);
          padding = getDirectionPadding(direction, padding);

          BoxConstraints constraints = BoxConstraints(
            maxWidth: available.width,
            maxHeight: available.height,
          );

          Size target = Size(
            min(size.width, available.width),
            min(size.height, available.height),
          );

          if (widget.followWidth) {
            constraints = constraints.enforce(
              BoxConstraints(
                maxWidth: target.width,
              ),
            );
          }
          if (widget.followHeight) {
            constraints = constraints.enforce(
              BoxConstraints(
                maxHeight: target.height,
              ),
            );
          }

          return CompositedTransformFollower(
            showWhenUnlinked: false,
            link: widget.link.layerLink,
            offset: getDirectionOffset(
              direction,
              Offset.zero,
              widget.offset,
            ),
            targetAnchor: targetAnchor,
            followerAnchor: followerAnchor,
            child: Padding(
              padding: padding,
              child: Align(
                alignment: followerAnchor,
                child: ConstrainedBox(
                  constraints: constraints,
                  child: widget.builder(context),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
