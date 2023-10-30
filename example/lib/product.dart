import 'package:flutter/material.dart';

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
    name: "Organic Carrots",
    description: "1lb bag",
    price: 1.5,
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
    name: "IKEA Markus Swivel Chair",
    price: 229.0,
  ),
  Product(
    name: "Canon EOS 5D Mark IV DSLR",
    price: 2499.99,
  ),
  Product(
    name: "IKEA Micke Desk",
    description: "White",
    price: 79.99,
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
    name: "Winmau Blade 5 Dual Core Dartboard",
    price: 79.99,
  ),
  Product(
    name: "Organic Brown Eggs",
    description: "Dozen",
    price: 3.99,
  ),
  Product(
    name: "Mack's Ultra Soft Foam Earplugs",
    description: "50 pairs",
    price: 9.99,
  ),
  Product(
    name: "Breville Barista Express Espresso Machine",
    price: 699.99,
  ),
  Product(
    name: "Staedtler Mars Plastic Erasers",
    description: "2-Pack",
    price: 1.99,
  ),
  Product(
    name: "AmazonBasics CAT6 Ethernet Cable",
    description: "10ft",
    price: 7.99,
  ),
  Product(
    name: "Honeywell TurboForce Air Circulator Fan",
    price: 49.99,
  ),
  Product(
    name: "Maglite Mini LED Flashlight",
    description: "2-Cell AA",
    price: 19.99,
  ),
  Product(
    name: "T-fal Professional Non-Stick Frying Pan",
    description: "12-inch",
    price: 39.99,
  ),
  Product(
    name: "Samsung 28 cu. ft. French Door Refrigerator",
    price: 1799.99,
  ),
  Product(
    name: "Fidgetly CTRL High-Speed Fidget Spinner",
    price: 9.99,
  ),
  Product(
    name: "Seedless Grapes",
    description: "1lb",
    price: 2.99,
  ),
  Product(
    name: "Nintendo Switch Game Console",
    price: 299.99,
  ),
  Product(
    name: "Weber Charcoal Grill",
    price: 165.0,
  ),
  Product(
    name: "Fender Acoustic Guitar",
    price: 199.99,
  ),
  Product(
    name: "Nitrile Examination Gloves",
    description: "100 count",
    price: 10.99,
  ),
  Product(
    name: "Baseball Cap",
    description: "Adjustable",
    price: 14.99,
  ),
  Product(
    name: "Sony WH-1000XM4 Headphones",
    description: "Noise-Canceling",
    price: 349.99,
  ),
  Product(
    name: "Belkin HDMI Cable",
    description: "6ft",
    price: 16.99,
  ),
  Product(
    name: "Dyson Supersonic Hairdryer",
    price: 399.99,
  ),
  Product(
    name: "Stanley Claw Hammer",
    description: "16 oz",
    price: 9.99,
  ),
  Product(
    name: "Ben & Jerry's Ice Cream",
    description: "1 pint",
    price: 4.99,
  ),
  Product(
    name: "HP 63 Ink Cartridge",
    description: "Black",
    price: 20.99,
  ),
  Product(
    name: "Black+Decker Steam Iron",
    price: 29.99,
  ),
  Product(
    name: "iPhone 13 Pro",
    description: "128GB",
    price: 999.0,
  ),
  Product(
    name: "Rubbermaid Ice Tray",
    description: "2-Pack",
    price: 4.99,
  ),
  Product(
    name: "JBL Charge 4 Bluetooth Speaker",
    price: 179.99,
  ),
  Product(
    name: "Java Programming for Dummies",
    description: "Paperback",
    price: 24.99,
  ),
  Product(
    name: "Jack Daniel's Whiskey",
    description: "750ml",
    price: 21.99,
  ),
  Product(
    name: "Jigsaw Puzzle",
    description: "1000 Pieces",
    price: 14.99,
  ),
  Product(
    name: "Johnson's Baby Shampoo",
    description: "15oz",
    price: 4.99,
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
    name: "Kodak Printomatic Digital Camera",
    price: 49.99,
  ),
  Product(
    name: "Levi's 501 Original Jeans",
    description: "Men's",
    price: 59.99,
  ),
  Product(
    name: "Logitech MX Master 3 Mouse",
    price: 99.99,
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
    name: "Lindt Milk Chocolate Truffles",
    description: "12 oz",
    price: 10.99,
  ),
  Product(
    name: "Microsoft Surface Laptop",
    description: "13.5-inch, 256GB",
    price: 999.99,
  ),
  Product(
    name: "Moleskine Classic Notebook",
    description: "Hardcover",
    price: 19.99,
  ),
  Product(
    name: "Motorola Moto G Smartphone",
    description: "64GB",
    price: 199.99,
  ),
  Product(
    name: "Mr. Coffee 12-Cup Coffeemaker",
    price: 24.99,
  ),
  Product(
    name: "Michelin Premier A/S Tires",
    description: "Set of 4",
    price: 600.0,
  ),
  Product(
    name: "Nutella Hazelnut Spread",
    description: "13 oz",
    price: 3.99,
  ),
  Product(
    name: "Nintendo Switch Pro Controller",
    price: 69.99,
  ),
  Product(
    name: "Nike Air Force 1 Sneakers",
    description: "Men's",
    price: 90.0,
  ),
  Product(
    name: "Nespresso Vertuo Coffee Machine",
    price: 159.0,
  ),
  Product(
    name: "Netgear Nighthawk WiFi Router",
    description: "AX12",
    price: 299.99,
  ),
  Product(
    name: "Old Spice Deodorant",
    description: "3 oz",
    price: 4.99,
  ),
  Product(
    name: "OtterBox Defender iPhone Case",
    description: "For iPhone 13",
    price: 49.99,
  ),
  Product(
    name: "Oreo Cookies",
    description: "Family Size",
    price: 3.99,
  ),
  Product(
    name: "Organic Olive Oil",
    description: "16.9 fl oz",
    price: 8.99,
  ),
  Product(
    name: "Ozark Trail Camping Tent",
    description: "4 Person",
    price: 49.99,
  ),
  Product(
    name: "PlayStation 5 Console",
    price: 499.99,
  ),
  Product(
    name: "Puma Athletic Socks",
    description: "6-Pack",
    price: 14.99,
  ),
  Product(
    name: "Pilot G2 Gel Pens",
    description: "Pack of 12",
    price: 12.99,
  ),
  Product(
    name: "Pyrex Glass Storage Set",
    description: "18-Piece",
    price: 29.99,
  ),
  Product(
    name: "Pepsi Cola",
    description: "12-Pack Cans",
    price: 5.99,
  ),
  Product(
    name: "Quaker Oats",
    description: "42 oz",
    price: 4.99,
  ),
  Product(
    name: "Queen-Size Mattress",
    description: "Memory Foam",
    price: 299.99,
  ),
  Product(
    name: "QuickBooks Software",
    description: "2023 Edition",
    price: 249.99,
  ),
  Product(
    name: "Quilted Northern Toilet Paper",
    description: "12 Mega Rolls",
    price: 12.99,
  ),
  Product(
    name: "Quest Nutrition Protein Bars",
    description: "12 Count",
    price: 24.99,
  ),
  Product(
    name: "Roku Streaming Stick+",
    price: 49.99,
  ),
  Product(
    name: "Ray-Ban Aviator Sunglasses",
    price: 153.0,
  ),
  Product(
    name: "Red Bull Energy Drink",
    description: "12-Pack, 8.4 oz",
    price: 19.99,
  ),
  Product(
    name: "Revlon Hair Dryer",
    price: 39.99,
  ),
  Product(
    name: "Rubik's Cube",
    description: "3x3",
    price: 9.99,
  ),
  Product(
    name: "Samsung Galaxy S21",
    description: "128GB",
    price: 799.99,
  ),
  Product(
    name: "Sharpie Permanent Markers",
    description: "12-Pack",
    price: 9.99,
  ),
  Product(
    name: "Sony WH-1000XM4 Headphones",
    price: 348.0,
  ),
  Product(
    name: "Swiss Army Knife",
    description: "Classic SD",
    price: 21.99,
  ),
  Product(
    name: "Sunscreen SPF 50",
    description: "8 oz",
    price: 8.99,
  ),
  Product(
    name: "Tide Laundry Detergent",
    description: "100 fl oz",
    price: 11.99,
  ),
  Product(
    name: "Toothpaste",
    description: "Colgate, 4.8 oz",
    price: 2.99,
  ),
  Product(
    name: "Tommy Hilfiger T-Shirt",
    description: "Men's",
    price: 19.99,
  ),
  Product(
    name: "TP-Link WiFi Extender",
    price: 29.99,
  ),
  Product(
    name: "Toshiba Microwave Oven",
    description: "0.9 cu ft",
    price: 89.99,
  ),
  Product(
    name: "USB-C Charging Cable",
    description: "6ft",
    price: 12.99,
  ),
  Product(
    name: "Umbrella",
    description: "Compact, Windproof",
    price: 19.99,
  ),
  Product(
    name: "Ugg Boots",
    description: "Women's",
    price: 159.99,
  ),
  Product(
    name: "Ultra HD 4K TV",
    description: "Samsung, 55-inch",
    price: 599.99,
  ),
  Product(
    name: "Ukulele",
    description: "Soprano",
    price: 49.99,
  ),
  Product(
    name: "Vitamix Blender",
    price: 349.99,
  ),
  Product(
    name: "Vans Old Skool Sneakers",
    description: "Unisex",
    price: 59.99,
  ),
  Product(
    name: "Vaseline Petroleum Jelly",
    description: "13 oz",
    price: 3.99,
  ),
  Product(
    name: "Verbatim DVD-R",
    description: "Pack of 50",
    price: 14.99,
  ),
  Product(
    name: "Victoria's Secret Perfume",
    description: "1.7 oz",
    price: 58.0,
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
    name: "Windex Glass Cleaner",
    description: "32 oz",
    price: 3.49,
  ),
  Product(
    name: "Water Bottle",
    description: "Hydro Flask, 32 oz",
    price: 44.99,
  ),
  Product(
    name: "Wilson Tennis Racket",
    price: 179.99,
  ),
  Product(
    name: "Xbox Series X",
    price: 499.99,
  ),
  Product(
    name: "Xerox Copy Paper",
    description: "500 Sheets",
    price: 6.99,
  ),
  Product(
    name: "Xiaomi Mi Band 6",
    price: 44.99,
  ),
  Product(
    name: "XTEND BCAA Powder",
    description: "30 Servings",
    price: 24.99,
  ),
  Product(
    name: "X-Acto Knife",
    description: "#1 Precision",
    price: 4.99,
  ),
  Product(
    name: "YETI Rambler Tumbler",
    description: "20 oz",
    price: 29.99,
  ),
  Product(
    name: "Yoga Mat",
    description: "1/4-inch Thick",
    price: 19.99,
  ),
  Product(
    name: "Yankee Candle",
    description: "Large Jar",
    price: 27.99,
  ),
  Product(
    name: "Yamaha Acoustic Guitar",
    price: 199.99,
  ),
  Product(
    name: "Yogurt",
    description: "Chobani, 5.3 oz",
    price: 1.29,
  ),
  Product(
    name: "Ziploc Storage Bags",
    description: "Gallon, 75 Count",
    price: 8.99,
  ),
  Product(
    name: "Organic Zucchini",
    description: "1lb",
    price: 1.99,
  ),
  Product(
    name: "Coca-Cola Zero Sugar",
    description: "12-Pack Cans",
    price: 5.99,
  ),
  Product(
    name: "Zippo Windproof Lighter",
    description: "Brushed Chrome",
    price: 14.99,
  ),
  Product(
    name: "San Diego Zoo Tickets",
    description: "Adult Admission",
    price: 62.0,
  ),
];
