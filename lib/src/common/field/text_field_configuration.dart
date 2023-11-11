import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Common TextField configuration for both [TextFieldConfiguration] and [CupertinoTextFieldConfiguration].
abstract class BaseTextFieldConfiguration {
  const BaseTextFieldConfiguration({
    this.autofillHints,
    this.autocorrect = true,
    this.autofocus = false,
    this.contentInsertionConfiguration,
    this.contextMenuBuilder,
    this.controller,
    this.cursorColor,
    this.cursorRadius,
    this.cursorWidth = 2,
    this.enableInteractiveSelection = true,
    this.enableSuggestions = true,
    this.enabled = true,
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
    this.readOnly = false,
    this.scrollPadding = const EdgeInsets.all(20),
    this.style,
    this.textAlign = TextAlign.start,
    this.textCapitalization = TextCapitalization.none,
    this.textDirection,
    this.textInputAction,
  });

  /// Whether to hide the text being edited (e.g., for passwords).
  ///
  /// Same as [TextField.autocorrect](https://api.flutter.dev/flutter/material/TextField/autocorrect.html)
  final bool autocorrect;

  /// A list of strings that helps the autofill service identify the type of this text input.
  ///
  /// Same as [TextField.autofillHints](https://api.flutter.dev/flutter/material/TextField/autofillHints.html)
  final List<String>? autofillHints;

