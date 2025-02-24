import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

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
        gridLayout,
        dividers,
        constrainWidth,
        loadingDelay,
        retainOnLoading,
        debounce,
        hideOnSelect,
        hideOnUnfocus,
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
    value: SchedulerBinding.instance.platformDispatcher.platformBrightness ==
        Brightness.dark,
    icon: Icons.dark_mode,
    iconFalse: Icons.light_mode,
  );

  final ChoiceFieldOption<VerticalDirection> direction = ChoiceFieldOption(
    key: 'direction',
    title: 'Direction',
    value: VerticalDirection.down,
    icon: Icons.swap_vert,
    choices: [
      VerticalDirection.up,
      VerticalDirection.down,
    ],
  );

  final ToggleFieldOption gridLayout = ToggleFieldOption(
    key: 'gridLayout',
    title: 'Grid Layout',
    value: false,
    icon: Icons.grid_on,
  );

  final ToggleFieldOption dividers = ToggleFieldOption(
    key: 'dividers',
    title: 'Dividers',
    value: true,
    icon: Icons.border_clear,
  );

  final ToggleFieldOption constrainWidth = ToggleFieldOption(
    key: 'constrained',
    title: 'Constrain Width',
    value: true,
    icon: Icons.filter_frames,
  );

  final ToggleFieldOption loadingDelay = ToggleFieldOption(
    key: 'loadingDelay',
    title: 'Loading Delay',
    value: true,
    icon: Icons.timer,
  );

  final ToggleFieldOption retainOnLoading = ToggleFieldOption(
    key: 'retainOnLoading',
    title: 'Retain on Loading',
    value: true,
    icon: Icons.cached,
  );

  final ToggleFieldOption debounce = ToggleFieldOption(
    key: 'debounce',
    title: 'Debounce',
    value: true,
    icon: Icons.input,
  );

  final ToggleFieldOption hideOnSelect = ToggleFieldOption(
    key: 'hideOnSelect',
    title: 'Hide on Select',
    value: true,
    icon: Icons.fingerprint,
  );

  final ToggleFieldOption hideOnUnfocus = ToggleFieldOption(
    key: 'hideOnUnfocus',
    title: 'Hide on Unfocus',
    value: true,
    icon: Icons.visibility_off,
  );
}
