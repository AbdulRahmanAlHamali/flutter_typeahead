import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/src/common/base/connector_widget.dart';
import 'package:flutter_typeahead/src/common/base/suggestions_controller.dart';

import 'package:flutter_typeahead/src/common/base/types.dart';
import 'package:flutter_typeahead/src/common/search/suggestions_search_text_debouncer.dart';
import 'package:flutter_typeahead/src/common/search/suggestions_search_typing_connector.dart';

/// A widget that loads suggestions based on the text entered in a text field.
class SuggestionsSearch<T> extends StatefulWidget {
  const SuggestionsSearch({
    super.key,
    required this.controller,
    required this.textEditingController,
    required this.suggestionsCallback,
    required this.child,
    this.debounceDuration,
  });

  /// {@macro flutter_typeahead.SuggestionsBox.controller}
  final SuggestionsController<T> controller;

  /// {@template flutter_typeahead.SuggestionsSearch.textEditingController}
  /// Controller for the text field used for input.
  ///
  /// The value will be used to get suggestions.
  /// {@endtemplate}
  final TextEditingController textEditingController;

  /// {@template flutter_typeahead.SuggestionsSearch.suggestionsCallback}
  /// Called with the search pattern to get matching suggestions.
  ///
  /// Example:
  /// ```dart
  /// suggestionsCallback: (search) {
  ///   return Service.of(context).getSuggestions(search);
  /// }
  /// ```
  ///
  /// If this returns null, the suggestions box will be invisible.
  ///
  /// See also:
  /// * [debounceDuration], which is the duration to wait for changes in the text field before updating suggestions.
  /// {@endtemplate}
  final SuggestionsCallback<T> suggestionsCallback;

  /// The widget below this widget in the tree.
  final Widget child;

  /// {@template flutter_typeahead.SuggestionsSearch.debounce}
  /// Duration to wait for changes in the text field before updating suggestions.
  ///
  /// This prevents making unnecessary calls to [suggestionsCallback] while the
  /// user is still typing.
  ///
  /// If you want to update suggestions immediately, set this to Duration.zero.
  ///
  /// Defaults to `300 milliseconds`.
  /// {@endtemplate}
  final Duration? debounceDuration;

  @override
  State<SuggestionsSearch<T>> createState() => _SuggestionsSearchState<T>();
}

class _SuggestionsSearchState<T> extends State<SuggestionsSearch<T>> {
  bool isQueued = false;
  late String search = widget.textEditingController.text;
  late bool wasOpen = widget.controller.isOpen;
  late bool hadSuggestions = widget.controller.suggestions != null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => load());
  }

  void onChange() {
    if (!mounted) return;
    onOpenChange();
    onSuggestionsChange();
  }

  void onOpenChange() {
    bool isOpen = widget.controller.isOpen;
    if (wasOpen == isOpen) return;
    wasOpen = isOpen;
    load();
  }

  void onSuggestionsChange() {
    bool hasSuggestions = widget.controller.suggestions != null;
    if (hadSuggestions == hasSuggestions) return;
    hadSuggestions = hasSuggestions;
    load();
  }

  /// Loads suggestions if not already loaded.
  Future<void> load() async {
    if (widget.controller.suggestions != null) return;
    return reload();
  }

  /// Loads suggestions. Discards any previously loaded suggestions.
  Future<void> reload() async {
    if (!mounted) return;
    if (!wasOpen) return;

    if (widget.controller.isLoading) {
      isQueued = true;
      return;
    }

    widget.controller.suggestions = widget.controller.suggestions;
    widget.controller.isLoading = true;
    widget.controller.error = null;

    List<T>? newSuggestions;
    Object? newError;

    try {
      newSuggestions = (await widget.suggestionsCallback(search))?.toList();
    } on Exception catch (e) {
      newError = e;
    }

    if (!mounted) return;

    widget.controller.suggestions = newSuggestions;
    widget.controller.error = newError;
    widget.controller.isLoading = false;

    if (isQueued) {
      isQueued = false;
      await reload();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SuggestionsSearchTypingConnector<T>(
      controller: widget.controller,
      textEditingController: widget.textEditingController,
      child: SuggestionsSearchTextDebouncer(
        controller: widget.textEditingController,
        debounceDuration: widget.debounceDuration,
        onChanged: (value) {
          search = value;
          widget.controller.refresh();
        },
        child: ConnectorWidget(
          value: widget.controller,
          connect: (value) => value.addListener(onChange),
          disconnect: (value, key) => value.removeListener(onChange),
          child: ConnectorWidget(
            value: widget.controller,
            connect: (value) => value.$refreshes.listen((_) {
              hadSuggestions = false; // prevents double load
              reload();
            }),
            disconnect: (value, key) => key?.cancel(),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