  /// Whether to hide the text being edited (e.g., for passwords).
  ///
  /// Same as [TextField.autofocus](https://api.flutter.dev/flutter/material/TextField/autofocus.html)
  final bool autofocus;

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController](https://api.flutter.dev/flutter/widgets/TextEditingController-class.html).
  /// A typical use case for this field in the TypeAhead widget is to set the
  /// text of the widget when a suggestion is selected. For example:
  ///
  /// ```dart
  /// final TextEditingController controller = TextEditingController();
  /// ...
  /// ...
  /// TypeAheadField(
  ///   controller: controller,
  ///   ...
  ///   ...
  ///   onSuggestionSelected: (suggestion) {
  ///     controller.text = suggestion['name'];
  ///   },
  /// );
  /// ```
  ///
  /// Same as [TextField.controller](https://api.flutter.dev/flutter/material/TextField/controller.html)
  final TextEditingController? controller;

  /// Creates a content insertion configuration with the specified options.
  ///
  /// Same as [TextField.contentInsertionConfiguration](https://api.flutter.dev/flutter/material/TextField/contentInsertionConfiguration.html)
  final ContentInsertionConfiguration? contentInsertionConfiguration;

  /// Signature for a widget builder that builds a context menu for the given
  ///
  /// Same as [TextField.contextMenuBuilder](https://api.flutter.dev/flutter/material/TextField/contextMenuBuilder.html)
  final EditableTextContextMenuBuilder? contextMenuBuilder;

  /// The color to use when painting the cursor.
  ///
  /// Same as [TextField.cursorColor](https://api.flutter.dev/flutter/material/TextField/cursorColor.html)
  final Color? cursorColor;

  /// How rounded the corners of the cursor should be. By default, the cursor has a null Radius
  ///
  /// Same as [TextField.cursorRadius](https://api.flutter.dev/flutter/material/TextField/cursorRadius.html)
  final Radius? cursorRadius;

  /// How thick the cursor will be.
  ///
  /// Same as [TextField.cursorWidth](https://api.flutter.dev/flutter/material/TextField/cursorWidth.html)
  final double cursorWidth;

  /// Whether to hide the text being edited (e.g., for passwords).
  ///
  /// Same as [TextField.enableInteractiveSelection](https://api.flutter.dev/flutter/material/TextField/enableInteractiveSelection.html)
  final bool enableInteractiveSelection;

  /// Whether to hide the text being edited (e.g., for passwords).
  ///
  /// Same as [TextField.enableSuggestions](https://api.flutter.dev/flutter/material/TextField/enableSuggestions.html)
  final bool enableSuggestions;

  /// Whether to hide the text being edited (e.g., for passwords).
  ///
  /// Same as [TextField.obscureText](https://api.flutter.dev/flutter/material/TextField/obscureText.html)
  final bool expands;

  /// Whether to hide the text being edited (e.g., for passwords).
  ///
  /// Same as [TextField.enabled](https://api.flutter.dev/flutter/material/TextField/enabled.html)
  final bool enabled;

  /// Whether this textfield is in read only mode.
  ///
  /// Same as [TextField.readOnly](https://api.flutter.dev/flutter/material/TextField/readOnly.html)
  final bool readOnly;

  /// Controls whether this widget has keyboard focus.
  ///
  /// Same as [TextField.focusNode](https://api.flutter.dev/flutter/material/TextField/focusNode.html)
  final FocusNode? focusNode;

  /// Optional input validation and formatting overrides.
  ///
  /// Same as [TextField.inputFormatters](https://api.flutter.dev/flutter/material/TextField/inputFormatters.html)
  final List<TextInputFormatter>? inputFormatters;

  /// The appearance of the keyboard.
  ///
  /// Same as [TextField.keyboardAppearance](https://api.flutter.dev/flutter/material/TextField/keyboardAppearance.html)
  final Brightness? keyboardAppearance;

  /// The type of keyboard to use for editing the text.
  ///
  /// Same as [TextField.keyboardType](https://api.flutter.dev/flutter/material/TextField/keyboardType.html)
  final TextInputType keyboardType;

  /// The maximum number of characters (Unicode scalar values) to allow in the
  /// text field.
  ///
  /// Same as [TextField.maxLength](https://api.flutter.dev/flutter/material/TextField/maxLength.html)
  final int? maxLength;

  /// If true, prevents the field from allowing more than [maxLength]
  /// characters.
  ///
  /// Same as [TextField.maxLengthEnforcement](https://api.flutter.dev/flutter/material/TextField/maxLengthEnforcement.html)
  final MaxLengthEnforcement? maxLengthEnforcement;

  /// The maximum number of characters (Unicode scalar values) to allow in the
  /// text field.
  ///
  /// Same as [TextField.maxLines](https://api.flutter.dev/flutter/material/TextField/maxLines.html)
  final int? maxLines;

  /// The maximum number of characters (Unicode scalar values) to allow in the
  /// text field.
  ///
  /// Same as [TextField.minLines](https://api.flutter.dev/flutter/material/TextField/minLines.html)
  final int? minLines;

  /// Called when the user indicates that they are done editing the text in the
  /// field.
  ///
  /// Same as [TextField.onChanged](https://api.flutter.dev/flutter/material/TextField/onChanged.html)
  final ValueChanged<String>? onChanged;

  /// Called when the user submits editable content (e.g., user presses the "done" button on the keyboard).
  ///
  /// Same as [TextField.onEditingComplete](https://api.flutter.dev/flutter/material/TextField/onEditingComplete.html)
  final VoidCallback? onEditingComplete;

  /// Called for each distinct tap except for every second tap of a double tap.
  ///
  /// Same as [TextField.onTap](https://api.flutter.dev/flutter/material/TextField/onTap.html)
  final GestureTapCallback? onTap;

  /// Called when the user indicates that they are done editing the text in the
  /// field.
  ///
  /// Same as [TextField.onSubmitted](https://api.flutter.dev/flutter/material/TextField/onSubmitted.html)
  final ValueChanged<String>? onSubmitted;

  /// Whether to hide the text being edited (e.g., for passwords).
  ///
  /// Same as [TextField.obscureText](https://api.flutter.dev/flutter/material/TextField/obscureText.html)
  final bool obscureText;

  /// Configures padding to edges surrounding a Scrollable when the Textfield scrolls into view.
  ///
  /// Same as [TextField.scrollPadding](https://api.flutter.dev/flutter/material/TextField/scrollPadding.html)
  final EdgeInsets scrollPadding;

  /// The style to use for the text being edited.
  ///
  /// Same as [TextField.style](https://api.flutter.dev/flutter/material/TextField/style.html)
  final TextStyle? style;

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

  /// Configures how the text being edited is identified.
  ///
  /// Same as [TextField.textInputAction](https://api.flutter.dev/flutter/material/TextField/textInputAction.html)
  final TextInputAction? textInputAction;

  BaseTextFieldConfiguration copyWith({
    bool? autocorrect,
    bool? autofocus,
    List<String>? autofillHints,
    ContentInsertionConfiguration? contentInsertionConfiguration,
    EditableTextContextMenuBuilder? contextMenuBuilder,
    TextEditingController? controller,
    Color? cursorColor,
    Radius? cursorRadius,
    double? cursorWidth,
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
    bool? readOnly,
    EdgeInsets? scrollPadding,
    TextStyle? style,
    TextAlign? textAlign,
    TextCapitalization? textCapitalization,
    TextDirection? textDirection,
    TextInputAction? textInputAction,
  });
}
