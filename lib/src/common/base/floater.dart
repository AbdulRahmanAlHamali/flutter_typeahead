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
    required FloaterLink controller,
  })  : _controller = controller,
        super(child) {
    _controller?.addListener(_onLinkNotification);
  }

  void _onLinkNotification() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_disposed) return;
      markNeedsLayout();
    });
  }

  bool _disposed = false;

  FloaterLink? _controller;
  FloaterLink? get controller => _controller;
  set controller(FloaterLink? newController) {
    if (_controller == newController) return;
    _controller?.removeListener(_onLinkNotification);
    _controller = newController;
    _controller?.addListener(_onLinkNotification);
    _onLinkNotification();
  }

  @override
  void detach() {
    controller?.removeListener(_onLinkNotification);
    super.detach();
  }

  @override
  void dispose() {
    controller?.removeListener(_onLinkNotification);
    _disposed = true;
    super.dispose();
  }

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

// Describes how the Floater is anchored to the space and the target.
class FloaterAnchor {
  /// Creates a new [FloaterAnchor].
  const FloaterAnchor.only({
    this.top = true,
    this.bottom = true,
    this.left = true,
    this.right = true,
  });

  factory FloaterAnchor.fromLRTB(bool left, bool right, bool top, bool bottom) {
    return FloaterAnchor.only(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
    );
  }

  factory FloaterAnchor.all(bool value) {
    return FloaterAnchor.only(
      top: value,
      bottom: value,
      left: value,
      right: value,
    );
  }

  factory FloaterAnchor.symmetric({
    bool horizontal = true,
    bool vertical = true,
  }) {
    return FloaterAnchor.only(
      top: vertical,
      bottom: vertical,
      left: horizontal,
      right: horizontal,
    );
  }

  /// Whether the floater is anchored to the top of the target.
  final bool top;

  /// Whether the floater is anchored to the bottom of the target.
  final bool bottom;

  /// Whether the floater is anchored to the left of the target.
  final bool left;

  /// Whether the floater is anchored to the right of the target.
  final bool right;

  @override
  bool operator ==(Object other) {
    return other is FloaterAnchor &&
        other.top == top &&
        other.bottom == bottom &&
        other.left == left &&
        other.right == right;
  }

  @override
  int get hashCode => Object.hash(
        top,
        bottom,
        left,
        right,
      );

  @override
  String toString() {
    return 'FloaterAnchor(top: $top, bottom: $bottom, left: $left, right: $right)';
  }

  FloaterAnchor copyWith({
    bool? top,
    bool? bottom,
    bool? left,
    bool? right,
  }) {
    return FloaterAnchor.only(
      top: top ?? this.top,
      bottom: bottom ?? this.bottom,
      left: left ?? this.left,
      right: right ?? this.right,
    );
  }
}

extension EdgeInsetsPositive on EdgeInsets {
  EdgeInsets positive() => EdgeInsets.only(
        top: max(0, top),
        bottom: max(0, bottom),
        left: max(0, left),
        right: max(0, right),
      );
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
    this.direction = AxisDirection.down,
    this.anchor = const FloaterAnchor.only(bottom: false),
    this.padding = EdgeInsets.zero,
    this.autoFlip = false,
    this.autoFlipHeight = 100,
  });

  /// The widget below this widget in the tree.
  final Widget? child;

  /// Builds the content of the floater.
  final WidgetBuilder builder;

  /// The link to the [FloaterTarget] to which the floater should attach.
  final FloaterLink link;

  /// The offset of the floater in relation to the target and the space.
  ///
  /// This is layed out in relation to [direction].
  /// That means, left is cross axis start, right is cross axis end, top is main axis start, and bottom is main axis end.
  final EdgeInsets padding;

  /// Describes how the floater is anchored to the space and the target.
  ///
  /// This is layed out in relation to [direction].
  /// That means, left is cross axis start, right is cross axis end, top is main axis start, and bottom is main axis end.
  ///
  /// Is a given direction [false], the floater will take up all available space in that direction,
  /// until it reaches the edge of the space.
  /// Is it [true], the floater will stop at the limits of the target.
  final FloaterAnchor anchor;

  /// The desired direction of the floater.
  ///
  /// The floater will try to open in this direction.
  /// This also defines how much space the floater has to grow.
  final AxisDirection direction;

  /// Whether the floater should automatically flip direction if there's not enough space.
  ///
  /// The minimum height of the floater is defined by [autoFlipHeight].
  /// Defaults to false.
  final bool autoFlip;

  /// The minimum height of the floater before it attempts to flip direction.
  final double autoFlipHeight;

  /// Returns the [FloaterData] of the closest [Floater] ancestor, or null if there is no [Floater] ancestor.
  static FloaterData? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_FloaterProvider>()?.data;

  /// Returns the [FloaterData] of the closest [Floater] ancestor.
  static FloaterData of(BuildContext context) {
    FloaterData? data = maybeOf(context);
    if (data == null) {
      throw FlutterError.fromParts(
        [
          ErrorSummary(
            'Floater.of() called with a context '
            'that does not contain a Floater.',
          ),
          ErrorDescription(
            'No Floater ancestor could be found '
            'starting from the context that was passed to Floater.of().',
          ),
          context.describeElement('The context used was'),
        ],
      );
    }
    return data;
  }

  @override
  State<Floater> createState() => _FloaterState();
}

