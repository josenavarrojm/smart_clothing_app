// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// class SqliteHandler {
//   Future<Database> getDb() async {
//     String databasesPath = await getDatabasesPath();
//     String path = join(databasesPath, 'database_sqlite.db');

//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: _onCreate,
//     );
//   }

//   void _onCreate(Database db, int version, String tableName) async {
//     await db.execute('''
// CREATE TABLE $tableName(
// idx TEXT PRIMARY KEY,
// user_name TEXT)
// ''');
//   }
// }
