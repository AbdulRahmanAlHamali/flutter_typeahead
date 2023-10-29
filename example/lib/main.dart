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
  void initState() {
    super.initState();
    settings.connect(() => setState(() {}));
  }

  @override
  void dispose() {
    settings.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!settings.cupertino.value) {
      return MaterialApp(
        scrollBehavior: const MaterialScrollBehavior().copyWith(dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
        }),
        theme: settings.darkMode.value ? ThemeData.dark() : ThemeData.light(),
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
  }
}

class ExampleField extends StatelessWidget {
  const ExampleField({
    super.key,
    required this.settings,
    required this.controller,
  });

  final FieldSettings settings;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(32),
          child: TypeAheadFormField<FieldOption>(
            hideOnUnfocus: settings.hideOnUnfocus.value,
            keepSuggestionsOnSelect: settings.keepSuggestionsOnSelect.value,
            textFieldConfiguration: TextFieldConfiguration(
              controller: controller,
              autofocus: true,
              style: DefaultTextStyle.of(context)
                  .style
                  .copyWith(fontStyle: FontStyle.italic),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'What are you looking for?',
              ),
            ),
            suggestionsBoxDecoration: SuggestionsBoxDecoration(
              borderRadius: BorderRadius.circular(10),
              elevation: 8,
              color: Theme.of(context).cardColor,
            ),
            itemBuilder: (context, setting) {
              if (setting is ToggleFieldOption) {
                return IgnorePointer(
                  child: CheckboxListTile(
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
              } else {
                return ListTile(
                  leading: Icon(setting.icon),
                  title: Text(setting.title),
                );
              }
            },
            onSuggestionSelected: (setting) => setting.change(),
            suggestionsCallback: (pattern) async =>
                Future<List<FieldOption>>.delayed(
              Duration(seconds: settings.loadingDelay.value ? 1 : 0),
              () => settings.search(pattern),
            ),
          ),
        ),
      ],
    );
  }
}

class CupertinoExampleField extends StatelessWidget {
  const CupertinoExampleField({
    super.key,
    required this.settings,
    required this.controller,
  });

  final FieldSettings settings;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(32),
          child: CupertinoTypeAheadFormField<FieldOption>(
            hideOnUnfocus: settings.hideOnUnfocus.value,
            keepSuggestionsOnSelect: settings.keepSuggestionsOnSelect.value,
            textFieldConfiguration: CupertinoTextFieldConfiguration(
              controller: controller,
              autofocus: true,
              style: DefaultTextStyle.of(context)
                  .style
                  .copyWith(fontStyle: FontStyle.italic),
              padding: const EdgeInsets.all(12),
              placeholder: 'What are you looking for?',
            ),
            suggestionsBoxDecoration: CupertinoSuggestionsBoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            itemBuilder: (context, setting) {
              if (setting is ToggleFieldOption) {
                return CupertinoListTile(
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
              } else {
                return CupertinoListTile(
                  leading: Icon(setting.icon),
                  title: Text(setting.title),
                );
              }
            },
            onSuggestionSelected: (setting) => setting.change(),
            suggestionsCallback: (pattern) async =>
                Future<List<FieldOption>>.delayed(
              Duration(seconds: settings.loadingDelay.value ? 1 : 0),
              () => settings.search(pattern),
            ),
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
          if (title != null) Expanded(child: title!),
          const Spacer(),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

abstract class FieldOption<T> {
  FieldOption({
    this.key,
    required this.title,
    required this.value,
    this.icon,
  });

  final String? key;
  final String title;
  final IconData? icon;
  T value;
  FutureOr<void> change();
  void Function()? onChanged;
}

class ToggleFieldOption extends FieldOption<bool> {
  ToggleFieldOption({
    super.key,
    required super.title,
    super.icon,
    this.iconFalse,
    required super.value,
  });

  final IconData? iconFalse;

  @override
  FutureOr<void> change() {
    value = !value;
    onChanged?.call();
  }
}

class FieldSettings {
  FieldSettings();

  List<FieldOption> get values => [
        cupertino,
        darkMode,
        keepSuggestionsOnSelect,
        hideOnUnfocus,
        loadingDelay,
      ];

  void connect(VoidCallback onChanged) {
    for (final setting in values) {
      setting.onChanged = onChanged;
    }
  }

  void disconnect() {
    for (final setting in values) {
      setting.onChanged = null;
    }
  }

  List<FieldOption> search(String pattern) {
    return values
        .where(
          (setting) => setting.title.toLowerCase().contains(
                pattern.toLowerCase(),
              ),
        )
        .toList();
  }

  final ToggleFieldOption cupertino = ToggleFieldOption(
    key: 'cupertino',
    title: 'is Cupertino',
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
