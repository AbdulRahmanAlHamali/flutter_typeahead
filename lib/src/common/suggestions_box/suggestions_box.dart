import 'package:flutter/material.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_controller.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_list_animation.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_list_keyboard_connector.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_list_scroll_injector.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/typedef.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

/// A widget that contains suggestions based on user input.
///
/// This widget connects to a [SuggestionsField] through a [SuggestionsController].
class SuggestionsBox<T> extends StatelessWidget {
  const SuggestionsBox({
    super.key,
    required this.controller,
    this.scrollController,
    required this.builder,
    this.wrapperBuilder,
    this.transitionBuilder,
    this.animationDuration,
  });

  /// {@template flutter_typeahead.SuggestionsBox.controller}
  /// Controller to manage the state of the suggestions box.
  ///
  /// This can be used to programmatically open and close the suggestions box
  /// or read various states such as the suggestions list, loading state, etc.
  /// {@endtemplate}
  final SuggestionsController<T> controller;

  /// {@template flutter_typeahead.SuggestionsBox.scrollController}
  /// Controller for the [ScrollView] containing the suggestions.
  ///
  /// You may access the controller via [PrimaryScrollController.of]
  /// inside the body of the suggestions box.
  /// {@endtemplate}
  final ScrollController? scrollController;

  /// {@template flutter_typeahead.SuggestionsBox.builder}
  /// Builds the content of the suggestions box.
  ///
  /// This is typically a [SuggestionsList] widget.
  /// {@endtemplate}
  final WidgetBuilder builder;

  final Widget Function(BuildContext context, Widget child)? wrapperBuilder;

  /// {@template flutter_typeahead.SuggestionsBox.transitionBuilder}
  /// Builder function for animating the suggestions box.
  ///
  /// Example usage:
  /// ```dart
  /// transitionBuilder: (context, animation, child) {
  ///   return FadeTransition(
  ///     child: suggestionsBox,
  ///     opacity: CurvedAnimation(
  ///       parent: animationController,
  ///       curve: Curves.fastOutSlowIn,
  ///     ),
  ///   );
  /// }
  /// ```
  ///
  /// To disable the animation, simply return `child`
  ///
  /// Defaults to a [SizeTransition].
  ///
  /// See also:
  /// * [animationDuration], which is the duration of the animation.
  /// * [animationStart], which is the value at which the list of suggestions should start animating.
  /// {@endtemplate}
  final AnimationTransitionBuilder? transitionBuilder;

  /// {@template flutter_typeahead.SuggestionsBox.animationDuration}
  /// Duration of the animation for showing and hiding the suggestions box.
  ///
  /// Defaults to 500 milliseconds.
  ///
  /// See also:
  /// * [animationStart], which is the value at which the list of suggestions should start animating.
  /// * [transitionBuilder], which is the builder function for custom animation transitions.
  /// {@endtemplate}
  final Duration? animationDuration;

  @override
  Widget build(BuildContext context) {
    ItemBuilder<Widget> wrapper = wrapperBuilder ?? (_, child) => child;

    return SuggestionsControllerProvider<T>(
      controller: controller,
      child: Builder(
        builder: (context) => wrapper(
          context,
          SuggestionsListScrollInjector(
            controller: scrollController,
            child: SuggestionsListKeyboardConnector<T>(
              controller: controller,
              child: PointerInterceptor(
                child: SuggestionsListAnimation<T>(
                  controller: controller,
                  transitionBuilder: transitionBuilder,
                  animationDuration: animationDuration,
                  child: builder(context),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
