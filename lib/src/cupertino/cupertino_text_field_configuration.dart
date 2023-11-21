import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/src/common/base/text_field_configuration.dart';

/// Supply an instance of this class to the [TypeAheadField.textFieldConfiguration]
/// property to configure the displayed text field
class CupertinoTextFieldConfiguration extends BaseTextFieldConfiguration {
  const CupertinoTextFieldConfiguration({
    super.autocorrect,
    super.autofillHints,
    super.autofocus,
    super.contentInsertionConfiguration,
    super.contextMenuBuilder,
    super.controller,
    super.cursorColor,
    super.cursorRadius,
    super.cursorWidth,
    super.enabled,
    super.readOnly,
    super.enableInteractiveSelection,
    super.enableSuggestions,
    super.expands,
    super.focusNode,
    super.inputFormatters,
    super.keyboardAppearance,
    super.keyboardType,
    super.maxLength,
    super.maxLengthEnforcement,
    super.maxLines,
    super.minLines,
    super.obscureText,
    super.onChanged,
    super.onEditingComplete,
    super.onSubmitted,
    super.onTap,
    super.onTapOutside,
    super.scrollPadding,
    super.style,
    super.textAlign,
    super.textAlignVertical,
    super.textCapitalization,
    super.textDirection,
    super.textInputAction,
    this.decoration = _kDefaultRoundedBorderDecoration,
    this.padding = const EdgeInsets.all(6),
    this.placeholder,
    this.placeholderStyle,
    this.prefix,
    this.prefixMode = OverlayVisibilityMode.always,
    this.suffix,
    this.suffixMode = OverlayVisibilityMode.always,
    this.clearButtonMode = OverlayVisibilityMode.never,
  });

  /// The decoration to show around the text field.
  ///
  /// Same as [CupertinoTextField.decoration](https://api.flutter.dev/flutter/cupertino/CupertinoTextField/decoration.html)
  final BoxDecoration decoration;

  /// The padding for the text field decoration.
  ///
  /// Same as [CupertinoTextField.padding](https://api.flutter.dev/flutter/cupertino/CupertinoTextField/padding.html)
  final EdgeInsetsGeometry padding;

  /// Show an iOS-style clear button to clear the current text entry.
  ///
  /// Same as [CupertinoTextField.clearButtonMode](https://api.flutter.dev/flutter/cupertino/CupertinoTextField/clearButtonMode.html)
  final OverlayVisibilityMode clearButtonMode;

  /// Controls the visibility of the prefix widget based on the state of text entry when the prefix argument is not null.
  ///
  /// Same as [CupertinoTextField.prefixMode](https://api.flutter.dev/flutter/cupertino/CupertinoTextField/prefixMode.html)
  final OverlayVisibilityMode prefixMode;

  /// Controls the visibility of the suffix widget based on the state of text entry when the suffix argument is not null.
  ///
  /// Same as [CupertinoTextField.suffixMode](https://api.flutter.dev/flutter/cupertino/CupertinoTextField/suffixMode.html)
  final OverlayVisibilityMode suffixMode;

  /// A lighter colored placeholder hint that appears on the first line of the text field when the text entry is empty.
  ///
  /// Same as [CupertinoTextField.cursorRadius](https://api.flutter.dev/flutter/cupertino/CupertinoTextField/placeholder.html)
  final String? placeholder;

  /// The style to use for the text being edited.
  ///
  /// Same as [CupertinoTextField.style](https://api.flutter.dev/flutter/cupertino/CupertinoTextField/style.html)
  final TextStyle? placeholderStyle;

  /// A widget to display before the text.
  ///
  /// Same as [CupertinoTextField.prefix](https://api.flutter.dev/flutter/cupertino/CupertinoTextField/prefix.html)
  final Widget? prefix;

  /// A widget to display after the text.
  ///
  /// Same as [CupertinoTextField.suffix](https://api.flutter.dev/flutter/cupertino/CupertinoTextField/suffix.html)
  final Widget? suffix;

