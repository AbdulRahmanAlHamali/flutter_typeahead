import 'package:flutter/material.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/suggestions_controller.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/typedef.dart';
import 'package:flutter_typeahead/src/material/suggestions_box/suggestions_decoration.dart';

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
  static ItemBuilder<T> itemBuilder<T>(
    ItemBuilder<T> builder,
  ) {
    return (context, item) {
      return TextFieldTapRegion(
        child: InkWell(
          focusColor: Theme.of(context).hoverColor,
          onTap: () => SuggestionsController.of<T>(context).select(item),
          child: builder(context, item),
        ),
      );
    };
  }

  /// A Wrapper around the suggestions box of a TypeAheadField.
  /// Adds various Material specific decorations.
  static ItemBuilder<Widget> wrapperBuilder(
    SuggestionsDecoration decoration,
  ) {
    return (context, child) {
      return TextFieldTapRegion(
        child: Material(
          elevation: decoration.elevation,
          color: decoration.color,
          shape: decoration.shape,
          borderRadius: decoration.borderRadius,
          shadowColor: decoration.shadowColor,
          clipBehavior: decoration.clipBehavior,
          child: child,
        ),
      );
    };
  }
}
