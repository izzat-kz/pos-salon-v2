import 'package:sqflite/sqflite.dart';
import '../models/sales_model.dart';
import 'db_helper.dart';

class SalesService {
  static Future<void> insertSale(SalesReport sale) async {
    final db = await DBHelper().database;
    await db.insert('sales_report', sale.toMap());
  }

  static Future<List<SalesReport>> getAllSales() async {
    final db = await DBHelper().database;
    final List<Map<String, dynamic>> result = await db.query('sales_report');
    return result.map((map) => SalesReport.fromMap(map)).toList();
  }

  static Future<void> clearSales() async {
    final db = await DBHelper().database;
    await db.delete('sales_report');
  }
}
