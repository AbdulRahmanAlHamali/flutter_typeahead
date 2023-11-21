import 'dart:async';

import 'package:flutter/widgets.dart';

typedef SuggestionsCallback<T> = FutureOr<List<T>> Function(String pattern);
typedef ItemBuilder<T> = Widget Function(BuildContext context, T value);
typedef SuggestionSelectionCallback<T> = void Function(T suggestion);
typedef ErrorBuilder = Widget Function(BuildContext context, Object? error);
typedef TextFieldBuilder = Widget Function(
  BuildContext context,
  TextEditingController controller,
  FocusNode focusNode,
);
typedef DecorationBuilder = Widget Function(
  BuildContext context,
  Widget child,
);
typedef AnimationTransitionBuilder = Widget Function(
  BuildContext context,
  Animation<double> animation,
  Widget child,
);
typedef ListBuilder = Widget Function(
  BuildContext context,
  List<Widget> children,
);