  /// Copies the [CupertinoTextFieldConfiguration] and only changes the specified properties
  @override
  CupertinoTextFieldConfiguration copyWith({
    bool? autocorrect,
    bool? autofocus,
    List<String>? autofillHints,
    OverlayVisibilityMode? clearButtonMode,
    ContentInsertionConfiguration? contentInsertionConfiguration,
    EditableTextContextMenuBuilder? contextMenuBuilder,
    TextEditingController? controller,
    Color? cursorColor,
    Radius? cursorRadius,
    double? cursorWidth,
    BoxDecoration? decoration,
    bool? enableInteractiveSelection,
    bool? enableSuggestions,
    bool? enabled,
    bool? expands,
    FocusNode? focusNode,
    List<TextInputFormatter>? inputFormatters,
    Brightness? keyboardAppearance,
    TextInputType? keyboardType,
    int? maxLength,
    MaxLengthEnforcement? maxLengthEnforcement,
    int? maxLines,
    int? minLines,
    bool? obscureText,
    ValueChanged<String>? onChanged,
    VoidCallback? onEditingComplete,
    ValueChanged<String>? onSubmitted,
    GestureTapCallback? onTap,
    TapRegionCallback? onTapOutside,
    EdgeInsetsGeometry? padding,
    String? placeholder,
    TextStyle? placeholderStyle,
    Widget? prefix,
    OverlayVisibilityMode? prefixMode,
    bool? readOnly,
    EdgeInsets? scrollPadding,
    TextStyle? style,
    Widget? suffix,
    OverlayVisibilityMode? suffixMode,
    TextAlign? textAlign,
    TextAlignVertical? textAlignVertical,
    TextCapitalization? textCapitalization,
    TextDirection? textDirection,
    TextInputAction? textInputAction,
  }) =>
      CupertinoTextFieldConfiguration(
        autofillHints: autofillHints ?? this.autofillHints,
        autofocus: autofocus ?? this.autofocus,
        clearButtonMode: clearButtonMode ?? this.clearButtonMode,
        contentInsertionConfiguration:
            contentInsertionConfiguration ?? this.contentInsertionConfiguration,
        contextMenuBuilder: contextMenuBuilder ?? this.contextMenuBuilder,
        controller: controller ?? this.controller,
        cursorColor: cursorColor ?? this.cursorColor,
        cursorRadius: cursorRadius ?? this.cursorRadius,
        cursorWidth: cursorWidth ?? this.cursorWidth,
        decoration: decoration ?? this.decoration,
        enableInteractiveSelection:
            enableInteractiveSelection ?? this.enableInteractiveSelection,
        enableSuggestions: enableSuggestions ?? this.enableSuggestions,
        enabled: enabled ?? this.enabled,
        expands: expands ?? this.expands,
        focusNode: focusNode ?? this.focusNode,
        inputFormatters: inputFormatters ?? this.inputFormatters,
        keyboardAppearance: keyboardAppearance ?? this.keyboardAppearance,
        keyboardType: keyboardType ?? this.keyboardType,
        maxLength: maxLength ?? this.maxLength,
        maxLengthEnforcement: maxLengthEnforcement ?? this.maxLengthEnforcement,
        maxLines: maxLines ?? this.maxLines,
        minLines: minLines ?? this.minLines,
        obscureText: obscureText ?? this.obscureText,
        onChanged: onChanged ?? this.onChanged,
        onEditingComplete: onEditingComplete ?? this.onEditingComplete,
        onSubmitted: onSubmitted ?? this.onSubmitted,
        onTap: onTap ?? this.onTap,
        onTapOutside: onTapOutside ?? this.onTapOutside,
        padding: padding ?? this.padding,
        placeholder: placeholder ?? this.placeholder,
        placeholderStyle: placeholderStyle ?? this.placeholderStyle,
        prefix: prefix ?? this.prefix,
        prefixMode: prefixMode ?? this.prefixMode,
        readOnly: readOnly ?? this.readOnly,
        scrollPadding: scrollPadding ?? this.scrollPadding,
        style: style ?? this.style,
        suffix: suffix ?? this.suffix,
        suffixMode: suffixMode ?? this.suffixMode,
        textAlign: textAlign ?? this.textAlign,
        textAlignVertical: textAlignVertical ?? this.textAlignVertical,
        textCapitalization: textCapitalization ?? this.textCapitalization,
        textDirection: textDirection ?? this.textDirection,
        textInputAction: textInputAction ?? this.textInputAction,
        autocorrect: autocorrect ?? this.autocorrect,
      );
}

// Cupertino BoxDecoration taken from flutter/lib/src/cupertino/text_field.dart
const BorderSide _kDefaultRoundedBorderSide = BorderSide(
  color: CupertinoDynamicColor.withBrightness(
    color: Color(0x33000000),
    darkColor: Color(0x33FFFFFF),
  ),
  width: 0,
);

const Border _kDefaultRoundedBorder = Border(
  top: _kDefaultRoundedBorderSide,
  bottom: _kDefaultRoundedBorderSide,
  left: _kDefaultRoundedBorderSide,
  right: _kDefaultRoundedBorderSide,
);

const BoxDecoration _kDefaultRoundedBorderDecoration = BoxDecoration(
  color: CupertinoDynamicColor.withBrightness(
    color: CupertinoColors.white,
    darkColor: CupertinoColors.black,
  ),
  border: _kDefaultRoundedBorder,
  borderRadius: BorderRadius.all(Radius.circular(5)),
);
