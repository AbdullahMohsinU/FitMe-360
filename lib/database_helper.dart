import 'dart:async';
import 'package:sqflite/sqflite.dart'; //databse
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _db;

  DatabaseHelper._internal();

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'fitme360.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        fathername TEXT,
        gender TEXT,
        weight REAL,
        height REAL,
        age INTEGER,
        dob TEXT,
        email TEXT UNIQUE,
        password TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE todos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        task TEXT
      )
    ''');
  }

  // --------------------- USER METHODS ---------------------
  Future<int> insertUser(Map<String, dynamic> user) async {
    var dbClient = await db;
    return await dbClient.insert('users', user);
  }

  Future<Map<String, dynamic>?> getUser(String email, String password) async {
    var dbClient = await db;
    List<Map<String, dynamic>> result = await dbClient.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (result.isNotEmpty) return result.first;
    return null;
  }


  Future<void> createTodoTable() async {
    var dbClient = await db;
    await dbClient.execute('''
      CREATE TABLE IF NOT EXISTS todos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        task TEXT
      )
    ''');
  }

  Future<int> insertTodo(String task) async {
    var dbClient = await db;
    return await dbClient.insert('todos', {'task': task});
  }

  Future<List<Map<String, dynamic>>> getTodos() async {
    var dbClient = await db;
    return await dbClient.query('todos');
  }

  Future<void> updateTodo(int id, String newTask) async {
    var dbClient = await db;
    await dbClient.update(
      'todos',
      {'task': newTask},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteTodo(int id) async {
    var dbClient = await db;
    await dbClient.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAllTodos() async {
    var dbClient = await db;
    await dbClient.delete('todos');
  }
}
