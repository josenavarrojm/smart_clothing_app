import 'package:smartclothingproject/models/alert_model.dart';
import 'package:smartclothingproject/models/user_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:synchronized/synchronized.dart';

class DatabaseHandler {
  static final DatabaseHandler instance = DatabaseHandler._init();

  static Database? _database;
  final _lock = Lock();

  DatabaseHandler._init();

  Future<Database> get database async {
    return await _lock.synchronized(() async {
      if (_database != null) return _database!;
      _database = await _initDB('app_database.db');
      return _database!;
    });
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    // Solo eliminar la base de datos en desarrollo si se requiere.
    // await deleteDatabase(path);

    return await openDatabase(
      path,
      version: 12,
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

    await db.execute('''
    CREATE TABLE IF NOT EXISTS sensor_data (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      _id TEXT,
      user_id TEXT,
      bpm INTEGER,
      tempAmb REAL,
      tempCorp REAL,
      hum REAL,
      acelX REAL,
      acelY REAL,
      acelZ REAL,
      time INTEGER,
      ecg TEXT,
      created_at TEXT,
      onMongoDB BOOLEAN
    )
    ''');

    // Tabla de alertas
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

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 11) {
      await db.execute('ALTER TABLE sensor_data ADD COLUMN user_id TEXT');
    }
  }

  // Funciones para gestionar usuarios
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

  // Funciones para gestionar datos del dispositivoIoT
  // Guardar datos del sensor
  Future<void> saveSensorData(Map<String, dynamic> sensorData) async {
    final db = await instance.database;
    await db.insert('sensor_data', sensorData);
  }

  Future<List<Map<String, dynamic>>> getAllSensorData() async {
    final db = await instance.database;
    return await db.query('sensor_data');
  }

  Future<List<Map<String, dynamic>>> getSensorDataNotOnMongoDB() async {
    final db = await instance.database;
    return await db.query(
      'sensor_data',
      where: 'onMongoDB = ?', // Cláusula WHERE
      whereArgs: [0], // 0 representa false en SQLite
    );
  }

  Future<void> updateSensorDataSyncStatus(int id, bool isSynced) async {
    final db = await instance.database;
    await db.update(
      'sensor_data',
      {'onMongoDB': isSynced ? 1 : 0}, // Convertir bool a int
      where: 'id = ?',
      whereArgs: [id], // Usar el ID del registro
    );
  }

  Future<void> clearSensorData() async {
    final db = await instance.database;
    await db.delete('sensor_data');
  }
}
