import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_typeahead/src/common/base/suggestions_controller.dart';
import 'package:flutter_typeahead/src/common/base/types.dart';

/// A set of Cupertino specific default builders used by a CupertinoTypeAheadField.
abstract final class TypeAheadCupertinoDefaults {
  /// The default loading builder used by a CupertinoTypeAheadField.
  /// Displays a centered [CupertinoActivityIndicator].
  static Widget loadingBuilder(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [CupertinoActivityIndicator()],
      ),
    );
  }

  /// The default error builder used by a CupertinoTypeAheadField.
  /// Displays the error message in [CupertinoColors.destructiveRed].
  static Widget errorBuilder(BuildContext context, Object? error) {
    String message = 'An error has occured';
    message = 'Error: $error';
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        message,
        style: const TextStyle(color: CupertinoColors.destructiveRed),
      ),
    );
  }

  /// The default empty builder used by a CupertinoTypeAheadField.
  /// Displays 'No Items Found!'.
  static Widget emptyBuilder(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8),
      child: Text(
        'No Items Found!',
        textAlign: TextAlign.start,
        style: TextStyle(
          color: CupertinoColors.inactiveGray,
          fontSize: 18,
        ),
      ),
    );
  }

  /// A Wrapper around the item builder of a CupertinoTypeAheadField.
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
            }, debugLabel: 'TypeAheadField.CupertinoDefaults.itemBuilder');
          }
          return Container(
            decoration: BoxDecoration(
              color: highlighted
                  ? CupertinoColors.systemGrey4.withOpacity(0.5)
                  : null,
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            child: FocusableActionDetector(
              mouseCursor: SystemMouseCursors.click,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                child: builder(context, item),
                onTap: () => SuggestionsController.of<T>(context).select(item),
              ),
            ),
          );
        },
      );
    };
  }

  /// A Wrapper around the suggestions box of a CupertinoTypeAheadField.
  /// Adds various Cupertino specific decorations.
  static SuggestionsItemBuilder<Widget> wrapperBuilder(
    DecorationBuilder? builder,
  ) {
    return (context, child) {
      return DefaultTextStyle(
        style: CupertinoTheme.of(context).textTheme.textStyle,
        child: (builder ?? decorationBuilder)(context, child),
      );
    };
  }

  /// The default decoration builder used by a CupertinoTypeAheadField.
  static Widget decorationBuilder(
    BuildContext context,
    Widget child,
  ) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: CupertinoTheme.of(context).barBackgroundColor.withAlpha(255),
        border: Border.all(
          color: CupertinoDynamicColor.resolve(
            CupertinoColors.systemGrey4,
            context,
          ),
          width: 1,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(6)),
      ),
      child: child,
    );
  }

  /// The default text field builder used by a CupertinoTypeAheadField.
  static Widget builder(
    BuildContext context,
    TextEditingController controller,
    FocusNode node,
  ) {
    return CupertinoTextField(
      controller: controller,
      focusNode: node,
    );
  }
}
