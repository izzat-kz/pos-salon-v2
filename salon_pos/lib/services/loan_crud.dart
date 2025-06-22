import 'package:sqflite/sqflite.dart';
import '../services/db_helper.dart';
import '../models/loan_model.dart';
import '../models/item_catalog.dart';

class LoanService {
  /// ⚙️ Adds a new loan while ensuring multiple item options are properly stored.
  static Future<void> addLoan(Loan loan) async {
    final db = await DBHelper().database;
    await db.insert(
      'loan',
      loan.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// ⚙️ Removes loan ONLY if it exists
  static Future<void> removeLoan(String loanId) async {
    final db = await DBHelper().database;

    final loanExists = await db.query(
      'loan',
      where: 'loan_id = ?',
      whereArgs: [loanId],
    );

    if (loanExists.isNotEmpty) {
      await db.delete(
        'loan',
        where: 'loan_id = ?',
        whereArgs: [loanId],
      );
    }
  }

  /// ⚙️ Retrieves all loans.
  static Future<List<Loan>> getAllLoans() async {
    final db = await DBHelper().database;
    final List<Map<String, dynamic>> result = await db.query('loan');

    return result.map((map) => Loan.fromMap(map)).toList();
  }

  /// ⚙️ Retrieves a single loan by its ID.
  static Future<Loan?> getLoanById(String loanId) async {
    final db = await DBHelper().database;
    final result = await db.query(
      'loan',
      where: 'loan_id = ?',
      whereArgs: [loanId],
    );

    return result.isNotEmpty ? Loan.fromMap(result.first) : null;
  }

  /// ⚙️ Retrieves loans tied to a specific item option.
  static Future<List<Loan>> getLoansByItemOptionId(int itemOptionId) async {
    final db = await DBHelper().database;

    final List<Map<String, dynamic>> tiedLoans = await db.rawQuery(
      '''
    SELECT * FROM loan WHERE json_extract(billItems, '\$."' || ? || '"') IS NOT NULL
    ''',
      [itemOptionId.toString()],
    );

    return tiedLoans.map((map) => Loan.fromMap(map)).toList();
  }

  /// ⚙️ Converts a loan's billItems into actual Item objects for display or transaction reuse.
  static Future<Map<Item, int>> convertLoanToBill(Loan loan) async {
    final db = await DBHelper().database;

    final entries = await Future.wait(
      loan.billItems.entries.map((entry) async {
        final int subId = int.tryParse(entry.key.toString()) ?? -1;

        final itemOption = await db.query(
          'item_option',
          where: 'sub_id = ?',
          whereArgs: [subId],
        );

        final itemType = await db.query(
          'item_type',
          where: 'item_id = ?',
          whereArgs: [itemOption.first['item_id']],
        );

        final item = Item(
          id: subId,
          name: "${itemType.first['name']} - ${itemOption.first['name']}",
          price: (itemOption.first['price'] as num?)?.toDouble() ?? 0.0,
          parentItemName: itemType.first['name'] as String,
          category: itemType.first['category'] == "Services"
              ? ItemCategory.service
              : ItemCategory.product,
        );

        return MapEntry(item, entry.value);
      }),
    );

    return Map<Item, int>.fromEntries(entries);
  }
}
