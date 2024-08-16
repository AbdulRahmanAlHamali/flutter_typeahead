import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_typeahead/src/common/base/suggestions_controller.dart';
import 'package:flutter_typeahead/src/common/base/types.dart';

/// A set of Material specific default builders used by a TypeAheadField.
abstract final class TypeAheadMaterialDefaults {
  /// The default loading builder used by a TypeAheadField.
  /// Displays a centered [CircularProgressIndicator].
  static Widget loadingBuilder(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [CircularProgressIndicator()],
      ),
    );
  }

  /// The default error builder used by a TypeAheadField.
  /// Displays the error message in [ThemeData.colorScheme.error].
  static Widget errorBuilder(BuildContext context, Object? error) {
    String message = 'An error has occured';
    message = 'Error: $error';
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        message,
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      ),
    );
  }

  /// The default empty builder used by a TypeAheadField.
  /// Displays 'No items found!'.
  static Widget emptyBuilder(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        'No items found!',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  /// A Wrapper around the item builder of a TypeAheadField.
  /// Provides the functionality to select an item on tap.
  static SuggestionsItemBuilder<T> itemBuilder<T>(
    SuggestionsItemBuilder<T> builder,
  ) {
    return (context, item) {
      final controller = SuggestionsController.of<T>(context);
      return ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          final bool highlighted = controller.highlightedSuggestion == item;
          if (highlighted) {
            // scroll to the highlighted item
            SchedulerBinding.instance.addPostFrameCallback((_) {
              Scrollable.ensureVisible(context, alignment: 0.5);
            }, debugLabel: 'TypeAheadField.MaterialDefaults.itemBuilder');
          }
          return Container(
            color: highlighted ? Theme.of(context).hoverColor : null,
            child: InkWell(
              onTap: () => SuggestionsController.of<T>(context).select(item),
              child: builder(context, item),
            ),
          );
        },
      );
    };
  }

  /// A Wrapper around the suggestions box of a TypeAheadField.
  /// Adds various Material specific decorations.
  static SuggestionsItemBuilder<Widget> wrapperBuilder(
    DecorationBuilder? builder,
  ) {
    return (context, child) {
      return Material(
        type: MaterialType.transparency,
        child: (builder ?? decorationBuilder)(context, child),
      );
    };
  }

  /// The default decoration builder used by a TypeAheadField.
  static Widget decorationBuilder(
    BuildContext context,
    Widget child,
  ) {
    return Material(
      type: MaterialType.card,
      elevation: 4,
      borderRadius: BorderRadius.circular(8),
      child: child,
    );
  }

  /// The default text field builder used by a TypeAheadField.
  static Widget builder(
    BuildContext context,
    TextEditingController controller,
    FocusNode node,
  ) {
    return TextField(
      controller: controller,
      focusNode: node,
    );
  }
}
