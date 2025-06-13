import 'package:sqflite/sqflite.dart';
import '../../services/db_helper.dart';
import '../../models/staff_model.dart';

class StaffService {
  static Future<List<Staff>> getAllStaff() async {
    final db = await DBHelper().database;
    final result = await db.query('staff');
    return result.map((row) => Staff.fromMap(row)).toList();
  }

  static Future<void> insertStaff(Staff staff) async {
    final db = await DBHelper().database;
    await db.insert('staff', staff.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> updateStaff(Staff staff) async {
    final db = await DBHelper().database;
    await db.update(
      'staff',
      staff.toMap(),
      where: 'staff_id = ?',
      whereArgs: [staff.id],
    );
  }

  static Future<void> deleteStaff(int id) async {
    final db = await DBHelper().database;
    await db.delete(
      'staff',
      where: 'staff_id = ?',
      whereArgs: [id],
    );
  }
}
