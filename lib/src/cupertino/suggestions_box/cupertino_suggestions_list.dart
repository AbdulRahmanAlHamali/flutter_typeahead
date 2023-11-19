import 'package:flutter/cupertino.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_controller.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/typedef.dart';
import 'package:flutter_typeahead/src/cupertino/suggestions_box/cupertino_suggestions_decoration.dart';

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
  static ItemBuilder<T> itemBuilder<T>(
    ItemBuilder<T> builder,
  ) {
    return (context, item) {
      return TextFieldTapRegion(
        child: FocusableActionDetector(
          mouseCursor: SystemMouseCursors.click,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: builder(context, item),
            onTap: () => SuggestionsController.of<T>(context).select(item),
          ),
        ),
      );
    };
  }

  /// A Wrapper around the suggestions box of a CupertinoTypeAheadField.
  /// Adds various Cupertino specific decorations.
  static ItemBuilder<Widget> wrapperBuilder(
    CupertinoSuggestionsDecoration decoration,
  ) {
    return (context, child) {
      Color? color = decoration.color;
      color ??= CupertinoTheme.of(context).barBackgroundColor.withOpacity(1);

      BoxBorder? border = decoration.border;
      border ??= Border.all(
        color: CupertinoColors.separator.resolveFrom(context),
        width: 1,
      );

      return DefaultTextStyle(
        style: CupertinoTheme.of(context).textTheme.textStyle,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: color,
            border: border,
            borderRadius: decoration.borderRadius,
          ),
          child: child,
        ),
      );
    };
  }
}
