import 'package:sqflite/sqflite.dart';
import '../models/loan_payment.dart';
import 'db_helper.dart';

class LoanPaymentService {
  static Future<void> insertPayment(LoanPayment payment) async {
    final db = await DBHelper().database;
    await db.insert('loan_payments', payment.toMap());
  }

  /// Get total paid toward a specific loan
  static Future<double> getTotalPaid(String loanId) async {
    final db = await DBHelper().database;
    final result = await db.rawQuery(
      'SELECT SUM(amount_paid) as total FROM loan_payments WHERE loan_id = ?',
      [loanId],
    );
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  static Future<List<LoanPayment>> getPaymentsByLoanId(String loanId) async {
    final db = await DBHelper().database;
    final List<Map<String, dynamic>> maps = await db.query(
      'loan_payments',
      where: 'loan_id = ?',
      whereArgs: [loanId],
      orderBy: 'payment_date DESC',
    );
    return maps.map((map) => LoanPayment.fromMap(map)).toList();
  }

  /// Delete payments for a loan
  static Future<void> deletePayments(String loanId) async {
    final db = await DBHelper().database;
    await db.delete('loan_payments', where: 'loan_id = ?', whereArgs: [loanId]);
  }
}
