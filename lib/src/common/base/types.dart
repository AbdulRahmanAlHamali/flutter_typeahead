import 'dart:async';

import 'package:flutter/widgets.dart';

/// Called to retrieve the suggestions for [search].
typedef SuggestionsCallback<T> = FutureOr<List<T>?> Function(String search);

/// Builds a widget for a suggestion in the suggestions box.
typedef SuggestionsItemBuilder<T> = Widget Function(
  BuildContext context,
  T value,
);

/// Called when a suggestion is selected.
typedef SuggestionSelectionCallback<T> = void Function(T suggestion);

/// Builds a widget for the error in the suggestions box.
typedef SuggestionsErrorBuilder = Widget Function(
  BuildContext context,
  Object error,
);

/// Builds the text field of the suggestions field.
///
/// Both the [controller] and [focusNode] must be passed to the text field.
typedef TextFieldBuilder = Widget Function(
  BuildContext context,
  TextEditingController controller,
  FocusNode focusNode,
);

/// Builds the decoration of the suggestions box.
typedef DecorationBuilder = Widget Function(
  BuildContext context,
  Widget child,
);

/// Builds the animation for opening and closing the suggestions box.
typedef AnimationTransitionBuilder = Widget Function(
  BuildContext context,
  Animation<double> animation,
  Widget child,
);

/// Builds the list of suggestions in the suggestions box.
///
/// [children] is the list of suggestions to display built by [itemBuilder].
typedef ListBuilder = Widget Function(
  BuildContext context,
  List<Widget> children,
);
