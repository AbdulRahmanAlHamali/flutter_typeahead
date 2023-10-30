import 'dart:async';
import 'dart:io' show Platform;
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

void main() => runApp(const App());

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final TextEditingController controller = TextEditingController();
  FieldSettings settings = FieldSettings();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settings,
      builder: (context, child) {
        if (!settings.cupertino.value) {
          return MaterialApp(
            theme: ThemeData(
              brightness:
                  settings.darkMode.value ? Brightness.dark : Brightness.light,
            ),
            scrollBehavior:
                const MaterialScrollBehavior().copyWith(dragDevices: {
              PointerDeviceKind.mouse,
              PointerDeviceKind.touch,
            }),
            home: Scaffold(
              appBar: AppBar(
                title: const Text('TypeAhead Demo'),
              ),
              body: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: ExampleField(
                  settings: settings,
                  controller: controller,
                ),
              ),
            ),
          );
        } else {
          return CupertinoApp(
            theme: CupertinoThemeData(
              brightness:
                  settings.darkMode.value ? Brightness.dark : Brightness.light,
            ),
            home: Scaffold(
              appBar: const CupertinoNavigationBar(
                middle: Text('Cupertino TypeAhead Demo'),
              ),
              body: CupertinoPageScaffold(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: CupertinoExampleField(
                      settings: settings,
                      controller: controller,
                    ),
                  ),
                ),
              ),
            ), //MyHomePage(),
          );
        }
      },
    );
  }
}

mixin SharedExampleFieldConfig {
  FieldSettings get settings;

  final String hintText = 'What are you looking for?';
  final BorderRadius borderRadius = BorderRadius.circular(10);
  void onSuggestionSelected(FieldOption setting) => setting.change();
  Future<List<FieldOption>> suggestionsCallback(String pattern) async =>
      Future<List<FieldOption>>.delayed(
        Duration(seconds: settings.loadingDelay.value ? 1 : 0),
        () => settings.search(pattern),
      );
}

class ExampleField extends StatelessWidget with SharedExampleFieldConfig {
  ExampleField({
    super.key,
    required this.settings,
    required this.controller,
  });

  @override
  final FieldSettings settings;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: settings.direction.value == AxisDirection.up
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(32),
          child: TypeAheadFormField<FieldOption>(
            direction: settings.direction.value,
            hideOnUnfocus: settings.hideOnUnfocus.value,
            keepSuggestionsOnSelect: settings.keepSuggestionsOnSelect.value,
            textFieldConfiguration: TextFieldConfiguration(
              controller: controller,
              autofocus: true,
              style: DefaultTextStyle.of(context)
                  .style
                  .copyWith(fontStyle: FontStyle.italic),
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: hintText,
              ),
            ),
            suggestionsBoxDecoration: SuggestionsBoxDecoration(
              borderRadius: borderRadius,
              elevation: 8,
              color: Theme.of(context).cardColor,
            ),
            itemBuilder: (context, setting) {
              if (setting is ToggleFieldOption) {
                return IgnorePointer(
                  child: CheckboxListTile(
                    key: ValueKey(setting.value),
                    title: Text(setting.title),
                    secondary: Icon(
                      setting.value
                          ? setting.icon
                          : setting.iconFalse ?? setting.icon,
                    ),
                    value: setting.value,
                    onChanged: (_) {},
                  ),
                );
              } else if (setting is ChoiceFieldOption) {
                return IgnorePointer(
                  child: ListTile(
                    key: ValueKey(setting.value),
                    title: Text(setting.title),
                    leading: Icon(setting.icon),
                    trailing: Text(setting.value.toString()),
                  ),
                );
              } else {
                return ListTile(
                  key: ValueKey(setting.value),
                  leading: Icon(setting.icon),
                  title: Text(setting.title),
                );
              }
            },
            onSuggestionSelected: onSuggestionSelected,
            suggestionsCallback: suggestionsCallback,
          ),
        ),
      ],
    );
  }
}

