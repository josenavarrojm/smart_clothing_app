import 'package:mongo_dart/mongo_dart.dart';

class MongoService {
  static const String mongoUri =
      "mongodb+srv://smartApp:UfPuTjyg7spQvkuX@smart-clothes.p659y.mongodb.net/smartApp?retryWrites=true&w=majority";
  // static const String collectionName = "yourCollectionName"; // Cambia a tu colección

  late Db db;
  late DbCollection collection;

  // Abrir conexión
  Future<void> connect() async {
    db = await Db.create(mongoUri);
    await db.open();
    print("Conectado a MongoDB");
  }

  // Cerrar conexión
  Future<void> disconnect() async {
    await db.close();
    print("Conexión cerrada");
  }

  // Insertar un documento
  Future<void> insertDocument(
      Map<String, dynamic> data, String collectionName) async {
    collection = db.collection(collectionName);
    await collection.insert(data);
    print("Documento insertado: $data");
  }

  // Obtener documentos
  Future<List<Map<String, dynamic>>> getDocuments(String collectionName,
      {Map<String, dynamic>? filter}) async {
    collection = db.collection(collectionName);
    return await collection.find(filter ?? {}).toList();
  }

  // Actualizar un documento
  Future<void> updateDocument(String codeSession,
      Map<String, dynamic> updatedData, String collectionName) async {
    collection = db.collection(collectionName);
    await collection.update(where.eq('user_id', codeSession), updatedData);
    print("Documento actualizado con user_id: $codeSession");
  }

  // Eliminar un documento
  Future<void> deleteDocument(dynamic id, String collectionName) async {
    collection = db.collection(collectionName);
    await collection.remove(where.eq('_id', id));
    print("Documento eliminado con ID: $id");
  }
}
