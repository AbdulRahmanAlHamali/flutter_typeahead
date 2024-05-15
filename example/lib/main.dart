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
              TypeAheadField<Product>(
                direction: settings.direction.value,
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
                decorationBuilder: (context, child) => Material(
                  type: MaterialType.card,
                  elevation: 4,
                  borderRadius: borderRadius,
                  child: child,
                ),
                itemBorderRadius: BorderRadius.circular(8),
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
                hideWithKeyboard: settings.hideOnUnfocus.value,
                retainOnLoading: settings.retainOnLoading.value,
                onSelected: onSuggestionSelected,
                suggestionsCallback: suggestionsCallback,
                itemSeparatorBuilder: itemSeparatorBuilder,
                listBuilder:
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
                            'Total: \$${products.total}',
                            style: Theme.of(context).textTheme.titleMedium,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (products.value.isNotEmpty)
                      Expanded(
                        child: ProductList(products: products),
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
              CupertinoTypeAheadField<Product>(
                direction: settings.direction.value,
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
                decorationBuilder: (context, child) => DecoratedBox(
                  decoration: BoxDecoration(
                    color: CupertinoTheme.of(context)
                        .barBackgroundColor
                        .withOpacity(1),
                    border: Border.all(
                      color: CupertinoDynamicColor.resolve(
                        CupertinoColors.systemGrey4,
                        context,
                      ),
                      width: 1,
                    ),
                    borderRadius: borderRadius,
                  ),
                  child: child,
                ),
                itemBorderRadius: BorderRadius.circular(8),
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
                hideWithKeyboard: settings.hideOnUnfocus.value,
                retainOnLoading: settings.retainOnLoading.value,
                onSelected: onSuggestionSelected,
                suggestionsCallback: suggestionsCallback,
                itemSeparatorBuilder: itemSeparatorBuilder,
                listBuilder:
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
                      'Total: \$${products.total}',
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
                  child: CupertinoProductList(products: products),
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
        Duration(milliseconds: settings.loadingDelay.value ? 300 : 0),
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
    if (settings.direction.value == VerticalDirection.up) {
      return children.reversed.toList();
    }
    return children;
  }

  Widget gridLayoutBuilder(
    BuildContext context,
    List<Widget> items,
  ) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: items.length,
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 400,
        mainAxisExtent: 58,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      reverse: SuggestionsController.of<Product>(context).effectiveDirection ==
          VerticalDirection.up,
      itemBuilder: (context, index) => items[index],
    );
  }

  Duration get debounceDuration => settings.debounce.value
      ? const Duration(milliseconds: 300)
      : Duration.zero;
}
