import 'package:mongo_dart/mongo_dart.dart';
import 'package:smartclothingproject/functions/internet_connection_state_notifier.dart';

/// Servicio para gestionar la conexión y operaciones con MongoDB.
class MongoService {
  static const String mongoUri =
      "mongodb+srv://smartApp:UfPuTjyg7spQvkuX@smart-clothes.p659y.mongodb.net/smartApp?retryWrites=true&w=majority";

  late Db _db;
  late DbCollection _collection;

  /// Conecta a MongoDB si no hay una conexión activa.
  Future<void> connect() async {
    if (InternetConnectionNotifier().mongoDBConnectionState) {
      print("Ya hay una conexión activa con MongoDB.");
      return;
    }

    try {
      _db = await Db.create(mongoUri);
      await _db.open();

      if (_db.isConnected) {
        InternetConnectionNotifier().updateMongoDBConnectionState(true);
        print("Conexión establecida con MongoDB.");
      } else {
        print("No se pudo establecer la conexión con MongoDB.");
      }
    } catch (e) {
      print("Error al conectar a MongoDB: $e");
    }
  }

  /// Cierra la conexión activa con MongoDB.
  Future<void> disconnect() async {
    if (_db.isConnected) {
      await _db.close();
      InternetConnectionNotifier().updateMongoDBConnectionState(false);
      print("Conexión con MongoDB cerrada.");
    } else {
      print("No hay una conexión activa que cerrar.");
    }
  }

  /// Reconecta a MongoDB si la conexión está inactiva.
  Future<void> reconnect() async {
    if (_db.isConnected) {
      print("La conexión ya está activa.");
      return;
    }

    try {
      await connect();
      print("Conexión con MongoDB restablecida.");
    } catch (e) {
      print("Error al reconectar con MongoDB: $e");
    }
  }

  /// Inserta un documento en la colección especificada.
  Future<void> insertDocument(
      Map<String, dynamic> data, String collectionName) async {
    await _ensureConnected();
    _collection = _db.collection(collectionName);

    try {
      await _collection.insert(data);
      // print("Documento insertado: $data");
    } catch (e) {
      print("Error al insertar documento: $e");
    }
  }

  /// Obtiene documentos de la colección especificada, con un filtro opcional.
  Future<List<Map<String, dynamic>>> getDocuments(String collectionName,
      {Map<String, dynamic>? filter}) async {
    await _ensureConnected();
    _collection = _db.collection(collectionName);

    try {
      return await _collection.find(filter ?? {}).toList();
    } catch (e) {
      print("Error al obtener documentos: $e");
      return [];
    }
  }

  /// Actualiza un documento en la colección especificada.
  Future<void> updateDocument(String userId, Map<String, dynamic> updatedData,
      String collectionName) async {
    await _ensureConnected();
    _collection = _db.collection(collectionName);

    try {
      await _collection.update(where.eq('user_id', userId), updatedData);
      print("Documento actualizado con user_id: $userId");
    } catch (e) {
      print("Error al actualizar documento: $e");
    }
  }

  /// Elimina un documento por su ID en la colección especificada.
  Future<void> deleteDocument(dynamic userID, String collectionName) async {
    await _ensureConnected();
    _collection = _db.collection(collectionName);

    try {
      await _collection.remove(where.eq('user_id', userID));
      print("Documento eliminado con ID: $userID");
    } catch (e) {
      print("Error al eliminar documento: $e");
    }
  }

  /// Verifica que la conexión a MongoDB esté activa, de lo contrario la establece.
  Future<void> _ensureConnected() async {
    if (_db.isConnected) return;
    await connect();
  }
}
