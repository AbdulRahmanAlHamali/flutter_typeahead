import 'dart:async';

import 'package:flutter/widgets.dart';

typedef FutureOr<Iterable<T>> SuggestionsCallback<T>(String pattern);
typedef FutureOr<Iterable<R>> FetchRecentActionCallback<R>(String pattern);
typedef Widget ItemBuilder<T>(BuildContext context, T itemData);
typedef void SuggestionSelectionCallback<T>(T suggestion);
typedef void RecentSelectionCallback<R>(R recent);
typedef Widget ErrorBuilder(BuildContext context, Object? error);
typedef Widget ButtonActionBuilder(BuildContext context, dynamic action);
typedef void ButtonActionCallback(dynamic action);

typedef Widget AnimationTransitionBuilder(
    BuildContext context, Widget child, AnimationController? controller);
