import 'dart:async';
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_box.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_box_decoration.dart';
import 'package:flutter_typeahead/src/should_refresh_suggestion_focus_index_notifier.dart';
import 'package:flutter_typeahead/src/typedef.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

/// Renders all the suggestions using a ListView as default.
/// If `layoutArchitecture` is specified, uses that instead.
abstract class RenderSuggestionsList<T> extends StatefulWidget {
  const RenderSuggestionsList({
    super.key,
    required this.suggestionsBox,
    required this.itemBuilder,
    required this.controller,
    this.intercepting = false,
    this.onSuggestionSelected,
    this.suggestionsCallback,
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
    this.hideOnLoading,
    this.hideOnEmpty,
    this.hideOnError,
    this.keepSuggestionsOnLoading,
    this.minCharsForSuggestions,
    required this.shouldRefreshSuggestionFocusIndexNotifier,
    required this.giveTextFieldFocus,
    required this.onSuggestionFocus,
    required this.hideKeyboardOnDrag,
  });

  final SuggestionsBox suggestionsBox;
  BaseSuggestionsBoxDecoration? get decoration;
  final TextEditingController controller;
  final SuggestionSelectionCallback<T>? onSuggestionSelected;
  final SuggestionsCallback<T>? suggestionsCallback;
  final ItemBuilder<T> itemBuilder;
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
  final bool? hideOnLoading;
  final bool? hideOnEmpty;
  final bool? hideOnError;
  final bool? keepSuggestionsOnLoading;
  final int? minCharsForSuggestions;
  final ShouldRefreshSuggestionFocusIndexNotifier
      shouldRefreshSuggestionFocusIndexNotifier;
  final VoidCallback giveTextFieldFocus;
  final VoidCallback onSuggestionFocus;
  final bool hideKeyboardOnDrag;

  Widget createLoadingWidget(
    BuildContext context,
    SuggestionsListConfigState<T> state,
  );

  Widget createErrorWidget(
    BuildContext context,
    SuggestionsListConfigState<T> state,
  );

  Widget createNoItemsFoundWidget(
    BuildContext context,
    SuggestionsListConfigState<T> state,
  );

  Widget createSuggestionsWidget(
    BuildContext context,
    SuggestionsListConfigState<T> state,
  );

  Widget createWidgetWrapper(
    BuildContext context,
    SuggestionsListConfigState<T> state,
    Widget child,
  ) =>
      child;

  @override
  State<RenderSuggestionsList<T>> createState() =>
      _RenderSuggestionsListState<T>();
}

