import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

// Cupertino BoxDecoration taken from flutter/lib/src/cupertino/text_field.dart
const BorderSide _kDefaultRoundedBorderSide = BorderSide(
  color: CupertinoDynamicColor.withBrightness(
    color: Color(0x33000000),
    darkColor: Color(0x33FFFFFF),
  ),
  style: BorderStyle.solid,
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

/// Supply an instance of this class to the [TypeAhead.textFieldConfiguration]
/// property to configure the displayed text field. See [documentation](https://docs.flutter.io/flutter/cupertino/CupertinoTextField-class.html)
/// for more information on properties.
class CupertinoTextFieldConfiguration {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final BoxDecoration decoration;
  final EdgeInsetsGeometry padding;
  final String? placeholder;
  final Widget? prefix;
  final OverlayVisibilityMode prefixMode;
  final Widget? suffix;
  final OverlayVisibilityMode suffixMode;
  final OverlayVisibilityMode clearButtonMode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final TextStyle? style;
  final TextAlign textAlign;
  final bool autofocus;
  final bool obscureText;
  final bool autocorrect;
  final int maxLines;
  final int? minLines;
  final int? maxLength;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final GestureTapCallback? onTap;
  final ValueChanged<String>? onSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final bool enableSuggestions;
  final double cursorWidth;
  final Radius cursorRadius;
  final Color? cursorColor;
  final Brightness? keyboardAppearance;
  final EdgeInsets scrollPadding;
  final bool enableInteractiveSelection;

  /// Creates a CupertinoTextFieldConfiguration
  const CupertinoTextFieldConfiguration({
    this.controller,
    this.focusNode,
    this.decoration = _kDefaultRoundedBorderDecoration,
    this.padding = const EdgeInsets.all(6.0),
    this.placeholder,
    this.prefix,
    this.prefixMode = OverlayVisibilityMode.always,
    this.suffix,
    this.suffixMode = OverlayVisibilityMode.always,
    this.clearButtonMode = OverlayVisibilityMode.never,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.style,
    this.textAlign = TextAlign.start,
    this.autofocus = false,
    this.obscureText = false,
    this.autocorrect = true,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.maxLengthEnforcement,
    this.onChanged,
    this.onEditingComplete,
    this.onTap,
    this.onSubmitted,
    this.inputFormatters,
    this.enabled = true,
    this.enableSuggestions = true,
    this.cursorWidth = 2.0,
    this.cursorRadius = const Radius.circular(2.0),
    this.cursorColor,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.enableInteractiveSelection = true,
  });

  /// Copies the [CupertinoTextFieldConfiguration] and only changes the specified properties
  CupertinoTextFieldConfiguration copyWith({
    TextEditingController? controller,
    FocusNode? focusNode,
    BoxDecoration? decoration,
    EdgeInsetsGeometry? padding,
    String? placeholder,
    Widget? prefix,
    OverlayVisibilityMode? prefixMode,
    Widget? suffix,
    OverlayVisibilityMode? suffixMode,
    OverlayVisibilityMode? clearButtonMode,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    TextCapitalization? textCapitalization,
    TextStyle? style,
    TextAlign? textAlign,
    bool? autofocus,
    bool? obscureText,
    bool? autocorrect,
    int? maxLines,
    int? minLines,
    int? maxLength,
    MaxLengthEnforcement? maxLengthEnforcement,
    ValueChanged<String>? onChanged,
    VoidCallback? onEditingComplete,
    GestureTapCallback? onTap,
    ValueChanged<String>? onSubmitted,
    List<TextInputFormatter>? inputFormatters,
    bool? enabled,
    bool? enableSuggestions,
    double? cursorWidth,
    Radius? cursorRadius,
    Color? cursorColor,
    Brightness? keyboardAppearance,
    EdgeInsets? scrollPadding,
    bool? enableInteractiveSelection,
  }) {
    return CupertinoTextFieldConfiguration(
      controller: controller ?? this.controller,
      focusNode: focusNode ?? this.focusNode,
      decoration: decoration ?? this.decoration,
      padding: padding ?? this.padding,
      placeholder: placeholder ?? this.placeholder,
      prefix: prefix ?? this.prefix,
      prefixMode: prefixMode ?? this.prefixMode,
      suffix: suffix ?? this.suffix,
      suffixMode: suffixMode ?? this.suffixMode,
      clearButtonMode: clearButtonMode ?? this.clearButtonMode,
      keyboardType: keyboardType ?? this.keyboardType,
      textInputAction: textInputAction ?? this.textInputAction,
      textCapitalization: textCapitalization ?? this.textCapitalization,
      style: style ?? this.style,
      textAlign: textAlign ?? this.textAlign,
      autofocus: autofocus ?? this.autofocus,
      obscureText: obscureText ?? this.obscureText,
      autocorrect: autocorrect ?? this.autocorrect,
      maxLines: maxLines ?? this.maxLines,
      minLines: minLines ?? this.minLines,
      maxLength: maxLength ?? this.maxLength,
      maxLengthEnforcement: maxLengthEnforcement ?? this.maxLengthEnforcement,
      onChanged: onChanged ?? this.onChanged,
      onEditingComplete: onEditingComplete ?? this.onEditingComplete,
      onTap: onTap ?? this.onTap,
      onSubmitted: onSubmitted ?? this.onSubmitted,
      inputFormatters: inputFormatters ?? this.inputFormatters,
      enabled: enabled ?? this.enabled,
      enableSuggestions: enableSuggestions ?? this.enableSuggestions,
      cursorWidth: cursorWidth ?? this.cursorWidth,
      cursorRadius: cursorRadius ?? this.cursorRadius,
      cursorColor: cursorColor ?? this.cursorColor,
      keyboardAppearance: keyboardAppearance ?? this.keyboardAppearance,
      scrollPadding: scrollPadding ?? this.scrollPadding,
      enableInteractiveSelection: enableInteractiveSelection ?? this.enableInteractiveSelection,
    );
  }
}
