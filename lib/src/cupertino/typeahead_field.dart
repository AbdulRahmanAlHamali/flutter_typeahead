import 'package:flutter/cupertino.dart';
import 'package:flutter_typeahead/src/common/field/typeahead_field.dart';
import 'package:flutter_typeahead/src/common/base/types.dart';
import 'package:flutter_typeahead/src/cupertino/cupertino_defaults.dart';

/// {@template flutter_typeahead.CupertinoTypeAheadField}
/// A widget that shows suggestions above a text field while the user is typing.
///
/// This is the Cupertino version of the widget.
/// builder, itemBuilder, loadingBuilder, emptyBuilder, errorBuilder and decorationBuilder will default to Cupertino.
/// {@endtemplate}
class CupertinoTypeAheadField<T> extends RawTypeAheadField<T> {
  CupertinoTypeAheadField({
    super.key,
    super.animationDuration,
    super.autoFlipDirection,
    super.autoFlipMinHeight,
    TextFieldBuilder? builder,
    super.controller,
    super.debounceDuration,
    super.direction,
    SuggestionsErrorBuilder? errorBuilder,
    super.focusNode,
    super.hideKeyboardOnDrag,
    super.hideOnEmpty,
    super.hideOnError,
    super.hideOnLoading,
    super.showOnFocus,
    super.hideOnUnfocus,
    super.hideWithKeyboard,
    super.hideOnSelect,
    required SuggestionsItemBuilder<T> itemBuilder,
    super.itemSeparatorBuilder,
    super.retainOnLoading,
    WidgetBuilder? loadingBuilder,
    WidgetBuilder? emptyBuilder,
    required super.onSelected,
    super.scrollController,
    super.suggestionsController,
    required super.suggestionsCallback,
    super.transitionBuilder,
    DecorationBuilder? decorationBuilder,
    super.listBuilder,
    super.constraints,
    super.constrainWidth,
    super.offset,
  }) : super(
          builder: builder ?? TypeAheadCupertinoDefaults.builder,
          errorBuilder: errorBuilder ?? TypeAheadCupertinoDefaults.errorBuilder,
          loadingBuilder:
              loadingBuilder ?? TypeAheadCupertinoDefaults.loadingBuilder,
          emptyBuilder: emptyBuilder ?? TypeAheadCupertinoDefaults.emptyBuilder,
          itemBuilder: TypeAheadCupertinoDefaults.itemBuilder(itemBuilder),
          decorationBuilder:
              TypeAheadCupertinoDefaults.wrapperBuilder(decorationBuilder),
        );
}
