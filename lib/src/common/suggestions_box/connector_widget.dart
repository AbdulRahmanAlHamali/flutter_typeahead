import 'package:flutter/widgets.dart';

/// A simplified life-cycle widget for connecting to a resource <T>
/// that may change over time.
///
/// On connection, a key <R> may be returned, which can later
/// be used for disconnection. This is useful for e.g. [StreamSubscription]s.
/// The key may also be ignored (e.g. void).
///
/// This is useful because I am tired of writing a test for [State.didUpdateWidget] everytime.
class ConnectorWidget<T, R> extends StatefulWidget {
  const ConnectorWidget({
    super.key,
    required this.value,
    this.connect,
    this.disconnect,
    required this.child,
  });

  /// The value to connect to.
  final T value;

  /// Called when the value is connected.
  ///
  /// This is called whenever a new value is passed in.
  ///
  /// The return value can be used as an optional key for disconnection.
  final R Function(T value)? connect;

  /// Called when the value is disconnected.
  ///
  /// This is called whenever a value is replaced or the widget is disposed.
  ///
  /// The key is the value returned from [connect].
  /// If [connect] was not defined, this will be null.
  final void Function(T value, R? key)? disconnect;

  /// The widget below this widget in the tree.
  final Widget child;

  @override
  State<ConnectorWidget<T, R>> createState() => _ConnectorWidgetState<T, R>();
}

class _ConnectorWidgetState<T, R> extends State<ConnectorWidget<T, R>> {
  R? key;

  @override
  void initState() {
    super.initState();
    key = widget.connect?.call(widget.value);
  }

  @override
  void didUpdateWidget(covariant ConnectorWidget<T, R> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      widget.disconnect?.call(oldWidget.value, key);
      key = widget.connect?.call(widget.value);
    }
  }

  @override
  void dispose() {
    widget.disconnect?.call(widget.value, key);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
