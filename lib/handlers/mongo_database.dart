import 'package:mongo_dart/mongo_dart.dart';
import 'package:smartclothingproject/functions/internet_connection_state_notifier.dart';

class MongoService {
  static const String mongoUri =
      "mongodb+srv://smartApp:UfPuTjyg7spQvkuX@smart-clothes.p659y.mongodb.net/smartApp?retryWrites=true&w=majority";
  late Db db;
  late DbCollection collection;

  // Abrir conexión
  Future<void> connect() async {
    if (!InternetConnectionNotifier().mongoDBConnectionState) {
      try {
        db = await Db.create(mongoUri);
        await db.open();
        if (db.isConnected) {
          InternetConnectionNotifier().updateMongoDBConnectionState(true);
          print("Conectado a MongoDB");
        } else {
          print("No se pudo establecer la conexión con MongoDB.");
        }
      } catch (e) {
        print("Error al conectar a MongoDB: $e");
      }
    }
  }

  // Cerrar conexión
  Future<void> disconnect() async {
    if (db.isConnected) {
      await db.close();
      InternetConnectionNotifier().updateMongoDBConnectionState(false);
      print("Conexión cerrada");
    } else {
      print("La conexión ya está cerrada.");
    }
  }

  // Reconnect method - now checking if db is not initialized before reconnecting
  Future<void> reconnect() async {
    db = await Db.create(mongoUri);
    if (db.isConnected) {
      return; // Avoid reconnecting if already connected
    }

    try {
      // Crear una nueva instancia de Db
      db = await Db.create(mongoUri);

      // Intentar abrir la conexión
      await db.open();
      print("Conexión a MongoDB restablecida.");
      InternetConnectionNotifier().updateMongoDBConnectionState(true);
    } catch (e) {
      print("Error al reconectar: $e");
    }
  }

  // Insertar un documento
  Future<void> insertDocument(
      Map<String, dynamic> data, String collectionName) async {
    if (!db.isConnected) await connect(); // Ensure db is connected
    collection = db.collection(collectionName);
    await collection.insert(data);
    print("Documento insertado: $data");
  }

  // Obtener documentos
  Future<List<Map<String, dynamic>>> getDocuments(String collectionName,
      {Map<String, dynamic>? filter}) async {
    if (!db.isConnected) await connect();
    collection = db.collection(collectionName);
    return await collection.find(filter ?? {}).toList();
  }

  // Actualizar un documento
  Future<void> updateDocument(String codeSession,
      Map<String, dynamic> updatedData, String collectionName) async {
    if (!db.isConnected) await connect(); // Ensure db is connected
    collection = db.collection(collectionName);
    await collection.update(where.eq('user_id', codeSession), updatedData);
    print("Documento actualizado con user_id: $codeSession");
  }

  // Eliminar un documento
  Future<void> deleteDocument(dynamic id, String collectionName) async {
    if (!db.isConnected) await connect(); // Ensure db is connected
    collection = db.collection(collectionName);
    await collection.remove(where.eq('_id', id));
    print("Documento eliminado con ID: $id");
  }
}
