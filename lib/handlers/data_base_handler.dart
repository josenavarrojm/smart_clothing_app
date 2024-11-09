import 'package:smartclothingproject/models/user_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHandler {
  // Singleton para mantener una sola instancia de DatabaseHandler
  static final DatabaseHandler instance = DatabaseHandler._init();

  static Database? _database;

  DatabaseHandler._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('app_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      Email TEXT,
      Hashpwd TEXT,
      Name TEXT,
      Surname TEXT,
      Age INTEGER,
      BirthDate TEXT,
      Gender TEXT,
      UserType TEXT,
      PhoneNumber TEXT
    )
  ''');
  }

  Future<void> saveOrUpdateUser(Map<String, dynamic> userData) async {
    final db = await instance.database;

    // Eliminar todos los registros existentes
    await db.delete('users');

    // Insertar el nuevo registro (siempre será uno solo)
    await db.insert('users', userData);
  }

  Future<void> deleteUser() async {
    final db = await instance.database;

    // Eliminar todos los registros existentes
    await db.delete('users');
  }

  Future<List<UserModel>> getAllUsers() async {
    final db = await database;
    final result = await db.query('users'); // 'users' es el nombre de la tabla

    return result.map((e) => UserModel.fromJson(e)).toList();
  }
}
