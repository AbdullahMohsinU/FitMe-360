import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Singleton instance for DatabaseHelper
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _db;

  DatabaseHelper._internal();

  // Getter for database instance
  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  // Initialize the database
  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'fitme360.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // Create database tables
  Future<void> _onCreate(Database db, int version) async {
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

  // Insert a new user with email uniqueness check
  Future<int> insertUser(Map<String, dynamic> user) async {
    var dbClient = await db;

    // Validate input
    if (!_isValidEmail(user['email'])) {
      throw Exception('Invalid email format');
    }
    if (user['name']?.isEmpty ?? true) {
      throw Exception('Name cannot be empty');
    }
    if (user['password']?.isEmpty ?? true) {
      throw Exception('Password cannot be empty');
    }

    // Check if email already exists
    List<Map<String, dynamic>> existingUser = await dbClient.query(
      'users',
      where: 'email = ?',
      whereArgs: [user['email']],
    );

    if (existingUser.isNotEmpty) {
      throw Exception('Email already exists. Please use a different email.');
    }

    try {
      return await dbClient.insert('users', user);
    } catch (e) {
      throw Exception('Failed to insert user: $e');
    }
  }

  // Retrieve a user by email and password
  Future<Map<String, dynamic>?> getUser(String email, String password) async {
    if (!_isValidEmail(email)) {
      throw Exception('Invalid email format');
    }

    var dbClient = await db;
    List<Map<String, dynamic>> result = await dbClient.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return result.isNotEmpty ? result.first : null;
  }


  // Create todos table (if not already created)
  Future<void> createTodoTable() async {
    var dbClient = await db;
    await dbClient.execute('''
      CREATE TABLE IF NOT EXISTS todos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        task TEXT
      )
    ''');
  }

  // Insert a new todo
  Future<int> insertTodo(String task) async {
    // ignore: avoid_print
    print('Inserting todo with task: "$task"'); // Debug log
    if (task.isEmpty) {
      throw Exception('Task cannot be empty');
    }

    var dbClient = await db;
    return await dbClient.insert('todos', {'task': task});
  }

  // Retrieve all todos
  Future<List<Map<String, dynamic>>> getTodos() async {
    var dbClient = await db;
    return await dbClient.query('todos');
  }

  // Update an existing todo
  Future<void> updateTodo(int id, String newTask) async {
    // ignore: avoid_print
    print('Updating todo id: $id with task: "$newTask"'); // Debug log
    if (newTask.isEmpty) {
      throw Exception('Task cannot be empty');
    }

    var dbClient = await db;
    await dbClient.update(
      'todos',
      {'task': newTask},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete a specific todo
  Future<void> deleteTodo(int id) async {
    var dbClient = await db;
    await dbClient.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete all todos
  Future<void> deleteAllTodos() async {
    var dbClient = await db;
    await dbClient.delete('todos');
  }

  // Helper method to validate email format
  bool _isValidEmail(String? email) {
    if (email == null || email.isEmpty) return false;
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }
}