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
      version: 5,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

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
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 6) {
      await db.execute("ALTER TABLE users ADD COLUMN user_id TEXT");
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
}
