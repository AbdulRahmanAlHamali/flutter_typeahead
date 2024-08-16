import 'package:flutter/material.dart';
import 'package:flutter_typeahead/src/common/base/suggestions_controller.dart';
import 'package:flutter_typeahead/src/common/base/types.dart';
import 'package:flutter_typeahead/src/common/box/suggestions_box_animation.dart';
import 'package:flutter_typeahead/src/common/box/suggestions_box_focus_connector.dart';
import 'package:flutter_typeahead/src/common/box/suggestions_box_scroll_injector.dart';
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
    this.decorationBuilder,
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

  /// {@template flutter_typeahead.SuggestionsBox.decorationBuilder}
  /// Builder function for decorating the suggestions box.
  ///
  /// Example usage:
  /// ```dart
  /// decorationBuilder: (context, child) {
  ///   return Container(
  ///     decoration: BoxDecoration(
  ///       border: Border.all(color: Colors.grey),
  ///       borderRadius: BorderRadius.circular(5.0),
  ///     ),
  ///     child: child,
  ///   );
  /// }
  /// ```
  ///
  /// This widget is always built, even when the suggestions box is closed.
  /// {@endtemplate}
  final DecorationBuilder? decorationBuilder;

  /// {@template flutter_typeahead.SuggestionsBox.transitionBuilder}
  /// Builder function for animating the suggestions box.
  ///
  /// Example usage:
  /// ```dart
  /// transitionBuilder: (context, animation, child) {
  ///   return FadeTransition(
  ///     opacity: CurvedAnimation(
  ///       parent: animationController,
  ///       curve: Curves.fastOutSlowIn,
  ///     ),
  ///     child: child,
  ///   );
  /// }
  /// ```
  ///
  /// To disable the animation, simply return `child`
  ///
  /// Defaults to a [SizeTransition] and [AnimatedSize] combination.
  ///
  /// See also:
  /// * [animationDuration], which is the duration of the animation.
  /// {@endtemplate}
  final AnimationTransitionBuilder? transitionBuilder;

  /// {@template flutter_typeahead.SuggestionsBox.animationDuration}
  /// Duration of the animation for showing and hiding the suggestions box.
  ///
  /// Defaults to `500 milliseconds`.
  ///
  /// See also:
  /// * [transitionBuilder], which is the builder function for custom animation transitions.
  /// {@endtemplate}
  final Duration? animationDuration;

  @override
  Widget build(BuildContext context) {
    SuggestionsItemBuilder<Widget> wrapper =
        decorationBuilder ?? (_, child) => child;

    return SuggestionsControllerProvider<T>(
      controller: controller,
      child: SuggestionsBoxScrollInjector(
        controller: scrollController,
        child: SuggestionsBoxFocusConnector<T>(
          controller: controller,
          child: PointerInterceptor(
            child: Builder(
              builder: (context) => wrapper(
                context,
                SuggestionsBoxAnimation<T>(
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
