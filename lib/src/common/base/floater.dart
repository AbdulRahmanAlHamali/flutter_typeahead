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
    this.visible = true,
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

  /// Whether the floater overlay is visible.
  ///
  /// When false, the overlay is hidden and position updates are skipped.
  final bool visible;

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    widget.link.addListener(updateOverlay);
    maybeUpdateOverlay();
  }

  @override
  void didUpdateWidget(covariant Floater oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.link != widget.link) {
      oldWidget.link.removeListener(updateOverlay);
      widget.link.addListener(updateOverlay);
    }
    if (widget.visible && !oldWidget.visible) {
      updateOverlay();
    }
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
    updateOverlay();
  }

  void maybeUpdateOverlay() {
    final List<Object?> newDependencies = createDependencies();
    if (!listEquals(dependencies, newDependencies)) {
      dependencies = newDependencies;
      updateOverlay();
    }
  }

  void updateOverlay() {
    if (!widget.visible) return;
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
    final RenderBox? overlayBox =
        overlay.context.findRenderObject() as RenderBox?;

    if (overlayBox == null || !overlayBox.hasSize) {
      return (
        size: Size.zero,
        offset: Offset.zero,
        viewPadding: EdgeInsets.zero,
      );
    }

    Offset overlayOffset = overlayBox.localToGlobal(Offset.zero);
    Size overlaySize = overlayBox.size;

    MediaQueryData mediaQuery = MediaQuery.of(overlay.context);
    EdgeInsets viewPadding = mediaQuery.padding + mediaQuery.viewInsets;

    return (
      size: overlaySize,
      offset: overlayOffset,
      viewPadding: viewPadding,
    );
  }

  /// Computes the floater's bounding rectangle in screen coordinates.
  ///
  /// The anchor booleans are direction-relative:
  ///   top = main axis start (near target)
  ///   bottom = main axis end (far from target)
  ///   left = cross axis start
  ///   right = cross axis end
  ///
  /// Main axis states:
  ///   T,F → home side only (standard)
  ///   T,T → target overlap
  ///   F,F → expand through target (target + home)
  ///   F,T → shifted to opposite side (opposite + target)
  ///
  /// Cross axis states:
  ///   T,T → target extent only
  ///   T,F → extend toward cross end
  ///   F,T → extend toward cross start
  ///   F,F → full cross extent
  Rect getFloaterRect(
    AxisDirection direction,
    Size space,
    Offset offset,
    Size size,
    FloaterAnchor anchor,
  ) {
    final targetRect = offset & size;

    // Main axis: determine the vertical (or horizontal) span
    final (double mainStart, double mainEnd) = _mainAxisSpan(
      direction,
      space,
      targetRect,
      anchor.top,
      anchor.bottom,
    );

    // Cross axis: determine the horizontal (or vertical) span
    final (double crossStart, double crossEnd) = _crossAxisSpan(
      direction,
      space,
      targetRect,
      anchor.left,
      anchor.right,
    );

    final bool mainIsVertical =
        direction == AxisDirection.down || direction == AxisDirection.up;

    if (mainIsVertical) {
      return Rect.fromLTRB(crossStart, mainStart, crossEnd, mainEnd);
    } else {
      return Rect.fromLTRB(mainStart, crossStart, mainEnd, crossEnd);
    }
  }

  /// Computes the main-axis span (start, end) in screen coordinates.
  (double, double) _mainAxisSpan(
    AxisDirection direction,
    Size space,
    Rect target,
    bool anchorTop,
    bool anchorBottom,
  ) {
    // "home" = the region on the opening side of the target
    // "opposite" = the region on the far side from the opening direction
    // "target" = the target's own extent

    final bool mainIsVertical =
        direction == AxisDirection.down || direction == AxisDirection.up;

    final double spaceEnd = mainIsVertical ? space.height : space.width;
    final double targetStart = mainIsVertical ? target.top : target.left;
    final double targetEnd = mainIsVertical ? target.bottom : target.right;

    // home and opposite depend on which way we're opening
    final bool opensPositive =
        direction == AxisDirection.down || direction == AxisDirection.right;

    final double homeStart = opensPositive ? targetEnd : 0;
    final double homeEnd = opensPositive ? spaceEnd : targetStart;
    final double oppositeStart = opensPositive ? 0 : targetEnd;
    final double oppositeEnd = opensPositive ? targetStart : spaceEnd;

    if (anchorTop && !anchorBottom) {
      // Standard: home side only
      return (homeStart, homeEnd);
    } else if (anchorTop && anchorBottom) {
      // Overlap target
      return (targetStart, targetEnd);
    } else if (!anchorTop && !anchorBottom) {
      // Expand through target (target + home)
      return (min(targetStart, homeStart), max(targetEnd, homeEnd));
    } else {
      // Shifted opposite (opposite + target)
      return (min(oppositeStart, targetStart), max(oppositeEnd, targetEnd));
    }
  }

  /// Computes the cross-axis span (start, end) in screen coordinates.
  (double, double) _crossAxisSpan(
    AxisDirection direction,
    Size space,
    Rect target,
    bool anchorLeft,
    bool anchorRight,
  ) {
    final bool mainIsVertical =
        direction == AxisDirection.down || direction == AxisDirection.up;

    final double spaceEnd = mainIsVertical ? space.width : space.height;
    final double targetStart = mainIsVertical ? target.left : target.top;
    final double targetEnd = mainIsVertical ? target.right : target.bottom;

    final double start = anchorLeft ? targetStart : 0;
    final double end = anchorRight ? targetEnd : spaceEnd;

    return (start, end);
  }

  /// Maps direction-relative padding to screen-coordinate EdgeInsets.
  ///
  /// Direction-relative: top=main start, bottom=main end, left=cross start, right=cross end.
  /// Screen coordinates: top/bottom/left/right are absolute.
  EdgeInsets mapPaddingToScreen(AxisDirection direction, EdgeInsets padding) =>
      switch (direction) {
        AxisDirection.down => EdgeInsets.only(
            top: padding.top,
            bottom: padding.bottom,
            left: padding.left,
            right: padding.right,
          ),
        AxisDirection.up => EdgeInsets.only(
            bottom: padding.top,
            top: padding.bottom,
            left: padding.left,
            right: padding.right,
          ),
        AxisDirection.left => EdgeInsets.only(
            right: padding.top,
            left: padding.bottom,
            top: padding.left,
            bottom: padding.right,
          ),
        AxisDirection.right => EdgeInsets.only(
            left: padding.top,
            right: padding.bottom,
            top: padding.left,
            bottom: padding.right,
          ),
      };

  /// Shrinks a rect by the given insets, clamping to zero size.
  Rect deflateRect(Rect rect, EdgeInsets insets) {
    return Rect.fromLTRB(
      rect.left + insets.left,
      rect.top + insets.top,
      max(rect.left + insets.left, rect.right - insets.right),
      max(rect.top + insets.top, rect.bottom - insets.bottom),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: controller,
      child: widget.child,
      overlayChildBuilder: (context) => Builder(
        builder: (context) {
          final (size: size, offset: linkOffset) = widget.link.value;

          final (size: overlaySize, offset: overlayOffset, :viewPadding) =
              getOverlayConstraints(Overlay.of(context));

          final offset = linkOffset - overlayOffset;

          if (offset.dx.isNaN || offset.dy.isNaN) {
            return const SizedBox.shrink();
          }

          final space = Size(
            max(0, overlaySize.width - viewPadding.horizontal),
            max(0, overlaySize.height - viewPadding.vertical),
          );
          final spaceOffset = Offset(
            offset.dx - viewPadding.left,
            offset.dy - viewPadding.top,
          );

          AxisDirection direction = widget.direction;

          Rect floaterRect = getFloaterRect(
            direction,
            space,
            spaceOffset,
            size,
            widget.anchor,
          );

          floaterRect =
              floaterRect.shift(Offset(viewPadding.left, viewPadding.top));

          final screenPadding = mapPaddingToScreen(direction, widget.padding);
          floaterRect = deflateRect(floaterRect, screenPadding);

          if (widget.autoFlip) {
            final mainSize =
                direction == AxisDirection.down || direction == AxisDirection.up
                    ? floaterRect.height
                    : floaterRect.width;

            if (mainSize < widget.autoFlipHeight) {
              final opposite = flipAxisDirection(widget.direction);
              var flippedRect = getFloaterRect(
                opposite,
                space,
                spaceOffset,
                size,
                widget.anchor,
              );
              flippedRect =
                  flippedRect.shift(Offset(viewPadding.left, viewPadding.top));
              flippedRect = deflateRect(
                  flippedRect, mapPaddingToScreen(opposite, widget.padding));

              final flippedMainSize =
                  opposite == AxisDirection.down || opposite == AxisDirection.up
                      ? flippedRect.height
                      : flippedRect.width;

              if (flippedMainSize > mainSize) {
                direction = opposite;
                floaterRect = flippedRect;
              }
            }
          }

          final floaterSize = floaterRect.size;
          final floaterOffset = floaterRect.topLeft - offset;

          final overlayWidth = overlaySize.width;
          final overlayHeight = overlaySize.height;

          return CompositedTransformFollower(
            showWhenUnlinked: false,
            link: widget.link.layerLink,
            targetAnchor: Alignment.topLeft,
            followerAnchor: Alignment.topLeft,
            offset: floaterOffset,
            child: Padding(
              padding: EdgeInsets.only(
                right: max(0, overlayWidth - floaterSize.width),
                bottom: max(0, overlayHeight - floaterSize.height),
              ),
              child: MediaQuery.removePadding(
                context: context,
                child: Align(
                  alignment: switch (direction) {
                    AxisDirection.down => Alignment.topLeft,
                    AxisDirection.up => Alignment.bottomLeft,
                    AxisDirection.left => Alignment.topRight,
                    AxisDirection.right => Alignment.topLeft,
                  },
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: floaterSize.width,
                      maxHeight: floaterSize.height,
                    ),
                    child: _FloaterProvider(
                      data: FloaterData(
                        size: floaterSize,
                        offset: floaterRect.topLeft,
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
