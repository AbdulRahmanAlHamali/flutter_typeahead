import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/src/common/suggestions_box/text_field_configuration.dart';

/// Supply an instance of this class to the [TypeAheadField.textFieldConfiguration]
/// property to configure the displayed text field
class CupertinoTextFieldConfiguration extends BaseTextFieldConfiguration {
  const CupertinoTextFieldConfiguration({
    super.autocorrect,
    super.autofillHints,
    super.autofocus,
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
    super.scrollPadding,
    super.style,
    super.textAlign,
    super.textCapitalization,
    super.textDirection,
    super.textInputAction,
    this.decoration = _kDefaultRoundedBorderDecoration,
    this.padding = const EdgeInsets.all(6.0),
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
    bool? enabled,
    bool? enableInteractiveSelection,
    bool? enableSuggestions,
    bool? expands,
    bool? obscureText,
    bool? readOnly,
    Brightness? keyboardAppearance,
    Color? cursorColor,
    double? cursorWidth,
    EdgeInsets? scrollPadding,
    FocusNode? focusNode,
    GestureTapCallback? onTap,
    int? maxLength,
    int? maxLines,
    int? minLines,
    List<String>? autofillHints,
    List<TextInputFormatter>? inputFormatters,
    MaxLengthEnforcement? maxLengthEnforcement,
    Radius? cursorRadius,
    TextAlign? textAlign,
    TextCapitalization? textCapitalization,
    TextDirection? textDirection,
    TextEditingController? controller,
    TextInputAction? textInputAction,
    TextInputType? keyboardType,
    TextStyle? style,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    VoidCallback? onEditingComplete,
    BoxDecoration? decoration,
    EdgeInsetsGeometry? padding,
    OverlayVisibilityMode? clearButtonMode,
    OverlayVisibilityMode? prefixMode,
    OverlayVisibilityMode? suffixMode,
    String? placeholder,
    TextStyle? placeholderStyle,
    Widget? prefix,
    Widget? suffix,
  }) =>
      CupertinoTextFieldConfiguration(
        autocorrect: autocorrect ?? this.autocorrect,
        autofocus: autofocus ?? this.autofocus,
        enabled: enabled ?? this.enabled,
        enableInteractiveSelection:
            enableInteractiveSelection ?? this.enableInteractiveSelection,
        enableSuggestions: enableSuggestions ?? this.enableSuggestions,
        expands: expands ?? this.expands,
        obscureText: obscureText ?? this.obscureText,
        readOnly: readOnly ?? this.readOnly,
        keyboardAppearance: keyboardAppearance ?? this.keyboardAppearance,
        cursorColor: cursorColor ?? this.cursorColor,
        cursorWidth: cursorWidth ?? this.cursorWidth,
        scrollPadding: scrollPadding ?? this.scrollPadding,
        focusNode: focusNode ?? this.focusNode,
        onTap: onTap ?? this.onTap,
        maxLength: maxLength ?? this.maxLength,
        maxLines: maxLines ?? this.maxLines,
        minLines: minLines ?? this.minLines,
        autofillHints: autofillHints ?? this.autofillHints,
        inputFormatters: inputFormatters ?? this.inputFormatters,
        maxLengthEnforcement: maxLengthEnforcement ?? this.maxLengthEnforcement,
        cursorRadius: cursorRadius ?? this.cursorRadius,
        textAlign: textAlign ?? this.textAlign,
        textCapitalization: textCapitalization ?? this.textCapitalization,
        textDirection: textDirection ?? this.textDirection,
        controller: controller ?? this.controller,
        textInputAction: textInputAction ?? this.textInputAction,
        keyboardType: keyboardType ?? this.keyboardType,
        style: style ?? this.style,
        onChanged: onChanged ?? this.onChanged,
        onSubmitted: onSubmitted ?? this.onSubmitted,
        onEditingComplete: onEditingComplete ?? this.onEditingComplete,
        decoration: decoration ?? this.decoration,
        padding: padding ?? this.padding,
        clearButtonMode: clearButtonMode ?? this.clearButtonMode,
        prefixMode: prefixMode ?? this.prefixMode,
        suffixMode: suffixMode ?? this.suffixMode,
        placeholder: placeholder ?? this.placeholder,
        placeholderStyle: placeholderStyle ?? this.placeholderStyle,
        prefix: prefix ?? this.prefix,
        suffix: suffix ?? this.suffix,
      );
}

// Cupertino BoxDecoration taken from flutter/lib/src/cupertino/text_field.dart
const BorderSide _kDefaultRoundedBorderSide = BorderSide(
  color: CupertinoDynamicColor.withBrightness(
    color: Color(0x33000000),
    darkColor: Color(0x33FFFFFF),
  ),
  width: 0.0,
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
  borderRadius: BorderRadius.all(Radius.circular(5.0)),
);
