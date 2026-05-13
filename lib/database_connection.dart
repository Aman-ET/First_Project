import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  // Private constructor
  DatabaseHelper._internal();

  // Getter to lazily initialize the database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_database.db');

    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  // Create table(s)
  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE User(
        name TEXT NOT NULL,
        age INTEGER NOT NULL
      )
    ''');
  }

  // --- CRUD Operations ---

  // Create (Insert)
  Future<int> insertUsers(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('User', row);
  }

  // Read (Query All)
  Future<List<Map<String, dynamic>>> queryAllUsers() async {
    final db = await instance.database;
    return await db.query(
      'User',
      // where: 'age >= ?',
      // whereArgs: [200],
    );
  }

  // Update
  Future<int> updateUserByName(
    String oldName,
    Map<String, dynamic> newRow,
  ) async {
    final db = await instance.database;

    return await db.update(
      'User',
      newRow, // This contains the new name and new age
      where: 'name = ?',
      whereArgs: ["Aman"], // This finds the specific record to change
    );
  }

  // Delete
  Future<int> deleteUserByName(String name) async {
    final db = await instance.database;

    // This finds the row where name matches and deletes it
    return await db.delete('User', where: 'name = ?', whereArgs: [name]);
  }

  Future<bool> insertOrUpdateUser(String name, int age) async {
    final db = await instance.database;
    // Check if the user already exists
    List<Map<String, dynamic>> users = await db.query(
      'User',
      where: "name = ?",
      whereArgs: [name],
    );

    if (users.isNotEmpty) {
      // User exists, so update
      await db.update(
        'User',
        {'age': age},
        where: "name = ?",
        whereArgs: [name],
      );
      return false;
    } else {
      // User does not exist, so insert
      await db.insert('User', {'name': name, 'age': age});
      return true;
    }
  }

  Future<List<Map<String, dynamic>>> getUsersSorted() async {
    final db = await instance.database;
    // 'ASC' stands for Ascending (A-Z)
    return await db.query('User', orderBy: 'name COLLATE NOCASE ASC');
  }

}
