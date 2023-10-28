import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_box_controller.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_box_decoration.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_list_config.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_list_focus.dart';
import 'package:flutter_typeahead/src/typedef.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

/// Renders all the suggestions using a ListView as default.
/// If `layoutArchitecture` is specified, uses that instead.
abstract class RenderSuggestionsList<T> extends StatefulWidget
    implements SuggestionsListConfig<T> {
  const RenderSuggestionsList({
    super.key,
    this.animationDuration,
    this.animationStart,
    required this.controller,
    this.debounceDuration,
    this.errorBuilder,
    this.hideKeyboardOnDrag = false,
    this.hideOnEmpty,
    this.hideOnError,
    this.hideOnLoading,
    required this.itemBuilder,
    this.itemSeparatorBuilder,
    this.intercepting = false,
    this.keepSuggestionsOnLoading,
    this.keepSuggestionsOnSelect,
    this.layoutArchitecture,
    this.loadingBuilder,
    this.minCharsForSuggestions,
    this.noItemsFoundBuilder,
    this.onSuggestionSelected,
    this.scrollController,
    required this.suggestionsBoxController,
    this.suggestionsCallback,
    this.transitionBuilder,
  });

  @override
  final Duration? animationDuration;
  @override
  final double? animationStart;
  @override
  final TextEditingController controller;
  @override
  final Duration? debounceDuration;
  @override
  final ErrorBuilder? errorBuilder;
  @override
  final bool hideKeyboardOnDrag;
  @override
  final bool? hideOnEmpty;
  @override
  final bool? hideOnError;
  @override
  final bool? hideOnLoading;
  @override
  final ItemBuilder<T> itemBuilder;
  @override
  final IndexedWidgetBuilder? itemSeparatorBuilder;
  @override
  final bool intercepting;
  @override
  final bool? keepSuggestionsOnLoading;
  @override
  final bool? keepSuggestionsOnSelect;
  @override
  final LayoutArchitecture? layoutArchitecture;
  @override
  final WidgetBuilder? loadingBuilder;
  @override
  final int? minCharsForSuggestions;
  @override
  final WidgetBuilder? noItemsFoundBuilder;
  @override
  final SuggestionSelectionCallback<T>? onSuggestionSelected;
  @override
  final ScrollController? scrollController;
  @override
  final SuggestionsBoxController suggestionsBoxController;
  @override
  final SuggestionsCallback<T>? suggestionsCallback;
  @override
  final AnimationTransitionBuilder? transitionBuilder;

  BaseSuggestionsBoxDecoration? get decoration;

  /// Creates a widget to display while suggestions are loading.
  @protected
  Widget createLoadingWidget(
    BuildContext context,
    SuggestionsListState<T> state,
  );

  /// Creates a widget to display when an error has occurred.
  @protected
  Widget createErrorWidget(
    BuildContext context,
    SuggestionsListState<T> state,
  );

  /// Creates a widget to display when no suggestions are available.
  @protected
  Widget createNoItemsFoundWidget(
    BuildContext context,
    SuggestionsListState<T> state,
  );

  /// Creates a widget to display the suggestions.
  @protected
  Widget createSuggestionsWidget(
    BuildContext context,
    SuggestionsListState<T> state,
  );

  /// Creates a widget to wrap all the other widgets.
  @protected
  Widget createWidgetWrapper(
    BuildContext context,
    SuggestionsListState<T> state,
    Widget child,
  ) =>
      child;

  /// Call to select a suggestion.
  ///
  /// Handles closing the suggestions box if [keepSuggestionsOnSelect] is false.
  @protected
  void onSelected(T suggestion) {
    if (!(keepSuggestionsOnSelect ?? false)) {
      suggestionsBoxController.close(retainFocus: true);
    }
    onSuggestionSelected?.call(suggestion);
  }

  @protected
  Widget createDefaultLayout(
    Iterable<Widget> items,
    ScrollController controller,
  ) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      primary: false,
      shrinkWrap: true,
      keyboardDismissBehavior: hideKeyboardOnDrag
          ? ScrollViewKeyboardDismissBehavior.onDrag
          : ScrollViewKeyboardDismissBehavior.manual,
      controller: controller,
      // TODO: re-enable this
      /*
      reverse: suggestionsBoxController.direction == AxisDirection.down
          ? false
          : suggestionsBoxController.autoFlipListDirection,
      */
      itemCount: items.length,
      itemBuilder: (context, index) => items.elementAt(index),
      separatorBuilder: (context, index) =>
          itemSeparatorBuilder?.call(context, index) ?? const SizedBox.shrink(),
    );
  }

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
    widget.controller.removeListener(_onTextChange);
    super.dispose();
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
          animationStart = 1;
        }
        _animationController.forward(from: animationStart);

        _error = error;
        _isLoading = false;
        _suggestions = suggestions;
        /*
        _focusNodes = List.generate(
          _suggestions?.length ?? 0,
          (index) =>
              FocusNode(onKey: widget.suggestionsBoxController.onKeyEvent),
        );
        */
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

    SuggestionsListState<T> state = SuggestionsListState<T>(
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

    return SuggestionsListFocus(
      controller: widget.suggestionsBoxController,
      child: PointerInterceptor(
        intercepting: widget.intercepting,
        child: widget.createWidgetWrapper(
          context,
          state,
          child,
        ),
      ),
    );
  }
}

class SuggestionsListState<T> {
  SuggestionsListState({
    required this.scrollController,
    this.suggestions,
    this.error,
  });

  final ScrollController scrollController;
  final Iterable<T>? suggestions;
  final Object? error;
}
