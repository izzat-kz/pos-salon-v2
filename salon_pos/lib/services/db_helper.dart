import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB('salon.db');
    return _db!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE staff(
        staff_id INTEGER PRIMARY KEY AUTOINCREMENT,
        staff_name TEXT NOT NULL,
        password TEXT NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE item_type(
        item_id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        category TEXT NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE item_option(
        sub_id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        price REAL NOT NULL,
        item_id INTEGER NOT NULL,
        FOREIGN KEY (item_id) REFERENCES item(item_id)
      );
    ''');

    await db.execute('''
      CREATE TABLE booking(
        booking_id INTEGER PRIMARY KEY AUTOINCREMENT,
        cust_name TEXT NOT NULL,
        cust_phone TEXT NOT NULL,
        time TEXT,
        date TEXT

      );
    ''');

    await db.execute('''
      CREATE TABLE loan(
        loan_id TEXT PRIMARY KEY,
        cust_name TEXT NOT NULL,
        cust_phone TEXT NOT NULL,
        cust_address TEXT NOT NULL,
        totalAmount INTEGER NOT NULL,
        billItems TEXT NOT NULL,
        dateTime TEXT NOT NULL
      );
    ''');

    // await db.execute('''
    //   CREATE TABLE transaction_history(
    //     transaction_id INTEGER PRIMARY KEY AUTOINCREMENT,
    //     staff_id INTEGER,
    //     action TEXT,
    //     details TEXT,
    //     timestamp TEXT,
    //     FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
    //   );
    // ''');
  }
}