class CupertinoExampleField extends StatelessWidget
    with SharedExampleFieldConfig {
  CupertinoExampleField({
    super.key,
    required this.settings,
    required this.controller,
  });

  @override
  final FieldSettings settings;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: settings.direction.value == AxisDirection.up
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(32),
          child: CupertinoTypeAheadFormField<FieldOption>(
            direction: settings.direction.value,
            hideOnUnfocus: settings.hideOnUnfocus.value,
            keepSuggestionsOnSelect: settings.keepSuggestionsOnSelect.value,
            textFieldConfiguration: CupertinoTextFieldConfiguration(
              controller: controller,
              autofocus: true,
              style: DefaultTextStyle.of(context)
                  .style
                  .copyWith(fontStyle: FontStyle.italic),
              padding: const EdgeInsets.all(12),
              placeholder: hintText,
            ),
            suggestionsBoxDecoration: CupertinoSuggestionsBoxDecoration(
              borderRadius: borderRadius,
            ),
            itemBuilder: (context, setting) {
              if (setting is ToggleFieldOption) {
                return CupertinoListTile(
                  key: ValueKey(setting.value),
                  leading: Icon(
                    setting.value
                        ? setting.icon
                        : setting.iconFalse ?? setting.icon,
                  ),
                  title: Text(setting.title),
                  trailing: CupertinoCheckbox(
                    value: setting.value,
                    onChanged: (_) => setting.change(),
                  ),
                );
              } else if (setting is ChoiceFieldOption) {
                return CupertinoListTile(
                  key: ValueKey(setting.value),
                  leading: Icon(setting.icon),
                  title: Text(setting.title),
                  trailing: Text(setting.value.toString()),
                );
              } else {
                return CupertinoListTile(
                  key: ValueKey(setting.value),
                  leading: Icon(setting.icon),
                  title: Text(setting.title),
                );
              }
            },
            onSuggestionSelected: onSuggestionSelected,
            suggestionsCallback: suggestionsCallback,
          ),
        ),
      ],
    );
  }
}

class CupertinoListTile extends StatelessWidget {
  const CupertinoListTile({
    super.key,
    this.leading,
    this.title,
    this.trailing,
  });

  final Widget? title;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          if (leading != null) leading!,
          if (leading != null && title != null) const SizedBox(width: 16),
          if (title != null)
            DefaultTextStyle(
              style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
              child: title!,
            ),
          const Spacer(),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

abstract class FieldOption<T> extends ValueNotifier<T> {
  FieldOption({
    required this.key,
    required this.title,
    required T value,
    this.icon,
  }) : super(value);

  /// The name of the property on the TypeAheadField class that this setting
  /// corresponds to, if any.
  final String key;
  final String title;
  final IconData? icon;

  FutureOr<void> change();
}

class ToggleFieldOption extends FieldOption<bool> {
  ToggleFieldOption({
    required super.key,
    required super.title,
    super.icon,
    this.iconFalse,
    required super.value,
  });

  final IconData? iconFalse;

  @override
  FutureOr<void> change() => value = !value;
}

class ChoiceFieldOption<T> extends FieldOption<T> {
  ChoiceFieldOption({
    required super.key,
    required super.title,
    super.icon,
    required super.value,
    required this.choices,
  });

  final List<T> choices;

  @override
  FutureOr<void> change() {
    final index = choices.indexOf(value);
    value = choices[(index + 1) % choices.length];
  }
}

class FieldSettings extends ChangeNotifier {
  FieldSettings() {
    for (final setting in values) {
      setting.addListener(notifyListeners);
    }
  }

  @override
  void dispose() {
    for (final setting in values) {
      setting.removeListener(notifyListeners);
    }
    super.dispose();
  }

  List<FieldOption> get values => [
        cupertino,
        darkMode,
        direction,
        keepSuggestionsOnSelect,
        hideOnUnfocus,
        loadingDelay,
      ];

  List<FieldOption> search(String pattern) {
    return values.where(
      (setting) {
        String title = setting.title.toLowerCase().split(' ').join('');
        String search = pattern.toLowerCase().split(' ').join('');
        return title.contains(search);
      },
    ).toList();
  }

  final ToggleFieldOption cupertino = ToggleFieldOption(
    key: 'cupertino',
    title: 'Cupertino',
    value: !kIsWeb && Platform.isIOS,
    icon: CupertinoIcons.device_phone_portrait,
    iconFalse: Icons.phone_android,
  );

  final ToggleFieldOption darkMode = ToggleFieldOption(
    key: 'darkMode',
    title: 'Dark Mode',
    value: false,
    icon: Icons.dark_mode,
    iconFalse: Icons.light_mode,
  );

  final ChoiceFieldOption<AxisDirection> direction = ChoiceFieldOption(
    key: 'direction',
    title: 'Direction',
    value: AxisDirection.down,
    icon: Icons.swap_vert,
    choices: [
      AxisDirection.up,
      AxisDirection.down,
    ],
  );

  final ToggleFieldOption keepSuggestionsOnSelect = ToggleFieldOption(
    key: 'keepSuggestionsOnSelect',
    title: 'Keep Suggestions On Select',
    value: true,
    icon: Icons.pan_tool,
  );

  final ToggleFieldOption hideOnUnfocus = ToggleFieldOption(
    key: 'hideOnUnfocus',
    title: 'Hide On Unfocus',
    value: false,
    icon: Icons.keyboard,
  );

  final ToggleFieldOption loadingDelay = ToggleFieldOption(
    key: 'loadingDelay',
    title: 'Suggestion Loading Delay',
    value: false,
    icon: Icons.timer,
  );
}
