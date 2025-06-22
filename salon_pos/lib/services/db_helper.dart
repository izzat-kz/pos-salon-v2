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
      // onUpgrade: (db, oldVersion, newVersion) async {
      //   // if (oldVersion < 1) {}
      // },
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
        FOREIGN KEY (item_id) REFERENCES item_type(item_id) ON DELETE CASCADE
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
      CREATE TABLE IF NOT EXISTS loan_payments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        loan_id TEXT,
        amount_paid REAL,
        payment_date TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE loan (
        loan_id TEXT PRIMARY KEY,
        cust_name TEXT NOT NULL,
        cust_ic TEXT NOT NULL DEFAULT '000000-00-0000',
        cust_phone TEXT NOT NULL,
        cust_address TEXT,
        totalAmount REAL NOT NULL,
        billItems TEXT NOT NULL,
        dateTime TEXT NOT NULL,
        customer_pax INTEGER DEFAULT 1
    );
    ''');

    await db.execute('''
      CREATE TABLE sales_report (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        bill_id INTEGER,
        date TEXT NOT NULL,
        total_amount REAL NOT NULL,
        pax INTEGER NOT NULL,
        staff_id INTEGER NOT NULL,
        FOREIGN KEY (staff_id) REFERENCES staff(staff_id) ON DELETE SET NULL
      );
    ''');
  }
}
