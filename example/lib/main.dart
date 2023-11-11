import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_typeahead_example/checkout.dart';
import 'package:flutter_typeahead_example/frame.dart';
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
  @override
  Widget build(BuildContext context) {
    return MaterialCupertinoFrame(
      exampleBuilder: (context, controller, products, settings) =>
          ExampleTypeAhead(
        controller: controller,
        products: products,
        settings: settings,
      ),
      settingsBuilder: (context, controller, settings) => SettingsTypeAhead(
        controller: controller,
        settings: settings,
      ),
      cupertinoExampleBuilder: (context, controller, products, settings) =>
          CupertinoExampleTypeAhead(
        controller: controller,
        products: products,
        settings: settings,
      ),
      cupertinoSettingsBuilder: (context, controller, settings) =>
          CupertinoSettingsTypeAhead(
        controller: controller,
        settings: settings,
      ),
    );
  }
}

class ExampleTypeAhead extends StatelessWidget
    with SharedExampleTypeAheadConfig {
  ExampleTypeAhead({
    super.key,
    required this.controller,
    required this.products,
    required this.settings,
  });

  @override
  final TextEditingController controller;
  @override
  final ProductController products;
  @override
  final FieldSettings settings;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: products,
      builder: (context, value, child) {
        return Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: maybeReversed([
              TypeAheadFormField<Product>(
                direction: settings.direction.value,
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
                itemBuilder: (context, product) => ListTile(
                  title: Text(product.name),
                  subtitle: product.description != null
                      ? Text(
                          '${product.description!} - \$${product.price}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      : Text('\$${product.price}'),
                ),
                debounceDuration: debounceDuration,
                hideOnSelect: settings.hideOnSelect.value,
                hideOnUnfocus: settings.hideOnUnfocus.value,
                onSuggestionSelected: onSuggestionSelected,
                suggestionsCallback: suggestionsCallback,
                itemSeparatorBuilder: itemSeparatorBuilder,
                layoutArchitecture:
                    settings.gridLayout.value ? gridLayoutBuilder : null,
              ),
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Text('Shopping Cart',
                              style: Theme.of(context).textTheme.titleLarge),
                          const Spacer(),
                          Text(
                            'Total: \$${products.total.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.titleMedium,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (products.value.isNotEmpty)
                      Expanded(
                        child: ListView(
                          children: products.value.entries
                              .map(
                                (entry) => ListTile(
                                  title: Text(entry.key.name),
                                  subtitle: entry.key.description != null
                                      ? Text(entry.key.description!)
                                      : null,
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'x${entry.value}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      Text(
                                        ', \$${entry.key.price * entry.value}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      IconButton(
                                        tooltip: 'Remove',
                                        icon: const Icon(
                                            Icons.remove_circle_outline),
                                        onPressed: () {
                                          products.value =
                                              Map.of(products.value)
                                                ..update(
                                                  entry.key,
                                                  (value) => value - 1,
                                                  ifAbsent: () => 0,
                                                );
                                          if ((products.value[entry.key] ??
                                                  0) <=
                                              0) {
                                            products.value =
                                                Map.of(products.value)
                                                  ..remove(entry.key);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      )
                    else
                      Expanded(
                        child: Center(
                          child: Text(
                            'Your cart is empty',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => CheckoutDialog(products: products),
                    ),
                    child: const Text('Checkout'),
                  ),
                ],
              ),
            ]),
          ),
        );
      },
    );
  }
}

class CupertinoExampleTypeAhead extends StatelessWidget
    with SharedExampleTypeAheadConfig {
  CupertinoExampleTypeAhead({
    super.key,
    required this.controller,
    required this.products,
    required this.settings,
  });

  @override
  final TextEditingController controller;
  @override
  final ProductController products;
  @override
  final FieldSettings settings;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: products,
      builder: (context, value, child) {
        return Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: maybeReversed([
              CupertinoTypeAheadFormField<Product>(
                direction: settings.direction.value,
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
                itemBuilder: (context, product) => CupertinoListTile(
                  title: Text(product.name),
                  subtitle: product.description != null
                      ? Text(
                          '${product.description!} - \$${product.price}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      : Text('\$${product.price}'),
                ),
                debounceDuration: debounceDuration,
                hideOnSelect: settings.hideOnSelect.value,
                hideOnUnfocus: settings.hideOnUnfocus.value,
                onSuggestionSelected: onSuggestionSelected,
                suggestionsCallback: suggestionsCallback,
                itemSeparatorBuilder: itemSeparatorBuilder,
                layoutArchitecture:
                    settings.gridLayout.value ? gridLayoutBuilder : null,
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text('Shopping Cart',
                        style: CupertinoTheme.of(context)
                            .textTheme
                            .textStyle
                            .copyWith(fontSize: 24)),
                    const Spacer(),
                    Text(
                      'Total: \$${products.total.toStringAsFixed(2)}',
                      style: CupertinoTheme.of(context)
                          .textTheme
                          .textStyle
                          .copyWith(fontSize: 18),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 8),
              if (products.value.isNotEmpty)
                Expanded(
                  child: ListView(
                    children: products.value.entries
                        .map(
                          (entry) => CupertinoListTile(
                            title: Text(entry.key.name),
                            subtitle: entry.key.description != null
                                ? Text(entry.key.description!)
                                : null,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'x${entry.value}',
                                  style: CupertinoTheme.of(context)
                                      .textTheme
                                      .textStyle
                                      .copyWith(fontSize: 18),
                                ),
                                Text(
                                  ', \$${entry.key.price * entry.value}',
                                  style: CupertinoTheme.of(context)
                                      .textTheme
                                      .textStyle
                                      .copyWith(fontSize: 18),
                                ),
                                CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    products.value = Map.of(products.value)
                                      ..update(
                                        entry.key,
                                        (value) => value - 1,
                                        ifAbsent: () => 0,
                                      );
                                    if ((products.value[entry.key] ?? 0) <= 0) {
                                      products.value = Map.of(products.value)
                                        ..remove(entry.key);
                                    }
                                  },
                                  child: const Icon(
                                    CupertinoIcons.minus_circled,
                                    size: 24,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                )
              else
                Expanded(
                  child: Center(
                    child: Text(
                      'Your cart is empty',
                      style: CupertinoTheme.of(context)
                          .textTheme
                          .textStyle
                          .copyWith(fontSize: 18),
                    ),
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CupertinoButton(
                    onPressed: () => showCupertinoDialog(
                      context: context,
                      builder: (context) =>
                          CupertinoCheckoutDialog(products: products),
                    ),
                    child: const Text('Checkout'),
                  ),
                ],
              ),
            ]),
          ),
        );
      },
    );
  }
}

mixin SharedExampleTypeAheadConfig {
  FieldSettings get settings;
  ProductController get products;
  TextEditingController get controller;

  final String hintText = 'What are you looking for?';
  final BorderRadius borderRadius = BorderRadius.circular(10);
  void onSuggestionSelected(Product product) {
    products.value = Map.of(
      products.value
        ..update(
          product,
          (value) => value + 1,
          ifAbsent: () => 1,
        ),
    );
    controller.clear();
  }

  Future<List<Product>> suggestionsCallback(String pattern) async =>
      Future<List<Product>>.delayed(
        Duration(seconds: settings.loadingDelay.value ? 1 : 0),
        () => allProducts.where((product) {
          final nameLower = product.name.toLowerCase().split(' ').join('');
          final patternLower = pattern.toLowerCase().split(' ').join('');
          return nameLower.contains(patternLower);
        }).toList(),
      );

  Widget itemSeparatorBuilder(BuildContext context, int index) =>
      settings.dividers.value
          ? const Divider(height: 1)
          : const SizedBox.shrink();

  List<Widget> maybeReversed(List<Widget> children) {
    if (settings.direction.value == AxisDirection.up) {
      return children.reversed.toList();
    }
    return children;
  }

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
        mainAxisExtent: 58,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, index) => items.toList()[index],
    );
  }

  Duration get debounceDuration => settings.debounce.value
      ? const Duration(milliseconds: 300)
      : Duration.zero;
}
