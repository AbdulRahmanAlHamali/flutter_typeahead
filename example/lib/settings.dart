import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_typeahead_example/options.dart';

class SettingsTypeAhead extends StatelessWidget
    with SharedSettingsTypeAheadConfig {
  SettingsTypeAhead({
    super.key,
    required this.controller,
    required this.settings,
  });

  final TextEditingController controller;
  @override
  final FieldSettings settings;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: settings.direction.value == VerticalDirection.up
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(32),
          child: TypeAheadField<FieldOption>(
            direction: settings.direction.value,
            hideOnUnfocus: false,
            hideWithKeyboard: false,
            hideOnSelect: false,
            controller: controller,
            builder: (context, controller, focusNode) => TextField(
              controller: controller,
              focusNode: focusNode,
              autofocus: true,
              style: DefaultTextStyle.of(context)
                  .style
                  .copyWith(fontStyle: FontStyle.italic),
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: hintText,
              ),
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
                    onChanged: (_) =>
                        SuggestionsController.of<FieldOption>(context)
                            .select(setting),
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
                return IgnorePointer(
                  child: ListTile(
                    key: ValueKey(setting.value),
                    leading: Icon(setting.icon),
                    title: Text(setting.title),
                  ),
                );
              }
            },
            itemSeparatorBuilder: itemSeparatorBuilder,
            listBuilder: settings.gridLayout.value ? gridLayoutBuilder : null,
            onSelected: onSuggestionSelected,
            suggestionsCallback: suggestionsCallback,
            constrainWidth: settings.constrainWidth.value,
            offset: const Offset(-12, 5),
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
    required this.controller,
    required this.settings,
  });

  final TextEditingController controller;
  @override
  final FieldSettings settings;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: settings.direction.value == VerticalDirection.up
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(32),
          child: CupertinoTypeAheadField<FieldOption>(
            direction: settings.direction.value,
            hideOnUnfocus: false,
            hideWithKeyboard: false,
            hideOnSelect: false,
            controller: controller,
            builder: (context, controller, focusNode) => CupertinoTextField(
              controller: controller,
              focusNode: focusNode,
              autofocus: true,
              padding: const EdgeInsets.all(12),
              placeholder: hintText,
              placeholderStyle:
                  CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                        color: CupertinoColors.placeholderText,
                        fontStyle: FontStyle.italic,
                      ),
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
                    onChanged: (_) =>
                        SuggestionsController.of<FieldOption>(context)
                            .select(setting),
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
            listBuilder: settings.gridLayout.value ? gridLayoutBuilder : null,
            onSelected: onSuggestionSelected,
            suggestionsCallback: suggestionsCallback,
            constrainWidth: settings.constrainWidth.value,
            offset: const Offset(-12, 5),
          ),
        ),
      ],
    );
  }
}

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

  Widget gridLayoutBuilder(BuildContext context, List<Widget> items) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: items.length,
      shrinkWrap: true,
      primary: false,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 400,
        mainAxisExtent: 48,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      reverse:
          SuggestionsController.of<FieldOption>(context).effectiveDirection ==
              VerticalDirection.up,
      itemBuilder: (context, index) => items.toList()[index],
    );
  }
}
