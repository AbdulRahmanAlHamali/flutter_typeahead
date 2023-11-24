import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef ProductController = ValueNotifier<Map<Product, int>>;

extension SumTotal on ProductController {
  double get total {
    double result = value.entries.fold<double>(
      0,
      (total, entry) => total + entry.key.price * entry.value,
    );
    return (result * 100).round() / 100;
  }
}

@immutable
class Product {
  final String name;
  final String? description;
  final double price;

  const Product({
    required this.name,
    this.description,
    required this.price,
  });

  @override
  String toString() =>
      'Product(name: $name, description: $description, price: $price)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          description == other.description &&
          price == other.price;

  @override
  int get hashCode => Object.hash(name, description, price);
}

class ProductList extends StatelessWidget {
  const ProductList({
    super.key,
    required this.products,
  });

  final ProductController products;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: products.value.entries.map(
        (entry) {
          return ListTile(
            title: Text(entry.key.name),
            subtitle: entry.key.description != null
                ? Text(entry.key.description!)
                : null,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'x${entry.value}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  ', \$${(entry.key.price * entry.value).toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                  tooltip: 'Remove',
                  icon: const Icon(Icons.remove_circle_outline),
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
                ),
              ],
            ),
          );
        },
      ).toList(),
    );
  }
}

class CupertinoProductList extends StatelessWidget {
  const CupertinoProductList({
    super.key,
    required this.products,
  });

  final ProductController products;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: products.value.entries.map(
        (entry) {
          return CupertinoListTile(
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
          );
        },
      ).toList(),
    );
  }
}

const List<Product> allProducts = [
  Product(
    name: "Organic Gala Apple",
    description: "1lb",
    price: 1.5,
  ),
  Product(
    name: "Bayer Aspirin",
    description: "500mg, 100 Tablets",
    price: 8.99,
  ),
  Product(
    name: "Ninja 4-Quart Air Fryer",
    price: 99.99,
  ),
  Product(
    name: "Apple AirPods Pro",
    description: "with Wireless Charging Case",
    price: 249.0,
  ),
  Product(
    name: "Amazon Echo 4th Gen",
    description: "Charcoal",
    price: 99.99,
  ),
  Product(
    name: "Chiquita Bananas",
    description: "1 bunch",
    price: 1.99,
  ),
  Product(
    name: "NutriBullet Pro Blender",
    description: "900W",
    price: 79.99,
  ),
  Product(
    name: "JBL Flip 5 Bluetooth Speaker",
    description: "Waterproof",
    price: 119.99,
  ),
  Product(
    name: "Harry Potter and the Sorcerer's Stone",
    description: "Hardcover",
    price: 24.99,
  ),
  Product(
    name: "Duracell AA Alkaline Batteries",
    description: "8-Pack",
    price: 8.99,
  ),
  Product(
    name: "Keurig K-Classic Single Serve Coffee Maker",
    price: 129.99,
  ),
  Product(
    name: "Anker USB-C Fast Charger",
    description: "20W",
    price: 19.99,
  ),
  Product(
    name: "Canon EOS 5D Mark IV DSLR",
    price: 2499.99,
  ),
  Product(
    name: "DJI Mavic Air 2 Drone",
    price: 799.0,
  ),
  Product(
    name: "Dawn Ultra Dishwashing Liquid",
    description: "16.2 oz",
    price: 2.99,
  ),
  Product(
    name: "Inception",
    description: "Standard Edition DVD",
    price: 14.99,
  ),
  Product(
    name: "Organic Brown Eggs",
    description: "Dozen",
    price: 3.99,
  ),
  Product(
    name: "Fidgetly CTRL High-Speed Fidget Spinner",
    price: 9.99,
  ),
  Product(
    name: "Nintendo Switch Game Console",
    price: 299.99,
  ),
  Product(
    name: "Fender Acoustic Guitar",
    price: 199.99,
  ),
  Product(
    name: "Sony WH-1000XM4 Headphones",
    description: "Noise-Canceling",
    price: 349.99,
  ),
  Product(
    name: "Dyson Supersonic Hairdryer",
    price: 399.99,
  ),
  Product(
    name: "Ben & Jerry's Ice Cream",
    description: "1 pint",
    price: 4.99,
  ),
  Product(
    name: "iPhone 13 Pro",
    description: "128GB",
    price: 999.0,
  ),
  Product(
    name: "Java Programming for Dummies",
    description: "Paperback",
    price: 24.99,
  ),
  Product(
    name: "Kellogg's Corn Flakes",
    description: "18oz Box",
    price: 3.99,
  ),
  Product(
    name: "Kindle Paperwhite",
    description: "8GB, Wi-Fi",
    price: 129.99,
  ),
  Product(
    name: "KitchenAid Mixer",
    description: "5-Quart",
    price: 279.99,
  ),
  Product(
    name: "Kleenex Tissues",
    description: "Box of 160",
    price: 2.49,
  ),
  Product(
    name: "Lysol Disinfectant Spray",
    description: "19 oz",
    price: 5.99,
  ),
  Product(
    name: "LEGO Star Wars Millennium Falcon",
    price: 159.99,
  ),
  Product(
    name: "Microsoft Surface Laptop",
    description: "13.5-inch, 256GB",
    price: 999.99,
  ),
  Product(
    name: "Motorola Moto G Smartphone",
    description: "64GB",
    price: 199.99,
  ),
  Product(
    name: "Nutella Hazelnut Spread",
    description: "13 oz",
    price: 3.99,
  ),
  Product(
    name: "Old Spice Deodorant",
    description: "3 oz",
    price: 4.99,
  ),
  Product(
    name: "Organic Olive Oil",
    description: "16.9 fl oz",
    price: 8.99,
  ),
  Product(
    name: "PlayStation 5 Console",
    price: 499.99,
  ),
  Product(
    name: "Queen-Size Mattress",
    description: "Memory Foam",
    price: 299.99,
  ),
  Product(
    name: "Roku Streaming Stick+",
    price: 49.99,
  ),
  Product(
    name: "Samsung Galaxy S21",
    description: "128GB",
    price: 799.99,
  ),
  Product(
    name: "Tide Laundry Detergent",
    description: "100 fl oz",
    price: 11.99,
  ),
  Product(
    name: "TP-Link WiFi Extender",
    price: 29.99,
  ),
  Product(
    name: "Umbrella",
    description: "Compact, Windproof",
    price: 19.99,
  ),
  Product(
    name: "Vitamix Blender",
    price: 349.99,
  ),
  Product(
    name: "WD 2TB External Hard Drive",
    price: 59.99,
  ),
  Product(
    name: "Whirlpool Washing Machine",
    description: "Top-Loading",
    price: 499.99,
  ),
  Product(
    name: "YETI Rambler Tumbler",
    description: "20 oz",
    price: 29.99,
  ),
  Product(
    name: "Yamaha Acoustic Guitar",
    price: 199.99,
  ),
  Product(
    name: "Ziploc Storage Bags",
    description: "Gallon, 75 Count",
    price: 8.99,
  ),
  Product(
    name: "San Diego Zoo Tickets",
    description: "Adult Admission",
    price: 62.0,
  ),
];
