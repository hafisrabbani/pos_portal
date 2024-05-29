import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBConfig {
  static final DBConfig instance = DBConfig._init();

  static Database? _database;

  DBConfig._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('pos.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    // Product Table
    await db.execute('''
      CREATE TABLE Product(
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        price REAL NOT NULL,
        stock_type TINYINT NOT NULL DEFAULT 0,
        stock INTEGER NULL DEFAULT NULL,
        created_time TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_time TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
    ''');
    // - stock_type: 0 = unlimited, 1 = limited

    // Transaction Table
    await db.execute('''
      CREATE TABLE Transaction_Record(
        id INTEGER PRIMARY KEY,
        nominal_payment REAL NOT NULL,
        total REAL NOT NULL,
        change REAL NOT NULL,
        status TINYINT NOT NULL DEFAULT 0,
        payment_method TEXT NOT NULL DEFAULT 'cash',
        created_time TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_time TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
    ''');
    // - status: 0 = pending, 1 = paid, 2 = failed/cancelled

    // Transaction Detail Table
    await db.execute('''
      CREATE TABLE Transaction_Detail(
        id INTEGER PRIMARY KEY,
        transaction_id INTEGER NOT NULL,
        product_id INTEGER NOT NULL,
        quantity INTEGER NOT NULL,
        price REAL NOT NULL,
        created_time TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_time TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (transaction_id) REFERENCES TransactionRecord(id) ON DELETE CASCADE,
        FOREIGN KEY (product_id) REFERENCES Product(id) ON DELETE CASCADE
      )
    ''');

    // Setting Table
    await db.execute('''
      CREATE TABLE Setting(
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        value TEXT NOT NULL,
        created_time TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_time TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
    ''');
  }
}