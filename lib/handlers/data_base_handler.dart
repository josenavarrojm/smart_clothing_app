import 'package:smartclothingproject/models/alert_model.dart';
import 'package:smartclothingproject/models/user_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:synchronized/synchronized.dart';

/// Clase para manejar la base de datos SQLite del proyecto.
class DatabaseHandler {
  // Singleton
  static final DatabaseHandler instance = DatabaseHandler._init();

  static Database? _database;
  final _lock = Lock();

  // Constructor privado para el patrón Singleton.
  DatabaseHandler._init();

  /// Obtiene la instancia de la base de datos. Si no está inicializada, la crea.
  Future<Database> get database async {
    return await _lock.synchronized(() async {
      if (_database != null) return _database!;
      _database = await _initDB('app_database.db');
      return _database!;
    });
  }

  /// Inicializa la base de datos SQLite.
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 12,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  /// Crea las tablas necesarias para la aplicación.
  Future<void> _createDB(Database db, int version) async {
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

  /// Actualiza la base de datos al cambiar de versión.
  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 11) {
      await db.execute('ALTER TABLE sensor_data ADD COLUMN user_id TEXT');
    }
  }

  // ------------------------- Funciones para Usuarios -------------------------

  /// Guarda o actualiza un usuario. Reemplaza los registros existentes.
  Future<void> saveOrUpdateUser(Map<String, dynamic> userData) async {
    final db = await instance.database;
    await db.delete('users'); // Elimina registros antiguos
    await db.insert('users', userData); // Inserta nuevo registro
  }

  /// Elimina todos los registros de usuarios.
  Future<void> deleteUser() async {
    final db = await instance.database;
    await db.delete('users');
  }

  /// Obtiene todos los usuarios registrados en la tabla.
  Future<List<UserModel>> getAllUsers() async {
    final db = await database;
    final result = await db.query('users');
    return result.map((e) => UserModel.fromJson(e)).toList();
  }

  // ------------------------ Funciones para Alertas --------------------------

  /// Guarda una alerta en la base de datos.
  Future<void> saveAlert(Map<String, dynamic> alertData) async {
    final db = await instance.database;
    await db.insert('alerts', alertData);
  }

  /// Elimina una alerta específica usando su ID.
  Future<void> deleteAlert(String id) async {
    final db = await instance.database;
    await db.delete(
      'alerts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Obtiene todas las alertas almacenadas.
  Future<List<AlertModel>> getAllAlerts() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('alerts');

    return List.generate(maps.length, (i) {
      return AlertModel(
        id: maps[i]['id'].toString(),
        title: maps[i]['title'] ?? '',
        description: maps[i]['description'] ?? '',
        minute: maps[i]['minute'].toString(),
        hour: maps[i]['hour'].toString(),
        day: maps[i]['day'].toString(),
        month: maps[i]['month'].toString(),
        year: maps[i]['year'].toString(),
      );
    });
  }

  /// Elimina todas las alertas de la tabla.
  Future<void> clearAlerts() async {
    final db = await instance.database;
    await db.delete('alerts');
  }

  // -------------------- Funciones para Datos del Sensor ---------------------

  /// Guarda un registro de datos del sensor.
  Future<void> saveSensorData(Map<String, dynamic> sensorData) async {
    final db = await instance.database;
    await db.insert('sensor_data', sensorData);
  }

  /// Obtiene todos los datos del sensor.
  Future<List<Map<String, dynamic>>> getAllSensorData() async {
    final db = await instance.database;
    return await db.query('sensor_data');
  }

  /// Obtiene los datos del sensor que no han sido sincronizados con MongoDB.
  Future<List<Map<String, dynamic>>> getSensorDataNotOnMongoDB() async {
    final db = await instance.database;
    return await db.query(
      'sensor_data',
      where: 'onMongoDB = ?',
      whereArgs: [0],
    );
  }

  /// Actualiza el estado de sincronización de los datos del sensor.
  Future<void> updateSensorDataSyncStatus(int id, bool isSynced) async {
    final db = await instance.database;
    await db.update(
      'sensor_data',
      {'onMongoDB': isSynced ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Elimina todos los datos del sensor.
  Future<void> clearSensorData() async {
    final db = await instance.database;
    await db.delete('sensor_data');
  }
}
