import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_typeahead/src/cupertino/suggestions_box/cupertino_suggestions_box.dart';
import 'package:flutter_typeahead/src/cupertino/suggestions_box/cupertino_suggestions_box_decoration.dart';
import 'package:flutter_typeahead/src/typedef.dart';

/// Renders all the suggestions using a ListView as default.  If
/// `layoutArchitecture` is specified, uses that instead.

class CupertinoSuggestionsList<T> extends StatefulWidget {
  final CupertinoSuggestionsBox? suggestionsBox;
  final TextEditingController? controller;
  final bool getImmediateSuggestions;
  final SuggestionSelectionCallback<T>? onSuggestionSelected;
  final SuggestionsCallback<T>? suggestionsCallback;
  final ItemBuilder<T>? itemBuilder;
  final IndexedWidgetBuilder? itemSeparatorBuilder;
  final LayoutArchitecture? layoutArchitecture;
  final ScrollController? scrollController;
  final CupertinoSuggestionsBoxDecoration? decoration;
  final Duration? debounceDuration;
  final WidgetBuilder? loadingBuilder;
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
  final bool hideKeyboardOnDrag;

  const CupertinoSuggestionsList({
    super.key,
    required this.suggestionsBox,
    this.controller,
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
    this.hideKeyboardOnDrag = false,
  });

  @override
  State<CupertinoSuggestionsList<T>> createState() =>
      _CupertinoSuggestionsListState<T>();
}

class _CupertinoSuggestionsListState<T>
    extends State<CupertinoSuggestionsList<T>>
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

  @override
  void didUpdateWidget(CupertinoSuggestionsList<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
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

    widget.controller!.addListener(this._controllerListener);
  }

  Future<void> invalidateSuggestions() async {
    _suggestionsValid = false;
    _getSuggestions();
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
        });
      }
    }
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isEmpty =
        (this._suggestions?.isEmpty ?? false) && widget.controller!.text == "";
    if ((this._suggestions == null || isEmpty) && this._isLoading == false) {
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

    var animationChild = widget.transitionBuilder != null
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

    return ConstrainedBox(
      constraints: constraints,
      child: animationChild,
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
          : Container(
              decoration: BoxDecoration(
                color: CupertinoColors.white,
                border: Border.all(
                  color: CupertinoColors.extraLightBackgroundGray,
                  width: 1.0,
                ),
              ),
              child: const Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: CupertinoActivityIndicator(),
                ),
              ),
            );
    }

    return child;
  }

  Widget createErrorWidget() {
    return widget.errorBuilder != null
        ? widget.errorBuilder!(context, this._error)
        : Container(
            decoration: BoxDecoration(
              color: CupertinoColors.white,
              border: Border.all(
                color: CupertinoColors.extraLightBackgroundGray,
                width: 1.0,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                'Error: ${this._error}',
                textAlign: TextAlign.start,
                style: const TextStyle(
                  color: CupertinoColors.destructiveRed,
                  fontSize: 18.0,
                ),
              ),
            ),
          );
  }

  Widget createNoItemsFoundWidget() {
    return widget.noItemsFoundBuilder != null
        ? widget.noItemsFoundBuilder!(context)
        : Container(
            decoration: BoxDecoration(
              color: CupertinoColors.white,
              border: Border.all(
                color: CupertinoColors.extraLightBackgroundGray,
                width: 1.0,
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.all(4.0),
              child: Text(
                'No Items Found!',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: CupertinoColors.inactiveGray,
                  fontSize: 18.0,
                ),
              ),
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
    Widget child = Container(
      decoration: BoxDecoration(
        color: widget.decoration!.color ?? CupertinoColors.white,
        border: widget.decoration!.border ??
            Border.all(
              color: CupertinoColors.extraLightBackgroundGray,
              width: 1.0,
            ),
        borderRadius: widget.decoration!.borderRadius,
      ),
      child: ListView.separated(
        padding: EdgeInsets.zero,
        primary: false,
        shrinkWrap: true,
        controller: _scrollController,
        keyboardDismissBehavior: widget.hideKeyboardOnDrag
            ? ScrollViewKeyboardDismissBehavior.onDrag
            : ScrollViewKeyboardDismissBehavior.manual,
        reverse: widget.suggestionsBox!.direction == AxisDirection.down
            ? false
            : widget.suggestionsBox!.autoFlipListDirection,
        itemCount: this._suggestions!.length,
        itemBuilder: (context, index) => GestureDetector(
          behavior: HitTestBehavior.translucent,
          child: widget.itemBuilder!(
            context,
            this._suggestions!.elementAt(index),
          ),
          onTap: () => widget.onSuggestionSelected!(
            this._suggestions!.elementAt(index),
          ),
        ),
        separatorBuilder: (context, index) =>
            widget.itemSeparatorBuilder?.call(context, index) ??
            const SizedBox.shrink(),
      ),
    );

    if (widget.decoration!.hasScrollbar) {
      child = MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: CupertinoScrollbar(
          controller: _scrollController,
          thumbVisibility: widget.decoration!.scrollbarThumbAlwaysVisible,
          child: child,
        ),
      );
    }

    return child;
  }

  Widget customSuggestionsWidget() {
    Widget child = DecoratedBox(
      decoration: BoxDecoration(
        color: widget.decoration!.color ?? CupertinoColors.white,
        border: widget.decoration!.border ??
            Border.all(
              color: CupertinoColors.extraLightBackgroundGray,
              width: 1.0,
            ),
        borderRadius: widget.decoration!.borderRadius,
      ),
      child: widget.layoutArchitecture!(
        List.generate(this._suggestions!.length, (index) {
          final suggestion = _suggestions!.elementAt(index);

          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: widget.itemBuilder!(context, suggestion),
            onTap: () {
              widget.onSuggestionSelected!(suggestion);
            },
          );
        }),
        _scrollController,
      ),
    );

    if (widget.decoration!.hasScrollbar) {
      child = MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: CupertinoScrollbar(
          controller: _scrollController,
          thumbVisibility: widget.decoration!.scrollbarThumbAlwaysVisible,
          child: child,
        ),
      );
    }

    return child;
  }
}
