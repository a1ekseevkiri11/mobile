import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'DatabaseHelper4.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
        CREATE TABLE categories(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          type INTEGER
        )
    ''');

    await db.execute('''
      CREATE TABLE transactions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category_id NOT NULL,
        title TEXT,
        amount FLOAT, 
        date TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (category_id) REFERENCES categories (id) ON DELETE CASCADE
      )
    ''');

    await db.insert(
        'categories', {'name': 'Salary', 'type': 1});
    await db.insert(
        'categories', {'name': 'Food', 'type': 0});
  }

  Future<void> clearCategory() async {
    final db = await instance.database;
    await db.delete('categories');
  }

  Future<void> clearTransactions() async {
    final db = await instance.database;
    await db.delete('transactions');
  }

  Future<void> deleteCategory(index) async {
    final db = await instance.database;
    await db.delete('categories', where: 'id = ?', whereArgs: [index]);
  }

  Future<void> deleteTransaction(index) async {
    final db = await instance.database;
    await db.delete('transactions', where: 'id = ?', whereArgs: [index]);
  }

  Future<List<Map<String, dynamic>>> getCategoryList() async {
    final db = await instance.database;
    return await db.query('categories');
  }

  Future<int?> getCategoryId(String name) async {
    final db = await instance.database;
    final result = await db.query(
      'categories',
      columns: ['id'],
      where: 'name = ?',
      whereArgs: [name],
    );
    if (result.isNotEmpty) {
      return result.first['id'] as int;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getExpenseCategories() async {
    final db = await instance.database;
    return await db.query('categories', where: 'type = ?', whereArgs: [0]);
  }

  Future<void> addCategory(String name, bool type) async {
    final db = await instance.database;
    await db.insert('categories', {'name': name, 'type': type});
  }

  Future<void> addTransaction(int categoryId, String title, double amount, String date) async {
    final db = await instance.database;
    await db.insert(
      'transactions',
      {'category_id': categoryId, 'title': title, 'amount': amount, 'date': date},
    );
  }

  Future<List<Map<String, dynamic>>> getAllTransactions() async {
    final db = await instance.database;
    return await db.query('transactions');
  }

  Future<List<Map<String, dynamic>>> getFilteredTransactions({
    int? categoryId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final db = await instance.database;

    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (categoryId != null) {
      whereClause += 'category_id = ?';
      whereArgs.add(categoryId);
    }

    if (startDate != null && endDate != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      whereClause += 'date BETWEEN ? AND ?';
      whereArgs.add(startDate.toIso8601String());
      whereArgs.add(endDate.toIso8601String());
    }

    return await db.query('transactions', where: whereClause, whereArgs: whereArgs);
  }
}
