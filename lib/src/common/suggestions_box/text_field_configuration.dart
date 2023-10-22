import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Common TextField configuration for both [TextFieldConfiguration] and [CupertinoTextFieldConfiguration].
abstract class BaseTextFieldConfiguration {
  const BaseTextFieldConfiguration({
    this.autocorrect = true,
    this.autofillHints,
    this.autofocus = false,
    this.controller,
    this.cursorColor,
    this.cursorRadius,
    this.cursorWidth = 2.0,
    this.enabled = true,
    this.readOnly = false,
    this.enableInteractiveSelection = true,
    this.enableSuggestions = true,
    this.expands = false,
    this.focusNode,
    this.inputFormatters,
    this.keyboardAppearance,
    this.keyboardType = TextInputType.text,
    this.maxLength,
    this.maxLengthEnforcement,
    this.maxLines = 1,
    this.minLines,
    this.obscureText = false,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.onTap,
    this.scrollPadding = const EdgeInsets.all(20),
    this.style,
    this.textAlign = TextAlign.start,
    this.textCapitalization = TextCapitalization.none,
    this.textDirection,
    this.textInputAction,
  });

  /// The appearance of the keyboard.
  ///
  /// Same as [TextField.keyboardAppearance](https://api.flutter.dev/flutter/material/TextField/keyboardAppearance.html)
  final Brightness? keyboardAppearance;

  /// The color to use when painting the cursor.
  ///
  /// Same as [TextField.cursorColor](https://api.flutter.dev/flutter/material/TextField/cursorColor.html)
  final Color? cursorColor;

  /// Configures padding to edges surrounding a Scrollable when the Textfield scrolls into view.
  ///
  /// Same as [TextField.scrollPadding](https://api.flutter.dev/flutter/material/TextField/scrollPadding.html)
  final EdgeInsets scrollPadding;

  /// Controls whether this widget has keyboard focus.
  ///
  /// Same as [TextField.focusNode](https://api.flutter.dev/flutter/material/TextField/focusNode.html)
  final FocusNode? focusNode;

  /// Called for each distinct tap except for every second tap of a double tap.
  ///
  /// Same as [TextField.onTap](https://api.flutter.dev/flutter/material/TextField/onTap.html)
  final GestureTapCallback? onTap;

  /// A list of strings that helps the autofill service identify the type of this text input.
  ///
  /// Same as [TextField.autofillHints](https://api.flutter.dev/flutter/material/TextField/autofillHints.html)
  final List<String>? autofillHints;

  /// Optional input validation and formatting overrides.
  ///
  /// Same as [TextField.inputFormatters](https://api.flutter.dev/flutter/material/TextField/inputFormatters.html)
  final List<TextInputFormatter>? inputFormatters;

  /// If true, prevents the field from allowing more than [maxLength]
  /// characters.
  ///
  /// Same as [TextField.maxLengthEnforcement](https://api.flutter.dev/flutter/material/TextField/maxLengthEnforcement.html)
  final MaxLengthEnforcement? maxLengthEnforcement;

  /// How rounded the corners of the cursor should be. By default, the cursor has a null Radius
  ///
  /// Same as [TextField.cursorRadius](https://api.flutter.dev/flutter/material/TextField/cursorRadius.html)
  final Radius? cursorRadius;

  /// How the text being edited should be aligned horizontally.
  ///
  /// Same as [TextField.textAlign](https://api.flutter.dev/flutter/material/TextField/textAlign.html)
  final TextAlign textAlign;

  /// Configures how the platform keyboard will select an uppercase or lowercase keyboard.
  ///
  /// Same as [TextField.TextCapitalization](https://api.flutter.dev/flutter/material/TextField/textCapitalization.html)
  final TextCapitalization textCapitalization;

