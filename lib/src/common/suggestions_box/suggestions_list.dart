import 'dart:async';
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_box.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_box_decoration.dart';
import 'package:flutter_typeahead/src/keyboard_suggestion_selection_notifier.dart';
import 'package:flutter_typeahead/src/should_refresh_suggestion_focus_index_notifier.dart';
import 'package:flutter_typeahead/src/typedef.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

/// Renders all the suggestions using a ListView as default.
/// If `layoutArchitecture` is specified, uses that instead.
abstract class RenderSuggestionsList<T> extends StatefulWidget {
  const RenderSuggestionsList({
    super.key,
    required this.suggestionsBox,
    this.controller,
    this.intercepting = false,
    this.getImmediateSuggestions = false,
    this.onSuggestionSelected,
    this.suggestionsCallback,
    this.itemBuilder,
    this.itemSeparatorBuilder,
    this.layoutArchitecture,
    this.scrollController,
    this.debounceDuration,
    this.loadingBuilder,
    this.noItemsFoundBuilder,
    this.errorBuilder,
    this.transitionBuilder,
    this.animationDuration,
    this.animationStart,
    this.direction,
    this.hideOnLoading,
    this.hideOnEmpty,
    this.hideOnError,
    this.keepSuggestionsOnLoading,
    this.minCharsForSuggestions,
    required this.keyboardSuggestionSelectionNotifier,
    required this.shouldRefreshSuggestionFocusIndexNotifier,
    required this.giveTextFieldFocus,
    required this.onSuggestionFocus,
    required this.onKeyEvent,
    required this.hideKeyboardOnDrag,
  });

  final SuggestionsBox? suggestionsBox;
  BaseSuggestionsBoxDecoration? get decoration;
  final TextEditingController? controller;
  final bool getImmediateSuggestions;
  final SuggestionSelectionCallback<T>? onSuggestionSelected;
  final SuggestionsCallback<T>? suggestionsCallback;
  final ItemBuilder<T>? itemBuilder;
  final IndexedWidgetBuilder? itemSeparatorBuilder;
  final LayoutArchitecture? layoutArchitecture;
  final ScrollController? scrollController;
  final Duration? debounceDuration;
  final WidgetBuilder? loadingBuilder;
  final bool intercepting;
  final WidgetBuilder? noItemsFoundBuilder;
  final ErrorBuilder? errorBuilder;
  final AnimationTransitionBuilder? transitionBuilder;
  final Duration? animationDuration;
  final double? animationStart;
  final AxisDirection? direction;
  final bool? hideOnLoading;
  final bool? hideOnEmpty;
  final bool? hideOnError;
  final bool? keepSuggestionsOnLoading;
  final int? minCharsForSuggestions;
  final KeyboardSuggestionSelectionNotifier keyboardSuggestionSelectionNotifier;
  final ShouldRefreshSuggestionFocusIndexNotifier
      shouldRefreshSuggestionFocusIndexNotifier;
  final VoidCallback giveTextFieldFocus;
  final VoidCallback onSuggestionFocus;
  final FocusOnKeyCallback onKeyEvent;
  final bool hideKeyboardOnDrag;

  Widget createLoadingWidget(
    BuildContext context,
    SuggestionsListConfigState state,
  );

  Widget createErrorWidget(
    BuildContext context,
    SuggestionsListConfigState state,
  );

  Widget createNoItemsFoundWidget(
    BuildContext context,
    SuggestionsListConfigState state,
  );

  Widget createSuggestionsWidget(
    BuildContext context,
    SuggestionsListConfigState state,
  );

  Widget defaultSuggestionsWidget(
    BuildContext context,
    SuggestionsListConfigState state,
  );

  Widget customSuggestionsWidget(
    BuildContext context,
    SuggestionsListConfigState state,
  );

  @override
  State<RenderSuggestionsList<T>> createState() =>
      _RenderSuggestionsListState<T>();
}

