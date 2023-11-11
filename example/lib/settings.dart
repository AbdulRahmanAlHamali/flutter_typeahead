import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_typeahead_example/options.dart';

mixin SharedSettingsTypeAheadConfig {
  FieldSettings get settings;

  final String hintText = 'Search demo settings';
  final BorderRadius borderRadius = BorderRadius.circular(10);
  void onSuggestionSelected(FieldOption setting) => setting.change();
  List<FieldOption> suggestionsCallback(String pattern) =>
      settings.search(pattern);

  Widget itemSeparatorBuilder(BuildContext context, int index) =>
      settings.dividers.value
          ? const Divider(height: 1)
          : const SizedBox.shrink();

  Widget gridLayoutBuilder(
      Iterable<Widget> items, ScrollController controller) {
    return GridView.builder(
      controller: controller,
      padding: const EdgeInsets.all(8),
      itemCount: items.length,
      shrinkWrap: true,
      primary: false,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 300,
        mainAxisExtent: 48,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, index) => items.toList()[index],
    );
  }
}

class SettingsTypeAhead extends StatelessWidget
    with SharedSettingsTypeAheadConfig {
  SettingsTypeAhead({
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
            hideOnUnfocus: false,
            hideOnSelect: false,
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
            suggestionsDecoration: SuggestionsDecoration(
              borderRadius: borderRadius,
              elevation: 8,
              color: Theme.of(context).cardColor,
            ),
            itemBuilder: (context, setting) {
              if (setting is ToggleFieldOption) {
                IconData? icon = setting.value
                    ? setting.icon
                    : setting.iconFalse ?? setting.icon;
                return IgnorePointer(
                  child: CheckboxListTile(
                    key: ValueKey(setting.value),
                    title: Text(setting.title),
                    secondary: icon != null ? Icon(icon) : null,
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
            itemSeparatorBuilder: itemSeparatorBuilder,
            layoutArchitecture:
                settings.gridLayout.value ? gridLayoutBuilder : null,
            onSuggestionSelected: onSuggestionSelected,
            suggestionsCallback: suggestionsCallback,
          ),
        ),
      ],
    );
  }
}

class CupertinoSettingsTypeAhead extends StatelessWidget
    with SharedSettingsTypeAheadConfig {
  CupertinoSettingsTypeAhead({
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
            hideOnUnfocus: false,
            hideOnSelect: false,
            textFieldConfiguration: CupertinoTextFieldConfiguration(
              controller: controller,
              autofocus: true,
              padding: const EdgeInsets.all(12),
              placeholder: hintText,
              placeholderStyle:
                  CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                        color: CupertinoColors.placeholderText,
                        fontStyle: FontStyle.italic,
                      ),
            ),
            suggestionsDecoration: CupertinoSuggestionsDecoration(
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
            itemSeparatorBuilder: itemSeparatorBuilder,
            layoutArchitecture:
                settings.gridLayout.value ? gridLayoutBuilder : null,
            onSuggestionSelected: onSuggestionSelected,
            suggestionsCallback: suggestionsCallback,
          ),
        ),
      ],
    );
  }
}
