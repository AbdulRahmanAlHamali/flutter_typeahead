import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead_example/example.dart';
import 'package:flutter_typeahead_example/settings.dart';
import 'package:flutter_typeahead_example/product.dart';
import 'package:flutter_typeahead_example/options.dart';

void main() => runApp(const App());

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final TextEditingController customTextController = TextEditingController();
  final TextEditingController basicTextController = TextEditingController();
  final ProductController products = ValueNotifier<Map<Product, int>>({});
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
                              foregroundColor: Colors.white,
                            ),
                            icon: const Icon(Icons.arrow_forward),
                            onPressed: () {
                              DefaultTabController.of(context).animateTo(1);
                            },
                            label: const Text('Settings'),
                          );
                        } else {
                          return TextButton.icon(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                            ),
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () {
                              DefaultTabController.of(context).animateTo(0);
                            },
                            label: const Text('Demo'),
                          );
                        }
                      },
                    ),
                  ],
                ),
                body: GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: TabBarView(
                    children: [
                      ExampleTypeAhead(
                        settings: settings,
                        controller: basicTextController,
                        products: products,
                      ),
                      SettingsTypeAhead(
                        controller: customTextController,
                        settings: settings,
                      ),
                    ],
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
                      onTap: () => FocusScope.of(context).unfocus(),
                      child: TabBarView(
                        children: [
                          CupertinoExampleTypeAhead(
                            settings: settings,
                            controller: basicTextController,
                            products: products,
                          ),
                          CupertinoSettingsTypeAhead(
                            settings: settings,
                            controller: customTextController,
                          ),
                        ],
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
