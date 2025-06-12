class Item {
  final String name;
  final double price;
  final ItemCategory category;

  Item({
    required this.name,
    required this.price,
    required this.category,
  });
}

enum ItemCategory {
  service,
  product,
}

class ItemCatalog {
  static final List<Item> items = [
    Item(name: "Hair Cutting", price: 10, category: ItemCategory.service),
    Item(name: "Hair Colouring", price: 15, category: ItemCategory.service),
    Item(name: "Hair Waxing", price: 13, category: ItemCategory.service),
    Item(name: "Nails Treatment", price: 20, category: ItemCategory.service),
    Item(name: "Repair Shampoo", price: 34, category: ItemCategory.product),
    Item(name: "Dry Shampoo", price: 28, category: ItemCategory.product),
    Item(name: "Bonding Oil", price: 22, category: ItemCategory.product),
    Item(name: "Hair Cream", price: 45, category: ItemCategory.product),
    Item(name: "Nail Paint", price: 27, category: ItemCategory.product),
  ];

  static Item getItemByName(String itemName) {
    return items.firstWhere(
      (item) => item.name == itemName,
      orElse: () =>
          Item(name: "Unknown", price: 0.0, category: ItemCategory.service),
    );
  }

  static List<Item> get services =>
      items.where((item) => item.category == ItemCategory.service).toList();

  static List<Item> get products =>
      items.where((item) => item.category == ItemCategory.product).toList();
}
