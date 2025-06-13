import 'package:sqflite/sqflite.dart';
import '../services/db_helper.dart';
import '../models/loan_model.dart';

class LoanService {
  static Future<void> addLoan(Loan loan) async {
    final db = await DBHelper().database;
    await db.insert(
      'loan',
      loan.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> removeLoan(String loanId) async {
    final db = await DBHelper().database;
    await db.delete(
      'loan',
      where: 'loan_id = ?',
      whereArgs: [loanId],
    );
  }

  static Future<List<Loan>> getAllLoans() async {
    final db = await DBHelper().database;
    final List<Map<String, dynamic>> result = await db.query('loan');

    return result.map((map) => Loan.fromMap(map)).toList();
  }

  static Future<Loan?> getLoanById(String loanId) async {
    final db = await DBHelper().database;
    final result = await db.query(
      'loan',
      where: 'loan_id = ?',
      whereArgs: [loanId],
    );

    if (result.isNotEmpty) {
      return Loan.fromMap(result.first);
    } else {
      return null;
    }
  }
}
