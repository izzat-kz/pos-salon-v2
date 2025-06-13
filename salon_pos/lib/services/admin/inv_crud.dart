import 'package:sqflite/sqflite.dart';
import 'package:salon_pos/services/db_helper.dart';

class InventoryService {
  static Future<List<Map<String, dynamic>>> getItemsByCategory(
      String category) async {
    final db = await DBHelper().database;
    return await db.query(
      'item_type',
      where: 'category = ?',
      whereArgs: [category],
    );
  }

  static Future<void> addItemWithOptions({
    required String name,
    required String category,
    required List<Map<String, dynamic>> itemOptions,
  }) async {
    final db = await DBHelper().database;
    int itemId = await db.insert('item_type', {
      'name': name,
      'category': category,
    });

    for (var option in itemOptions) {
      await db.insert('item_option', {
        'name': option['name'],
        'price': option['price'],
        'item_id': itemId,
      });
    }
  }

  static Future<List<Map<String, dynamic>>> getItemOptions(int itemId) async {
    final db = await DBHelper().database;
    final result = await db.query(
      'item_option',
      where: 'item_id = ?',
      whereArgs: [itemId],
    );
    return result.map((row) => Map<String, dynamic>.from(row)).toList();
  }

  static Future<void> updateItemWithOptions({
    required int itemId,
    required String name,
    required String category,
    required List<Map<String, dynamic>> itemOptions,
  }) async {
    final db = await DBHelper().database;

    await db.update(
      'item_type',
      {'name': name, 'category': category},
      where: 'item_id = ?',
      whereArgs: [itemId],
    );

    await db.delete('item_option', where: 'item_id = ?', whereArgs: [itemId]);

    for (var s in itemOptions) {
      if ((s['name'] ?? '').toString().isNotEmpty) {
        await db.insert('item_option', {
          'name': s['name'],
          'price': s['price'],
          'item_id': itemId,
        });
      }
    }
  }

  static Future<void> deleteItem(int itemId) async {
    final db = await DBHelper().database;
    await db.delete('item_option', where: 'item_id = ?', whereArgs: [itemId]);
    await db.delete('item_type', where: 'item_id = ?', whereArgs: [itemId]);
  }
}