class _FloaterState extends State<Floater> with WidgetsBindingObserver {
  OverlayPortalController controller = OverlayPortalController();

  List<Object?>? dependencies;
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
    final List<Object?> newDependencies = createDependencies();
    if (!listEquals(dependencies, newDependencies)) {
      dependencies = newDependencies;
      updateOverlay();
    }
  }

  void updateOverlay() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {});
      controller.show();
    });
  }

  List<Object?> createDependencies() => [
        widget.link,
        widget.link.value,
        widget.direction,
        widget.anchor,
        widget.padding,
      ];

  ({Size size, Offset offset, EdgeInsets viewPadding}) getOverlayConstraints(
      OverlayState overlay) {
    final RenderBox overlayBox =
        overlay.context.findRenderObject()! as RenderBox;

    Offset overlayOffset = overlayBox.localToGlobal(Offset.zero);
    Size overlaySize = overlayBox.size;

    MediaQueryData mediaQuery = MediaQuery.of(overlay.context);
    EdgeInsets viewPadding = mediaQuery.padding;

    overlayOffset = Offset(
      overlayOffset.dx,
      overlayOffset.dy,
    );

    overlaySize = Size(
      overlaySize.width,
      overlaySize.height,
    );

    return (
      size: overlaySize,
      offset: overlayOffset,
      viewPadding: viewPadding,
    );
  }

  /// Returns the target and follower anchors for the given direction.
  ///
  /// Because it should be possible for the floater to overlap the target,
  /// when negative padding is used, both anchors are at the start of the main axis.
  /// Because it should be possible to shift the floater in the cross axis,
  /// both anchors are at the center of the cross axis.
  (Alignment, Alignment) getDirectionAnchors(
    AxisDirection direction,
  ) =>
      switch (direction) {
        AxisDirection.down => (Alignment.topCenter, Alignment.topCenter),
        AxisDirection.up => (Alignment.bottomCenter, Alignment.bottomCenter),
        AxisDirection.left => (Alignment.centerRight, Alignment.centerRight),
        AxisDirection.right => (Alignment.centerLeft, Alignment.centerLeft),
      };

  /// Applies directionality to padding.
  /// "Down" is the assumed default direction, and "left" is rotated clockwise.
  /// "Up" and "right" are mirrored versions of "down" and "left". They are not rotated.
  /// This is because this seems like a more natural output for a user,
  /// even though the principle behind it does not appear obvious.
  EdgeInsets mapPaddingDirection(
    AxisDirection direction,
    EdgeInsets padding,
  ) =>
      switch (direction) {
        AxisDirection.down => EdgeInsets.only(
            top: padding.top,
            bottom: padding.bottom,
            left: padding.left,
            right: padding.right,
          ),
        AxisDirection.up => EdgeInsets.only(
            top: padding.bottom,
            bottom: padding.top,
            right: padding.right,
            left: padding.left,
          ),
        AxisDirection.left => EdgeInsets.only(
            top: padding.left,
            bottom: padding.right,
            right: padding.top,
            left: padding.bottom,
          ),
        AxisDirection.right => EdgeInsets.only(
            top: padding.left,
            bottom: padding.right,
            right: padding.bottom,
            left: padding.top,
          ),
      };

  /// Calculates the padding needed to position the floater.
  ///
  /// In the main axis, the padding is the intrinsic extent of the target plus the input padding.
  /// If the input padding is negative, it can overlap the target, but never more than the target's main axis extent.
  /// The end padding of the main axis is ignored, as it cannot be enforced through padding.
  ///
  /// In the cross axis, the padding is the absolute input padding.
  /// Negative padding is ignored, as it cannot be enforced through padding.
  EdgeInsets getPositionPadding(
    AxisDirection direction,
    Size space,
    Offset offset,
    Size size,
    EdgeInsets padding,
  ) =>
      mapPaddingDirection(
        direction,
        padding + EdgeInsets.only(top: size.height),
      ).positive();

  /// Calculates the constraints for the floater based on the given direction.
  ///
  /// In the main axis, this is the vacant space left in the given direction,
  /// when subtracting the target size, its offset, and the input padding.
  ///
  /// In the cross axis, this is the cross axis extent of the target,
  /// minus the input padding.
  BoxConstraints getPositionConstraints(
    AxisDirection direction,
    Size space,
    Offset offset,
    Size size,
    EdgeInsets padding,
  ) =>
      switch (direction) {
        AxisDirection.down => BoxConstraints(
            maxWidth: size.width - padding.horizontal,
            maxHeight:
                space.height - offset.dy - size.height - padding.vertical,
          ),
        AxisDirection.up => BoxConstraints(
            maxWidth: size.width - padding.horizontal,
            maxHeight: offset.dy - padding.vertical,
          ),
        AxisDirection.left => BoxConstraints(
            maxWidth: offset.dx - padding.horizontal,
            maxHeight: size.height - padding.vertical,
          ),
        AxisDirection.right => BoxConstraints(
            maxWidth: space.width - offset.dx - size.width - padding.horizontal,
            maxHeight: size.height - padding.vertical,
          ),
      }
          .normalize();

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: controller,
      child: widget.child,
      overlayChildBuilder: (context) => Builder(
        builder: (context) {
          final (size: size, offset: linkOffset) = widget.link.value;

          // TODO: use viewPadding
          final (size: space, offset: overlayOffset, :viewPadding) =
              getOverlayConstraints(Overlay.of(context));

          final offset = linkOffset - overlayOffset;
          AxisDirection direction = widget.direction;

          final rawPadding = widget.padding;

          final padding = getPositionPadding(
            direction,
            space,
            offset,
            size,
            rawPadding,
          );

          final inputPadding = mapPaddingDirection(
            widget.direction,
            rawPadding,
          );

          BoxConstraints constraints = getPositionConstraints(
            direction,
            space,
            offset,
            size,
            inputPadding,
          );

          if (widget.autoFlip &&
              constraints.maxHeight < widget.autoFlipHeight) {
            final opposite = flipAxisDirection(widget.direction);
            final oppositeConstraints = getPositionConstraints(
              opposite,
              space,
              offset,
              size,
              inputPadding,
            );

            if (oppositeConstraints.maxHeight > constraints.maxHeight) {
              direction = opposite;
              constraints = oppositeConstraints;
            }
          }

          if (size.height + offset.dy < 0) {
            // For reasons unclear to us, the floater cannot exceed the size of the space,
            // despite being able to be offset outside of it.
            // This means, its not possible to have an "infinite" floater that continously expands,
            // as the user scrolls the target out of view.
            // To avoid weird behavior, we collapse the floater to zero size in this case.
            // This is also the behavior that would occur if the widget was unmounted by a
            // scrollview, as showWhenUnlinked is false.
            constraints = BoxConstraints.tight(Size.zero);
          }

          final (targetAnchor, followerAnchor) = getDirectionAnchors(direction);

          return CompositedTransformFollower(
            showWhenUnlinked: false,
            link: widget.link.layerLink,
            targetAnchor: targetAnchor,
            followerAnchor: followerAnchor,
            child: Padding(
              padding: padding,
              child: MediaQuery.removePadding(
                context: context,
                child: Align(
                  alignment: followerAnchor,
                  child: ConstrainedBox(
                    constraints: constraints,
                    child: _FloaterProvider(
                      data: FloaterData(
                        size: constraints.biggest,
                        offset: offset + Offset(padding.left, padding.top),
                        direction: widget.direction,
                        effectiveDirection: direction,
                      ),
                      child: Builder(builder: widget.builder),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Information about the current state of a [Floater].
@immutable
class FloaterData {
  const FloaterData({
    required this.size,
    required this.offset,
    required this.direction,
    required this.effectiveDirection,
  });

  /// The maximum size of the floater.
  final Size size;

  /// The global offset of the floater.
  final Offset offset;

  /// The desired direction of the floater.
  final AxisDirection direction;

  /// The effective direction of the floater.
  final AxisDirection effectiveDirection;

  @override
  bool operator ==(Object other) {
    return other is FloaterData &&
        other.size == size &&
        other.offset == offset &&
        other.direction == direction &&
        other.effectiveDirection == effectiveDirection;
  }

  @override
  int get hashCode => Object.hash(
        size,
        offset,
        direction,
        effectiveDirection,
      );
}

class _FloaterProvider extends InheritedWidget {
  const _FloaterProvider({
    required this.data,
    required Widget child,
  }) : super(child: child);

  final FloaterData data;

  @override
  bool updateShouldNotify(_FloaterProvider oldWidget) => oldWidget.data != data;
}