class _RenderSuggestionsListState<T> extends State<RenderSuggestionsList<T>>
    with SingleTickerProviderStateMixin {
  Timer? _debounceTimer;

  Object? _error;

  late final AnimationController _animationController;

  late final ScrollController _scrollController =
      widget.scrollController ?? ScrollController();

  String? _lastTextValue;

  bool _isLoading = false;
  bool _isQueued = false;
  bool _suggestionsValid = false;
  Iterable<T>? _suggestions;
  List<FocusNode> _focusNodes = [];
  int _suggestionIndex = -1;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _lastTextValue = widget.controller.text;
    _suggestionsValid =
        widget.controller.text.length < widget.minCharsForSuggestions!;
    _loadSuggestions();

    widget.controller.addListener(_onTextChange);
    widget.suggestionsBox.keyEvents.listen(_onKey);

    widget.shouldRefreshSuggestionFocusIndexNotifier.addListener(() {
      if (_suggestionIndex != -1) {
        _suggestionIndex = -1;
      }
    });
  }

  @override
  void didUpdateWidget(RenderSuggestionsList<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.controller.removeListener(_onTextChange);
    widget.controller.addListener(_onTextChange);
    _onTextChange();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _debounceTimer?.cancel();
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    widget.controller.removeListener(_onTextChange);
    super.dispose();
  }

  void _onKey(LogicalKeyboardKey key) {
    // this feature is currently disabled
    return;

    // ignore: dead_code
    final suggestionsLength = _suggestions?.length;
    if (suggestionsLength == null) return;

    if (key == LogicalKeyboardKey.arrowDown) {
      _suggestionIndex++;
    } else if (key == LogicalKeyboardKey.arrowUp) {
      _suggestionIndex--;
    }

    _suggestionIndex = _suggestionIndex.clamp(-1, suggestionsLength - 1);

    if (_suggestionIndex == -1) {
      widget.giveTextFieldFocus();
    } else {
      final focusNode = _focusNodes[_suggestionIndex];
      focusNode.requestFocus();
      widget.onSuggestionFocus();
    }
  }

  void _onTextChange() {
    // ignore changes in selection only
    if (widget.controller.text == _lastTextValue) return;
    _lastTextValue = widget.controller.text;

    Duration? debounceDuration = widget.debounceDuration;
    debounceDuration ??= const Duration(milliseconds: 300);

    _debounceTimer?.cancel();
    if (widget.controller.text.length >= widget.minCharsForSuggestions!) {
      if (debounceDuration == Duration.zero) {
        _reloadSuggestions();
      } else {}
      _debounceTimer = Timer(debounceDuration, () async {
        if (_isLoading) {
          _isQueued = true;
          return;
        }

        await this._reloadSuggestions();
        if (_isQueued) {
          _isQueued = false;
          await this._reloadSuggestions();
        }
      });
    } else {
      setState(() {
        _isLoading = false;
        _suggestions = null;
        _suggestionsValid = true;
      });
    }
  }

  Future<void> _reloadSuggestions() async {
    _suggestionsValid = false;
    await _loadSuggestions();
  }

  Future<void> _loadSuggestions() async {
    if (!context.mounted) return;
    if (_suggestionsValid) return;
    _suggestionsValid = true;

    if (mounted) {
      setState(() {
        _animationController.forward(from: 1);

        _isLoading = true;
        _error = null;
      });

      Iterable<T>? suggestions;
      Object? error;

      try {
        suggestions = await widget.suggestionsCallback!(widget.controller.text);
      } on Exception catch (e) {
        error = e;
      }

      if (!mounted) return;

      setState(() {
        double? animationStart = widget.animationStart;
        // allow suggestionsCallback to return null and not throw error here
        if (error != null || suggestions?.isEmpty == true) {
          animationStart = 1.0;
        }
        _animationController.forward(from: animationStart);

        _error = error;
        _isLoading = false;
        _suggestions = suggestions;
        _focusNodes = List.generate(
          _suggestions?.length ?? 0,
          (index) => FocusNode(onKey: widget.suggestionsBox.onKeyEvent),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEmpty =
        (_suggestions?.isEmpty ?? true) && widget.controller.text.isEmpty;
    if (isEmpty && !_isLoading && _error == null) {
      return const SizedBox();
    }

    SuggestionsListConfigState<T> state = SuggestionsListConfigState<T>(
      focusNodes: _focusNodes,
      scrollController: _scrollController,
      suggestions: _suggestions,
      error: _error,
    );

    Widget child;
    if (_isLoading) {
      if (widget.hideOnLoading!) {
        child = const SizedBox(height: 0);
      } else {
        child = widget.createLoadingWidget(context, state);
      }
    } else if (_error != null) {
      if (widget.hideOnError!) {
        child = const SizedBox(height: 0);
      } else {
        child = widget.createErrorWidget(context, state);
      }
    } else if (_suggestions!.isEmpty) {
      if (widget.hideOnEmpty!) {
        child = const SizedBox(height: 0);
      } else {
        child = widget.createNoItemsFoundWidget(context, state);
      }
    } else {
      child = widget.createSuggestionsWidget(context, state);
    }

    if (widget.transitionBuilder != null) {
      child = widget.transitionBuilder!(context, child, _animationController);
    } else {
      // TODO: implicit animation with AnimatedSize?
      child = SizeTransition(
        axisAlignment: -1,
        sizeFactor: CurvedAnimation(
          parent: _animationController,
          curve: Curves.fastOutSlowIn,
        ),
        child: child,
      );
    }

    BoxConstraints constraints;
    if (widget.decoration!.constraints == null) {
      constraints = BoxConstraints(
        maxHeight: widget.suggestionsBox.maxHeight,
      );
    } else {
      double maxHeight = min(widget.decoration!.constraints!.maxHeight,
          widget.suggestionsBox.maxHeight);
      constraints = widget.decoration!.constraints!.copyWith(
        minHeight: min(widget.decoration!.constraints!.minHeight, maxHeight),
        maxHeight: maxHeight,
      );
    }

    return PointerInterceptor(
      intercepting: widget.intercepting,
      child: widget.createWidgetWrapper(
        context,
        state,
        ConstrainedBox(
          constraints: constraints,
          child: child,
        ),
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
