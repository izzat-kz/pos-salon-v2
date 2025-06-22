import 'package:sqflite/sqflite.dart';
import 'package:salon_pos/services/db_helper.dart';
import '../../widgets/admin/popups.dart';
import '../../services/loan_crud.dart';

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

  static Future<void> updateItemOption(
      int itemOptionId, String newName, String newPrice) async {
    final db = await DBHelper().database;

    await db.update(
      'item_option',
      {
        'name': newName,
        'price': double.tryParse(newPrice) ?? 0.0,
      },
      where: 'sub_id = ?',
      whereArgs: [itemOptionId],
    );
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

    // TO DO: Ensure NO item options tied to loans exist before deleting item type
    final List<Map<String, dynamic>> tiedItemOptions = await db.rawQuery(
      '''
    SELECT loan_id FROM loan WHERE json_extract(billItems, '\$."' || ? || '"') IS NOT NULL
    ''',
      [itemId.toString()],
    );

    if (tiedItemOptions.isNotEmpty) {
      throw Exception("Cannot delete item type with loan-linked item options!");
    }

    // TO DO: Proceed with deletion if no tied item options exist
    await db.delete('item_option', where: 'item_id = ?', whereArgs: [itemId]);
    await db.delete('item_type', where: 'item_id = ?', whereArgs: [itemId]);
  }

  static Future<void> deleteItemOption(int itemOptionId) async {
    final db = await DBHelper().database;

    // TO DO: Ensure THIS item option is linked to an active loan before deletion
    final List<Map<String, dynamic>> tiedLoans = await db.rawQuery(
      '''
  SELECT loan_id FROM loan WHERE json_extract(billItems, '\$."' || ? || '"') IS NOT NULL
  ''',
      [itemOptionId.toString()],
    );

    if (tiedLoans.isNotEmpty) {
      throw Exception("Cannot delete item option tied to active loans!");
    }

    // TO DO: Proceed with deletion ONLY if the item option itself is NOT tied to a loan
    await db.delete(
      'item_option',
      where: 'sub_id = ?',
      whereArgs: [itemOptionId],
    );
  }
}
