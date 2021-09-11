import 'dart:async';

import 'package:flutter/widgets.dart';

typedef FutureOr<Iterable<T>> SuggestionsCallback<T>(String pattern);
typedef Widget ItemBuilder<T>(BuildContext context, T itemData);
typedef void SuggestionSelectionCallback<T>(T suggestion);
typedef Widget ErrorBuilder(BuildContext context, Object? error);

typedef Widget AnimationTransitionBuilder(
    BuildContext context, Widget child, AnimationController? controller);
