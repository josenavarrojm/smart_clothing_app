import 'package:smartclothingproject/models/alert_model.dart';
import 'package:smartclothingproject/models/user_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHandler {
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
      version: 8, // Asegúrate de incrementar la versión
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Tabla de usuarios
    await db.execute('''
    CREATE TABLE IF NOT EXISTS users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id TEXT,
      Name TEXT,
      Surname TEXT,
      PhoneNumber TEXT,
      Email TEXT,
      Gender TEXT,
      BirthDate TEXT,
      Age TEXT,
      Cedula TEXT,
      DateCedula TEXT,
      DepartamentoCedula TEXT,
      CiudadCedula TEXT,
      ScholarityLevel TEXT,
      Occupation TEXT,
      MaritalStatus TEXT,
      NumberOfChildren TEXT,
      PeopleEconomlyDepend TEXT,
      StateOfResidence TEXT,
      CityOfResidence TEXT,
      BarrioOfResidence TEXT,
      AddressOfResidence TEXT,
      BloodType TEXT,
      EPS TEXT,
      ARL TEXT,
      PensionFondo TEXT
    )
    ''');

    // Tabla de alertas
    await db.execute('''
    CREATE TABLE IF NOT EXISTS alerts (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      description TEXT,
      minute TEXT,
      hour  TEXT,
      day   TEXT,
      month TEXT,
      year  TEXT
    )
    ''');
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 8) {
      // Crea la tabla de alertas si no existía
      await db.execute('''
      CREATE TABLE IF NOT EXISTS alerts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        minute TEXT,
        hour TEXT,
        day TEXT,
        month TEXT,
        year TEXT
      )
      ''');
    }
  }

  Future<void> saveOrUpdateUser(Map<String, dynamic> userData) async {
    final db = await instance.database;
    await db.delete('users'); // Elimina registros antiguos
    await db.insert('users', userData); // Inserta nuevo registro
  }

  Future<void> deleteUser() async {
    final db = await instance.database;
    await db.delete('users');
  }

  Future<List<UserModel>> getAllUsers() async {
    final db = await database;
    final result = await db.query('users');
    return result.map((e) => UserModel.fromJson(e)).toList();
  }

  // Funciones para gestionar alertas
  Future<void> saveAlert(Map<String, dynamic> alertData) async {
    final db = await instance.database;
    await db.insert('alerts', alertData);
  }

  Future<void> deleteAlert(String id) async {
    final db = await instance.database;
    await db.delete(
      'alerts',
      where: 'id = ?',
      whereArgs: [id], // Eliminar usando el id
    );
  }

  Future<List<AlertModel>> getAllAlerts() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('alerts');
    print(maps); // Verifica los datos recuperados

    return List.generate(maps.length, (i) {
      return AlertModel(
        id: maps[i]['id'].toString(), // Convierte el id a String
        title: maps[i]['title'] ?? '',
        description: maps[i]['description'] ?? '',
        minute: maps[i]['minute'].toString(), // Convierte minute a String
        hour: maps[i]['hour'].toString(), // Convierte hour a String
        day: maps[i]['day'].toString(), // Convierte day a String
        month: maps[i]['month'].toString(), // Convierte month a String
        year: maps[i]['year'].toString(), // Convierte year a String
      );
    });
  }

  Future<void> clearAlerts() async {
    final db = await instance.database;
    await db.delete('alerts');
  }
}
