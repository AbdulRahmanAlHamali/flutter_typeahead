import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/src/keyboard_suggestion_selection_notifier.dart';
import 'package:flutter_typeahead/src/should_refresh_suggestion_focus_index_notifier.dart';
import 'package:flutter_typeahead/src/material/suggestions_box/suggestions_box.dart';
import 'package:flutter_typeahead/src/material/suggestions_box/suggestions_box_decoration.dart';
import 'package:flutter_typeahead/src/typedef.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

/// Renders all the suggestions using a ListView as default.  If
/// `layoutArchitecture` is specified, uses that instead.
class SuggestionsList<T> extends StatefulWidget {
  final SuggestionsBox? suggestionsBox;
  final TextEditingController? controller;
  final bool getImmediateSuggestions;
  final SuggestionSelectionCallback<T>? onSuggestionSelected;
  final SuggestionsCallback<T>? suggestionsCallback;
  final ItemBuilder<T>? itemBuilder;
  final IndexedWidgetBuilder? itemSeparatorBuilder;
  final LayoutArchitecture? layoutArchitecture;
  final ScrollController? scrollController;
  final SuggestionsBoxDecoration? decoration;
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
  final KeyEventResult Function(FocusNode _, RawKeyEvent event) onKeyEvent;
  final bool hideKeyboardOnDrag;

  const SuggestionsList({
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
    this.decoration,
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

  @override
  State<SuggestionsList<T>> createState() => _SuggestionsListState<T>();
}

class _SuggestionsListState<T> extends State<SuggestionsList<T>>
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

  _SuggestionsListState() {
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
  void didUpdateWidget(SuggestionsList<T> oldWidget) {
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
            (index) => FocusNode(onKey: (_, event) {
              return widget.onKeyEvent(_, event);
            }),
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

    Widget child;
    if (this._isLoading!) {
      if (widget.hideOnLoading!) {
        child = const SizedBox(height: 0);
      } else {
        child = createLoadingWidget();
      }
    } else if (this._error != null) {
      if (widget.hideOnError!) {
        child = const SizedBox(height: 0);
      } else {
        child = createErrorWidget();
      }
    } else if (this._suggestions!.isEmpty) {
      if (widget.hideOnEmpty!) {
        child = const SizedBox(height: 0);
      } else {
        child = createNoItemsFoundWidget();
      }
    } else {
      child = createSuggestionsWidget();
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
      child: Material(
        elevation: widget.decoration!.elevation,
        color: widget.decoration!.color,
        shape: widget.decoration!.shape,
        borderRadius: widget.decoration!.borderRadius,
        shadowColor: widget.decoration!.shadowColor,
        clipBehavior: widget.decoration!.clipBehavior,
        child: ConstrainedBox(
          constraints: constraints,
          child: animationChild,
        ),
      ),
    );
  }

  Widget createLoadingWidget() {
    Widget child;

    if (widget.keepSuggestionsOnLoading! && this._suggestions != null) {
      if (this._suggestions!.isEmpty) {
        child = createNoItemsFoundWidget();
      } else {
        child = createSuggestionsWidget();
      }
    } else {
      child = widget.loadingBuilder != null
          ? widget.loadingBuilder!(context)
          : const Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: CircularProgressIndicator(),
              ),
            );
    }

    return child;
  }

  Widget createErrorWidget() {
    return widget.errorBuilder != null
        ? widget.errorBuilder!(context, this._error)
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Error: ${this._error}',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          );
  }

  Widget createNoItemsFoundWidget() {
    return widget.noItemsFoundBuilder != null
        ? widget.noItemsFoundBuilder!(context)
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'No Items Found!',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context).disabledColor, fontSize: 18.0),
            ),
          );
  }

  Widget createSuggestionsWidget() {
    if (widget.layoutArchitecture == null) {
      return defaultSuggestionsWidget();
    } else {
      return customSuggestionsWidget();
    }
  }

  Widget defaultSuggestionsWidget() {
    Widget child = ListView.separated(
      padding: EdgeInsets.zero,
      primary: false,
      shrinkWrap: true,
      keyboardDismissBehavior: widget.hideKeyboardOnDrag
          ? ScrollViewKeyboardDismissBehavior.onDrag
          : ScrollViewKeyboardDismissBehavior.manual,
      controller: _scrollController,
      reverse: widget.suggestionsBox!.direction == AxisDirection.down
          ? false
          : widget.suggestionsBox!.autoFlipListDirection,
      itemCount: this._suggestions!.length,
      itemBuilder: (BuildContext context, int index) {
        final suggestion = this._suggestions!.elementAt(index);
        final focusNode = _focusNodes[index];
        return TextFieldTapRegion(
          child: InkWell(
            focusColor: Theme.of(context).hoverColor,
            focusNode: focusNode,
            child: widget.itemBuilder!(context, suggestion),
            onTap: () {
              // * we give the focus back to the text field
              widget.giveTextFieldFocus();

              widget.onSuggestionSelected!(suggestion);
            },
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) =>
          widget.itemSeparatorBuilder?.call(context, index) ??
          const SizedBox.shrink(),
    );

    if (widget.decoration!.hasScrollbar) {
      child = MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Scrollbar(
          controller: _scrollController,
          thumbVisibility: widget.decoration!.scrollbarThumbAlwaysVisible,
          trackVisibility: widget.decoration!.scrollbarTrackAlwaysVisible,
          child: child,
        ),
      );
    }

    child = TextFieldTapRegion(child: child);

    return child;
  }

  Widget customSuggestionsWidget() {
    Widget child = widget.layoutArchitecture!(
      List.generate(this._suggestions!.length, (index) {
        final suggestion = _suggestions!.elementAt(index);
        final focusNode = _focusNodes[index];

        return TextFieldTapRegion(
          child: InkWell(
            focusColor: Theme.of(context).hoverColor,
            focusNode: focusNode,
            child: widget.itemBuilder!(context, suggestion),
            onTap: () {
              // * we give the focus back to the text field
              widget.giveTextFieldFocus();

              widget.onSuggestionSelected!(suggestion);
            },
          ),
        );
      }),
      _scrollController,
    );

    if (widget.decoration!.hasScrollbar) {
      child = MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Scrollbar(
          controller: _scrollController,
          thumbVisibility: widget.decoration!.scrollbarThumbAlwaysVisible,
          trackVisibility: widget.decoration!.scrollbarTrackAlwaysVisible,
          child: child,
        ),
      );
    }

    child = TextFieldTapRegion(child: child);

    return child;
  }
}
