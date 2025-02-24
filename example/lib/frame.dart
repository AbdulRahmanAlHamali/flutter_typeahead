import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_typeahead_example/options.dart';
import 'package:flutter_typeahead_example/product.dart';

class MaterialCupertinoFrame extends StatefulWidget {
  const MaterialCupertinoFrame({
    super.key,
    required this.exampleBuilder,
    required this.settingsBuilder,
    required this.cupertinoExampleBuilder,
    required this.cupertinoSettingsBuilder,
  });

  final Widget Function(
    BuildContext context,
    TextEditingController controller,
    ValueNotifier<Map<Product, int>> products,
    SuggestionsController<Product> suggestions,
    FieldSettings settings,
  ) exampleBuilder;

  final Widget Function(
    BuildContext context,
    TextEditingController controller,
    FieldSettings settings,
  ) settingsBuilder;

  final Widget Function(
    BuildContext context,
    TextEditingController controller,
    ValueNotifier<Map<Product, int>> products,
    SuggestionsController<Product> suggestions,
    FieldSettings settings,
  ) cupertinoExampleBuilder;

  final Widget Function(
    BuildContext context,
    TextEditingController controller,
    FieldSettings settings,
  ) cupertinoSettingsBuilder;

  @override
  State<MaterialCupertinoFrame> createState() => _MaterialCupertinoFrameState();
}

class _MaterialCupertinoFrameState extends State<MaterialCupertinoFrame> {
  final TextEditingController settingsController = TextEditingController();
  final TextEditingController exampleController = TextEditingController();
  final ProductController products = ValueNotifier<Map<Product, int>>({});
  final SuggestionsController<Product> suggestions =
      SuggestionsController<Product>();
  final FieldSettings settings = FieldSettings();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: ListenableBuilder(
        listenable: settings,
        builder: (context, child) {
          if (!settings.cupertino.value) {
            return MaterialApp(
              theme: ThemeData(
                brightness: settings.darkMode.value
                    ? Brightness.dark
                    : Brightness.light,
                useMaterial3: true,
              ),
              scrollBehavior:
                  const MaterialScrollBehavior().copyWith(dragDevices: {
                PointerDeviceKind.mouse,
                PointerDeviceKind.touch,
              }),
              home: Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    icon: const Icon(Icons.phone_iphone),
                    onPressed: settings.cupertino.change,
                  ),
                  title: const Text('TypeAhead Demo'),
                  actions: [
                    ListenableBuilder(
                      listenable: DefaultTabController.of(context),
                      builder: (context, child) {
                        if (DefaultTabController.of(context).index == 0) {
                          return TextButton.icon(
                            style: TextButton.styleFrom(
                              foregroundColor:
                                  Theme.of(context).colorScheme.onSurface,
                            ),
                            icon: const Icon(Icons.arrow_forward),
                            onPressed: () =>
                                DefaultTabController.of(context).animateTo(1),
                            label: const Text('Settings'),
                          );
                        } else {
                          return TextButton.icon(
                            style: TextButton.styleFrom(
                              foregroundColor:
                                  Theme.of(context).colorScheme.onSurface,
                            ),
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () =>
                                DefaultTabController.of(context).animateTo(0),
                            label: const Text('Demo'),
                          );
                        }
                      },
                    ),
                  ],
                ),
                body: GestureDetector(
                  onTap: () => primaryFocus?.unfocus(),
                  child: TabBarView(
                    children: [
                      widget.exampleBuilder(
                        context,
                        exampleController,
                        products,
                        suggestions,
                        settings,
                      ),
                      widget.settingsBuilder(
                        context,
                        settingsController,
                        settings,
                      ),
                    ]
                        .map(
                          (e) => Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxWidth: 800,
                              ),
                              child: e,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            );
          } else {
            return CupertinoApp(
              theme: CupertinoThemeData(
                brightness: settings.darkMode.value
                    ? Brightness.dark
                    : Brightness.light,
              ),
              home: Scaffold(
                appBar: CupertinoNavigationBar(
                  middle: const Text('Cupertino TypeAhead Demo'),
                  leading: IconButton(
                    icon: const Icon(Icons.phone_android),
                    onPressed: settings.cupertino.change,
                    iconSize: 24,
                  ),
                  trailing: ListenableBuilder(
                    listenable: DefaultTabController.of(context),
                    builder: (context, child) {
                      if (DefaultTabController.of(context).index == 0) {
                        return CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            DefaultTabController.of(context).animateTo(1);
                          },
                          child: const Text('Settings'),
                        );
                      } else {
                        return CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            DefaultTabController.of(context).animateTo(0);
                          },
                          child: const Text('Demo'),
                        );
                      }
                    },
                  ),
                ),
                body: CupertinoPageScaffold(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: GestureDetector(
                      onTap: () => primaryFocus?.unfocus(),
                      child: TabBarView(
                        children: [
                          widget.cupertinoExampleBuilder(
                            context,
                            exampleController,
                            products,
                            suggestions,
                            settings,
                          ),
                          widget.cupertinoSettingsBuilder(
                            context,
                            settingsController,
                            settings,
                          ),
                        ]
                            .map(
                              (e) => Center(
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxWidth: 800,
                                  ),
                                  child: e,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ), //MyHomePage(),
            );
          }
        },
      ),
    );
  }
}