class _RenderSuggestionsListState<T> extends State<RenderSuggestionsList<T>>
    with SingleTickerProviderStateMixin {
  Iterable<T>? _suggestions;
  late bool _suggestionsValid;
  late VoidCallback _controllerListener;
  Timer? _debounceTimer;
  bool? _isLoading, _isQueued;
  Object? _error;
  AnimationController? _animationController;
  String? _lastTextValue;
  late final ScrollController _scrollController =
      widget.scrollController ?? ScrollController();
  List<FocusNode> _focusNodes = [];
  int _suggestionIndex = -1;

  _RenderSuggestionsListState() {
    this._controllerListener = () {
      // If we came here because of a change in selected text, not because of
      // actual change in text
      if (widget.controller!.text == this._lastTextValue) return;

      this._lastTextValue = widget.controller!.text;

      this._debounceTimer?.cancel();
      if (widget.controller!.text.length < widget.minCharsForSuggestions!) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _suggestions = null;
            _suggestionsValid = true;
          });
        }
        return;
      } else {
        this._debounceTimer = Timer(widget.debounceDuration!, () async {
          if (this._debounceTimer!.isActive) return;
          if (_isLoading!) {
            _isQueued = true;
            return;
          }

          await this.invalidateSuggestions();
          while (_isQueued!) {
            _isQueued = false;
            await this.invalidateSuggestions();
          }
        });
      }
    };
  }

  @override
  void didUpdateWidget(RenderSuggestionsList<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.controller!.addListener(this._controllerListener);
    _getSuggestions();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getSuggestions();
  }

  @override
  void initState() {
    super.initState();

    this._animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    this._suggestionsValid = widget.minCharsForSuggestions! > 0 ? true : false;
    this._isLoading = false;
    this._isQueued = false;
    this._lastTextValue = widget.controller!.text;

    if (widget.getImmediateSuggestions) {
      this._getSuggestions();
    }

    widget.controller!.addListener(this._controllerListener);

    widget.keyboardSuggestionSelectionNotifier.addListener(() {
      final suggestionsLength = _suggestions?.length;
      final event = widget.keyboardSuggestionSelectionNotifier.value;
      if (event == null || suggestionsLength == null) return;

      if (event == LogicalKeyboardKey.arrowDown &&
          _suggestionIndex < suggestionsLength - 1) {
        _suggestionIndex++;
      } else if (event == LogicalKeyboardKey.arrowUp && _suggestionIndex > -1) {
        _suggestionIndex--;
      }

      if (_suggestionIndex > -1 && _suggestionIndex < _focusNodes.length) {
        final focusNode = _focusNodes[_suggestionIndex];
        focusNode.requestFocus();
        widget.onSuggestionFocus();
      } else {
        widget.giveTextFieldFocus();
      }
    });

    widget.shouldRefreshSuggestionFocusIndexNotifier.addListener(() {
      if (_suggestionIndex != -1) {
        _suggestionIndex = -1;
      }
    });
  }

  Future<void> invalidateSuggestions() async {
    _suggestionsValid = false;
    await _getSuggestions();
  }

  Future<void> _getSuggestions() async {
    if (_suggestionsValid) return;
    _suggestionsValid = true;

    if (mounted) {
      setState(() {
        this._animationController!.forward(from: 1.0);

        this._isLoading = true;
        this._error = null;
      });

      Iterable<T>? suggestions;
      Object? error;

      try {
        suggestions =
            await widget.suggestionsCallback!(widget.controller!.text);
      } catch (e) {
        error = e;
      }

      if (mounted) {
        // if it wasn't removed in the meantime
        setState(() {
          double? animationStart = widget.animationStart;
          // allow suggestionsCallback to return null and not throw error here
          if (error != null || suggestions?.isEmpty == true) {
            animationStart = 1.0;
          }
          this._animationController!.forward(from: animationStart);

          this._error = error;
          this._isLoading = false;
          this._suggestions = suggestions;
          _focusNodes = List.generate(
            _suggestions?.length ?? 0,
            (index) => FocusNode(onKey: widget.onKeyEvent),
          );
        });
      }
    }
  }

  @override
  void dispose() {
    _animationController!.dispose();
    _debounceTimer?.cancel();
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isEmpty =
        (this._suggestions?.isEmpty ?? false) && widget.controller!.text == "";
    if ((this._suggestions == null || isEmpty) &&
        this._isLoading == false &&
        this._error == null) {
      return const SizedBox();
    }

    SuggestionsListConfigState<T> state = SuggestionsListConfigState<T>(
      focusNodes: _focusNodes,
      scrollController: _scrollController,
      suggestions: this._suggestions,
      error: this._error,
    );

    Widget child;
    if (this._isLoading!) {
      if (widget.hideOnLoading!) {
        child = const SizedBox(height: 0);
      } else {
        child = widget.createLoadingWidget(context, state);
      }
    } else if (this._error != null) {
      if (widget.hideOnError!) {
        child = const SizedBox(height: 0);
      } else {
        child = widget.createErrorWidget(context, state);
      }
    } else if (this._suggestions!.isEmpty) {
      if (widget.hideOnEmpty!) {
        child = const SizedBox(height: 0);
      } else {
        child = widget.createNoItemsFoundWidget(context, state);
      }
    } else {
      child = widget.createSuggestionsWidget(context, state);
    }

    final animationChild = widget.transitionBuilder != null
        ? widget.transitionBuilder!(context, child, this._animationController)
        : SizeTransition(
            axisAlignment: -1.0,
            sizeFactor: CurvedAnimation(
              parent: this._animationController!,
              curve: Curves.fastOutSlowIn,
            ),
            child: child,
          );

    BoxConstraints constraints;
    if (widget.decoration!.constraints == null) {
      constraints = BoxConstraints(
        maxHeight: widget.suggestionsBox!.maxHeight,
      );
    } else {
      double maxHeight = min(widget.decoration!.constraints!.maxHeight,
          widget.suggestionsBox!.maxHeight);
      constraints = widget.decoration!.constraints!.copyWith(
        minHeight: min(widget.decoration!.constraints!.minHeight, maxHeight),
        maxHeight: maxHeight,
      );
    }

    return PointerInterceptor(
      intercepting: widget.intercepting,
      child: ConstrainedBox(
        constraints: constraints,
        child: animationChild,
      ),
    );
  }
}

class SuggestionsListConfigState<T> {
  SuggestionsListConfigState({
    required this.focusNodes,
    required this.scrollController,
    this.suggestions,
    this.error,
  });

  final List<FocusNode> focusNodes;
  final ScrollController scrollController;
  final Iterable<T>? suggestions;
  final Object? error;
}
