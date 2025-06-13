import 'package:salon_pos/services/db_helper.dart';
import 'package:sqflite/sqflite.dart';

enum ItemCategory { service, product }

class Item {
  final int id; // sub_id from item_option
  final String name;
  final double price;
  final String parentItemName;
  final ItemCategory category;

  Item({
    required this.id,
    required this.name,
    required this.price,
    required this.parentItemName,
    required this.category,
  });

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['sub_id'] as int,
      name: map['name'].toString(),
      price: (map['price'] as num).toDouble(),
      parentItemName: map['parent_name'].toString(),
      category: map['category'] == 'Services'
          ? ItemCategory.service
          : ItemCategory.product,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Item &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          parentItemName == other.parentItemName;

  @override
  int get hashCode => id.hashCode ^ parentItemName.hashCode;
}

class ItemCatalog {
  static Future<List<Item>> getItems() async {
    final db = await DBHelper().database;

    final result = await db.rawQuery('''
      SELECT 
        item_option.sub_id,
        item_option.name,
        item_option.price,
        item_type.name AS parent_name,
        item_type.category
      FROM item_option
      JOIN item_type ON item_option.item_id = item_type.item_id
    ''');

    return result.map((row) => Item.fromMap(row)).toList();
  }

  static Future<List<Item>> getServices() async {
    final items = await getItems();
    return items
        .where((item) => item.category == ItemCategory.service)
        .toList();
  }

  static Future<List<Item>> getProducts() async {
    final items = await getItems();
    return items
        .where((item) => item.category == ItemCategory.product)
        .toList();
  }

  static Future<List<Map<String, dynamic>>> getItemTypes() async {
    final db = await DBHelper().database;
    return await db.query('item_type');
  }

  static Future<Item> getItemById(int subId) async {
    final items = await getItems();
    return items.firstWhere(
      (item) => item.id == subId,
      orElse: () => throw Exception("Item not found"),
    );
  }

  static Future<Item?> getItemByName(String name) async {
    final db = await DBHelper().database;
    final result = await db.rawQuery('''
      SELECT 
        item_option.sub_id,
        item_option.name,
        item_option.price,
        item_type.name AS parent_name,
        item_type.category
      FROM item_option
      JOIN item_type ON item_option.item_id = item_type.item_id
      WHERE item_option.name = ?
      LIMIT 1
    ''', [name]);

    if (result.isNotEmpty) {
      final row = result.first;
      return Item.fromMap(row);
    }

    return null;
  }
}