  /// Same as [TextField.textDirection](https://api.flutter.dev/flutter/material/TextField/textDirection.html)
  ///
  /// Defaults to null
  final TextDirection? textDirection;

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController](https://api.flutter.dev/flutter/widgets/TextEditingController-class.html).
  /// A typical use case for this field in the TypeAhead widget is to set the
  /// text of the widget when a suggestion is selected. For example:
  ///
  /// ```dart
  /// _controller = TextEditingControllerget ();
  /// ...
  /// ...
  /// TypeAheadField(
  ///   controller: _controller,
  ///   ...
  ///   ...
  ///   onSuggestionSelected: (suggestion) {
  ///     _controller.text = suggestion['city_name'];
  ///   }
  /// )
  /// ```
  final TextEditingController? controller;

  /// The type of action button to use for the keyboard.
  ///
  /// Same as [TextField.textInputAction](https://api.flutter.dev/flutter/material/TextField/textInputAction.html)
  final TextInputAction? textInputAction;

  /// The type of keyboard to use for editing the text.
  ///
  /// Same as [TextField.keyboardType](https://api.flutter.dev/flutter/material/TextField/keyboardType.html)
  final TextInputType keyboardType;

  /// The style to use for the text being edited.
  ///
  /// Same as [TextField.style](https://api.flutter.dev/flutter/material/TextField/style.html)
  final TextStyle? style;

  /// Called when the user indicates that they are done editing the text in the
  /// field.
  ///
  /// Same as [TextField.onSubmitted](https://api.flutter.dev/flutter/material/TextField/onSubmitted.html)
  final ValueChanged<String>? onChanged;

  /// Called when the user indicates that they are done editing the text in the
  /// field.
  ///
  /// Same as [TextField.onSubmitted](https://api.flutter.dev/flutter/material/TextField/onSubmitted.html)
  final ValueChanged<String>? onSubmitted;

  /// Called when the user submits editable content (e.g., user presses the "done" button on the keyboard).
  ///
  /// Same as [TextField.onEditingComplete](https://api.flutter.dev/flutter/material/TextField/onEditingComplete.html)
  final VoidCallback? onEditingComplete;

  /// Whether to hide the text being edited (e.g., for passwords).
  ///
  /// Same as [TextField.obscureText](https://api.flutter.dev/flutter/material/TextField/obscureText.html)
  final bool autocorrect;

  /// Whether to hide the text being edited (e.g., for passwords).
  ///
  /// Same as [TextField.obscureText](https://api.flutter.dev/flutter/material/TextField/obscureText.html)
  final bool autofocus;

  /// Whether to hide the text being edited (e.g., for passwords).
  ///
  /// Same as [TextField.obscureText](https://api.flutter.dev/flutter/material/TextField/obscureText.html)
  final bool enableInteractiveSelection;

  /// Whether to hide the text being edited (e.g., for passwords).
  ///
  /// Same as [TextField.obscureText](https://api.flutter.dev/flutter/material/TextField/obscureText.html)
  final bool enableSuggestions;

  /// Whether to hide the text being edited (e.g., for passwords).
  ///
  /// Same as [TextField.obscureText](https://api.flutter.dev/flutter/material/TextField/obscureText.html)
  final bool enabled;

  /// Whether this textfield is in read only mode.
  ///
  /// Same as [TextField.readOnly](https://api.flutter.dev/flutter/material/TextField/readOnly.html)
  final bool readOnly;

  /// Whether to hide the text being edited (e.g., for passwords).
  ///
  /// Same as [TextField.obscureText](https://api.flutter.dev/flutter/material/TextField/obscureText.html)
  final bool expands;

  /// Whether to hide the text being edited (e.g., for passwords).
  ///
  /// Same as [TextField.obscureText](https://api.flutter.dev/flutter/material/TextField/obscureText.html)
  final bool obscureText;

  /// How thick the cursor will be.
  ///
  /// Same as [TextField.cursorWidth](https://api.flutter.dev/flutter/material/TextField/cursorWidth.html)
  final double cursorWidth;

  /// The maximum number of characters (Unicode scalar values) to allow in the
  /// text field.
  ///
  /// Same as [TextField.maxLength](https://api.flutter.dev/flutter/material/TextField/maxLength.html)
  final int? maxLength;

  /// The maximum number of characters (Unicode scalar values) to allow in the
  /// text field.
  ///
  /// Same as [TextField.maxLength](https://api.flutter.dev/flutter/material/TextField/maxLength.html)
  final int? maxLines;

  /// The maximum number of characters (Unicode scalar values) to allow in the
  /// text field.
  ///
  /// Same as [TextField.maxLength](https://api.flutter.dev/flutter/material/TextField/maxLength.html)
  final int? minLines;

  BaseTextFieldConfiguration copyWith({
    Brightness? keyboardAppearance,
    Color? cursorColor,
    EdgeInsets? scrollPadding,
    FocusNode? focusNode,
    GestureTapCallback? onTap,
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
    bool? autocorrect,
    bool? autofocus,
    bool? enableInteractiveSelection,
    bool? enableSuggestions,
    bool? enabled,
    bool? readOnly,
    bool? expands,
    bool? obscureText,
    double? cursorWidth,
    int? maxLength,
    int? maxLines,
    int? minLines,
  });
}
